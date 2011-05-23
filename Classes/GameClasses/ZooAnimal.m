//
//  ZooAnimal.m
//  Animation
//
//  Created by FIH on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "EAGLView.h"
#import "ZooAnimal.h"
#import "flyfoodObj.h"

@implementation ZooAnimal
@synthesize animalkind = _animalkind, feedingfoodtype = _feedingfoodtype, totfeedingcounts = _totfeedingcounts, curfeedingcounts = _curfeedingcounts;
@synthesize imgScore = _imgScore , isStuffed = _isStuffed , rightScores = _rightScores, wrongScores = _wrongScores;

- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super init]) {
		//[super initWithStart];
		_image = image;
		self.freeTexture = NO;/*don't free the texture image while parent dealloc*/
		ori_no = self.no = no;
		self.pos = pos;
		self.type = type;
		bResponse = NO;
	}
	return self;	
}

- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y-5;
		aRect.size.width = _image.tileWidth;
		aRect.size.height = _image.tileHeight-20;
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


- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts{
	if (self = [super init]) 
	{
		_state = ZAEmotionNormal;
		
		_animalkind = kind;
		_feedingfoodtype = (ZooAnimalFoodstuff)_animalkind+1;
		_totfeedingcounts = feedcounts;
		_curfeedingcounts = 0;
		_isStuffed = NO;
		_rightScores = 0;
		switch (_animalkind) {
			case ZAKindGiraffe:
				[self loadImageFromFile: @"GAM_Zooff_ANI_Girafee.png" tileWidth:80 tileHeight:80];
	
				foodIdx = [[Texture2D alloc] fromFile:@"ZM_G_Food_Leaf.png"];				
				
//				self.pos = CGPointMake(80.0, 230.0);
				break;
			case ZAKindLion:
				[self loadImageFromFile: @"GAM_Zooff_ANI_Lion.png" tileWidth:80 tileHeight:80];

				foodIdx = [[Texture2D alloc] fromFile:@"ZM_G_Food_Meat.png"];		
				
				//				self.pos = CGPointMake(80.0, 160.0);
				break;
			case ZAKindRabbit:
				[self loadImageFromFile: @"GAM_Zooff_ANI_Rabbit.png" tileWidth:80 tileHeight:80];
//				self.pos = CGPointMake(80.0, 110.0);
								foodIdx = [[Texture2D alloc] fromFile:@"ZM_G_Food_Carrot.png"];	
				break;
			case ZAKindHorse:
				[self loadImageFromFile: @"GAM_Zooff_ANI_Horse.png" tileWidth:80 tileHeight:80];
//                self.pos = CGPointMake(80.0, 45.0);
												foodIdx = [[Texture2D alloc] fromFile:@"ZM_G_Food_Grass.png"];	
				break;
			default:
				break;
		}


		[foodIdx SetTileSize:39 tileHeight:34];
		
		_imgScore = [[Texture2D alloc] fromFile:@"ZM_G_Food-numbers.png"];
		if (_imgScore != nil) {
			[_imgScore SetTileSize:8 tileHeight:11];
		}
	
	}
	return self;	
}

- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts Point:(CGPoint) point view:(id)view{
    EAGLView *gameView = view;
	if (self = [super init]) {
		[super initWithStart];
		[self initWithZooAnimalKind:kind FeedCounts:feedcounts];
		self.pos = point;
	}	
	
	//init sound path {{ //pohsu
	animalSoundEffect = gameView.soundEffect; 
	bundle = gameView.bundle;
	
	if(point.x < 160.0)
	{
		if(kind == ZAKindLion || kind == ZAKindHorse )
			_angleY = 180.0;
		else
			_angleY = 0.0;
	}	
	else
	{
		if(kind == ZAKindGiraffe || kind == ZAKindRabbit )
			_angleY = 180.0;
		else
			_angleY = 0.0;
	}
	
	return self;	
}

- (void)resetWithTotFeedingCounts:(uint)feedcounts{
	_state = ZAEmotionNormal;
	_totfeedingcounts = feedcounts;
	_curfeedingcounts = 0;
	_isStuffed = NO;
	_rightScores = 0;
	_wrongScores = 0;
}

