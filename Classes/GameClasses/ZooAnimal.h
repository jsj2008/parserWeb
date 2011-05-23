//
//  ZooAnimal.h
//  Animation
//
//  Created by JarshChen on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#define MAXZAKIND 4
#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
#import "dataDefine.h"
@interface ZooAnimal : AnimObj {
	ZooAnimalKind _animalkind;
	ZooAnimalFoodstuff _feedingfoodtype;
	uint _totfeedingcounts;
	uint _curfeedingcounts;
	NSInteger  _rightScores;
	NSInteger  _wrongScores;
	Texture2D *_imgScore;
	Texture2D *foodIdx;

	AudioPlaybackMgr *soundEffect;
	BOOL _isStuffed;
	//sound{{ pohsu
	NSBundle *bundle;
	AudioPlaybackMgr *animalSoundEffect;
	SESoundObj *animalSoundObj;
	SESoundObj *tmpSoundJoyful[5];
	SESoundObj *tmpSoundAngry[5];
	//AnimalsoundEffect	
	NSInteger ori_no;
	BOOL bResponse;
}

@property(nonatomic) ZooAnimalKind animalkind;
@property(nonatomic) ZooAnimalFoodstuff feedingfoodtype;
@property(nonatomic,readonly) uint totfeedingcounts;
@property(nonatomic) uint curfeedingcounts;
@property(nonatomic, assign) Texture2D *imgScore;
@property(nonatomic) BOOL isStuffed;
@property(nonatomic) NSInteger rightScores;
@property(nonatomic) NSInteger wrongScores;

- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts;    
- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts Point:(CGPoint) point view:(id)view;

//MaxPan
- (CGRect) getTouchRect;
- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos;
//MaxPan

- (void)resetWithTotFeedingCounts:(uint)feedcounts;
-(BOOL) feedWithFood:(ZooAnimalFoodstuff)foodstuff;
-(void)PlaySoundByAnimalType;
+(NSInteger) ZACountingScores:(NSMutableArray*) zooAnimalArray;
+(NSInteger) ZACountingFailedScores:(NSMutableArray*) zooAnimalArray;
+(NSInteger) ZooAnimalsAllStuffed:(NSMutableArray*) zooAnimalArray;
- (NSInteger) OtherActionRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
-(BOOL) getStuffedVal;
@end
