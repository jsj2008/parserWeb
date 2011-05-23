//
//  startFullVersion.m
//  game
//
//  Created by FIH on 2009/11/5.
//  Copyright 2009 Foxconn International Gaming. All rights reserved.
//

#import "startFullVersion.h"
#import "EAGLView.h"
#import "SimpleButton.h"

@implementation startFullVersion
@synthesize selItemType;
-(BOOL)initFullVer:(id)view{
	
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"GAM_Buy_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		//create menu item START
		/*Jarsh added */
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeFullVerBack Position:CGPointMake(455, 23)];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/
#ifdef LITE_VERSION		
		SimpleButton *linkBtn = [[SimpleButton alloc]initWithType:SBTypeBuyFullVersionLink Position:CGPointMake(143, 194)];
		[gameView.animManager requestWithObj:linkBtn];
#endif		
#ifdef FIG_ADWHIRL
		gameView.rollerView.hidden = NO;
#endif
		
	}		
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_FULLVER];
	
	// init frame count
	gameView.frameCount = 0;
	return TRUE;
}
-(BOOL)processFullVer:(id)view{
	return TRUE;
}
-(BOOL)endFullVer:(id)view{
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	
#ifdef FIG_ADWHIRL
	gameView.rollerView.hidden = YES;
#endif
	switch (selItemType) {
		case SBTypeFullVerBack:
			gameView.gameState = GS_INIT_MENU;
			break;
#ifdef LITE_VERSION			
		case SBTypeBuyFullVersionLink:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=335771243&mt=8"]];
			break;
#endif			
		default:
			break;
	}
	
	return TRUE;
}

@end
