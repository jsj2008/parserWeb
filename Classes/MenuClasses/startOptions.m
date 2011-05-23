//
//  startOptions.m
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startOptions.h"
#import "EAGLView.h"
#import "SimpleButton.h"
#define SoundButtonPOSITION CGPointMake(160, 255)
#define MusicButtonPOSITION CGPointMake(160, 120)
#define BackButtonPOSITION CGPointMake(260, 40)
@implementation startOptions

@synthesize optionsItemType;

- (BOOL)initOptions:(id)view {
	
	EAGLView *gameView = view;
	
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Options_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:320 tileHeight:480];
	}
	
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		//create menu item START
		/*Jarsh added */

		SimpleButton *soundsBtn = [[SimpleButton alloc]initWithType:SBTypeOptionsSounds Position:SoundButtonPOSITION];
		[gameView.animManager requestWithObj:soundsBtn];
		
		SimpleButton *musicBtn = [[SimpleButton alloc]initWithType:SBTypeOptionsMusic Position:MusicButtonPOSITION];
		[gameView.animManager requestWithObj:musicBtn];


		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeOptionsBack Position:BackButtonPOSITION];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/
	}
	
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_OPTIONS];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}

- (BOOL)processOptions:(id)view {
	
	return TRUE;
}

- (BOOL)endOptions:(id)view {
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	
	if (gameView.ScreenFrom == MainMenuCategory)
		gameView.gameState = GS_INIT_MENU;
	else
		gameView.gameState = GS_INIT_PAUSE;
	
	[gameView saveToFileSystem];

	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}


@end
