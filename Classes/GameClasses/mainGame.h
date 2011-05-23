//
//  mainGame.h
//  game
//
//  Created by StevenKao on 2009/9/14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import "ZooAnimal.h"
#import "ZooAnimalFeeder.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
#import "GBMusicTrack.h"
#import "AnimObjManager.h"
#import "DisplayClock.h"
#import "failCntObj.h"
#import "EndScreen.h"
#import "sqObj.h"
//#define FIG_USE_OPENAL

#define _DEMO_STATE_1 1
#define _DEMO_STATE_2 2
#define _DEMO_STATE_3 3
#define _DEMO_STATE_4 4
#define _DEMO_STATE_5 5
#define _DEMO_STATE_6 6
#define _DEMO_STATE_7 7
#define _DEMO_STATE_8 8
#define _DEMO_STATE_9 9
#define _DEMO_STATE_10 10

typedef enum {
	ZAGLS_LoadingStart = 0,
	ZAGLS_Dot,
    ZAGLS_BGSound ,
	ZAGLS_AnimManager,
	ZAGLS_ZooAnimals,
	ZAGLS_ZooManager,
	ZAGLS_Arrow,
	ZAGLS_FailCount,
	ZAGLS_TimeLimit,
	ZAGLS_PauseButton,
	//ZAGLS_GameMap,
	ZAGLS_VarDeclare,
	ZAGLS_LoadingDone
} ZooAnimalGameLoadingState;

@interface mainGame : NSObject {
	//NSInteger idxEnemy;
	NSInteger gameLevel;
	NSInteger gameMaxLevel;
	// for menu option
	//NSInteger pauseItemType;
	NSMutableArray *zooAnimalArray;
	NSArray *strPreviewFood; //MaxPan
	
	//BOOL isInitialized;
	ZooAnimalGameLoadingState zaglsLoadingState;
	
	AnimObjManager *gameAnimManager;
	
	AnimObjManager *gameFoodAnimManager;
	AnimObjManager *gameEnemyAnimManager;
	AnimObjManager *gameESAnimManager;
	Texture2D *gameBackground;
	Texture2D *loadingBackground;

	// frame count
	GLuint gameFrameCount;
	
	DisplayClock* timelimit;
	failCntObj* pfailCntObj;
	
	//MaxPan add{ 
	//NSInteger failedCnt;
	int previewType;
//	NSInteger 
	//MaxPan add}
	GameStageState gameStageState;
	EndScreen *endScreen;
	NSInteger idx;
	NSInteger fFactoryIdx;
	GLuint gamePreFrameCnt;
	GLuint gameFrameCntDelta;	
	//pohsu{
	NSInteger grandTotalScore;
	NSInteger subTotalScore;
	NSInteger rightFoodScore;
	NSInteger wrongFoodScore;
	NSInteger timeBonus;
	NSInteger extraBonus;
	NSInteger posTyp;
	//pohsu}
	
	ZooAnimalFeeder* zaMkObj;
	sqObj *sObj;
	NSInteger DemoState;
}

//@property NSInteger pauseItemType;
//pohsu{
@property NSInteger grandTotalScore;
@property NSInteger subTotalScore;
@property NSInteger rightFoodScore;
@property NSInteger wrongFoodScore;
@property NSInteger timeBonus;
@property NSInteger extraBonus;
//pohsu}
@property NSInteger gameMaxLevel;
@property NSInteger gameLevel;
@property (nonatomic, assign) NSMutableArray *zooAnimalArray;
@property (nonatomic) ZooAnimalGameLoadingState zaglsLoadingState;
@property (nonatomic, assign) AnimObjManager *gameAnimManager;
@property (nonatomic, assign) AnimObjManager *gameESAnimManager;
@property (nonatomic, assign) AnimObjManager *gameFoodAnimManager;//MaxPan
@property (nonatomic, assign) AnimObjManager *gameEnemyAnimManager;//MaxPan
@property (nonatomic, assign) EndScreen *endScreen;
@property (nonatomic, assign) Texture2D *gameBackground;
@property (nonatomic, assign) Texture2D *loadingBackground;
@property (nonatomic, assign) ZooAnimalFeeder* zaMkObj; //Max Pan for recording 
@property GLuint gameFrameCount;
@property (nonatomic, assign) DisplayClock *timelimit;
@property (nonatomic, assign) failCntObj *pfailCntObj;
@property (nonatomic) GameStageState gameStageState;
@property NSInteger DemoState;

-(BOOL)initGame:(id)view;
-(BOOL)processGame:(id)view;
-(BOOL)endGame:(id)view;

-(void) gameResetVar;
@end
