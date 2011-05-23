//
//  MainMenu.m
//  game
//
//  Created by StevenKao on 2009/9/14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "mnuObj.h"
#import "AnimObjManager.h"
#import "startMainMenu.h"
#import "EAGLView.h"
#import "CombinedButton.h"
#ifdef LITE_VERSION
#import "SimpleButton.h"
#endif


//LuckyDraw {
#import "LuckyDrawObj.h"
//LuckyDraw }

#define Y_OFFSET 65
#define Y_1STVAL 350

int EndLessIdx = 0; 

#define EDNLESS_POSITION 3 

#if 0
IMAGEFILEINFO MAINMENUDATA[] = {
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL,				30, 0, CBTypeMainNewGame},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET,		30, 1, CBTypeMainResume},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET,		30, 5, CBTypeMainResume},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET*2,	30, 6, CBTypeMainEndlessMode},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET*2,	30, 2, CBTypeMainOptions},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET*3,	30, 3, CBTypeMainMoreGames},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, Y_1STVAL+Y_OFFSET*4,	30, 4, CBTypeMainInfo},
{0, 0, 0, 0, -1, 0}
};
#else
IMAGEFILEINFO MAINMENUDATA[] = {
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL,				0, CBTypeMainNewGame},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET,		3, CBTypeMainResume},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET,		15, CBTypeMainResume},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET*5+15,	18, CBTypeMainEndlessMode},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET*2,	6, CBTypeMainOptions},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET*3,	9, CBTypeMainMoreGames},
{MAINMNU_TILEWIDTH, MAINMNU_TILEHEIGHT, 155,	Y_1STVAL-Y_OFFSET*4,	12, CBTypeMainInfo},
{0, 0, 0, 0, -1, 0}
};

#endif


IMAGEFILEINFO MNUNOTICEDATA[] = {
{54,26, 112, 200, 0, CBTypeMainNoticeYes},
{54,26, 208, 200, 1, CBTypeMainNoticeNo},
{0, 0, 0, 0, -1, 0}
};


@implementation startMainMenu

@synthesize selItemType;
@synthesize yesnoPopup;
@synthesize mainMenuState;

-(BOOL)initMenu:(id)view 
{	
	EAGLView *gameView = view;
	// init screen come from
	gameView.ScreenFrom = MainMenuCategory; 
	
	// load backupground
#ifdef LITE_VERSION
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zoo_L_Menu_BG.png"];
#else	
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Main_BG.png"];
#endif	
	if (gameView.background != nil) 
	{	
		//[gameView.background SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
		// Landscape and the home button on the right side
		[gameView.background SetTileSize:320 tileHeight:480];
	}
	
	// create Menu item
	gameView.animManager = [[AnimObjManager alloc] initArray];
	//LuckyDraw {
	
	if(gameView.showLuckydrawIcon == YES)
	{
		gameView.LuckyDrawAnimManager = [[AnimObjManager alloc] initArray];
		if(gameView.LuckyDrawAnimManager != nil)
		{
			LuckyDrawObj *luckobj = [[LuckyDrawObj alloc]initWithType:CGPointMake(250,28) view:gameView ];
			[gameView.LuckyDrawAnimManager requestWithObj:luckobj];
		}
	}
	//LuckyDraw }
	if (gameView.animManager != nil) 
	{
#if 1		
		int idx = 0;			
#ifdef LITE_VERSION		
		//create menu item START
		SimpleButton *backBtn = [[SimpleButton alloc]initWithType:SBTypeMenuBuyFullVer Position:CGPointMake(426, 288)];
		[gameView.animManager requestWithObj:backBtn];
#endif		
#endif
#if 0	
		mnuObj *mObj5 = [[mnuObj alloc] initMnuObj:MNU_OBJ_SPEACH view:view];
		if(mObj5!=nil)
		{
			[gameView.animManager requestWithObj:mObj5];
		}
		
		
		mnuObj *mObj1 = [[mnuObj alloc] initMnuObj:MNU_OBJ_TITLE view:view];
		if(mObj1!=nil)
		{
			[gameView.animManager requestWithObj:mObj1];		
		}
		
		mnuObj *mObj2 = [[mnuObj alloc] initMnuObj:MNU_OBJ_MONKEY view:view];
		if(mObj2!=nil)
		{
			[gameView.animManager requestWithObj:mObj2];		
		}

		mnuObj *mObj3 = [[mnuObj alloc] initMnuObj:MNU_OBJ_BOX view:view];
		if(mObj3!=nil)
		{
			[gameView.animManager requestWithObj:mObj3];		
		}
		
		mnuObj *mObj4 = [[mnuObj alloc] initMnuObj:MNU_OBJ_ANIMAL view:view];
		if(mObj4!=nil)
		{
			[gameView.animManager requestWithObj:mObj4];		
		}

		mnuObj *mObj6 = [[mnuObj alloc] initMnuObj:MNU_OBJ_SPEACHRESPONSE view:view];
		if(mObj6!=nil)
		{
			[gameView.animManager requestWithObj:mObj6];		
		}
#endif
		//mnuObj *mObj7 = [[mnuObj alloc] initMnuObj:MNU_OBJ_TRACK view:view];
		//if(mObj7!=nil)
		//{
		//	[gameView.animManager requestWithObj:mObj7];		
		//}
		
		
		btnImage = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Main_Button.png"];
		//btnResumeImage = [[Texture2D alloc] fromFile:@"MNU_Zoo_C_Resume_Button.png"];			
		
		if(btnImage!=nil)
		{
			[btnImage SetTileSize:MAINMNU_TILEWIDTH tileHeight:MAINMNU_TILEHEIGHT]; 
		}
		
		
		if(btnImage!=nil)
		{
			CGPoint point;
			
			while (MAINMENUDATA[idx].no != -1) 
			{					
				if(gameView.enableEndless == _ENABLE_ENDLESS_MODE_)
				{
					if(MAINMENUDATA[idx].type == CBTypeMainEndlessMode)
					{
						EndLessIdx = idx;	
					}	
					
					if(idx > EndLessIdx)
					{
						point = CGPointMake(MAINMENUDATA[idx].x + Y_OFFSET, MAINMENUDATA[idx].y);
					}
					else
						point = CGPointMake(MAINMENUDATA[idx].x, MAINMENUDATA[idx].y);
					CombinedButton* btnObj = [[CombinedButton alloc]initWithTexture2D:btnImage No: MAINMENUDATA[idx].no Type:MAINMENUDATA[idx].type Position:point];
					[gameView.animManager requestWithObj:btnObj];	
				}	
				else
				{
					if(MAINMENUDATA[idx].type != CBTypeMainEndlessMode)
					{
						point = CGPointMake(MAINMENUDATA[idx].x, MAINMENUDATA[idx].y);
						CombinedButton* btnObj = [[CombinedButton alloc]initWithTexture2D:btnImage No: MAINMENUDATA[idx].no Type:MAINMENUDATA[idx].type Position:point];
						[gameView.animManager requestWithObj:btnObj];						
					}	
				}
				
				idx++;
			}
		}
		
	}
		
	//init&play sound
	if(gameView.song)
		[gameView.song close];
	
	[gameView.song initWithPath:[[NSBundle mainBundle] pathForResource:@"Relax jungle music" ofType:@"mp3"]];
	[gameView.song setRepeat:YES];
	if(gameView.musicOFF == NO)
	{
		[gameView.song play];
	}
	else
	{
		[gameView.song pause];
	}
	
	mainMenuState = MMenuStateNormal;
#ifdef FIG_ADWHIRL
	gameView.rollerView.hidden = NO;
#endif
	[gameView readFromFileSystem];//Jarsh
	
	// switch application state
	[gameView fadeInWithState:GS_PROCESS_MENU];
	
	return TRUE;
}

