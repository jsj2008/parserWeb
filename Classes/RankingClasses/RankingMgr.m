/*
 * RankingMgr.m
 * game
 * 
 * Created by JerryDung on 2009/9/16.
 * Copyright 2009 __FIHTDC__. All rights reserved.
 */

#import "RankingMgr.h"
#import "sqlite3.h"

//#define DEBUGMSG_RANKINGMGR

static sqlite3 *database = NULL;	//Ranking database
static NSString *databaseName = @"database";
static NSString *databaseNameWithExt = @"database.db";

@interface RankingMgr ()
- (BOOL) initDatabase;
- (void) endDatabase;
- (void) setScoreRanking:(NSInteger)score ranking:(NSInteger)ranking;
- (BOOL) add2RankingTable:(NSString *)name UserScore:(NSInteger)score;

#if TARGET_OS_IPHONE
- (BOOL) createEditableCopyOfDatabaseIfNeeded;
#endif
@end

@implementation RankingMgr

- (id)init {
	if((self = [super init]) != nil) {
#if TARGET_OS_IPHONE
		if(NO == [self createEditableCopyOfDatabaseIfNeeded]) {
#ifdef DEBUGMSG_RANKINGMGR
			NSLog(@"createEditableCopyOfDatabaseIfNeeded ERROR");
#endif
		}
#endif
		if(NO == [self initDatabase]) {
			[self release];
			return nil;
		}
		currentUserName = nil;
	}
	return self;
}

// Open database, check table
- (BOOL) initDatabase {
	if(sqlite3_open([[self fileLocation] UTF8String], &database) == SQLITE_OK) {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"Open database succeeded");
#endif
	}
	else {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"Open database failed");
#endif
		return NO;
	}
	return YES;
}

// Close database
- (void) endDatabase {
}

// Return the database file location
- (NSString *) fileLocation {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - fileLocation");
#endif

#if TARGET_OS_IPHONE
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseNameWithExt];
	BOOL rtnVal = [fileManager fileExistsAtPath:writableDBPath];
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"fileExistsAtPath:%@, rtnVal:%d", writableDBPath, rtnVal); 
#endif
	if (rtnVal) {
		return writableDBPath;
	}
	else {
	return [[NSBundle mainBundle] pathForResource:databaseName ofType:@"db"];
}
#else
	return [[NSBundle mainBundle] pathForResource:databaseName ofType:@"db"];
#endif
}

/*   Input: NONE
 *   Output: 'name': store the name with top MAX_SCORE_RANKING, 'score': store the score with top MAX_SCORE_RANKING
 *   Return: YES: top MAX_SCORE_RANKING is loaded from db to rankingInfo; NO:otherwise
 */
- (BOOL) getAllRankingInfo:(NSMutableArray *)nameArray scoreInfo:(NSMutableArray *)scoreArray {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - getAllRankingInfo");
#endif
	
	BOOL rtnVal = YES;
	
	if(nil == nameArray || nil == scoreArray) {
		return NO;
	}
	
	static sqlite3_stmt *findStmt = NULL;
	const char *sql = "select name, score from ranking order by score desc limit ?";
	
	if(sqlite3_prepare_v2(database, sql, -1, &findStmt, NULL) != SQLITE_OK) {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"sqlite3_prepare_v2 error");
#endif
	}
	else {
		sqlite3_bind_int(findStmt, 1, MAX_SCORE_RANKING);
		
		while(sqlite3_step(findStmt) == SQLITE_ROW) {
			[nameArray addObject:[[NSString alloc] initWithString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(findStmt, 0)]]];
			[scoreArray addObject:[NSNumber numberWithInt:sqlite3_column_int(findStmt, 1)]];
		}
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"nameArray total number:%d",[nameArray count]);
		NSLog(@"scoreArray total number:%d",[scoreArray count]);
		for(int i=0; i<[nameArray count] && i<[scoreArray count]; i++) {
			NSLog(@"nameArray[%d]=%@",i,[nameArray objectAtIndex:i]);
			NSLog(@"scoreArray[%d]=%d",i,[[scoreArray objectAtIndex:i] intValue]);
		}
#endif
	}
	
	sqlite3_reset(findStmt);
	
	return rtnVal;
}

/*   Input: Current user play name/score
 *   Return: current user ranking(currentUserRanking). (0:input wrong, >=1:otherwise)
 */
- (NSInteger) setCurrentUserRanking:(NSString *)name UserScore:(NSInteger)score {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - setCurrentUserRanking");
#endif
	
	if(nil == name)
		return 0;
	
	if(currentUserName) {
		[currentUserName release];
	}
	currentUserName = [[NSString alloc] initWithString:name];
	currentUserScore = score;
	currentUserRanking = [self checkRanking:score];
	
	if(currentUserRanking <= MAX_SCORE_RANKING) {
		[self add2RankingTable:name UserScore:score];
	}
	
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"currentUserRanking:%d",currentUserRanking);
#endif
	
	return currentUserRanking;
}

// Return current user ranking(currentUserRanking). 0:if current user is NONE, >=1:otherwise
- (NSInteger) getCurrentUserRanking {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"getCurrentUserRanking:%d",currentUserRanking);
#endif
	return currentUserRanking;
}

