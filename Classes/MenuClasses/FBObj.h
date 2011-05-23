//
//  Score.h
//  game
//
//  Created by fih on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleButton.h"
#import "AnimObj.h"
#import "FBConnect.h"

enum FBButtonType {
	FBButtonType_NULL=101,
	FBButtonType_Connect, /*add for facebook*/
	FBButtonType_Post, /*add for facebook*/
	FBButtonType_Max
};

@interface FBObj : SimpleButton <FBDialogDelegate, FBSessionDelegate, FBRequestDelegate> {
	IBOutlet UILabel* _label;
	IBOutlet UIButton* _permissionButton;
	IBOutlet UIButton* _feedButton;
	IBOutlet FBLoginButton* _loginButton;
	int tatalScore;
	NSInteger dispLevel;
	NSInteger endlessMode;
}

//- (void) FBPost;
- (void) setContainScore:(int)scoretmp;
@end
