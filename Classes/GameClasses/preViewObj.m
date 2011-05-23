//
//  DisplayClock.m
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "preViewObj.h"
#import "EAGLView.h"

@implementation preViewObj

- (id) initWithfailCnt:(int)fCnt {
	if (self = [super init]) {
		[super initWithStart];
		[self loadImageFromFile:@"ZM_G_Time-numbers.png" tileWidth:19 tileHeight:26];
		failCntLevel = fCnt;
		failCnt =0;
	}
	return (self);	
}

- (void) CountFailCnt{
	failCnt++;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	if(failCnt == failCntLevel)
	{
		EAGLView *gameView = view;
		gameView.isGameOver = TRUE;
		printf("game over\n");	
	}	
	return 0;
}

- (void) drawImageWithFade:(GLfloat)fadelevel {
	if(_image) {
		char str[2] = {0,0};
		sprintf(str, "%d", (failCntLevel-failCnt));
		for (int i = 0; i < strlen(str); i++) {
			[_image drawImageWithNo:CGPointMake(397+i*10, 302) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:0.7f scaleY:0.7f scaleZ:1.0f alpha:fadelevel];
		}
	}
}

- (void) dealloc {
	[super dealloc];
}

@end