// Return current user name
- (NSString *) getCurrentUserName {
#ifdef DEBUGMSG_RANKINGMGR
	if(currentUserName)
		NSLog(@"getCurrentUserName:%@",currentUserName);
#endif
	return currentUserName;
}

// Return current user score
- (NSInteger) getCurrentUserScore {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"getCurrentUserScore:%d",currentUserScore);
#endif
	return currentUserScore;
}

// Set current user's score and ranking
- (void) setScoreRanking:(NSInteger)score ranking:(NSInteger)ranking {
	currentUserScore = score;
	currentUserRanking = ranking;
}

// Return current score ranking(>=1, 1 mean current user score is the highest) from database.
- (NSInteger) checkRanking:(NSInteger)score {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - checkRanking");
#endif
	
	NSInteger rtnVal = 0;
	
	static sqlite3_stmt *findStmt = NULL;
	const char *sql = "select count(*) from ranking where score >= ?";
	if(sqlite3_prepare_v2(database, sql, -1, &findStmt, NULL) != SQLITE_OK) {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"sqlite3_prepare_v2 error");
#endif
	}
	else {
		sqlite3_bind_int(findStmt, 1, score);
		
		int result = sqlite3_step(findStmt);
		if(SQLITE_DONE == result) {
#ifdef DEBUGMSG_RANKINGMGR
			NSLog(@"sqlite3_step - no record");
#endif
			rtnVal = 1;  //Highest score
		}
		else if(SQLITE_ROW == result) {
#ifdef DEBUGMSG_RANKINGMGR
			NSLog(@"sqlite3_step - at least one record");
#endif
			rtnVal = sqlite3_column_int(findStmt, 0) + 1;
		}
	}
	
	sqlite3_reset(findStmt);
	
	[self setScoreRanking:score ranking:rtnVal];
	
	return rtnVal;
}

/*   Input: Current user play name/score
 *   Return: YES:add SUCCESS, NO:otherwise
 */
- (BOOL) add2RankingTable:(NSString *)name UserScore:(NSInteger)score {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - add2RankingTable");
#endif
	
	BOOL rtnVal = YES;
	
	static sqlite3_stmt *insertStmt = NULL;
	const char *sql = "insert into ranking (name, score, datetime) Values(?, ?, ?)";
	if(sqlite3_prepare_v2(database, sql, -1, &insertStmt, NULL) != SQLITE_OK) {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"sqlite3_prepare_v2 error");
#endif
	}
	else {
		sqlite3_bind_text(insertStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(insertStmt, 2, score);
		sqlite3_bind_double(insertStmt, 3, [[NSDate dateWithTimeIntervalSinceNow:20] timeIntervalSince1970]);
		
		if(SQLITE_DONE != sqlite3_step(insertStmt)) {
#ifdef DEBUGMSG_RANKINGMGR
			NSLog(@"sqlite3_step FAIL");
#endif
		}
		else {
#ifdef DEBUGMSG_RANKINGMGR
			NSLog(@"sqlite3_step SUCCESS");
#endif
		}
	}
	
	sqlite3_reset(insertStmt);
	
	/*
	 NSString *foo = @"your text here";
	 const char *bar = [foo UTF8String];
	 */
	
	/*
	 double f = [[NSDate dateWithTimeIntervalSinceNow:20] timeIntervalSince1970];
	 NSDate *myData = [NSDate dateWithTimeIntervalSince1970:f];
	 */
	return rtnVal;
}

#if TARGET_OS_IPHONE
- (BOOL) createEditableCopyOfDatabaseIfNeeded {
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"RankingMgr.m - createEditableCopyOfDatabaseIfNeeded");
#endif
	BOOL rtnVal = YES;
	
	// First, test for existence.
	NSFileManager *fileManager = [NSFileManager defaultManager]; 
	NSError *error = nil; 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseNameWithExt]; 
	rtnVal = [fileManager fileExistsAtPath:writableDBPath];
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"fileExistsAtPath:%@, rtnVal:%d", writableDBPath, rtnVal); 
#endif
	if (rtnVal) {
		return rtnVal;
	}
	// The writable database does not exist, so copy the default to the appropriate location. 
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseNameWithExt]; 
	rtnVal = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
#ifdef DEBUGMSG_RANKINGMGR
	NSLog(@"copyItemAtPath:%@, rtnVal:%d", defaultDBPath, rtnVal); 
#endif
	if (NO == rtnVal) {
#ifdef DEBUGMSG_RANKINGMGR
		NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
#endif
	}
	return rtnVal;
}
#endif

-(BOOL)deleteAllRecord
{

	const char *sql = "delete from ranking where score > 0";
	char *errorMsg;
	if(sqlite3_exec(database, sql, NULL, NULL, &errorMsg) != SQLITE_OK) {
		
		NSLog(@">>>sqlite3_deleteAll error :%s",errorMsg);
	}
	else
		NSLog(@">>>sqlite3_deleteAll success");
	
	return TRUE;
}



- (void)dealloc {
	[currentUserName release];
	
	[self endDatabase];
	
	[super dealloc];
}

@end
