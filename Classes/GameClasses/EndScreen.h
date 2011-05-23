//
//  EndScreen.h
//  game
//
//  Created by FIH on 2009/9/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
typedef enum {
	GSStateProgress = 0,
	GSStateGameSucceed,
	GSStateGameOver,
	GSStateGameDemo,
	GSStateGameLeaveDemo
} GameStageState;
@interface EndScreen : AnimObj {
	//Texture2D *imgGameSucceed;
	//Texture2D *imgGameOver;
	int cnt;
}
 
//@property(nonatomic, assign) Texture2D *imgGameSucceed;
//@property(nonatomic, assign) Texture2D *imgGameOver;
-(void)setTextureImage:(NSString *)strFile StageState:(GameStageState) state view:(id)view;
- (id)initWithStageState:(GameStageState)state view:(id)view;
@end
