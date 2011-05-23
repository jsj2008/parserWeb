//
//  startHelp.h
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "Texture2D.h"

@interface startHelp : AnimObj {
	// for menu option
	Texture2D *StartButton;
	BOOL bResponse;
	int butNo;
}

-(BOOL)initHelp:(id)view;
-(BOOL)processHelp:(id)view;
-(BOOL)endHelp:(id)view;

-(BOOL)initHelpWithDemo:(id)view;

@end
