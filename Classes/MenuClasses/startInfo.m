//
//  Info.m
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "startInfo.h"
#import "CombinedButton.h"
#import "SimpleButton.h"
#define INFOMNU_TITLEWIDTH 148
#define INFOMNU_TITLEHEIGHT 47
#define Y_OFFSET 60



//#define TRIALVERSION
#ifdef TRIALVERSION

#define Y_1STVAL 234

IMAGEFILEINFO INFOMENUDATA[] = {
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL,            0, CBTypeInfoCredit},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET,   1, CBTypeInfoMoreGames},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET*2, 2, CBTypeInfoBuy},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET*3, 10, CBTypeInfoWebsite},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET*4, 11, CBTypeInfoRanking},
{0, 0, 0, 0, -1, 0}
};
#else

#define Y_1STVAL 350

IMAGEFILEINFO INFOMENUDATA[] = {
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL,            0, CBTypeInfoCredit},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET,   3, CBTypeInfoHelp},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET*2, 6, CBTypeInfoWebsite},
{INFOMNU_TITLEWIDTH, INFOMNU_TITLEHEIGHT, 160, Y_1STVAL-Y_OFFSET*3, 9, CBTypeInfoRanking},
{0, 0, 0, 0, -1, 0}
};
#endif 


@implementation startInfo

@synthesize selItemType;
@synthesize btnImage;

- (BOOL)initInfo:(id)view {
	
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Info_BG.png"];
	if (gameView.background != nil) {
		[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
	}

	// create Menu item
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		int idx = 0;	
		btnImage = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Info_Btn.png"];
		if (btnImage != nil) {		
			[btnImage SetTileSize:148 tileHeight:47];
		}
		
		
		if(btnImage!=nil)
		{
			while (INFOMENUDATA[idx].no != -1)
			{
				CGPoint point = CGPointMake(INFOMENUDATA[idx].x, INFOMENUDATA[idx].y);
				CombinedButton* btnObj = [[CombinedButton alloc]initWithTexture2D:btnImage No: INFOMENUDATA[idx].no Type:INFOMENUDATA[idx].type Position:point];
				[gameView.animManager requestWithObj:btnObj];
				idx++;
			}
		}	
		/*Jarsh added */
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeInfoBack Position:CGPointMake(260, 40)];
		[gameView.animManager requestWithObj:backBtn];
		/*Jarsh added*/
	}	
	// process to next state
	[gameView fadeInWithState:GS_PROCESS_INFO];
	
	// init frame count
	gameView.frameCount = 0;
	
	return TRUE;
}

- (BOOL)processInfo:(id)view {
	return TRUE;
}

- (BOOL)endInfo:(id)view {
	
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
		case CBTypeInfoCredit :// credit
			gameView.gameState = GS_INIT_CREDIT;
			break;
		case CBTypeInfoHelp : // more game from just play
			gameView.gameState = GS_INIT_HELP;
			break;
		case CBTypeInfoBuy : // buy full version
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=335771243&mt=8"]];
			break;
		case CBTypeInfoWebsite : // check our website
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gamememore.com"]];
			break;
		case CBTypeInfoRanking ://Ranking
			gameView.main_ranking.sbType = SBTypeRankingBack;
			gameView.gameState = GS_INIT_RANKING;
			break;
		case SBTypeInfoBack : //Back to previous menu
			if (gameView.ScreenFrom == MainMenuCategory)
				gameView.gameState = GS_INIT_MENU;
			else
				gameView.gameState = GS_INIT_PAUSE;
			break;
		default:
			break;
	}
	
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}


@end
