//
//  foodObj.h
//  game
//
//  Created by smallwin on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "Texture2D.h"

#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
#import "dataDefine.h"

@interface sqObj : AnimObj {
	NSBundle *bundle;
	int appearPerSec;
	int weightAppear;
	int weightCnt;
	int sQCnt;
	int sQRCnt;
	int runspeed;
	SESoundObj *animalSoundObj;
	AudioPlaybackMgr *animalSoundEffect;
}

- (id) initWithSecond:(int)sec;
- (void) resetSQAppearWeight:(int)sec weight:(int) weight speed:(int) speed;
- (id) initWithSRandeWeight:(int)sec weight:(int) weight view:(id)view;
-(void)PlaySoundByAnimalType;

@end
