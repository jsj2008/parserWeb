//
//  DisplayClock.h
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"

@interface DisplayClock : AnimObj {
	int countdownSecs;
	int showSecs;
	NSInteger gamelevel;
	Texture2D *imgLevel;
}
@property(nonatomic) int countdownSecs;
@property(nonatomic) int showSecs;
@property(nonatomic) NSInteger gamelevel;
@property(nonatomic, assign) Texture2D *imgLevel;
- (id) initWithSecs:(int)secs GameLevel:(NSInteger)level;
- (void) resetWithSecs:(int)secs GameLevel:(NSInteger)level;
- (int) DCCountingScores;
@end
