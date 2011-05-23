//
//  AudioPlayback.m
//  OpenALClass
//
//  Created by FIH on 2009/9/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AudioPlaybackMgr.h"

@implementation AudioPlaybackMgr

@synthesize bAllStop; //pohsu
- (id)initArray {
	if ((self = [super init]) != nil) {
		SEArray = [[NSMutableArray alloc] init];
		
		[self initOpenAL];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	
	if (SEArray) {
		for (int i = 0; i < [SEArray count]; i++) {
			SESoundObj *obj = [SEArray objectAtIndex:i];
			
			if (obj != nil) {
				[SEArray removeObjectAtIndex:i];
				[obj release];
				i--;
			}
		}
		
		[SEArray removeAllObjects];
		[SEArray release];
	}
}

- (void) initOpenAL {
	// Create a new OpenAL Device
	// Pass NULL to specify the system?ôs default output device
	device = alcOpenDevice(NULL);
	if (device != NULL) {
		// Create a new OpenAL Context
		// The new context will render to the OpenAL Device just created 
		context = alcCreateContext(device, 0);
		if (context != NULL) {
			// Make the new context the Current OpenAL Context
			alcMakeContextCurrent(context);
		}
		else {
			NSLog(@"initOpenAL(context) Fail");
		}
	}
	else {
		NSLog(@"initOpenAL(device) Fail");
	}
}

- (void) delOpenAL {
	//Release context
	if(NULL != context)
		alcDestroyContext(context);
    
	//Close device
    if(NULL != device)
		alcCloseDevice(device);
}

- (SESoundObj *)requestSEWithURL:(CFURLRef)fileURL {
	if (SEArray == nil)
		SEArray = [NSMutableArray array];
	
	if (SEArray != nil) {
		if (fileURL != nil) {
			SESoundObj *obj = [[SESoundObj alloc] initSEWithURL:fileURL];
			[SEArray addObject:obj];
			return obj;
		}
	}
	
	return nil;
}


- (void) play:(SESoundObj *)sourceObj sourceNumber:(int)sourceNo {
	if(bAllStop != YES)
	{
		if(sourceObj && (1 == sourceNo || 2 == sourceNo)) 
		{
			[sourceObj play:sourceNo];
		}
	}
}

- (void) stop:(SESoundObj *)sourceObj sourceNumber:(int)sourceNo {
	if(sourceObj && (1 == sourceNo || 2 == sourceNo)) {
		[sourceObj stop:sourceNo];
	}
}

-(void) allstop:(BOOL)yn
{
	bAllStop = yn;
}

@end
