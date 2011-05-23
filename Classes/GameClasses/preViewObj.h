//
//  DisplayClock.h
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"

@interface preViewObj : AnimObj {
	uint failCntLevel;
	uint failCnt;
}

- (id) initWithfailCnt:(int)fCnt;
- (void) CountFailCnt;
@end
