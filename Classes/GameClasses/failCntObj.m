//
//  DisplayClock.m
//  game
//
//  Created by FIH on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "failCntObj.h"
#import "EAGLView.h"

@implementation failCntObj

- (uint) getFailCnt
{
	return  failCnt;
}

- (id) initWithfailCnt:(int)fCnt {
	if (self = [super init]) {
		//[super initWithStart];
		[self loadImageFromFile:@"GAM_Zoo_C_Life_Number.png" tileWidth:13 tileHeight:18];
		heartImg = [[Texture2D alloc] fromFile:@"GAM_Zooff_Failcount.png"];	
		if (heartImg != nil) 
			[heartImg SetTileSize:64 tileHeight:64];
			//[heartImg SetTileSize:21 tileHeight:19];
		
		failCntLevel = fCnt;
//		failCntLevel =1;
		failCnt =0;
	}
	return (self);	
}


- (BOOL) CountFailCnt{
//	return NO;//maxpan test
	if(++failCnt == failCntLevel)
		return YES;
	else
		return NO;
}

- (BOOL) AddFailCnt{
	failCnt = failCnt - 1;
	return YES;
}

- (void) setFailCntLevel:(int) setVal{
	failCntLevel = setVal;
	failCnt = 0;
}

/*- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	return 0;
}*/

- (void) drawImageWithFade:(GLfloat)fadelevel {
	int hp;
	if(_image) {
		[heartImg drawImageWithNo:CGPointMake(240.0, 463) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:0.5f scaleY:0.5f scaleZ:0.5f alpha:fadelevel];
		char str[3] = {0,0,0};
		hp = (failCntLevel-failCnt);
		if(hp<0)
			hp=0;
		sprintf(str, "%d", hp);
		for (int i = 0; i < strlen(str); i++) {
			[_image drawImageWithNo:CGPointMake(260+i*10, 463) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		}
	}
}

- (void) dealloc {
	[super dealloc];
	if(heartImg != nil)
		[heartImg release];
	heartImg = nil;
}

@end
