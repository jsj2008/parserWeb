//
//  EndScreen.m
//  game
//
//  Created by FIH on 2009/9/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EndScreen.h"
#import "EAGLView.h"
#import "mainGame.h"
#define ALPHAVAL 1.0

@implementation EndScreen
//@synthesize imgGameSucceed;
//@synthesize imgGameOver;
- (id)initWithStageState:(GameStageState)state view:(id)view{
	
	EAGLView *gameView = view;
	
	if (self = [super init]) {
		//[super initWithStart];
		[self setTextureImage:@"MNU_Zooff_C_Congratulations.png" StageState:state view:gameView];
		_pos = CGPointMake(160,240);
		_alpha = ALPHAVAL;
			
	}
	cnt = 30;

	return (self);	
}
-(void)setTextureImage:(NSString *)strFile StageState:(GameStageState) state view:(id)view{
	
	EAGLView *gameView = view;
	
	if(_image)
		[_image release];
	_image = nil;
	cnt = 30;

	if(state == GSStateGameSucceed)
	{
		[self loadImageFromFile: @"MNU_Zooff_C_Congratulations.png" tileWidth:320 tileHeight:480];
		[gameView PlaySoundEffect:EN_LevelSuccess playorstop:YES];
	}
	else if(state == GSStateGameOver)
	{
		[self loadImageFromFile: @"MNU_Zooff_C_GameOver.png" tileWidth:320 tileHeight:480];
		[gameView PlaySoundEffect:EN_LevelFail playorstop:YES];
	}
}
- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	
	if((--cnt) > 0)
		return 0;
	if ([touchMode isEqualToString:@"End"]) {
		//[gameView PlaySoundEffect:EN_LevelFail playorstop:NO];
		switch (main_Game.gameStageState) {
			case GSStateGameOver:
				[gameView fadeOutWithState:GS_END_GAME];
				break;
			case GSStateGameSucceed:
				[gameView fadeOutWithState:GS_INIT_SCORE];
				
			default:
				break;
		}
		
	}
	return 0;
}

@end
