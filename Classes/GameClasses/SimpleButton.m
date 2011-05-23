//
//  SimpleButton.m
//  game
//
//  Created by FIH on 2009/9/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleButton.h"
#define EXPANDRATE 1.2f
EAGLView *globalGameView;
@implementation SimpleButton
@synthesize bResponse;
- (id)initWithType:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super init]) {
		//[super initWithStart];
		
		switch (type) {			
			case SBTypePause:
				[self loadImageFromFile: @"ZM_Pause.png" tileWidth:32 tileHeight:32];
				break;
			case SBTypeOptionsSounds:
			case SBTypeOptionsMusic:
				[self loadImageFromFile: @"MNU_Zooff_C_Options_OnOff_Btn.png" tileWidth:138 tileHeight:65];
				break;
			//case SBTypeGameOverNext:
			//case SBTypeCongratulationsNext:
			case SBTypeGameEndNext:
			case SBTypeRankingNext: 
			case SBTypeScoreNext:
				[self loadImageFromFile: @"MNU_Zoo_C_Main_Next.PNG" tileWidth:44 tileHeight:30];
				break;
			case SBTypeScoreNextLev:
				[self loadImageFromFile: @"END_Zoo_C_Scores_NextL.png" tileWidth:148 tileHeight:47];
				break;
			case SBTypeInfoBack:
			case SBTypeRankingBack:
			case SBTypeHelpBack:
			case SBTypeCreditsBack:
			//case SBTypePauseBack:
			case SBTypeOptionsBack:
			case SBTypeMoreGamesBack:				
				[self loadImageFromFile: @"MNU_Zooff_C_Back_Btn.png" tileWidth:148 tileHeight:47];
//				[self loadImageFromFile: @"MNU_Zoo_C_Main_Back.PNG" tileWidth:46 tileHeight:30];
				break;
#if 0				
			case SBTypeMoreGamesBack:
				[self loadImageFromFile: @"MNU_MoreGame_Back.png" tileWidth:156 tileHeight:60];
				break;	
#endif				
			case SBTypeLocalRank:
				[self loadImageFromFile: @"MNU_Zooff_C_Rank_Btn.png" tileWidth:320 tileHeight:62];
				break;
#ifdef LITE_VERSION
			case SBTypeFullVerBack:
				[self loadImageFromFile:@"GAM_Buy_Back.png" tileWidth:64 tileHeight:29];
				break;
				
			case SBTypeMenuBuyFullVer:
				[self loadImageFromFile:@"MNU_Zoo_L_Menu_BUY.png" tileWidth:128 tileHeight:64];
				break;
			case SBTypeBuyFullVersionLink:
				[self loadImageFromFile:@"GAM_Buy_Link.png" tileWidth:256 tileHeight:125];
				break;
#endif	
			default:
				break;
		}
		self.pos = pos;
		self.no = 0;
		self.type = type;
		bResponse = NO;
	}
	return self;
}
- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) 
	{
		aRect.origin.x = _pos.x;
		aRect.size.width = _image.tileWidth * EXPANDRATE;
		if(_type == SBTypeLocalRank)
		{
			aRect.origin.y = _pos.y+35;
			aRect.size.height = _image.tileHeight -10;
		}
		else
		{
			aRect.origin.y = _pos.y;
			aRect.size.height = _image.tileHeight * EXPANDRATE;		
		}	
		
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
		case SBTypePause:
			rtn  = [self SBTypePauseRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case SBTypeOptionsSounds:
		case SBTypeOptionsMusic:
			rtn  = [self SBTypeOptionsToggleRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		//case SBTypeGameOverNext:
		//case SBTypeCongratulationsNext:
		case SBTypeGameEndNext:
		case SBTypeScoreNext:
		case SBTypeScoreNextLev:
		case SBTypeRankingNext:
			rtn = [self SBTypeNextRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case SBTypeInfoBack:
		case SBTypeRankingBack:
		case SBTypeHelpBack:
		case SBTypeCreditsBack:
		case SBTypeMoreGamesBack:
		//case SBTypePauseBack:
		case SBTypeOptionsBack:
//		case SBTypeFullVerBack:
			rtn = [self SBTypeBackRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
		case SBTypeLocalRank:
			rtn = [self SBTypeRankingRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
			
#ifdef LITE_VERSION
		case SBTypeMenuBuyFullVer:
		case SBTypeBuyFullVersionLink:
			rtn = [self SBTypeFullVerRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
			break;
#endif
		default:
			break;
	}
	return rtn;
}
#ifdef LITE_VERSION
- (NSInteger)SBTypeFullVerRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	
	if(_type == SBTypeMenuBuyFullVer && main_Game.gameStageState!=GSStateProgress)
	{
		return 0;
	}
	
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				//_no = 1;
				bResponse = YES;
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				//_no = 0;
				bResponse = NO;
				
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				switch (_type) {
				    case SBTypeMenuBuyFullVer:
						gameView.main_menu.selItemType = _type;
						[gameView fadeOutWithState:GS_END_MENU];
						break;
					case SBTypeBuyFullVersionLink:
						gameView.main_fullversion.selItemType = _type;
						[gameView fadeOutWithState:GS_END_FULLVER];
						break;
					default:
						break;
				}
				//_no = 0;
			}
		}
		
	}
	return 0;
}
#endif
- (NSInteger)SBTypeBackRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = 1;
				bResponse = YES;
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = 0;
				bResponse = NO;
				
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				switch (_type) {
					case SBTypeInfoBack:
						gameView.main_info.selItemType = _type;
						[gameView fadeOutWithState:GS_END_INFO];
						break;
					case SBTypeRankingBack:
						[gameView fadeOutWithState:GS_END_RANKING];
						break;
					case SBTypeHelpBack:
						[gameView fadeOutWithState:GS_END_HELP];
						break;
#if 0						
					case SBTypeFullVerBack:
						gameView.main_fullversion.selItemType = _type;
						[gameView fadeOutWithState:GS_END_FULLVER];
						break;
#endif						
					case SBTypeCreditsBack:
						[gameView fadeOutWithState:GS_END_CREDIT];
						break;
					case SBTypeMoreGamesBack:
						gameView.main_moregame.selItemType = _type;
						[gameView fadeOutWithState:GS_END_MOREGAME];
						break;
					/*case SBTypePauseBack:
						[gameView.main_Game endGame:view];
						gameView.main_pausemenu.selItemType = _type;
						[gameView fadeOutWithState:GS_END_PAUSE];
						break;*/
					case SBTypeOptionsBack:
						[gameView fadeOutWithState:GS_END_OPTIONS];
						break;
						
					default:
						break;
				}
				//_no = 0;
			}
		}
		
	}
	return 0;
}
- (NSInteger)SBTypeNextRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = 1;
				bResponse = YES;
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = 0;
				bResponse = NO;
				
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				switch (_type) {
					case SBTypeGameEndNext:
						{
							switch (main_Game.gameStageState) {
								case GSStateGameOver:
									[gameView fadeOutWithState:GS_END_GAME];
									break;
								case GSStateGameSucceed:
									[gameView fadeOutWithState:GS_INIT_SCORE];
									
								default:
									break;
							}
						}
						break;
					case SBTypeScoreNext:
					case SBTypeScoreNextLev:
						[gameView fadeOutWithState:GS_END_SCORE];
						break;
					case SBTypeRankingNext:
						[gameView fadeOutWithState:GS_END_RANKING];
					default:
						break;
				}
				
				//_no = 0;
			}
		}
		
	}
	return 0;
}
- (NSInteger)SBTypeOptionsToggleRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	switch (_type) {
		case SBTypeOptionsSounds:
			{
				if (gameView.soundOFF == NO)
				{
					_no = 0;
				}
				else
				{
					_no = 1;
					
				}
			}
			break;
		case SBTypeOptionsMusic:
			{
				if (gameView.musicOFF == NO)
				{
					_no = 0;
				}
				else
				{
					_no = 1;
				}
			}
			break;
		default:
			break;
	}
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				bResponse = YES;
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				bResponse = NO;
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				switch (_type) {
					case SBTypeOptionsSounds : 
						{
							if (gameView.soundOFF == NO){
								gameView.soundOFF = YES;
								//add code here for sound ON/OFF
								
								printf("SBTypeOptionsSounds=gotoYes=\n");
								[gameView.soundEffect allstop:YES];
							}
							else
							{
								printf("SBTypeOptionsSounds=gotoN=\n");
								gameView.soundOFF = NO;
								//add code here for sound ON/OFF
								[gameView.soundEffect allstop:NO];
							}
							//_no = 0;
							bResponse = NO;
						}
						break;
					case SBTypeOptionsMusic:
						{
							
							if (gameView.musicOFF == NO){
								printf("SBTypeOptionsMusic=gotoYes=\n");

								gameView.musicOFF = YES;
								//add code here for music ON/OFF
								[gameView.song pause];
							}
							else{
								printf("SBTypeOptionsMusic=gotoNo=\n");

								gameView.musicOFF = NO;
								//add code here for music ON/OFF
								[gameView.song play];
								
							}
						}
						break;
					default:
						break;

				}
			}
		}
		
	}
	return 0;
}
- (NSInteger)SBTypePauseRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	if(main_Game.gameStageState!=GSStateProgress)
	{
		return 0;
	}
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				_no = 1;
				bResponse = YES;
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				_no = 0;
				bResponse = NO;
            }
		}
	}
	else{
			if ([touchMode isEqualToString:@"End"]) {
				if (bResponse && [self pointInImage:x y:y]) {
					switch (_type) {
						case SBTypePause : 
							/*[gameView fadeOutWithState:GS_INIT_PAUSE];*/
							gameView.gameState = GS_INIT_PAUSE;
							_no = 0;
							break;
					}
				}
		}

	}
	return 0;	
}

