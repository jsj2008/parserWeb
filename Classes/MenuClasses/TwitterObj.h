//
//  TwitterObj.h
//  game
//
//  Created by YiChun on 2010/1/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "EditText.h"

enum TwitterButtonType {
	TWButtonType_Connect,
	TWButtonType_Post,
	TWButtonType_Max
};

@interface TwitterObj : AnimObj {
	id pView;
	NSString *name;
	UITextField *twitter_name;
	UITextField	*twitter_pw;
}

@property(nonatomic, assign ) UITextField *twitter_name;
@property(nonatomic, assign ) UITextField *twitter_pw;
@property(nonatomic, assign)  id	pView;
@property(nonatomic, retain)  NSString *name;


-(void)ShowInputNameandPWDiag:(id)view;
-(void)ShowSubmitInfoDiag:(id)view;
-(id)initWithType:(NSInteger)type Position:(CGPoint) pos;


@end