-(BOOL)processMenu:(id)view {
	return TRUE;
}
-(BOOL)initNoticePopup:(id)view {
	EAGLView *gameView = view;
	BOOL rtn = NO;
	if(gameView.PopupAnimManager == nil)
	{
		gameView.PopupAnimManager = [[AnimObjManager alloc] initArray];
		if(gameView.PopupAnimManager)
		{
			int idx = 0;
			yesnoPopup = [[Popup alloc]init];
			[gameView.PopupAnimManager requestWithObj:yesnoPopup];
			
			
			noticeImage = [[Texture2D alloc]fromFile:@"MNU_Zoo_C_Notice_Button.png"];
			
			if(noticeImage!=nil)
			{
				[noticeImage SetTileSize:MNUNOTICEDATA[idx].tilewidth tileHeight:MNUNOTICEDATA[idx].tileheight]; 
				
				while(MNUNOTICEDATA[idx].no != -1)
				{
					CGPoint point = CGPointMake(MNUNOTICEDATA[idx].x, MNUNOTICEDATA[idx].y);
					CombinedButton* btnObj = [[CombinedButton alloc]initWithTexture2D:noticeImage No: MNUNOTICEDATA[idx].no Type:MNUNOTICEDATA[idx].type Position:point];
					[gameView.PopupAnimManager requestWithObj:btnObj];
					idx++;
					
				}
				rtn = YES;
			}
		}
	}
	mainMenuState = MMenuStateNoticeDisp;
	return rtn;
}
-(BOOL)endNoticePopup:(id)view {
	EAGLView *gameView = view;
	if(gameView.PopupAnimManager!=nil)
	{
		[gameView.PopupAnimManager release];
		gameView.PopupAnimManager = nil;
	}
	if(noticeImage!=nil)
	{
		[noticeImage release];
		noticeImage = nil;
	}
	mainMenuState = MMenuStateNormal;
	return YES;	
}

-(BOOL)endMenu:(id)view {	
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;

	//LuckyDraw {
	if (gameView.LuckyDrawAnimManager != nil)
		[gameView.LuckyDrawAnimManager release];
	gameView.LuckyDrawAnimManager = nil;
	//LuckyDraw }
	
	if(btnImage!=nil)
		[btnImage release];
	btnImage = nil;
	
	[self endNoticePopup:view];
	
#ifdef FIG_ADWHIRL
	gameView.rollerView.hidden = YES;
#endif
	
	switch (selItemType) 
	{
		case CBTypeMainNewGame:
		case CBTypeMainNoticeYes : //Confirm to Play
		    gameView.gameLevel = 0;
			gameView.grandTotalScore = 0;
			[gameView saveToFileSystem];
			gameView.gameState = GS_INIT_GAME;
			break;
		case CBTypeMainEndlessMode:
			gameView.endlessMode = _ENABLE_ENDLESS_MODE_;
			gameView.gameState = GS_INIT_GAME;
			break;			
		case CBTypeMainResume : //RESUME
			gameView.gameState = GS_INIT_GAME;
			break;
		case CBTypeMainOptions : //OPTIONS
			gameView.gameState = GS_INIT_OPTIONS;
			break;
		case CBTypeMainMoreGames : //More Games
			gameView.gameState = GS_INIT_MOREGAME;
			break;
		case CBTypeMainInfo : //INFO
			gameView.gameState = GS_INIT_INFO;
			break;
#if 0 //def LITE_VERSION			
		case SBTypeMenuBuyFullVer:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=335771243&mt=8"]];
			break;
#endif			
		default:
			break;
	}

	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}

@end
