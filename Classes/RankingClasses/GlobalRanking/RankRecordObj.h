//
//  RankRecordObj.h
//  game
//
//  Created by EvanChen on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RankRecordObj : NSObject {
	NSString *_playerName;
	int _score;
	int _gameLevel;	
	int _rank;
	int _playTime;
}

@property (readwrite, retain) NSString *playerName;
@property (readwrite) int score;
@property (readwrite) int gameLevel;
@property (readwrite) int rank;
@property (readwrite) int playTime;

-(void) initWithPlayerName:(NSString *)playerName gameLevel:(int)level gameScore:(int)score;
-(void) setPlayTime:(int)lengthInMinute;
@end
