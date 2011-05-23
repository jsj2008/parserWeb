//
//  RankHelper.m
//  game
//
//  Created by EvanChen on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RankHelper.h"
#import <CoreFoundation/CoreFoundation.h>
#import "startRanking.h"
#import "EAGLView.h"

//#define DEBUGMSG_RANKHELPER

@implementation RankHelper

@synthesize hostName = _hostName, gameName = _gameName, topCount = _topCount;
@synthesize receivedData = _receivedData;
@synthesize dataRecieved = _dataRecieved;
@synthesize connection = _connection;
//@synthesize waitTimer = _waitTimer;
//@synthesize isQueryTimerOn = _isQueryTimerOn;
//@synthesize isSendTimerOn = _isSendTimerOn;
@synthesize waitingAlert = _waitingAlert;
@synthesize networkErrAlert = _networkErrAlert;
@synthesize state = _state;
@synthesize delegate = _delegate;

- (id) initWithView:(id)view delegate:(id)delegate
{
	if (self = [super init])
	{
		pView = view;
		_delegate = delegate;
		
		_hostName = FIG_GAME_RECORD_SERVER;
		_topCount = FIG_GAME_DEFAULT_TOP_COUNT;
		_receivedData = nil;
		_dataRecieved = NO;
		_state = RHS_NONE;
		
		_waitingAlert = [[UIAlertView alloc] initWithTitle:@"Please wait" message:@" "/*@"Connecting to the server"*/ delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityView.frame = CGRectMake(125, 45, 27, 27);
		[_waitingAlert addSubview:activityView];
		[activityView startAnimating];
		[activityView release];
	}
	
	return self;
}

/*
-(void)initWithDefaultValues:(id)view
{
	//[self setHostName:@FIG_GAME_RECORD_SERVER ];
	_hostName = FIG_GAME_RECORD_SERVER;
	_topCount = FIG_GAME_DEFAULT_TOP_COUNT;
	_receivedData = nil;
	_dataRecieved = NO;
	
	//_isSendTimerOn = NO;
	//_isQueryTimerOn = NO;
	pView = view;
	
	_state = RHS_NONE;
	_waitingAlert = [[UIAlertView alloc] initWithTitle:@"Waiting" message:@"Get top20 ranking from server ...." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityView.frame = CGRectMake(125, 80, 27, 27);
	[_waitingAlert addSubview:activityView];
	[activityView startAnimating];
	[activityView release];
}
*/

/*
-(BOOL) queryTopRanks:(int)level
{
	NSMutableString *post = [[NSMutableString alloc] init];
	[post appendFormat:@"%@", _hostName ];
	[post appendFormat:@"%@", FIG_GAME_QUERY_PATH ];
	[post appendFormat:@"&gameName=%@", _gameName ];
	[post appendFormat:@"&gameLevel=%d", level ];
	//NSLog(post);
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:post]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)   
	{  
		_receivedData = [[NSMutableData data] retain];  
	}   
	else   
	{  
		// inform the user that the download could not be made  
#ifdef DEBUGMSG_RANKHELPER
		NSLog(@"RankHelper:queryTopRanks:Connection Failed.");
#endif
		return NO;
	}
	_waitTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(dataSent:) userInfo: nil repeats:NO];
	//[_waitTimer fire];
	_isQueryTimerOn = YES;
	return YES;
	
}
 */

-(void) getTopRanks:(NSMutableArray *)outArray
{
	//NSMutableArray *rtnRanks = [NSMutableArray arrayWithCapacity:_topCount];

	NSString *tmpSubStr;
	int currTailIndex = 0;
	int totalLength = 0;
	
	//BOOL keepGoing = YES;
	
//	while(keepGoing)
	{
		//while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE) == kCFRunLoopRunHandledSource);
//		if(_dataRecieved)
		{
			NSString *stratMark = @FIG_GAME_RECORD_SEPARATOR_START;
			NSString *endMark = @FIG_GAME_RECORD_SEPARATOR_END;
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			
			totalLength = recievedStr.length;
			
			NSRange aRange = [recievedStr rangeOfString:@"ThisIsQueryData"];
			if(aRange.location != NSNotFound )
			{
				tmpSubStr = [recievedStr copy];
				for(int i=0;i<FIG_GAME_DEFAULT_TOP_COUNT;i++)
				{
					NSRange startRange = [tmpSubStr rangeOfString:stratMark];
					NSRange endRange = [tmpSubStr rangeOfString:endMark];
					int rankStrIndex = startRange.location + startRange.length;
					int rankStrLength = endRange.location - rankStrIndex;
					currTailIndex = (endRange.location + endRange.length);
					
					if((startRange.location != NSNotFound)&&(endRange.location != NSNotFound))
					{
						NSString *rankStr = [tmpSubStr substringWithRange:NSMakeRange(rankStrIndex , rankStrLength)];
						NSArray *recordData = [rankStr componentsSeparatedByString:@","];
						RankRecordObj *rank = [RankRecordObj alloc];
						
						rank.rank = [[recordData objectAtIndex:0] intValue];
						rank.playerName = [recordData objectAtIndex:1];
						rank.gameLevel = [[recordData objectAtIndex:2] intValue];
						rank.score = [[recordData objectAtIndex:3] intValue];
#ifdef DEBUGMSG_RANKHELPER
						NSLog(@"player=%@",rank.playerName);
						NSLog(@"score=%d",rank.score);
						NSLog(@"level=%d",rank.gameLevel);
						NSLog(@"rank=%d",rank.rank);
#endif						
						[outArray addObject:rank];
						
						//[tmpSubStr release];
						tmpSubStr = [tmpSubStr substringWithRange:NSMakeRange(currTailIndex, ([tmpSubStr length] - currTailIndex))];
					}
					//else
					{
						//i = FIG_GAME_DEFAULT_TOP_COUNT;
					}
				}
				
				
				
				[recievedStr release];
				//[tmpSubStr release];
			//	keepGoing = NO;
			}
			//_dataRecieved = NO;
		}
	}
	
	
	
	//return rtnRanks;
	
	

	
}

-(BOOL) QueryFollowsSendRecord:(RankRecordObj *)rankRecord
{
	
	NSMutableString *post = [[NSMutableString alloc] init];
	NSString *encodedDate;
	NSString *today = [[NSDate date] description];
	[post appendFormat:@"%@", _hostName ];
	[post appendFormat:@"%@", FIG_GAME_RECORD_PATH ];
	[post appendFormat:@"gameName=%@", _gameName ];
	[post appendFormat:@"&mode=%@",@"both"];
	[post appendFormat:@"&userName=%@", rankRecord.playerName ];
	[post appendFormat:@"&gameLevel=%d", rankRecord.gameLevel ];
	[post appendFormat:@"&score=%d", rankRecord.score ];
	[post appendFormat:@"&playTime=%d", rankRecord.playTime ];
	
	int timeRecordA = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_A];
	int timeRecordB = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_B];
	int timeRecordC = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_C];
	int timeRecordD = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_D];

	[post appendFormat:@"&playTimeA=%d", timeRecordA ];
	[post appendFormat:@"&timeSectionA=%@", @"A"];
	
	[post appendFormat:@"&playTimeB=%d", timeRecordB ];
	[post appendFormat:@"&timeSectionB=%@", @"B"];
	
	[post appendFormat:@"&playTimeC=%d", timeRecordC ];
	[post appendFormat:@"&timeSectionC=%@", @"C"];
	
	[post appendFormat:@"&playTimeD=%d", timeRecordD ];
	[post appendFormat:@"&timeSectionD=%@", @"D"];
	
	
	NSString *fixedDate = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)today, NULL, NULL, kCFStringEncodingASCII);
	encodedDate = [fixedDate stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	
	[post appendFormat:@"&time=%@", encodedDate ];

	NSLog(post);

	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:post]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData]; 
	
	[request setTimeoutInterval:30.0];
	
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (_connection)   
	{  
		_receivedData = [[NSMutableData data] retain];  
		_state = RHS_SENDLOCALRANK;
		
		if(_waitingAlert != nil)
		{
			[_waitingAlert show];
		}
	}   
	else   
	{  
		// inform the user that the download could not be made  
#ifdef DEBUGMSG_RANKHELPER
		NSLog(@"RankHelper:sendRecord:Connection Failed.");
#endif
		_state = RHS_NONE;
		return NO;
	}
	return YES;
	
}
/*
- (void) sendGameTime
{
	NSMutableString *post = [[NSMutableString alloc] init];
	
	int timeRecordA = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_A];
	int timeRecordB = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_B];
	int timeRecordC = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_C];
	int timeRecordD = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_D];
	
	[post appendFormat:@"%@", _hostName ];
	[post appendFormat:@"%@", FIG_GAME_RECORD_PATH ];
	[post appendFormat:@"&gameName=%@", _gameName ];
	[post appendFormat:@"&mode=%@", @"time"];
	
	[post appendFormat:@"&playTimeA=%d", timeRecordA ];
	[post appendFormat:@"&timeSectionA=%@", @"A"];
	
	[post appendFormat:@"&playTimeB=%d", timeRecordB ];
	[post appendFormat:@"&timeSectionB=%@", @"B"];
	
	[post appendFormat:@"&playTimeC=%d", timeRecordC ];
	[post appendFormat:@"&timeSectionC=%@", @"C"];
	
	[post appendFormat:@"&playTimeD=%d", timeRecordD ];
	[post appendFormat:@"&timeSectionD=%@", @"D"];
	
#ifdef DEBUGMSG_RANKHELPER
	NSLog(post);
#endif
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:post]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (conn)   
	{  
		_receivedData = [[NSMutableData data] retain];  
	}   
	else   
	{  
		// inform the user that the download could not be made  
#ifdef DEBUGMSG_RANKHELPER
		NSLog(@"RankHelper:sendRecord:Connection Failed.");
#endif
	}
	[_waitTimer fire];
	_isSendTimerOn = YES;
	
}
*/
/*
- (BOOL) isSendOK
{
	//BOOL keepGoing = YES;
	//int waitCount = 0;
	//while (keepGoing && waitCount < 5) 
	//while (waitCount < 1000) 
		//for(int i = 0 ; i < 20 ; i++)
	
	{
		//waitCount ++;
		//while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE) == kCFRunLoopRunHandledSource);
		if(_dataRecieved)
		{
			_dataRecieved = NO;
			//keepGoing = NO;
			//i = 5;
			//waitCount = 20000;
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			NSRange aRange = [recievedStr rangeOfString:@"GameRecord"];
			if(aRange.location != NSNotFound )
			{
				return YES;
			}
			else
			{
				return NO;
			}
		}
		else
		{
			[NSThread sleepForTimeInterval:1/100];
			//NSLog(@"waitCount=%d",waitCount);
		}
		
	}
	//if(waitCount == 20000) return YES;
	//else return NO;
	//return NO;
	return NO;
	
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(alertView == _networkErrAlert)
	{
		[_networkErrAlert release];
		_networkErrAlert = nil;
	}
	else if(alertView == _waitingAlert)
	{
		if(_connection)
		{
			[_connection cancel];
			NSLog(@"_connection cancel");
			[_connection release];
			_connection = nil;
			
			if(_waitingAlert)
			{
				[_waitingAlert dismissWithClickedButtonIndex:0 animated:NO]; 
			}			
		}
		if(_receivedData)
		{
			[_receivedData release];
			_receivedData = nil;
		}
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
	
    [_receivedData appendData:data];
	NSLog(@"connection didReceiveData");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// release the connection, and the data object
	if(_connection!=nil)
	{
		[_connection release];
		_connection = nil;
	}
    // receivedData is declared as a method instance elsewhere
	if(_receivedData != nil)
	{
		[_receivedData release];
		_receivedData = nil;
	}
	
	if(_waitingAlert)
	{
		[_waitingAlert dismissWithClickedButtonIndex:0 animated:NO]; 
	}
	
	_networkErrAlert = [[UIAlertView alloc]initWithTitle:@"Connect Failed" message:@"Ranking server is not available.\n Please check the Internet connection or try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[_networkErrAlert show];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//NSLog(@"connection didReceiveResponse");
	
	// this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [_receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// do something with the data
    // receivedData is declared as a method instance elsewhere
#ifdef DEBUGMSG_RANKHELPER
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    NSString *aStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
    if(aStr) {
		NSLog(aStr);
		[aStr release];
	}
#endif
	
	//[self dataSent:nil];  
	[self HandleReceivedData]; /*handle the received data*/
	
    // release the connection, and the data object
    //[_connection release];
    //[_receivedData release];
}
#if FIH_DEVELOP
-(void)connection:(NSURLConnection *)connection

didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge

{
	
    if ([challenge previousFailureCount] == 0) {
		
        NSURLCredential *newCredential;
		
        newCredential=[NSURLCredential credentialWithUser:@"elvisfan"
					   
                                                 password:@"2ixxigux$"
					   
                                              persistence:NSURLCredentialPersistenceNone];
		
        [[challenge sender] useCredential:newCredential
		 
               forAuthenticationChallenge:challenge];
		
    } else {
		
        [[challenge sender] cancelAuthenticationChallenge:challenge];
		
        // inform the user that the user name and password
		
        // in the preferences are incorrect
		//[self showPreferencesCredentialsAreIncorrectPanel:self];
        //[gameAppDelegate showPreferencesCredentialsAreIncorrectPanel:gameAppDelegate];
		
    }
	
}

#endif

-(BOOL) queryByRank:(RankRecordObj *)myRankRecord mode:(NSString *)modeStr
{
	NSMutableString *post = [[NSMutableString alloc] init];
	[post appendFormat:@"%@", _hostName ];
	[post appendFormat:@"%@", FIG_GAME_QUERY_PATH ];
	[post appendFormat:@"gameName=%@", _gameName ];
	[post appendFormat:@"&userName=%@", myRankRecord.playerName ];
	[post appendFormat:@"&gameLevel=%d", myRankRecord.gameLevel ];
	[post appendFormat:@"&score=%d", myRankRecord.score ];
	[post appendFormat:@"&mode=%@", modeStr];
#ifdef DEBUGMSG_RANKHELPER
	NSLog(post);
#endif
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:post]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	[request setTimeoutInterval:30.0];
	
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (_connection)   
	{  
		_receivedData = [[NSMutableData data] retain];  
		_state = RHS_QUERYREMOTERANK;
	}   
	else   
	{  
		// inform the user that the download could not be made 
#ifdef DEBUGMSG_RANKHELPER
		NSLog(@"RankHelper:getMyRank:Connection Failed.");
#endif
		_state = RHS_NONE;
		return NO;
	}
	return YES;
}
/*
-(RankRecordObj *) getMyRank:(RankRecordObj *)myRankObj
{
	RankRecordObj *rtnRank = myRankObj;
	BOOL keepGoing = YES;
	
	while(keepGoing)
	{
		while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE) == kCFRunLoopRunHandledSource);
		if(_dataRecieved)
		{
			NSString *stratMark = @FIG_GAME_RECORD_SEPARATOR_START;
			NSString *endMark = @FIG_GAME_RECORD_SEPARATOR_END;
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			
			NSRange aRange = [recievedStr rangeOfString:@"ThisIsQueryData"];
			if(aRange.location != NSNotFound )
			{
				NSRange startRange = [recievedStr rangeOfString:stratMark];
				NSRange endRange = [recievedStr rangeOfString:endMark];
				int rankStrIndex = startRange.location + startRange.length;
				int rankStrLength = endRange.location - rankStrIndex;
				NSString *rankStr = [recievedStr substringWithRange:NSMakeRange(rankStrIndex , rankStrLength)];
				NSArray *recordData = [rankStr componentsSeparatedByString:@","];
			
				rtnRank.rank = [[recordData objectAtIndex:0] intValue];
				rtnRank.playerName = [recordData objectAtIndex:1];
				rtnRank.gameLevel = [[recordData objectAtIndex:2] intValue];
				rtnRank.score = [[recordData objectAtIndex:3] intValue];
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"player=%@",rtnRank.playerName);
				NSLog(@"score=%d",rtnRank.score);
				NSLog(@"level=%d",rtnRank.gameLevel);
				NSLog(@"rank=%d",rtnRank.rank);
#endif
				[recievedStr release];
				keepGoing = NO;
			}
			_dataRecieved = NO;
		}
	}
	return rtnRank;		
}
*/
//- (BOOL)isRecordServerReachable
//{
	//NSString* str = @"http://www.gamememore.com/";
	//NSMutableURLRequest* request2=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
	//[request2 setHTTPMethod:@"POST"];       
	//[request2 setTimeoutInterval:10];
	//NSURLResponse *response=nil;
	//NSError *err=nil;
	//NSData *data1=[[NSURLConnection sendSynchronousRequest:request2 returningResponse:&response error:&err] retain];
	//if(data1 == nil)
	//{
		/*  //Move to startTanking
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Connect Fail" message:@"Ranking server is not available.\n Please check the Internet connection or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
		*/
		//return NO;
		
	//}
	//else
	//{
		// It will store all data to data1
		// Here you can proceed with data1
		//return YES;
	//}
	
