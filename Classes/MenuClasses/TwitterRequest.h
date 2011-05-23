//
//  TwitterRequest.h
//  game
//
//  Created by Taco on 2010/1/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterRequest : NSObject {
	NSString			*username;
	NSString			*password;
	NSMutableData		*receivedData;
	NSMutableURLRequest	*theRequest;
	NSURLConnection		*theConnection;
	id					delegate;
	SEL					callback;
	SEL					errorCallback;
	id					pView;
	BOOL				isPost;
	NSString			*requestBody;
	UIActionSheet * loadingActionSheet;
}

@property(nonatomic, retain) NSString	   *username;
@property(nonatomic, retain) NSString	   *password;
@property(nonatomic, retain) NSMutableData *receivedData;
@property(nonatomic, retain) id			    delegate;
@property(nonatomic, retain) id			    pView;
@property(nonatomic) SEL					callback;
@property(nonatomic) SEL					errorCallback;

-(void)friends_timeline:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)request:(NSURL *) url;

-(void)statuses_update:(NSString *)status delegate:(id)requestDelegate requestSelector:(SEL)requestSelector;
-(void)startPicker:(id)view name:(NSString *)name pw:(NSString *)pw;
@end
