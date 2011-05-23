//
//  map.m
//  game
//
//  Created by fih on 2009/10/5.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "mainGameMap.h"
#import "EAGLView.h"
#ifdef LITE_VERSION
int arr[TOPGAMELEVEL] = {0,0,0};
#else
int arr[TOPGAMELEVEL] = {0,1,2,0,1/*,0,1,2,0,1,2*/};
#endif

static CGPoint btnPosLv1[4] = {{38.0, 96.0},{118.0, 96.0}, {199.0, 96.0},{280.0, 96.0}};
static CGPoint btnPosLv2[4] = {{39.0, 96.0},{123.0, 96.0}, {204.0, 96.0},{289.0, 96.0}};
static CGPoint btnPosLv3[4] = {{38.0, 116.0},{118.0, 116.0}, {199.0, 116.0},{280.0, 116.0}};


@implementation mainGameMap
-(BOOL)initMap:(id)view
{
	EAGLView *gameView = view;
	mainGame *mainView = gameView.main_Game;
	CGRect mainbounds = gameView.bounds;

	trans1 = [[Texture2D alloc] fromFile:@"GAM_Zooff_Trans.PNG"];
	if (trans1 != nil){
		[trans1 SetTileSize:320 tileHeight:480];
	}
	
	trans2 = [[Texture2D alloc] fromFile:@"GAM_Zooff_Trans_no_LV.PNG"];
	if (trans2 != nil){
		[trans2 SetTileSize:320 tileHeight:480];
	}
	
	//load background map
	if (mainView.gameBackground != nil)
	{
		[mainView.gameBackground release];
		mainView.gameBackground = nil;
	}
	
	if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
	{
		mainView.gameBackground = [[Texture2D alloc] fromFile:@"GAM_Zooff_END_BG.PNG"];
		
		for(int j=0; j < 4; j++)
		{
			btnPos[j] = btnPosLv3[j];
			
			btnClk[j] = [[Texture2D alloc] fromFile:@"GAM_Zooff_L3_Optima.png"];
			[btnClk[j] SetTileSize:86 tileHeight:50];
			btnCnt[j] = 0;
		}			
	}
	else
	{
		NSString *background_map =[[NSArray arrayWithObjects:@"GAM_Zooff_L1_BG.PNG",@"GAM_Zooff_L2_BG.PNG",@"GAM_Zooff_L3_BG.PNG",nil] objectAtIndex:arr[mainView.gameLevel-1]];
		NSString *btn_click =[[NSArray arrayWithObjects:@"GAM_Zooff_L1_Optima.png",@"GAM_Zooff_L2_Optima.png",@"GAM_Zooff_L3_Optima.png",nil] objectAtIndex:arr[mainView.gameLevel-1]];

		mainView.gameBackground = [[Texture2D alloc] fromFile:background_map];	
		for(int j=0; j < 4; j++)
		{	
			if(arr[mainView.gameLevel-1] == 0)
				btnPos[j] = btnPosLv1[j];
			else if(arr[mainView.gameLevel-1] == 1)
				btnPos[j] = btnPosLv2[j];
			else if(arr[mainView.gameLevel-1] == 2)
				btnPos[j] = btnPosLv3[j];

			btnClk[j] = [[Texture2D alloc] fromFile:btn_click];
			if(arr[mainView.gameLevel-1] == 2)
				[btnClk[j] SetTileSize:86 tileHeight:50];
			else	
				[btnClk[j] SetTileSize:86 tileHeight:88];
			btnCnt[j] = 0;
		}	
	}	
	
	if (mainView.gameBackground != nil) 
	{
		[mainView.gameBackground SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}

	return TRUE;	
}

-(BOOL)drawMap:(id)view fadeLevel:(GLfloat)fadeLevel
{
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	CGRect mainBounds = gameView.bounds; 
	int i;
	
	for(i=0 ; i < 4; i++ )
	{
		if((1<<i)&gameView.btnBit)
		{
			btnCnt[i] = 30;
			gameView.btnBit &= !(1<<i);
		}	
	}	
	
	for(i=0 ; i < 4; i++ )
	{
		if(btnCnt[i])
		{			
			[btnClk[i] drawImageWithNo:btnPos[i] no:0  angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
			btnCnt[i]--;		
		}		
	}
	
	if (gameView.endlessMode == _INIFINITY_TIME_LEVEL){
		if (gameView.tmpDelta2 > 0)
			[trans2 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else if((main_Game.gameFrameCount/10)%3 == 0 )
			[trans2 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else if((main_Game.gameFrameCount/10)%3 == 1 )
			[trans2 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:1 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else
			[trans2 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:2 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];		
	}else{
		if (gameView.tmpDelta2 > 0)
			[trans1 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else if((main_Game.gameFrameCount/10)%3 == 0 )
			[trans1 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else if((main_Game.gameFrameCount/10)%3 == 1 )
			[trans1 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:1 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
		else
			[trans1 drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:2 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
	}
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

@end
