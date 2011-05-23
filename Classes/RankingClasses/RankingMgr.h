/*
 * RankingMgr.h
 * game
 * 
 * Created by JerryDung on 2009/9/16.
 * Copyright 2009 __FIHTDC__. All rights reserved.
 *
 * Below is the test code
 {
	RankingMgr *test = [[RankingMgr alloc] init];
	NSMutableArray *nameArray = [[NSMutableArray alloc] init];
	NSMutableArray *scoreArray = [[NSMutableArray alloc] init];
	NSString *str = nil;
	NSInteger uScore = 12000;
	NSInteger ranking = 0;
	
	NSLog(@"================First User================");
	uScore = 12000;
	if([test checkRanking:uScore] <= MAX_SCORE_RANKING) {
		[test setCurrentUserRanking:@"Jerry" UserScore:uScore];
		if([nameArray count] > 0)
			[nameArray removeAllObjects];
		if([scoreArray count] > 0)
			[scoreArray removeAllObjects];
	}
	[test getAllRankingInfo:nameArray scoreInfo:scoreArray];
	str = [test getCurrentUserName];
	ranking = [test getCurrentUserRanking];
	uScore = [test getCurrentUserScore];
	
	NSLog(@"================Second User================");
	uScore = 14000;
	if([test checkRanking:uScore] <= MAX_SCORE_RANKING) {
		ranking = [test setCurrentUserRanking:@"Leo" UserScore:uScore];
		if([nameArray count] > 0)
			[nameArray removeAllObjects];
		if([scoreArray count] > 0)
			[scoreArray removeAllObjects];
	}
	[test getAllRankingInfo:nameArray scoreInfo:scoreArray];
	str = [test getCurrentUserName];
	ranking = [test getCurrentUserRanking];
	uScore = [test getCurrentUserScore];
	
	NSLog(@"================Third User================");
	uScore = 16000;
	if([test checkRanking:uScore] <= MAX_SCORE_RANKING) {
		ranking = [test setCurrentUserRanking:@"James" UserScore:uScore];
		if([nameArray count] > 0)
			[nameArray removeAllObjects];
		if([scoreArray count] > 0)
			[scoreArray removeAllObjects];
	}
	[test getAllRankingInfo:nameArray scoreInfo:scoreArray];
	str = [test getCurrentUserName];
	ranking = [test getCurrentUserRanking];
	uScore = [test getCurrentUserScore];
	
	NSLog(@"================Forth User================");
	uScore = 11000;
	if([test checkRanking:uScore] <= MAX_SCORE_RANKING) {
		ranking = [test setCurrentUserRanking:@"Jarsh" UserScore:uScore];
		if([nameArray count] > 0)
			[nameArray removeAllObjects];
		if([scoreArray count] > 0)
			[scoreArray removeAllObjects];
	}
	[test getAllRankingInfo:nameArray scoreInfo:scoreArray];
	str = [test getCurrentUserName];
	ranking = [test getCurrentUserRanking];
	uScore = [test getCurrentUserScore];
	
	NSLog(@"================Fifth User================");
	uScore = 500;
	if([test checkRanking:uScore] <= MAX_SCORE_RANKING) {
		ranking = [test setCurrentUserRanking:@"Yimo" UserScore:uScore];
		if([nameArray count] > 0)
			[nameArray removeAllObjects];
		if([scoreArray count] > 0)
			[scoreArray removeAllObjects];
	}
	[test getAllRankingInfo:nameArray scoreInfo:scoreArray];
	str = [test getCurrentUserName];
	ranking = [test getCurrentUserRanking];
	uScore = [test getCurrentUserScore];
	
 }
 *
 *
 */

#import <Foundation/Foundation.h>

#define MAX_SCORE_RANKING (20)

@interface RankingMgr : NSObject {
	NSInteger currentUserRanking;
	NSString *currentUserName;
	NSInteger currentUserScore;
}

- (id)init;
- (void)dealloc;

- (NSInteger) checkRanking:(NSInteger)score;
- (BOOL) getAllRankingInfo:(NSMutableArray *)nameArray scoreInfo:(NSMutableArray *)scoreArray;
- (NSString *) fileLocation;
- (NSInteger) setCurrentUserRanking:(NSString *)name UserScore:(NSInteger)score;
- (NSInteger) getCurrentUserRanking;
- (NSString *) getCurrentUserName;
- (NSInteger) getCurrentUserScore;
- (BOOL)deleteAllRecord;
@end
