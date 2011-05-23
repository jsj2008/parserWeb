//
//  StartCredit.m
//  game
//
//  Created by Taco on 2009/9/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startCredit.h"
#import "EAGLView.h"
#import "SimpleButton.h"

@implementation startCredit

@synthesize creditItemType;

- (BOOL)initCredit:(id)view {
	
	EAGLView *gameView = view;
	
	// backupground	
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Credits_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:320 tileHeight:480];
	}	
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		//create menu item START
		/*Jarsh added */
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeCreditsBack Position:CGPointMake(260,40)];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/	
		
	}	
	
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_CREDIT];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}

- (BOOL)processCredit:(id)view {
	return TRUE;
}

- (BOOL)endCredit:(id)view {
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	if (gameView.animManager != nil)
		[gameView.animManager release];
	
	gameView.animManager = nil;
	
	gameView.gameState = GS_INIT_INFO;
	
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}

@end
