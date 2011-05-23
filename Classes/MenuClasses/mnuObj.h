//
//  pauseMenu.h
//  game
//
//  Created by Taco on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#import "AnimObj.h"

#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
#import "dataDefine.h"

enum
{
	MNU_OBJ_INIT,
	MNU_OBJ_TITLE,
	MNU_OBJ_SPEACH,
	MNU_OBJ_SPEACHRESPONSE,
	MNU_OBJ_BOX,
	MNU_OBJ_MONKEY,
	MNU_OBJ_ANIMAL,
	MNU_OBJ_TRACK,
	MNU_OBJ_BUTTOM,
	MNU_OBJ_MAX	
};	

@interface mnuObj : AnimObj 
{
	int preCnt;
	int mnuCnt;	
	int hasPlayed;
	AudioPlaybackMgr *sndEft;
	NSBundle *bundle;
	SESoundObj *tmpSndObj;
	SESoundObj *soundObjMk;
	SESoundObj *soundObjRep[4];
}

-(id)initMnuObj:(int)mnuType view:(id) view;

@end
