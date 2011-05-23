//
//  pauseMenu.m
//  game
//
//  Created by Taco on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "pauseMenu.h"
#import "CombinedButton.h"
//#import "SimpleButton.h"
#define PAUSEMNU_TILEHEIGHT 47
#define PAUSEMNU_TILEWIDTH	148
#define Y_OFFSET 60
#define Y_1STVAL 355
IMAGEFILEINFO PAUSEMENUDATA[] = {
{PAUSEMNU_TILEWIDTH, PAUSEMNU_TILEHEIGHT, 160,  Y_1STVAL,            0, CBTypePauseResume},
{PAUSEMNU_TILEWIDTH, PAUSEMNU_TILEHEIGHT, 160,  Y_1STVAL-Y_OFFSET,   3, CBTypePauseRestart},
{PAUSEMNU_TILEWIDTH, PAUSEMNU_TILEHEIGHT, 160,  Y_1STVAL-Y_OFFSET*2, 6, CBTypePauseOptions},
{PAUSEMNU_TILEWIDTH, PAUSEMNU_TILEHEIGHT, 160,  Y_1STVAL-Y_OFFSET*3, 9, CBTypePauseHelp},
{PAUSEMNU_TILEWIDTH, PAUSEMNU_TILEHEIGHT, 160,  Y_1STVAL-Y_OFFSET*4, 12, CBTypePauseMainMenu},
{0, 0, 0, 0, -1, 0}
};


@implementation pauseMenu

@synthesize selItemType;
@synthesize btnImage;

-(BOOL)initPauseMenu:(id)view {
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	
	// init screen come from
	gameView.ScreenFrom = PauseMenuCategory;
	
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Pause_BG.png"];

//	gameView.background = [[Texture2D alloc] fromFile:@"ZM_G_Pause_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}
	
	// create Menu item
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		int idx = 0;
		GLuint w, h;
		GLuint tileWidth  = PAUSEMENUDATA[idx].tilewidth;
		GLuint tileHeight = PAUSEMENUDATA[idx].tileheight;
		
		btnImage = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Pause_Btn.png"];
		if (btnImage != nil) {
			if (tileWidth > 0 && tileWidth <= btnImage.width)
				w = tileWidth;
			else
				w = btnImage.width;
			if (tileHeight > 0 && tileHeight <= btnImage.height)
				h = tileHeight;
			else
				h = btnImage.height;
			[btnImage SetTileSize:w	tileHeight:h];
		}
		
		
		if(btnImage!=nil)
		{
			while (PAUSEMENUDATA[idx].no != -1)
			{
				CGPoint point = CGPointMake(PAUSEMENUDATA[idx].x, PAUSEMENUDATA[idx].y);
				CombinedButton* btnObj = [[CombinedButton alloc]initWithTexture2D:btnImage No: PAUSEMENUDATA[idx].no Type:PAUSEMENUDATA[idx].type Position:point];
				[gameView.animManager requestWithObj:btnObj];
				idx++;
			}
		}	
		/*Jarsh added */
		//SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypePauseBack Position:CGPointMake(240, 18)];
		//[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/
	}	
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_PAUSE];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}

-(BOOL)processPauseMenu:(id)view {
	return TRUE;
}

-(BOOL)endPauseMenu:(id)view {
	EAGLView *gameView = view;
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	if (gameView.animManager != nil)
	{
		[gameView.animManager release];
	    gameView.animManager = nil;
	}
	
	if (btnImage != nil)
		[btnImage release];
	btnImage = nil;
	
	switch (selItemType) {
		case CBTypePauseResume : //RESUME
		    //gameView.gameState = GS_PROCESS_GAME;
			[gameView fadeInWithState:GS_PROCESS_GAME];  /*Jarsh*/
			break;
		case CBTypePauseRestart : //RESTART
            //Only In GSStateProgress State can pause the game. 
			if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
				gameView.endlessMode = 0;
			[gameView.main_Game endGame:view];
			gameView.gameState = GS_INIT_GAME;
			break;
		case CBTypePauseOptions : //OPTIONS
			gameView.gameState = GS_INIT_OPTIONS;
			break;
		case CBTypePauseHelp : //HELP
			gameView.gameState = GS_INIT_HELP;
			break;
		case CBTypePauseMainMenu : //MAIN MENU
			if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
				gameView.endlessMode = 0;
			gameView.gameState = GS_INIT_MENU;
			break;
		/*case SBTypePauseBack:
			gameView.gameState = GS_INIT_MENU;
			break;*/
	}
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}

@end
