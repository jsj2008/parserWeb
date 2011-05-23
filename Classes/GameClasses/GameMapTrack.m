//
//  map.m
//  game
//
//  Created by fih on 2009/10/5.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameMapTrack.h"
#import "EAGLView.h"
@implementation MapTrack

#if 0
-(BOOL)drawTrack:(id)view fadeLevel:(GLfloat)fadeLevel
{
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	CGRect mainBounds = gameView.bounds; 
	if((main_Game.gameFrameCount/30)%2){
		[trans1 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
	}
	else
	{
		[trans2 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
	}
	
	[woodBG drawImageWithNo:CGPointMake(155, 160.0) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];	
	
	[woodOverlay drawImageWithNo:CGPointMake(140.0, 151.0) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
	return TRUE;
}

-(BOOL)endMainGameMap:(id)view
{
#if 1
	EAGLView *gameView = view;
	mainGame *mainView = gameView.main_Game;
	if (mainView.gameBackground != nil)
		[mainView.gameBackground release];
	mainView.gameBackground = nil;
#endif
	
	if (woodBG != nil)
		[woodBG release];
	woodBG = nil;
	
	if (woodOverlay != nil)
		[woodOverlay release];
	woodOverlay = nil;
	
	if (trans1 != nil)
		[trans1 release];
	trans1 = nil;
	
	if (trans2 != nil)
		[trans2 release];
	trans2 = nil;	
	
	return TRUE;
}

-(void)dealloc
{
	[super dealloc];
}
#endif 

@end
