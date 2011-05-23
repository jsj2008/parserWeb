//
//  SESound.m
//  OpenALClass
//
//  Created by FIH on 2009/9/11.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SESoundObj.h"
#import "MyOpenALSupport.h"


@implementation SESoundObj

- (void) initBuffer:(CFURLRef)fileURL {
	ALenum		error = AL_NO_ERROR;
	ALenum		format;
	ALsizei		size;
	ALsizei		freq;
	
	if (fileURL)
	{	
		data = MyGetOpenALAudioData(fileURL, &size, &format, &freq);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"error loading sound: %x\n", error);
			return;
		}
		
		// use the static buffer data API
		alBufferDataStaticProc(buffer, format, data, size, freq);
		
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"error attaching audio to buffer: %x\n", error);
			return;
		}
	}
	else
		NSLog(@"Could not find file!\n");	
}

- (void) initSource
{
	ALenum error = AL_NO_ERROR;
	alGetError(); // Clear the error
    
	// Turn Looping ON
	alSourcei(source1, AL_LOOPING, AL_FALSE);
	
	// Set Source Position
	float sourcePosAL[] = {sourcePos.x, 25.0, sourcePos.y};
	alSourcefv(source1, AL_POSITION, sourcePosAL);
	
	// Set Source Reference Distance
	alSourcef(source1, AL_REFERENCE_DISTANCE, 50.0f);
	
	// attach OpenAL Buffer to OpenAL Source
	alSourcei(source1, AL_BUFFER, buffer);
	alSourcei(source2, AL_BUFFER, buffer);
	
	if((error = alGetError()) != AL_NO_ERROR) {
		NSLog(@"Error attaching buffer to source: %x\n", error);
	}
}

- (void) play:(int)sourceNo {
	if(1 == sourceNo) {
		NSLog(@"play source1");
		alSourcePlay(source1);
	}
	else if(2 == sourceNo) {
		NSLog(@"play source2");
		alSourcePlay(source2);
	}
	else {
		NSLog(@"Play with wrong source number");
	}
}

- (void) stop:(int)sourceNo {
	if(1 == sourceNo) {
		NSLog(@"stop source1");
		alSourceStop(source1);
	}
	else if(2 == sourceNo) {
		NSLog(@"Stop source2");
		alSourceStop(source2);
	}
	else {
		NSLog(@"Play with wrong source number");
	}
}

- (id) initSEWithURL:(CFURLRef)fileURL {
	if(self = [super init]) {
		ALenum  error = AL_NO_ERROR;
		
		// Create some OpenAL Buffer Objects
		alGenBuffers(1, &buffer);
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"Error Generating Buffers: %x", error);
			return self;
		}
		
		// Create some OpenAL Source Objects
		alGenSources(1, &source1);
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"Error generating sources! %x\n", error);
			return self;
		}
		
		alGenSources(1, &source2);
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"Error generating sources! %x\n", error);
			return self;
		}
		
		alGetError();
		if((error = alGetError()) != AL_NO_ERROR) {
			NSLog(@"initOpenAL %x\n", error);
			return self;
		}
		
		[self initBuffer:fileURL];
		[self initSource];
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
	
	// Release data
	if(data){
		free(data);
	}
	
	// Delete the Sources
    alDeleteSources(1, &source1);
	alDeleteSources(1, &source2);
	
	// Delete the Buffers
    alDeleteBuffers(1, &buffer);
}
@end