//}

- (void) removeLocalTimeRecord
{
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:GAME_USED_TIME_KEY_A];
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:GAME_USED_TIME_KEY_B];
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:GAME_USED_TIME_KEY_C];
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:GAME_USED_TIME_KEY_D];	
}
- (void) HandleReceivedData
{
	BOOL btnVal = YES;
	switch (_state) {
		case RHS_SENDLOCALRANK:
		{
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			NSRange aRange = [recievedStr rangeOfString:@"GameRecordTimeRecord"];
			NSRange aRange1 = [recievedStr rangeOfString:@"GameRecord"];
			NSRange aRange2 = [recievedStr rangeOfString:@"TimeRecord"];
			if(aRange.location != NSNotFound )
			{
				// Game & Time records are saved
				// App's Next Step
				btnVal = YES;
				[self removeLocalTimeRecord];
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Do Next Step");				
				NSLog(recievedStr);
#endif
			}
			else if(aRange1.location != NSNotFound)
			{
				// Only Game record saved
				btnVal = NO;
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Game record Only");
				NSLog(recievedStr);
#endif
			}
			else if(aRange2.location != NSNotFound)
			{
				// Only Time record saved
				btnVal = NO;
				[self removeLocalTimeRecord];
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Time record Only");
				NSLog(recievedStr);
#endif
			}
			else
			{
				// Send Fail!
				// App can show a error message here.
				btnVal = NO;
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Not Correct Response");
#endif
			}
			
#if 1
			if(_connection)
			{
				[_connection release];
				_connection = nil;
			}
			if(_receivedData)
			{
				[_receivedData release];
				_receivedData = nil;
			}
			
			[self queryByRank:[[RankRecordObj alloc]autorelease] mode:@"top20"];
			
#else
			if(pView) {
				EAGLView *gameView = pView;
				if(gameView.main_ranking) {
					[gameView.main_ranking sendGLobalRankCB:btnVal];
				}
			}
#endif
			
		}
		break;
		case RHS_QUERYREMOTERANK:
		{
			int totalLength = 0;
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			
			totalLength = recievedStr.length;
			
			NSRange aRange = [recievedStr rangeOfString:@"ThisIsQueryData"];
			if(aRange.location != NSNotFound )
			{
				// data is correct
				btnVal = YES;
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Data received");
				NSLog(recievedStr);
#endif
			}
			else
			{
				// garbage.
				btnVal = NO;
#ifdef DEBUGMSG_RANKHELPER
				NSLog(@"Not Correct Response");
#endif
			}
			
			if(_waitingAlert)
			{
				[_waitingAlert dismissWithClickedButtonIndex:0 animated:YES]; 
			}
#if 1
			
			if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveGlobalRanks:glView:)])
			{
				[_delegate didReceiveGlobalRanks:(RankHelper *)self glView:(EAGLView *)pView];	
			}
			
			
#else
			if(pView) {
				EAGLView *gameView = pView;
				if(gameView.main_ranking) {
					[gameView.main_ranking getGlobalRankCB:btnVal];
				}
			}
			
#endif
			_state = RHS_NONE;
			if(_connection)
			{
				[_connection release];
				_connection = nil;
			}
			if(_receivedData)
			{
				[_receivedData release];
				_receivedData = nil;
			}
		}
		break;
		default:
			break;
	}
}
- (void)dealloc {
	
	if(_waitingAlert)
	{
		[_waitingAlert release];
	}
	_waitingAlert = nil;
	[super dealloc];
}


@end
