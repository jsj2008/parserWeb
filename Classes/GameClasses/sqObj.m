//
//  foodObj.m
//  game
//
//  Created by smallwin on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import "failCntObj.h"
#import "sqObj.h"
#import "dataDefine.h"
#import "EAGLView.h"
#import "AnimObjManager.h"
#import "mainGame.h"
#import "ZooAnimalFeeder.h"

#define DEFAULT_PREVIEW_POS CGPointMake(325.0, 230.0)
#define DEFAULT_RUN_START_POS CGPointMake(310.0, 170.0)
#define DEFAULT_RUN_SPEED CGPointMake(-4.0, 0.0) 

@implementation sqObj


- (CGRect) getCollisionRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x-20;
		aRect.origin.y = _pos.y-25;
		aRect.size.width = _image.tileWidth * 0.5f;
		aRect.size.height = _image.tileHeight * 0.8f;
	}	
	return aRect;
}

- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y;
		aRect.size.width = _image.tileWidth;
		aRect.size.height = _image.tileHeight;
	}
	return aRect;
}

- (BOOL)pointInImage:(int)x y:(int)y{
	CGRect rect = [self getTouchRect];
	int left = rect.origin.x - rect.size.width / 2;
	int right = rect.origin.x + rect.size.width / 2;
	int top = rect.origin.y - rect.size.height / 2;
	int bottom = rect.origin.y + rect.size.height / 2;
	
	if (x < left || x > right || y < top || y > bottom)
		return FALSE;
	return TRUE;
}

- (id) initWithSecond:(int)sec
{
	if(self = [super init])
	{
		[self loadImageFromFile: @"GAM_Zooff_ANI_Mouse.png" tileWidth:80 tileHeight:80];
		self.pos = DEFAULT_PREVIEW_POS;
		_state = 0;		
	}	
	appearPerSec = sec;
	return (self);
}

- (id) init {
	if (self = [super init]) {
		//[super initWithStart];
		[self loadImageFromFile: @"GAM_Zooff_ANI_Mouse.png" tileWidth:80 tileHeight:80];
		self.pos = DEFAULT_PREVIEW_POS;
		_state = 0;
		_type = 0;
		appearPerSec = 10;
	}
	return (self);
}

- (id) initWithSRandeWeight:(int)sec weight:(int) weight view:(id)view
{
    EAGLView *gameView = view;

	if (self = [super init]) {
		//[super initWithStart];
		[self loadImageFromFile: @"GAM_Zooff_ANI_Mouse.png" tileWidth:80 tileHeight:80];
		self.pos = DEFAULT_PREVIEW_POS;
		_state = 0;
		_type = 0;
		appearPerSec = sec;
		weightAppear = weight;
		weightCnt = weightAppear;
		sQCnt = 0;
	}


	animalSoundEffect = gameView.soundEffect; 
	bundle = gameView.bundle;
	
	
	return (self);
}

-(void)PlaySoundByAnimalType
{	
	CFURLRef fileURL;
//	if(_state == 3)
	{
		if(animalSoundObj == nil)
		{
			fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Squirrelcute" ofType:@"wav"]] retain];
			animalSoundObj = [animalSoundEffect requestSEWithURL:fileURL];
			CFRelease(fileURL);
		}
		
		[animalSoundEffect play:animalSoundObj sourceNumber:1];
	}
}

- (void) resetSQAppearWeight:(int)sec weight:(int) weight speed:(int) speed
{
	_alpha = 0;
	_state = 0;
	_type = 0;
	appearPerSec = sec;
	weightAppear = weight;	
	weightCnt = weightAppear;
	sQCnt =0;
	sQRCnt = 0;
	runspeed = speed;
	_speed.x = 0;// -1*speed;
	_speed.y = 0;
	
}

- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *game = gameView.main_Game;
	
	if(game.gameStageState == GSStateGameOver || game.gameStageState == GSStateGameSucceed
	   || game.gameStageState == GSStateGameDemo)
	{
		_alpha = 0;
		_state = 0;
		_type = 0;
		sQCnt =0;
		sQRCnt = 0;
		return 0;
	}
	
	if(_type == 1)
	{
		sQCnt ++;
		if(((sQCnt-sQRCnt)%15) == 0)			
			[self PlaySoundByAnimalType];
		if((((sQCnt-sQRCnt)/_SYSTEM_FRAME_COUNT_PER_SEC_) % 2)== 0 && (sQCnt-sQRCnt) > (_SYSTEM_FRAME_COUNT_PER_SEC_*2))
		{
			self.pos = DEFAULT_RUN_START_POS;
			self.speed = CGPointMake(-1.0*runspeed, 0.0); 
//			self.speed.y = 0;
			_state = 0;
			sQRCnt = sQCnt;
			_type = 2;
			
		}
	}
	else if(_type == 0)
	{	
		sQCnt ++;
		
		if((((sQCnt)/_SYSTEM_FRAME_COUNT_PER_SEC_) % appearPerSec) == 0 && sQCnt > (_SYSTEM_FRAME_COUNT_PER_SEC_*appearPerSec) )
		{
			int prob = arc4random()%97;			
			if( prob < weightCnt)
			{
				_type = 1;
				self.pos = DEFAULT_PREVIEW_POS;
				_alpha = 1;
				weightCnt = weightAppear;
				sQRCnt = sQCnt;
			}
			else
				weightCnt += weightAppear;
		}	
		_no = 0;
		_state = 3;
			
		return 0;
	}	
	
	[self update];
	
	if(_pos.x < -30 )
		{
		_alpha = 0;
		_type = 0;
		_speed.x = 0;
			_state = 0;
		sQCnt = 0;
	}	
	
	_no = ( gameView.frameCount/5)%2;
	
	[game.gameEnemyAnimManager checkCollision:game.gameAnimManager];

	
	if(_collision == TRUE)
	{
		/**
		 *
		 1 = fainting
		 2 = hit squirrel
		 3 = nothing
		 4 = NA
		 */
		if(_state == 0) // squ run
		{
			NSInteger passState = [game.zaMkObj queryPassState];

			if(  passState == 1)
			{
				[game.zaMkObj setMonkeyFaint];
				_alpha = 0;
				_state = 1;
				sQCnt = 0;
				sQRCnt = 0;	
				_speed.x = 0;
				_type =0;
				self.pos = DEFAULT_PREVIEW_POS;
			}
			else if(passState == 2)
			{				
				[game.zaMkObj setMonkeyHit];
				game.extraBonus++;
				_alpha = 0;
				_state = 1;
				sQCnt = 0;
				sQRCnt = 0;	
				_speed.x = 0;
				_type =0;
				self.pos = DEFAULT_PREVIEW_POS;				
			}
			
		}
	}	
	

	return 0;
}

- (void) dealloc {
	[SESoundObj release];
	[super dealloc];
}

@end
