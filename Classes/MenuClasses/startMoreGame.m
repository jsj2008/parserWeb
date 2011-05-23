//
//  startMoreGame.m
//  game
//
//  Created by Taco on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startMoreGame.h"
#import "EAGLView.h"
#import "SimpleButton.h"
#import "MoreGameObj.h"
#include <math.h>





@implementation startMoreGame

@synthesize selItemType;
@synthesize correct_page = _correct_page;

- (BOOL)initMoreGame:(id)view {
	
	EAGLView *gameView = view;
	MoreGameObj *Obj;
	CGPoint objPos;
	int page = 0,s = 0,t = 0,k = 0,offest  =0,imageNo = 0;

	
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_MoreGame_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:320 tileHeight:480];
	}
	// create animManager
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) 
	{
		//create menu item START
		/*Jarsh added */
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeMoreGamesBack Position:CGPointMake(260, 40)];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/		
	}

	// create Menu item
	//gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) 
	{
		MoreGameItem = [[Texture2D alloc] fromFile:@"MoreGames_Icon X10.png"];
			
		if(MoreGameItem!=nil)
		{
			[MoreGameItem SetTileSize:MOREGAME_TILEWIDTH tileHeight:MOREGAME_TILEHEIGHT];
		}			
		
		for(int i = 0; i< MOREGAME_ICON_ROW;i++)
		{
			for(int j = 0; j< MOREGAME_ICON_COL;j++)
			{
				k = j+i*MOREGAME_ICON_COL;
				if(k == MOREGAME_DISABLE_ICON_NUM-1)
				{
					offest =1;
				}
				
				imageNo =k+offest;
				s = (int)k%2;
				t = (k/2)%2;
				page = (int)k/4;

				if(page<MOREGAME_MAX_PAGE && imageNo<MOREGAME_MAX_PAGE*4)
				{
//					NSLog(@"page = %d,imageNo =%d ",page,imageNo);
					objPos.x = MOREGAME_ICON_FIRST_X;
					objPos.y = MOREGAME_ICON_FIRST_Y;
					objPos.x = objPos.x+MOREGAME_ICON_OFFSET_X*s+page*320;
					objPos.y = objPos.y-MOREGAME_ICON_OFFSET_Y*t;
					Obj = [[MoreGameObj alloc] initWithTexture2D:MoreGameItem Type:GAME_ICON_TYPE+imageNo Position:objPos Number:imageNo];
					[gameView.animManager requestWithObj:Obj];
				}
			}
		}
	
	}
	
	[self inttMultiplePage:view];

	[gameView fadeInWithState:GS_PROCESS_MOREGAME];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}


//robert liao add Multiple Page status..
-(BOOL)inttMultiplePage:(id)view
{
	EAGLView *gameView = view;
	float l_offsetX; 
	MoreGameObj *Obj;
	CGPoint objPos;
	//init..
	_correct_page = 1;

	MoreGamePage= [[Texture2D alloc] fromFile:@"MNU_AC_C_MoreGames_POINT.png"];
	if(MoreGamePage!=nil)
	{
		[MoreGamePage SetTileSize:MOREGAME_PAGE_TILE_W tileHeight:MOREGAME_PAGE_TILE_H];
	}	
	l_offsetX = (MOREGAME_PAGE_WIDTH*MOREGAME_MAX_PAGE)/2; 

	 for(int i =0;i< MOREGAME_MAX_PAGE;i++)
	 {
		 objPos.x = 160;
		 objPos.y =85;
		 objPos.x = objPos.x - (l_offsetX-MOREGAME_PAGE_WIDTH*i);
		 Obj = [[MoreGameObj alloc] initWithTexture2D:MoreGamePage Type:(MOREGAME_PAGE_TYPE+i) Position:objPos Number:0];
		 Obj.scaleX  =MOREGAME_PAGE_SCALE;
		 Obj.scaleY  =MOREGAME_PAGE_SCALE;
		 if(i==0)
			 Obj.no  = 0;
		 else
		     Obj.no   = 1;
		 [gameView.animManager requestWithObj:Obj];
	 }

	return TRUE;
	

}

	

- (BOOL)processMoreGame:(id)view {
	//EAGLView *gameView = view;
	
	

	return TRUE;
	
}

- (BOOL)endMoreGame:(id)view {
	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	
	gameView.background = nil;
	
	if (gameView.animManager != nil)
		[gameView.animManager release];
	
	gameView.animManager = nil;
	
	//printf("=[%d]===\n", selItemType);
	
		switch (selItemType) 
		{
		case SBTypeMoreGamesBack : //Back to MainMenu
			//if (gameView.ScreenFrom == MainMenuCategory)
			gameView.gameState = GS_INIT_MENU;
			//else
				//gameView.gameState = GS_INIT_PAUSE;
			break;
		case GAME_ICON_TYPE1: //MINI TRICKIE
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME1_URL]];
			break;
		case GAME_ICON_TYPE2: //DANCE DUO
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME2_URL]];
			break;
		case GAME_ICON_TYPE3: //DSB
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME3_URL]];
			break;
		case GAME_ICON_TYPE4://PAPER FISH
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME4_URL]];
			break;		
		case GAME_ICON_TYPE5://FISH SCROOPER
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME5_URL]];
			break;	
		case GAME_ICON_TYPE6:// ZOO MANAGER
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME6_URL]];
			break;	
		case GAME_ICON_TYPE7://SOUND SCRATCHER
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME7_URL]];
			break;	
		case GAME_ICON_TYPE8://ZOO MANAGER OFF
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME8_URL]];
			break;	
		case GAME_ICON_TYPE9://VIRUS FIGHTER
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME9_URL]];
			break;	
		case GAME_ICON_TYPE10://ANGEL IN CLOUD
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME10_URL]];
			break;	
		case GAME_ICON_TYPE11://Raining cats & dogs
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME11_URL]];
			break;	
		case GAME_ICON_TYPE12://Race'em home
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME12_URL]];
			break;	
		case GAME_ICON_TYPE13://Paper Airplane
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME13_URL]];
			break;	
		case GAME_ICON_TYPE14://Son of Fish
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAME14_URL]];
			break;	
		default:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAMEMEMORE_URL]];
			break;
			
	}
	

	return TRUE;
	}
	
- (void)dealloc {
	[super dealloc];
	if(MoreGameItem)
		[MoreGameItem release];	
	
}


@end
