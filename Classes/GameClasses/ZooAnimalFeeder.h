//
//  ZooAnimal.h
//  Animation
//
//  Created by JarshChen on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
#import "dataDefine.h"

@interface ZooAnimalFeeder : AnimObj {
	ZooAnimalKind _animalkind;
	ZooAnimalFoodstuff _feedingfoodtype;
	uint _totfeedingcounts;
	uint _totfeedingcounts2;
	uint _totfeedingcounts3;
	uint _totfeedingcounts4;
	uint _curfeedingcounts;
	uint _curfeedingcounts2;
	uint _curfeedingcounts3;
	uint _curfeedingcounts4;
	NSInteger  _rightScores;
	NSInteger  _wrongScores;
	Texture2D *_imgScore;
	Texture2D *_imgScore1;
	Texture2D *_imgScore2;
	Texture2D *_imgScore3;
	
	Texture2D *foodIdx;
	Texture2D *foodIdx1;
	Texture2D *foodIdx2;
	Texture2D *foodIdx3;
	Texture2D *Attach;
	
	Texture2D *AnimInCar1;

	uint InCar1;
	uint InCar2;
	uint InCar3;
	uint InCar4;
	uint InCar5;
	uint InCar6;
	uint InCar7;
	uint InCar8;
	uint InCar9;
	uint InCar10;
	uint totalCount;
	
	uint InCar1_ori;
	uint InCar2_ori;
	uint InCar3_ori;
	uint InCar4_ori;
	uint InCar5_ori;
	uint InCar6_ori;
	uint InCar7_ori;
	uint InCar8_ori;
	uint InCar9_ori;
	uint InCar10_ori;
	
	uint Car_ass_no;

	
	AudioPlaybackMgr *soundEffect;
	BOOL _isStuffed;
	//sound{{ pohsu
	NSBundle *bundle;
	AudioPlaybackMgr *animalSoundEffect;
	SESoundObj *animalSoundObj;
	SESoundObj *tmpSoundJoyful[6];
	SESoundObj *tmpSoundAngry[6];
	//AnimalsoundEffect	
	NSInteger ori_no;
	BOOL bResponse;
	int monkeyState;
	int monkeypos;
	int originMonPos;
	int mkActStat;
	int mkHdState;
	int tX;
	int tY;
	CGFloat origH;
	int feedCnt;
	int demoTouchCnt;
	int demoFinishCnt;
	Texture2D *Demoimg;
	Texture2D *finger;
	Texture2D *plusScore;
	Texture2D *Car_Ass;
	int figmovD;
	int hitCnt;
	int infineEnable;
}

@property(nonatomic) ZooAnimalKind animalkind;
@property(nonatomic) ZooAnimalFoodstuff feedingfoodtype;
@property(nonatomic,readonly) uint totfeedingcounts;
@property(nonatomic) uint curfeedingcounts;
@property(nonatomic, assign) Texture2D *imgScore;
@property(nonatomic, assign) Texture2D *imgScore1;
@property(nonatomic, assign) Texture2D *imgScore2;
@property(nonatomic, assign) Texture2D *imgScore3;
@property(nonatomic) BOOL isStuffed;
@property(nonatomic) NSInteger rightScores;
@property(nonatomic) NSInteger wrongScores;

- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts FeedCounts2:(uint) feedcounts2 FeedCounts3:(uint) feedcounts3 FeedCounts4:(uint) feedcounts4;    
//- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts Point:(CGPoint) point view:(id)view;
- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts FeedCounts2:(uint) feedcounts2 FeedCounts3:(uint) feedcounts3 FeedCounts4:(uint) feedcounts4 Point:(CGPoint) point view:(id)view;

//MaxPan
- (CGRect) getTouchRect;
- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos;
//MaxPan

//- (void)resetWithTotFeedingCounts:(uint)feedcounts;
- (void)resetWithTotFeedingCounts:(uint)feedcounts feedcounts2:(uint)feedcounts2 feedcounts3:(uint)feedcounts3 feedcounts4:(uint)feedcounts4;
-(BOOL) feedWithFood:(ZooAnimalFoodstuff)foodstuff view:(id)view;
-(void)PlaySoundByAnimalType;
+(NSInteger) ZACountingScores:(NSMutableArray*) zooAnimalArray;
+(NSInteger) ZACountingFailedScores:(NSMutableArray*) zooAnimalArray;
+(NSInteger) ZooAnimalsAllStuffed:(NSMutableArray*) zooAnimalArray;
//- (NSInteger) MonkeyActionRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger) MonkeyGsensorRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger) MonkeyDemoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;

-(BOOL) getStuffedVal;
-(void) restMkActState;
-(BOOL) ckMonkeyHandState;
-(ZooAnimalFoodstuff) reHandFood;

-(BOOL) canMove;
-(BOOL) canJump;
- (BOOL) canGetFood;
- (BOOL) canPassed;
-(void) setMonkeyFaint;
- (void) setDemoMode;
- (NSInteger) queryPassState;
-(void) setMonkeyHit;
@end
