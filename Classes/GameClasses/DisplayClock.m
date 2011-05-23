//
//  DisplayClock.m
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DisplayClock.h"
#import "EAGLView.h"
#define SCOREPERSEC 2

@implementation DisplayClock
@synthesize countdownSecs;
@synthesize showSecs;
@synthesize gamelevel;
@synthesize imgLevel;

- (id) initWithSecs:(int)secs GameLevel:(NSInteger)level{
	if (self = [super init]) {
		//[super initWithStart];

		gamelevel = level;
		
		if(gamelevel == _INIFINITY_TIME_LEVEL)
		{
			imgLevel = [[Texture2D alloc] fromFile:@"GAM_Zooff_Time_infi.png"];
			if (imgLevel != nil) {
				[imgLevel SetTileSize:80 tileHeight:40];
			}
					
		}
		else	
		{	
			[self loadImageFromFile:@"ZM_G_Time-numbers.png" tileWidth:19 tileHeight:26];
			countdownSecs = secs;
			showSecs = countdownSecs;
			imgLevel = [[Texture2D alloc] fromFile:@"GAM_Zoo_C_Lv_Number.png"];
			if (imgLevel != nil) {
				[imgLevel SetTileSize:19 tileHeight:28];
			}
		}
		
	}
	return (self);	
}
- (void) resetWithSecs:(int)secs GameLevel:(NSInteger)level{
	
	countdownSecs = secs;
	showSecs = countdownSecs;
	gamelevel = level;

	if(gamelevel == _INIFINITY_TIME_LEVEL)
	{
		if(_image != nil)
		{
			[_image release];
		}
		_image = nil;
		
		[self loadImageFromFile:@"GAM_Zooff_Time_infi.png" tileWidth:80 tileHeight:40];
		
		if(imgLevel !=nil)
			[imgLevel release];
		imgLevel = nil;
		
		imgLevel = [[Texture2D alloc] fromFile:@"GAM_Zooff_Time_infi.png"];
		if (imgLevel != nil) {
			[imgLevel SetTileSize:80 tileHeight:40];
		}
		
	}	

	return ;	
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	int elapsedsecs = 0;
	switch (main_Game.gameStageState) {
		case GSStateGameDemo:
		case GSStateGameOver:
		case GSStateGameSucceed:
			break;
	
		default:
			if(gamelevel == _INIFINITY_TIME_LEVEL)
				break;
			elapsedsecs = main_Game.gameFrameCount/_SYSTEM_FRAME_COUNT_PER_SEC_;
			showSecs = (countdownSecs > elapsedsecs ? (countdownSecs-elapsedsecs) : 0);
			if(showSecs == 0)
			{
				gameView.main_Game.gameStageState = GSStateGameOver;
				//gameView.main_Game.gameStageState = GS_INIT_SCORE;
			}
			break;
	}

	
	return 0;
}
- (void) drawImageWithFade:(GLfloat)fadelevel {
	
	if(gamelevel == _INIFINITY_TIME_LEVEL)
	{
		if(_image)
			[_image drawImageWithNo:CGPointMake(160, 460) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		
		if(imgLevel)
		{
		//	[imgLevel drawImageWithNo:CGPointMake(80, 460) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		}
	}	
	else
	{
		if(_image) {
			int mins = showSecs/60;
			int secs = showSecs%60; 
			char str[5] = "";
			sprintf(str, "%02d", mins);
			int x = 130;
			int y = 465;
			for (int i = 0; i < 2; i++) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x += 15;
			}
			[_image drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x += 15;
			sprintf(str, "%02d",secs);
			for (int i = 0; i < 2; i++) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x += 15;
			}
		}
		
		if(imgLevel)
		{
			char str[5] = "";
			int x = 53;
			int y = 459;
			
			{
				sprintf(str, "%02d", gamelevel);
				for (int i = 0; i < 2; i++) {
					[imgLevel drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
					x += 15;
				}
				
			}	
			
		}
	}	
	
	
}
- (int) DCCountingScores{
	
	return showSecs * SCOREPERSEC;
}

- (void) dealloc {
	if(imgLevel!=nil)
		[imgLevel release];
	imgLevel = nil;
	[super dealloc];
}


@end
