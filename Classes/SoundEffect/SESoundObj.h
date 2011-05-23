//
//  SESound.h
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


@interface SESoundObj : NSObject {
	void *data;
	
	ALuint buffer;
	ALuint source1;
	ALuint source2;
	
	CGPoint	sourcePos;
	CGPoint	listenerPos;
	ALfloat	sourceVolume;
}

- (id) initSEWithURL:(CFURLRef)fileURL;
- (void) dealloc;

- (void) play:(int)sourceNo;
- (void) stop:(int)sourceNo;
@end
