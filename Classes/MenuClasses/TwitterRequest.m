//
//  TwitterRequest.m
//  game
//
//  Created by Taco on 2010/1/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterRequest.h"
#import "EAGLView.h"

@implementation TwitterRequest

@synthesize username;
@synthesize password;
@synthesize receivedData;
@synthesize delegate;
@synthesize callback;
@synthesize errorCallback;
@synthesize pView;


-(void)friends_timeline:(id)requestDelegate requestSelector:(SEL)requestSelector{
	isPost = NO;
	// Set the delegate and selector
	self.delegate = requestDelegate;
	self.callback = requestSelector;
	// The URL of the Twitter Request we intend to send
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/friends_timeline.xml"];
	[self request:url];
}

-(void)statuses_update:(NSString *)status delegate:(id)requestDelegate requestSelector:(SEL)requestSelector; {
	isPost = YES;
	// Set the delegate and selector
	TwitterRequest * TwitterRequestobj = requestDelegate;
	self.pView = TwitterRequestobj.pView;
	self.delegate = self ;//self;//requestDelegate;
	self.callback = requestSelector;
	// The URL of the Twitter Request we intend to send
	NSURL *url = [NSURL URLWithString:@"http://twitter.com/statuses/update.xml"];
	requestBody = [NSString stringWithFormat:@"status=%@",status];
	[self request:url];
}

- (void) startPicker:(id)view name:(NSString *)name pw:(NSString *)pw
{
	EAGLView *gameView = view;
	NSInteger aa = gameView.main_Game.grandTotalScore ;
	if(aa < 0)
		aa =0;
	
	//twitter the post to twitter
	TwitterRequest * t = [[TwitterRequest alloc] init];
	t.username = name;
	t.password = pw;
	self.pView = view;
	//[twitterMessageText resignFirstResponder];
	
	//loadingActionSheet = [[UIActionSheet alloc] initWithTitle:@"Posting To Twitter..." delegate:nil 
	//										cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	//[loadingActionSheet showInView:gameView];
	//twitterMessageText.text = @"";
	gameView.twitter_wait_alert = [[UIAlertView alloc] initWithTitle:nil message:@"Post to Twitter ...." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityView.frame = CGRectMake(125, 50, 27, 27);
	[gameView.twitter_wait_alert addSubview:activityView];
	[activityView startAnimating];
	[gameView.twitter_wait_alert show];
	//[wait_alert release];
	
//	NSString *info = [[NSString alloc] initWithFormat:@"I am playing the hottest iPhone game Zoo Manager OFF and scores %%d; you've got to try it too!!!!! http://tinyurl.com/yahwvoj", aa] ;
	
	//NSString *post = [[NSString alloc] initWithFormat:@"I am playing the hottest iPhone game Raceem Home and scores %d; you've got to try it too!!!!! http://tinyurl.com/yahwvoj",aa] ;
	NSString *post = [[NSString alloc] initWithFormat:@"I am playing the hottest iPhone game ''Race'em Home'' Home and scores %d; you've got to try it too!!!!! http://tinyurl.com/yahwvoj",aa] ;
	//post = @"i play the best game, Good game for iphone!!!! from evenwell000";
	[t statuses_update:post delegate:self requestSelector:@selector(status_updateCallback:)];	
}

- (void) status_updateCallback: (NSData *) content {
	//[loadingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	//[loadingActionSheet release];
	EAGLView *gameView = pView;
	if(gameView.twitter_wait_alert != nil){ //if there is have any UIAlert at screen
		[gameView.twitter_wait_alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[gameView.twitter_wait_alert release];
		gameView.twitter_wait_alert = nil;
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:gameView.tw_name  forKey:@"NV_Twitter_name"];
	[[NSUserDefaults standardUserDefaults] setObject:gameView.tw_pw	   forKey:@"NV_Twitter_pw"];
	gameView.isTwitterConnectSuccess = YES;
	
	NSLog(@"%@",[[NSString alloc] initWithData:content encoding:NSASCIIStringEncoding]);
}

-(void)request:(NSURL *) url {
	theRequest   = [[NSMutableURLRequest alloc] initWithURL:url];
	
	if(isPost) {
		NSLog(@"ispost");
		[theRequest setHTTPMethod:@"POST"];
		[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[theRequest setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
		[theRequest setValue:[NSString stringWithFormat:@"%d",[requestBody length] ] forHTTPHeaderField:@"Content-Length"];
	}
	
	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	//NSLog(@"challenged %@",[challenge proposedCredential] );
	
	if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:[self username]
                                                 password:[self password]
                                              persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
		//[newCredential release];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        // inform the user that the user name and password
        // in the preferences are incorrect
		NSLog(@"Invalid Username or Password");
    }
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	//NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSString *errorNote;
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
	[theRequest release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	NSLog(@"error.code = %d",error.code);
	EAGLView *gameView = pView;
	if(gameView.twitter_wait_alert != nil){ //if there is have any UIAlert at screen
		[gameView.twitter_wait_alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[gameView.twitter_wait_alert release];
		gameView.twitter_wait_alert = nil;
	}

	int errorcode = error.code;
	switch (errorcode){
		case -1009:// no internet connection
			NSLog(@"error.code = %d",error.code);
			errorNote = @"No Internet connection";
			break;
		case -1012://Invalid user or PW 
			NSLog(@"error.code = %d",error.code);
			errorNote = @"Invalid Username or Password  Please re-enter";
			break;
		
	}
	
	gameView.main_score.twsubmit_status =  TWITTER_SUBMIT_NONE;
         if(gameView.tw_name != nil)
	[gameView.tw_name release];
        if(gameView.tw_pw != nil)
	[gameView.tw_pw release];
        if(gameView.tw_post != nil)
	[gameView.tw_post release];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:errorNote
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil ,nil];
	[alert show];
	[alert release];
	if(errorCallback) {
		[delegate performSelector:errorCallback withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
	
	if(delegate && callback) {
		if([delegate respondsToSelector:self.callback]) {
			[delegate performSelector:self.callback withObject:receivedData];
		} else {
			NSLog(@"No response from delegate");
		}
	} 

	// release the connection, and the data object
	[theConnection release];
    [receivedData release];
	[theRequest release];
}

-(void) dealloc {
	[super dealloc];
}


@end