- (NSInteger) OtherActionRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	if(bTouch)
	{
		if ([touchMode isEqualToString:@"Began"])
		{
			if ([self pointInImage:x y:y]) 
			{
				_no = 5;
				bResponse = YES;				
			}
		}	
		else if ([touchMode isEqualToString:@"Move"])
		{
			if (![self pointInImage:x y:y]) 
			{
				bResponse = NO;	
			}
		}	
	}
	else
	{	
		if(main_Game.gameStageState == GSStateGameDemo)
		{
			if(main_Game.DemoState < _DEMO_STATE_3 || _animalkind != ZAKindLion)
				return 0;
			
			if(main_Game.DemoState == _DEMO_STATE_3 && _animalkind == ZAKindLion)
			{	
				main_Game.DemoState = _DEMO_STATE_4;
			}	
		}
		
		if ([touchMode isEqualToString:@"End"]) 
		{
			if (bResponse && [self pointInImage:x y:y]) 
			{	
				_state = ZAEmotionIsHitted;
				if([main_Game.zaMkObj ckMonkeyHandState]==TRUE)
				{
					/*no need flyfood
					ZooAnimalFoodstuff aa = [main_Game.zaMkObj reHandFood];
					flyfoodObj *ffObj;
					int xxx = main_Game.zaMkObj.pos.x;
					int yyy = main_Game.zaMkObj.pos.y;

					ffObj = [[flyfoodObj alloc] initWithFoodTypeStartPosStopPos:aa goalType:_animalkind bigx:xxx bigy:yyy endx:_pos.x endy:_pos.y];
					[main_Game.gameAnimManager requestWithObj:ffObj];
					 */
					[main_Game.zaMkObj restMkActState];
				}
			}
		}
	}
	
	return 0;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *game = gameView.main_Game;
	
	NSInteger rtn;
	
	switch(_animalkind)
	{
		case ZAKindGiraffe:	
		case ZAKindLion:
		case ZAKindRabbit:
		case ZAKindHorse:		
		{ 
			//Handle feed  
			rtn  = [self OtherActionRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		}				
	}
	
    switch (game.gameStageState) 
	{
		case GSStateGameOver:
			_state = ZAEmotionDepressed;
			break;
		case GSStateGameSucceed:
			_state = ZAEmotionJoyful;
			break;
		default:			
			if((_state == ZAEmotionNormal)||(_state == ZAEmotionDepressed))
			{
				_wait= SUSTAINEDFRAMES * 4;
			}
			else
			{
				if(--(_wait) == 0)
				{
					_state = ZAEmotionNormal;
					_count = 0;
					_scaleX = 1.0;
					_scaleY = 1.0;
				}
				_scaleX = 1.1;
				_scaleY = 1.1;
			}
			
			if(_count == 1200)
			{
				_state = ZAEmotionDepressed;
			}
	
			break;
	}
	
	if(_state == ZAEmotionNormal || _state == ZAEmotionJoyful || _state == ZAEmotionAngry || _state == ZAEmotionDepressed)
	{	
		_no = ((_count/SUSTAINEDFRAMES)% 2)*6 +  _state ;
	}
	
	if(_state == ZAEmotionIsHitted)
	{	
		_scaleX = 1.2;
		_no = 4;
	}	
//	_no = 4;//(_count / SUSTAINEDFRAMES) % 4 + (_state)*5;
	_count++;

	return 0;
}

-(BOOL) feedWithFood:(ZooAnimalFoodstuff)foodstuff 
{				
	if(_feedingfoodtype == foodstuff)
	{
		_rightScores += CORRECTSCORE4;
		_curfeedingcounts++;
		if(_curfeedingcounts>=_totfeedingcounts)
		{
			_isStuffed = YES;
		}
		_state = ZAEmotionJoyful;
		[self PlaySoundByAnimalType];
		return YES;
	}
	else
	{

		_wrongScores += WRONGSCORE;
#if 0  //Jarsh
		if(_rightScores < 0)
		{
			_rightScores = 0;
		}
#endif
		_state = ZAEmotionAngry;
		[self PlaySoundByAnimalType];
		return NO;
	}
} 

