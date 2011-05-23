//
//  MainMenu.h
//  game
//
//  Created by StevenKao on 2009/9/14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMusicTrack.h"
#import "Texture2D.h"
#import "Popup.h"

typedef enum {
    MMenuStateNormal = 0,
    MMenuStateNoticeDisp
} MainMenuState;

#define MAINMNU_TILEHEIGHT  47
#define MAINMNU_TILEWIDTH	148

@interface startMainMenu : NSObject {
	// for menu option
	NSInteger selItemType;
	//MaxPan	
	Texture2D *btnImage;
	Texture2D *noticeImage;
	//MaxPan		
	Popup * yesnoPopup;
	MainMenuState mainMenuState;
}

@property NSInteger selItemType;
@property (nonatomic, assign) Popup *yesnoPopup;
@property (nonatomic) MainMenuState mainMenuState;
-(BOOL)initMenu:(id)view;
-(BOOL)processMenu:(id)view;
-(BOOL)endMenu:(id)view;
-(BOOL)initNoticePopup:(id)view;
-(BOOL)endNoticePopup:(id)view;

@end
