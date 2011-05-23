//
//  DisplayClock.h
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "Texture2D.h"

@interface failCntObj : AnimObj {
	uint failCntLevel;
	uint failCnt;
	Texture2D *heartImg;
}

- (uint) getFailCnt;
- (id) initWithfailCnt:(int)fCnt;
- (BOOL) CountFailCnt;
- (BOOL) AddFailCnt;
- (void) setFailCntLevel:(int) setVal;
@end
