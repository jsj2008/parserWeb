//
//  RankHelper.h
//  game
//
//  Created by EvanChen on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RankRecordObj.h"

#define FIG_GLOBAL_RANKING 1
//#if !TARGET_IPHONE_SIMULATOR
//#define FIH_DEVELOP 0
//#else
#define FIH_DEVELOP 0
//#endif

#define GAME_USED_TIME_KEY_A @"UsedTimeRecordA"
#define GAME_USED_TIME_KEY_B @"UsedTimeRecordB"
#define GAME_USED_TIME_KEY_C @"UsedTimeRecordC"
#define GAME_USED_TIME_KEY_D @"UsedTimeRecordD"


#define FIG_GAME_RECORD_SERVER @"http://www.gamememore.com/"
//#define FIG_GAME_RECORD_SERVER @"http://evanchen/"
#define FIG_GAME_RECORD_PATH @"game/log.php?"
//#define FIG_GAME_RECORD_PATH ""
#define FIG_GAME_QUERY_PATH @"game/query.php?"
#define FIG_GAME_DEFAULT_TOP_COUNT 24

#define FIG_GAME_RECORD_SEPARATOR_START "<rank>"
#define FIG_GAME_RECORD_SEPARATOR_END "</rank>"

@class RankHelper;

typedef enum {
	RHS_NONE,
	RHS_SENDLOCALRANK,
	RHS_QUERYREMOTERANK
} RankHelperState;
@protocol RankHelperDelegate <NSObject>
- (void)didReceiveGlobalRanks:(RankHelper *)rnkhelper glView:(id)glView;
@optional
@end

@interface RankHelper : NSObject {
	NSString *_hostName;
	NSString *_gameName;
	uint _topCount;
	//NSMutableArray *_topRanks;
	NSMutableData *_receivedData;
	NSURLConnection *_connection; 
	BOOL _dataRecieved;
	//NSTimer *_waitTimer;
	//BOOL _isQueryTimerOn;
	//BOOL _isSendTimerOn;
	id pView;
	id _delegate;
	UIAlertView* _waitingAlert;
	UIAlertView* _networkErrAlert;
	NSInteger _state;
}
//@property (assign) id delegate;
@property(assign) id<RankHelperDelegate> delegate;
@property (readwrite, retain) NSMutableData *receivedData;
@property (readwrite, retain) NSURLConnection *connection; 
@property (readwrite, retain) NSString *hostName;
@property (readwrite, retain) NSString *gameName;
@property (readwrite) uint		topCount;
@property (readwrite) BOOL dataRecieved;
//@property (readwrite, retain) NSTimer *waitTimer;
//@property (readwrite) BOOL isQueryTimerOn;
//@property (readwrite) BOOL isSendTimerOn;
@property (retain) UIAlertView* waitingAlert;
@property (retain) UIAlertView* networkErrAlert;
@property (readwrite) NSInteger state;

- (id) initWithView:(id)view delegate:(id)delegate;
//-(void)initWithDefaultValues:(id)view;

-(void) setHostName:(NSString *)hostName;
-(void) setGameName:(NSString *)gameName;

-(void) getTopRanks:(NSMutableArray *)outArray;
//-(BOOL) queryTopRanks:(int)level;
-(BOOL) QueryFollowsSendRecord:(RankRecordObj *)rankRecord;
//-(BOOL) isSendOK;
-(BOOL) queryByRank:(RankRecordObj *)myRankRecord mode:(NSString *)modeStr;
//-(RankRecordObj *) getMyRank:(RankRecordObj *)myRankRecord;
//-(NSMutableArray *) getAllMyRank:(RankRecordObj *)myRankRecord;

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

//- (BOOL)isRecordServerReachable;
//- (void) sendGameTime;
- (void) removeLocalTimeRecord;
- (void) HandleReceivedData;

@end
