//
//  startHelp.m
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startHelp.h"
#import "EAGLView.h"
#import "SimpleButton.h"

#define _BUTTON_POS_X 270
#define _BUTTON_POS_Y 35	
#define _BUTTON_SIZE_WIDTH	83
#define _BUTTON_SIZE_HEIGHT 30


@implementation startHelp

- (BOOL)initHelp:(id)view {
	
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	// backupground
	//gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Help.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		
		AnimObj *obj = [gameView.animManager requestWithObj:[[startHelp alloc] initWithStart] strName:@"mnu_help_all.png" tileWidth:320 tileHeight:480];
		if(obj!=nil)
		{
			obj.pos = CGPointMake(160, 240);
			obj.state = 0;
		}	
		//create menu item START
		/*Jarsh added */
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeHelpBack Position:CGPointMake(260, 40)];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/
		StartButton = nil;
		
	}		
	_state = 0;
	butNo = 0;
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_HELP];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}


- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _BUTTON_POS_X;
		aRect.origin.y = _BUTTON_POS_Y;
		aRect.size.width = _BUTTON_SIZE_WIDTH;
		aRect.size.height = _BUTTON_SIZE_HEIGHT;
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

- (id)initEX
{
	if (self = [super init])
	{
		[self loadImageFromFile:@"mnu_help_all.png" tileWidth:320 tileHeight:480];		
		
		self.state = 1;
		self.pos = CGPointMake(160, 240);
		StartButton = [[Texture2D alloc] fromFile:@"start_button.png"];
		if (StartButton != nil) {
			[StartButton SetTileSize:_BUTTON_SIZE_WIDTH tileHeight:_BUTTON_SIZE_HEIGHT];
		}	
	}
	return self;
}

- (BOOL)initHelpWithDemo:(id)view {	
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	// backupground
	//	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zoo_C_Main_Help_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) 
	{		
		[gameView.animManager requestWithObj:[[startHelp alloc] initEX]];			
	}		
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_HELP];
	butNo = 0;
	
	bResponse = NO;
	// init frame count
	gameView.frameCount = 0;
	return TRUE;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;
		
	if((bTouch == TRUE) && ([touchMode isEqualToString:@"Began"]))
	{
		[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
	}	
		
	if(_state == 1 && _no ==2)
	{
		if(bTouch)
		{
			if ([touchMode isEqualToString:@"Began"])
			{
				if ([self pointInImage:x y:y]) 
				{
					bResponse = YES;
				}
				butNo = 1;
			}
			else if ([touchMode isEqualToString:@"Move"]){
				if (![self pointInImage:x y:y]) {
					//_no = 0;
					bResponse = NO;
					
				}
			}
		}
		
	}	
		
		
	if([touchMode isEqualToString:@"End"])
	{
		if(bTouch!=TRUE && bResponse == YES)
		{
			gameView.showDemo = _HAD_DEMO_GAME_FLAG_;
			[gameView writeNVitemDemo]; 

			gameView.main_Game.gameFrameCount = 0; 
//			[game gameResetVar];
			gameView.main_Game.gameStageState = GSStateProgress;
//			[gameView fadeOutWithState:GS_END_HELP];
			
			gameView.gameState = GS_PROCESS_GAME;
			return -1;
		}
		else
			_no = (_no+1)%3;
	}
	
	return 0;
}

- (void) drawImageWithFade:(GLfloat)fadelevel {
	[super drawImageWithFade:fadelevel];
	
	if(_state==1 && _no ==2)
	{
		if(StartButton != nil)
		{
			[StartButton drawImageWithNo:CGPointMake(_BUTTON_POS_X, _BUTTON_POS_Y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];			
		}	
	}	
}

- (BOOL)processHelp:(id)view {
	return TRUE;
}

- (BOOL)endHelp:(id)view {
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	
	{
	if (gameView.ScreenFrom == MainMenuCategory)
		gameView.gameState = GS_INIT_INFO;
	else
		gameView.gameState = GS_INIT_PAUSE;
	}	
	
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
	if(StartButton!=nil)
		[StartButton release];
	StartButton =nil;
}


@end