-(void)PlaySoundByAnimalType 
{
	CFURLRef fileURL;
	if(_state == ZAEmotionJoyful)
	{
	switch (_animalkind) {
		case ZAKindGiraffe:
			if(tmpSoundJoyful[ZAKindGiraffe] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Giraffe_Right" ofType:@"wav"]] retain];
				tmpSoundJoyful[ZAKindGiraffe] = [animalSoundEffect requestSEWithURL:fileURL];
						CFRelease(fileURL);
			}
			animalSoundObj=tmpSoundJoyful[ZAKindGiraffe];
			break;	
		case ZAKindLion:
			if(tmpSoundJoyful[ZAKindLion] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Lion_Right" ofType:@"wav"]] retain];
				tmpSoundJoyful[ZAKindLion] = [animalSoundEffect requestSEWithURL:fileURL];
						CFRelease(fileURL);
			}
			animalSoundObj=tmpSoundJoyful[ZAKindLion];
			break;
		case ZAKindHorse:
			if(tmpSoundJoyful[ZAKindHorse] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Horse_Right" ofType:@"wav"]] retain];
				tmpSoundJoyful[ZAKindHorse] = [animalSoundEffect requestSEWithURL:fileURL];
						CFRelease(fileURL);
			}
			animalSoundObj=tmpSoundJoyful[ZAKindHorse];
			break;
		case ZAKindRabbit:
			if(tmpSoundJoyful[ZAKindRabbit] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Rabbit_Right" ofType:@"wav"]] retain];
				tmpSoundJoyful[ZAKindRabbit] = [animalSoundEffect requestSEWithURL:fileURL];
						CFRelease(fileURL);
			}
			animalSoundObj=tmpSoundJoyful[ZAKindRabbit];
			break;
			
		default:
			break;
	 }
		[animalSoundEffect play:animalSoundObj sourceNumber:2];
	}
	else if(_state == ZAEmotionAngry)
	{
		switch (_animalkind) {
			case ZAKindGiraffe:
				if(tmpSoundAngry[ZAKindGiraffe] == nil)
				{
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Giraffe_Wrong" ofType:@"wav"]] retain];
					tmpSoundAngry[ZAKindGiraffe] = [animalSoundEffect requestSEWithURL:fileURL];
							CFRelease(fileURL);
				}
				animalSoundObj=tmpSoundAngry[ZAKindGiraffe];
				break;	
			case ZAKindLion:
				if(tmpSoundAngry[ZAKindLion] == nil)
				{
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Lion_Wrong" ofType:@"wav"]] retain];
					tmpSoundAngry[ZAKindLion] = [animalSoundEffect requestSEWithURL:fileURL];
							CFRelease(fileURL);
				}
				animalSoundObj=tmpSoundAngry[ZAKindLion];
				break;
			case ZAKindHorse:
				if(tmpSoundAngry[ZAKindHorse] == nil)
				{
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Horse_Wrong" ofType:@"wav"]] retain];
					tmpSoundAngry[ZAKindHorse] = [animalSoundEffect requestSEWithURL:fileURL];
							CFRelease(fileURL);
				}
				animalSoundObj=tmpSoundAngry[ZAKindHorse];
				break;
			case ZAKindRabbit:
				if(tmpSoundAngry[ZAKindRabbit] == nil)
				{
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle	pathForResource:@"SFX_Rabbit_Wrong" ofType:@"wav"]] retain];
					tmpSoundAngry[ZAKindRabbit] = [animalSoundEffect requestSEWithURL:fileURL];
							CFRelease(fileURL);
				}
				animalSoundObj=tmpSoundAngry[ZAKindRabbit];
				break;
				
			default:
				break;
		}
		[animalSoundEffect play:animalSoundObj sourceNumber:2];
	}
}

- (void) drawImageWithFade:(GLfloat)fadelevel 
{
	[super drawImageWithFade:fadelevel];
	
	if (_imgScore) {
		char str[5] = "";
		int x = 20;
		int y = 420- _animalkind *15;

		[foodIdx drawImageWithNo:CGPointMake(x, y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:0.5f scaleY:0.5f scaleZ:1.0f alpha:fadelevel];
		x += 14;		
		
		if(_totfeedingcounts == 99)
		{	
			sprintf(str, "%d", _curfeedingcounts);
			for (int i = 0; i < strlen(str); i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
		}	
		else
		{	
			sprintf(str, "%02d", _curfeedingcounts);
			for (int i = 0; i < 2; i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
			[_imgScore drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:SCORESCALE scaleZ:SCORESCALE alpha:fadelevel];
			x +=FOODNUMBERSOFFSET;
			sprintf(str, "%02d", _totfeedingcounts);
			for (int i = 0; i < 2; i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}								
		}	
		
	}
}	
	
+(NSInteger) ZACountingScores:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	NSInteger totalScores = 0;
	for(idx=0;idx< zaCounts;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		totalScores += zaObj.rightScores; 
	}
	return totalScores;
}

//pohsu{
+(NSInteger) ZACountingFailedScores:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
//	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	NSInteger totalFailedScores = 0;
	for(idx=0;idx< 4;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		totalFailedScores += zaObj.wrongScores; 
	}
	return totalFailedScores;
}
//pohsu}

-(BOOL) getStuffedVal
{
	return _isStuffed;
}

+(NSInteger) ZooAnimalsAllStuffed:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	BOOL bStuffed;
	
	
	for(idx=0;idx< zaCounts;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		bStuffed = [zaObj getStuffedVal]; 
		if(bStuffed!=YES)
		{
			return 0;
		}
	}
	return 1;
}

- (void) dealloc {
#if 0
	if(FoodOnH!=nil)
	{
		[FoodOnH release];
	}
	FoodOnH = nil;
#endif	
	if(_imgScore!=nil)
		[_imgScore release];
	_imgScore = nil;
	[SESoundObj release];
	[super dealloc];
}
@end
