//
//  pauseMenu.h
//  game
//
//  Created by Taco on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"


@interface pauseMenu : NSObject {
	// for Pause menu option
	NSInteger selItemType;
	Texture2D* btnImage;
}

@property NSInteger selItemType;
@property (nonatomic, assign) Texture2D *btnImage;

-(BOOL)initPauseMenu:(id)view;
-(BOOL)processPauseMenu:(id)view;
-(BOOL)endPauseMenu:(id)view;

@end
