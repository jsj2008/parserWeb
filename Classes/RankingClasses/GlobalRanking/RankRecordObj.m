//
//  RankRecordObj.m
//  game
//
//  Created by EvanChen on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RankRecordObj.h"


@implementation RankRecordObj

@synthesize playerName = _playerName, score = _score, gameLevel = _gameLevel, rank = _rank, playTime = _playTime;

-(void) initWithPlayerName:(NSString *)playerName gameLevel:(int)level gameScore:(int)score
{
	_playerName = playerName;
	_gameLevel = level;
	_score = score;
	_playTime = 0;
}

-(void) setPlayTime:(int)lengthInMinute
{
	_playTime = lengthInMinute;
}

@end
