//
//  LoadingAnimation.m
//  game
//
//  Created by FIH on 2009/10/6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LoadingAnimation.h"
#import "EAGLView.h"

@implementation LoadingAnimation
-(BOOL)initLoadAnim:(id)view{
	//EAGLView *gameView = view;
	
	loadingDot = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Loading_Dot.PNG"];
	if (loadingDot != nil){
		[loadingDot SetTileSize:16 tileHeight:16];
	}
	
	return YES;
}
-(BOOL)drawLoadAnim:(id)view fadeLevel:(GLfloat)fadeLevel{
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	switch (main_Game.zaglsLoadingState) {
		case ZAGLS_BGSound:
			dots = 1;
			break;
		case ZAGLS_ZooManager:
			dots = 2;
			break;
		case ZAGLS_FailCount:
			dots = 3;
			break;
		case ZAGLS_VarDeclare:
			dots = 4;
			break;
	}
	if(loadingDot!=nil)
	{
		int loc_x = 215;
		int loc_y = 260;
		
		for(int i = 0; i < dots; i++)
		{
			[loadingDot drawImageWithNo:CGPointMake(loc_x, loc_y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];	
			loc_x+=15;
		}
		
	}
	return YES;
}
-(BOOL)endLoadAnim:(id)view{
	//EAGLView *gameView = view;
	if (loadingDot != nil)
		[loadingDot release];
	loadingDot = nil;
	return YES;
}
@end
