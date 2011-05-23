//
//  CombinedButton.m
//  game
//
//  Created by FIH on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CombinedButton.h"
#import "dataDefine.h"
#define _WITH_BOUND_LRUN 160
#define _WITH_BOUND_RRUN 100

#define INFOMENUTOUCHOFFSETNO 5
#define PAUSEMENUTOUCHOFFSETNO 7
#define MAINMENUTOUCHOFFSETNO  8
#define MNUNOTICETOUCHOFFSETNO 2
#define EXPANDRATE 1.0

int menuButtonXPos[8] = {155, 155, 155, 155, 155, 155, 155, 155};
static int menuButtonXPos_orig[8] = {155, 155, 155, 155, 155, 155, 155, 155};
int delt=0;
int speedXmove = 1;
static int dirTracker = 0;

@implementation CombinedButton
@synthesize bResponse;
@synthesize ori_no;
- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super init]) {
		//[super initWithStart];
		_image = image;
		self.freeTexture = NO;/*don't free the texture image while parent dealloc*/
		ori_no = self.no = no;
		self.pos = pos;
		self.type = type;
		bResponse = NO;
		_count = 0;
		_state = 0;
		
		if(_type == CBTypeMainNewGame)
		{			
			for(int i = 0 ; i < 8; i++)
			{
				menuButtonXPos[i] = menuButtonXPos_orig[i];
			}		
			originX = menuButtonXPos[0];
		}	
	}
	return self;	
}
- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y;
		aRect.size.width = _image.tileWidth * EXPANDRATE;
		aRect.size.height = _image.tileHeight * EXPANDRATE;
	}
	return aRect;
}
- (BOOL)pointInImage:(int)x y:(int)y{
	CGRect rect = [self getTouchRect];
	int left = rect.origin.x - rect.size.width / 2;
	int right = rect.origin.x + rect.size.width / 2;
	int top = rect.origin.y - rect.size.height / 2;
	int bottom = rect.origin.y + rect.size.height / 2;
	
	if (x < left || x > right || y < top || y > bottom)
		return FALSE;
	return TRUE;
}
- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	NSInteger rtn = 0;
	switch (_type) {
		case CBTypeInfoCredit:
		case CBTypeInfoHelp:
		case CBTypeInfoBuy:
		case CBTypeInfoWebsite:
		case CBTypeInfoRanking:
			rtn  = [self CBTypeInfoRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case CBTypePauseResume:
		case CBTypePauseRestart:
		case CBTypePauseOptions:
		case CBTypePauseHelp:
		case CBTypePauseMainMenu:
			rtn  = [self CBTypePauseRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case CBTypeMainNewGame:
		case CBTypeMainResume:
		case CBTypeMainOptions:
		case CBTypeMainMoreGames:
		case CBTypeMainInfo:
		case CBTypeMainEndlessMode:	
			rtn  = [self CBTypeMainMnuRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case CBTypeMainNoticeYes:
		case CBTypeMainNoticeNo:
			rtn  = [self CBTypeMainMnuNoticeRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		default:
			break;
	}
	return rtn;
}
- (NSInteger)CBTypeMainMnuNoticeRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;
	
	if(gameView.main_menu.mainMenuState != MMenuStateNoticeDisp)
	{
		return 0;
	}
	
	if(bTouch)
	{
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = ori_no + MNUNOTICETOUCHOFFSETNO;
				bResponse = YES;
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = ori_no;
				bResponse = NO;
			}
		}
	}
	else
	{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				_no = ori_no;
				switch (_type) {
					case CBTypeMainNoticeYes:
						gameView.main_menu.selItemType = _type;
						[gameView fadeOutWithState:GS_END_MENU];
						break;
					case CBTypeMainNoticeNo:
						gameView.main_menu.mainMenuState = MMenuStateNormal;
						break;
					default:
						//gameView.main_menu.selItemType = _type;
						//[gameView fadeOutWithState:GS_END_MENU];
						break;
				}
				
			}
		}
		
	}
	return 0;
	
}
- (NSInteger)CBTypeMainMnuRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;

	if(gameView.main_menu.mainMenuState != MMenuStateNormal)
	{
		return 0;
	}
		
	if(_type == CBTypeMainNewGame)
	{
		if(bTouch == FALSE)
		{
			//if(speedXmove > 1 )
				//speedXmove --;
		}
		
		if(dirTracker == 0)
		{
			for(int i=0; i < 8 ; i++)
			{
				menuButtonXPos[i] = menuButtonXPos[i];// - 1*speedXmove; 
			}	
		}
		else if(dirTracker == 1)
		{
			for(int i=0; i < 8 ; i++)
			{
				menuButtonXPos[i] = menuButtonXPos[i];// + 1*speedXmove; 
			}	
		}
		

		
		if(gameView.enableEndless == _ENABLE_ENDLESS_MODE_)
		{
			if(originX > menuButtonXPos[0] + _WITH_BOUND_LRUN+140)	
			{			
				for(int i=0; i < 8 ; i++)
				{
					menuButtonXPos[i] = menuButtonXPos[i];// + 1*speedXmove; 
				}
				//speedXmove = 1;
				dirTracker = 1;
			}			
		}	
		else
		{
			if(originX > menuButtonXPos[0] + _WITH_BOUND_LRUN)	
			{			
				for(int i=0; i < 8 ; i++)
				{
					menuButtonXPos[i] = menuButtonXPos[i];// + 1*speedXmove; 
				}
				//speedXmove = 1;
				dirTracker = 1;
			}	
		}
		
		if(menuButtonXPos[0] > originX  + _WITH_BOUND_RRUN )		
		{
			for(int i=0; i < 8 ; i++)
			{
				menuButtonXPos[i] = menuButtonXPos[i];// - 1*speedXmove; 
			}				
			dirTracker = 0;
			//speedXmove = 1;
		}	
		_pos.x = menuButtonXPos[0];	
	}
	
	if(_type == CBTypeMainResume)
		_pos.x = menuButtonXPos[1];

	
	if(gameView.enableEndless == _ENABLE_ENDLESS_MODE_)
	{
		if(_type == CBTypeMainEndlessMode)
			_pos.x = menuButtonXPos[2];	
		
		if(_type == CBTypeMainOptions)
			_pos.x = menuButtonXPos[3];
		
		if(_type == CBTypeMainMoreGames)
			_pos.x = menuButtonXPos[4];
		
		if(_type == CBTypeMainInfo)
			_pos.x = menuButtonXPos[5];
		
	}	
	else
	{
		if(_type == CBTypeMainOptions)
			_pos.x = menuButtonXPos[2];
		
		if(_type == CBTypeMainMoreGames)
			_pos.x = menuButtonXPos[3];
		
		if(_type == CBTypeMainInfo)
			_pos.x = menuButtonXPos[4];		
	}	
	

	if(gameView.isFirstEnterGame != _HAD_USE_GAME_FLAG_ && _no == 3)
	{	
		_no = 15;
		_alpha = 1.0;
		return 0;
	}	
	
	if(gameView.isFirstEnterGame == _HAD_USE_GAME_FLAG_ && _no == 15)
	{	
		_alpha = 0;
		return 0;
	}
	
	if(_no != 15)
	{
		if(bTouch){
			if ([touchMode isEqualToString:@"Began"]){
				dirTracker = 3;
				preiousTime = gameView.frameCount;
				markX = x;
				if ([self pointInImage:x y:y]) {
					_no = ori_no + 1;//MAINMENUTOUCHOFFSETNO;
					bResponse = YES;
					[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
				}
			}
			else if ([touchMode isEqualToString:@"Move"])
			{				
				speedXmove = 20;
				if( x > markX)
				{
					dirTracker = 1;
				}
				else
				{
					dirTracker = 0;
				}	
				if (![self pointInImage:x y:y]) {
					_no = ori_no;
					bResponse = NO;					
				}
			}
		}
		else{
			if ([touchMode isEqualToString:@"End"]) {
							
				if(gameView.frameCount - preiousTime > 10)
				{
					dirTracker = 0;
					speedXmove = 1;
				}
				
				if (bResponse && [self pointInImage:x y:y]) {
					
					if( x > markX)
					{
						dirTracker = 1;
					}
					else
					{
						dirTracker = 0;
					}	
					
					
					_no = ori_no;
					switch (_type) {
						case CBTypeMainNewGame:
							{
								if(gameView.gameLevel > 0 /*gameView.isFirstEnterGame == _HAD_USE_GAME_FLAG_*/)
								{
									[gameView.main_menu initNoticePopup:view];
								}
								else {
									gameView.main_menu.selItemType = _type;
									[gameView fadeOutWithState:GS_END_MENU];
								}
							}
							break;
						default:
							gameView.main_menu.selItemType = _type;
							[gameView fadeOutWithState:GS_END_MENU];
							break;
					}
					
				}
			}
			
		}
		
	}
	
	return 0;
}

- (NSInteger)CBTypePauseRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = ori_no + 1;
				bResponse = YES;
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = ori_no;
				bResponse = NO;
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				_no = ori_no;
				switch (_type) {
					case CBTypePauseMainMenu:
						[gameView.main_Game endGame:view];
						gameView.main_pausemenu.selItemType = _type;
						break;
					default:
						gameView.main_pausemenu.selItemType = _type;
						break;
				}
				[gameView fadeOutWithState:GS_END_PAUSE];
			}
		}
		
	}
	
	return 0;
}
- (NSInteger)CBTypeInfoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = ori_no + 1;
				bResponse = YES;
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = ori_no;
				bResponse = NO;
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				_no = ori_no;
				switch (_type) {
					case CBTypeInfoCredit: 
					case CBTypeInfoHelp: 
					case CBTypeInfoBuy: 
					case CBTypeInfoWebsite:
					case CBTypeInfoRanking:
						gameView.main_info.selItemType = _type;
						break;
					default:
						gameView.main_info.selItemType = _type;
						break;
				}
				[gameView fadeOutWithState:GS_END_INFO];
			}
		}
		
	}
	
	return 0;
}
- (void)dealloc {
	//printf("CombinedBtn dealloc!\n");
	[super dealloc];
}
@end
