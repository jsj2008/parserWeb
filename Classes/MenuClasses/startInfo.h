//
//  Info.h
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
typedef enum {
	MNUInfoBtnCredit = 0,
	MNUInfoBtnMoreGames,
	MNUInfoBtnBUY,
	MNUInfoBtnWebsite,
	MNUInfoBtnRanking,
	MNUInfoBtnBack
} MNUInfoBtnType;

@interface startInfo : NSObject {
	// for menu option
	NSInteger selItemType;
	Texture2D* btnImage;
}

@property NSInteger selItemType;
@property (nonatomic, assign) Texture2D *btnImage;
-(BOOL)initInfo:(id)view;
-(BOOL)processInfo:(id)view;
-(BOOL)endInfo:(id)view;

@end
