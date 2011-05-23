//
//  startLogo.m
//  game
//
//  Created by StevenKao on 2009/9/14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startLogo.h"
#import "EAGLView.h"


@implementation startLogo

- (BOOL)initLogo:(id)view {
	
	EAGLView *gameView = view;
	
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"logo.png"];
	if (gameView.background != nil) {
		if ([gameView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
		{	
			// Landscape and the home button on the right side
			[gameView.background SetTileSize:480 tileHeight:320];
		}
		else
		{	// Portrait mode
			[gameView.background SetTileSize:320 tileHeight:480];
		}
	}
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_LOGO];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}

- (BOOL)processLogo:(id)view {
	
	EAGLView *gameView = view;
	
	// switch to next page after 4 sec or press screen
	if (([gameView.touchMode isEqualToString:@"End"]) || (gameView.frameCount > 240)) {
		[gameView fadeOutWithState:GS_END_LOGO];
	}
	return TRUE;
}

- (BOOL)endLogo:(id)view {
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	
	// process to next state
	gameView.gameState = GS_INIT_TITLE;
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}

@end
