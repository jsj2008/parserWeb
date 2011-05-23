//
//  AudioPlayback.h
//  OpenALClass
//
//  Created by FIH on 2009/9/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "SESoundObj.h"


@interface AudioPlaybackMgr : NSObject {
	ALCdevice *device;
	ALCcontext *context;

	NSMutableArray *SEArray;
	BOOL bAllStop; //pohsu
}
@property BOOL bAllStop;
- (id)initArray;
- (void)dealloc;

- (SESoundObj *)requestSEWithURL:(CFURLRef)fileURL;

- (void) initOpenAL;
- (void) delOpenAL;

- (void) play:(SESoundObj *)sourceObj sourceNumber:(int)sourceNo;
- (void) stop:(SESoundObj *)sourceObj sourceNumber:(int)sourceNo;
- (void) allstop:(BOOL)yn;//pohsu
@end