- (NSInteger)SBTypeRankingRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
		EAGLView *gameView = view;
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				bResponse = YES;
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				bResponse = NO;
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) {
			if (bResponse && [self pointInImage:x y:y]) {
				switch (_type) {
					case SBTypeLocalRank : 
					{	//Local Ranking
						if (gameView.isLocalRank == NO){
							gameView.isLocalRank = YES;
							_no = 0;
						}
						else//Global Ranking
						{
							UIAlertView *alertNote = [[UIAlertView alloc]initWithTitle:@"Confirming" message:@"Submitting ranking records requires server connection, and your highest score will be transferred to server.\nDo you want to continue?" 
													  delegate:self cancelButtonTitle:nil otherButtonTitles:@"YES",@"NO",nil];
							[alertNote show];
							globalGameView = gameView;
							
						}
						//_no = 0;
						bResponse = NO;
					}
						break;
					default:
						break;
						
				}
			}
		}
		
	}
	return 0;	
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if(buttonIndex == 0)
	{
		//globalGameView.isLocalRank = NO;
		if(globalGameView.main_ranking.isSendGlobRank == YES) //first time send to global rank
		{
			[globalGameView.main_ranking sendGlobalRank:(NSString *)globalGameView.rankInputName UserScore:globalGameView.main_ranking.TopScore];
			globalGameView.main_ranking.isSendGlobRank = NO;
		}
		else{ //not send rank, only show rank
			//[globalGameView.main_ranking secondThread];
			[globalGameView.main_ranking sendGlobalRank:@"" UserScore:0];
		}
		//_no = 1;
	}
	
	[alertView release];
	
	
}
- (void)dealloc {
    //printf("SimpleBtn dealloc");
	[super dealloc];
}


@end
