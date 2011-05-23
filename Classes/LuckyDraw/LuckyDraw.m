//
//  LuckyDraw.m
//  game
//
//  Created by YiChun on 2010/1/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LuckyDraw.h"
#import "EAGLView.h"
#import "LuckyDrawScrollView.h"

#import "RegexKitLite.h"

@implementation LuckyDraw

@synthesize receivedData = _receivedData;
@synthesize hostName = _hostName;
@synthesize tableName = _tableName;
@synthesize device;
@synthesize deviceID;
@synthesize palyingGamename;
@synthesize isPirateVersion;
@synthesize emailAccount;

-(id)init:(id)view
{
	self = [super init];
	pView = view;	
	field_1 = nil;
	field_2 = nil;	
	return self;
}

-(void)initDefaultValues:(id)view
{
	self = [super init];
	//Get the deviceID and gamename
	device =[UIDevice currentDevice];
	//deviceID = [device uniqueIdentifier];
	deviceID = [[NSString alloc] initWithFormat:@"%@",[device uniqueIdentifier]];
	//palyingGamename = [[NSUserDefaults standardUserDefaults] objectForKey:KEYFORGAMENAME];
	palyingGamename = GAMENAME;
	
	_hostName = FIG_GAME_LUCKYDRAW_SERVER;
	_tableName = LUCKDRAW_TABLE_NAME;
	
	privacyobj = [checkPrivacy alloc];
	if(privacyobj != nil)
	{
		isPirateVersion = [privacyobj is_encrypt];
	}
	
	pView = view;
}

-(BOOL)setLuckydraw:(LUCKYDRAW_SUBMIT_STATUS)status
{
	NSMutableString *post = [[NSMutableString alloc] init];
	NSString *encodedDate;
	NSString *today = [[NSDate date] description];

	request = [[[NSMutableURLRequest alloc] init] autorelease]; 
	
	waitAlert = [[UIAlertView alloc] initWithTitle:@"Waiting" message:@"Post data to server ...." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityView.frame = CGRectMake(125, 80, 27, 27);
	[waitAlert addSubview:activityView];
	[activityView startAnimating];
	[waitAlert show];
	[waitAlert release];
	
	current_status = status;

	//set luckydraw date 
	[post appendFormat:@"%@", _hostName ];
	[post appendFormat:@"%@", FIG_LUCKYDRAW_PATH ];
	//[post appendFormat:@"&tableName=%@", _tableName ];
	[request setURL:[NSURL URLWithString:post]]; 
	//set update to datebase date
	
	//[post appendFormat:@"&mode=%@",@"insert"];
	[post appendFormat:@"&deviceID=%@", deviceID];
	[post appendFormat:@"&GameName=%@", palyingGamename];
	[post appendFormat:@"&PirateVersion=%d",isPirateVersion];
	[post appendFormat:@"&emailAccount=%@",str_email];
	[post appendFormat:@"&friendA=%@",str_frienda];
	[post appendFormat:@"&friendB=%@",str_friendb];
	[post appendFormat:@"&friendC=%@",str_friendc];
	
    //http://www.gamememore.com/game/luckydraw.php?&tableName=Luckydraw&mode=insert&deviceID=89&GameName=ZOOTD&PirvateVersion=0&emailAccount=supermai2222@hotmail.com	
	
	NSString *fixedDate = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)today, NULL, NULL, kCFStringEncodingASCII);
	encodedDate = [fixedDate stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	
	[post appendFormat:@"&time=%@",encodedDate];
	
#if 0
	temp = [str_email stringByReplacingOccurrencesOfString:@" " withString:@"%20"];//replace the space to %2B..
	[post appendFormat:@"&emailAccount=%@",temp];
	temp = [str_frienda stringByReplacingOccurrencesOfString:@" " withString:@"%20"];//replace the space to %2B..
	[post appendFormat:@"&friendA=%@",temp];
	temp = [str_friendb stringByReplacingOccurrencesOfString:@" " withString:@"%20"];//replace the space to %2B..
	[post appendFormat:@"&friendB=%@",temp];
	temp = [str_friendc stringByReplacingOccurrencesOfString:@" " withString:@"%20"];//replace the space to %2B..
	[post appendFormat:@"&friendC=%@",temp];
#endif
	//NSLog(post);
	
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	

	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (theConnection)   
	{  
		_receivedData = [[NSMutableData data] retain];  
	}   
	else   
	{  
		// inform the user that the download could not be made  
		NSLog(@"RankHelper:sendRecord:Connection Failed.");
		if(post != nil)
		{
			[post release];
			post = nil;
		}
		
		if(fixedDate != nil)
		{
			[fixedDate release];
			fixedDate = nil;
		}
		
		return NO;
	}
	
	if(post != nil)
	{
		[post release];
		post = nil;
	}
	
	if(fixedDate != nil)
	{
		[fixedDate release];
		fixedDate = nil;
	}
	
	return YES;
}

-(BOOL)checkLuckyDrawIsExpired:(LUCKYDRAW_SUBMIT_STATUS)status
{
	NSMutableString *post = [[NSMutableString alloc] init];
	NSString *encodedDate;
	NSString *today = [[NSDate date] description];
	
	current_status = status;
	
	[post appendFormat:@"%@", FIG_GAME_LUCKYDRAW_SERVER ];
	[post appendFormat:@"%@", FIG_CHECKLUCKDRAW ];
	
	[post appendFormat:@"&GameName=%@", GAMENAME];
	
	NSString *fixedDate = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)today, NULL, NULL, kCFStringEncodingASCII);
	encodedDate = [fixedDate stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	
	[post appendFormat:@"&time=%@",encodedDate];
	
	//NSLog(post);
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	
	request = [[[NSMutableURLRequest alloc] init] autorelease];  
	[request setURL:[NSURL URLWithString:post]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  
	theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];  
	if (theConnection)   
	{  
		_receivedData = [[NSMutableData data] retain];  
	}   
	else   
	{  
		// inform the user that the download could not be made  
		NSLog(@"RankHelper:sendRecord:Connection Failed.");
		
		if(post != nil)
		{
			[post release];
			post = nil;
		}
		
		if(fixedDate != nil)
		{
			[fixedDate release];
			fixedDate = nil;
		}
		
		return NO;
	}
	
	if(post != nil)
	{
		[post release];
		post = nil;
	}
	
	if(fixedDate != nil)
	{
		[fixedDate release];
		fixedDate = nil;
	}
	
	return YES;
}

-(void)showLuckyDrawInfo:(id)view
{

#if 1	
	EAGLView *gameView = pView;
	LuckyDrawScrollView *contentView = [[LuckyDrawScrollView alloc]init:gameView];
	[gameView addSubview:contentView];
#else	

	


	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What's LuckyDraw"
													message:@"\n\n\n"
												   delegate:self
										  cancelButtonTitle:@"Agree"
										  otherButtonTitles:@"Cancel",nil];
	
	UITextView *MessageText = [[UITextView alloc]initWithFrame:CGRectMake(10,50,262,60)];
	[MessageText setBackgroundColor:[UIColor lightGrayColor]];
	MessageText.editable =NO;
	MessageText.text= @"Apple Inc. is Not associated in any aspect with the Lucky Draw activities held by Evenwell Digitech Inc.\n\n Join the Lucky Draw to win US$500 NOW! >>>>\nEvent period\nNow ~ 31st May 2010.\n\nPrize\n3 Winners: US$500 \nplease read the notification for the prize distribution rules.\n\nHow to participate the event \n1.As long as you purchase our paid apps, and enter your email address in this event page, and you will have a chance to win US$500!!\n2.If you use our email suggestion function in the event to suggest our game to your friends and they purchase our game, then you will have one more chance to win the prize.\n\nSchedule\nEvent period : Now ~ 31st May 2010\nWinner announcement: 3rd June 2010\nPrize distribution:PayPal.\n\nNotification\nEvents are sponsored by Evenwell Digitech Inc. The events are governed by these official rules. By participating in an event, each entrant agrees to these official rules, including all eligibility requirements, and understands that the results of the event are final in all respects. The event is subject to all federal, state and local laws and regulations and is void where prohibited by law.\nGamememore.com may disqualify any user if Gamememore, in its sole discretion, discovers any abuse or misconduct on the part of said user in connection with this event. Evenwell Digitech Inc. reserves the right to change the rules for this event at any time and without notice.\n\nPRIZE WINNER ANNOUNCEMENTS: \nEvent prizing is limited to United States, Canada and Taiwan residents only. If applicable, prize winners will be announced (as per the PRIZES section above) the day following the winning date in the associated game's announcement section. If necessary, any changes to these dates will additionally be posted within the associated game's announcement section.\n\nWinners will be individually notified via their registered email address in the event. Evenwell Digitech Inc. requires email, shipping addresses, and phone numbers for all physical prizes. Winning prizes will not be shipped until shipping addresses or information are verified. In the event a winner does not or cannot accept the prize for any reason within seven (7) days after being notified by Evenwell Digitech Inc. by email that he/she is the winner or any efforts to deliver the Prize to a winner by Evenwell Digitech Inc. has failed because of an incorrect email or mailing address, his/her prize will be forfeited. We are not responsible for delivery schedules, times, or accuracy and you hold Evenwell Digitech Inc. harmless for shipped but not delivered prizes. Gamememore.com protects the privacy of their users.\n\nELIGIBILITY: \nYou must have a connection to the internet and an e-mail account prior to the first date of this event. The event is open to all gamememore game users who are residents of Canada ,the United States and Taiwan. All entrants must be at least 13 years old or older to participate. Void where restricted, taxed, or prohibited by law. Employees of Evenwell Digitech Inc. and its affiliates, its dealers, its advertising and promotional agencies, in judging organization, manufacturers or distributors of the event materials and their immediate families in the same household are not eligible. Evenwell Digitech Inc., Inc. reserves the right to verify the eligibility of each winner.\n\nLIMITATION OF LIABILITY: Any and all disputes, claims, and causes of action arising out of or connected with this event, or any prizes awarded, shall be resolved individually, without resort to any form of class action, and exclusively by arbitration. Evenwell Digitech Inc. reserves the right, in its sole discretion, to cancel or suspend any part or all of the event should virus, bugs, non-authorized human intervention or other causes beyond the control of sponsor corrupt or impair the administration, security, fairness, or proper play of the event. In such case Evenwell Digitech Inc. may award prizes in a random drawing from all eligible entries received up to the date of cancellation or suspension. Evenwell Digitech Inc. and its promotion and advertising agencies are not responsible for technical, hardware, software, or telephone failures of any kind, lost or unavailable network connections, fraud, incomplete, garbled, or delayed computer transmissions whether caused by Evenwell Digitech Inc., users, or by any of the equipment or programming associated with or utilized in the promotion or by any technical or human error which may occur in the processing of submissions which may damage a user's system or limit a participant's ability to participate in the promotion. Evenwell Digitech Inc. may prohibit an entrant from participating in the event or winning a prize if, in its sole discretion, it determines that said entrant is attempting to undermine the legitimate operation of the event by cheating, hacking, deception, or other unfair playing practices (including the use of automated quick entry programs), or intending to annoy, abuse, threaten, or harass any other entrants or Sponsor representatives.\n\nCAUTION:\nANY ATTEMPT BY AN ENTRANT TO DELIBERATELY DAMAGE THE WEBSITE OR UNDERMINE THE LEGITIMATE OPERATION OF THE EVENT MAY BE IN VIOLATION OF CRIMINAL AND CIVIL LAWS AND SHOULD SUCH AN ATTEMPT BE MADE, NHN USA RESERVES THE RIGHT TO SEEK REMEDIES AND DAMAGES (INCLUDING ATTORNEY'S FEES) FROM ANY SUCH ENTRANT TO THE FULLEST EXTENT OF THE LAW, INCLUDING CRIMINAL PROSECUTION.\n";
	//[gameView addSubview:MessageText];

	
	[alert addSubview:MessageText];
	
	[alert show];
	[alert release];
	[MessageText release];	
#endif
	
	submit_status = LUCKYDRAW_SHOW_INFO;
	
}

-(void)showInputMoreFriends

{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter More Friends email"
													message:@"\n\n\n"
												   delegate:self
										  cancelButtonTitle:@"Submit"
										  otherButtonTitles:nil,nil];
	
	friendB = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
	[friendB setBackgroundColor:[UIColor whiteColor]];
	friendB.secureTextEntry = NO;

	
	friendC = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
	[friendC setBackgroundColor:[UIColor whiteColor]];
	friendC.secureTextEntry = NO;
	
	
	if(submit_status == LUCKYDRAW_SUBMIT_EMPYTACCOUNT)
	{
		if(field_1 == nil)
		{
			[friendB setPlaceholder:@"Enter Your Email  "];
		}
		else
		{
			if([field_1 length] == 0)
			{
				[friendB setPlaceholder:@"Enter Your Email  "];
			}
			else
			{
				[friendB setPlaceholder:field_1];
				friendB.text = field_1;
			}
		}
		
		if(field_2 == nil)
		{
			[friendC setPlaceholder:@"Enter Your Email "];
		}
		else
		{
			if([field_2 length] == 0)
			{
				[friendC setPlaceholder:@"Enter Your Email "];
			}
			else
			{
				[friendC setPlaceholder:field_2];
				friendC.text = field_2;
			}
		}
	}
	else
	{
	   	[friendB setPlaceholder:@"Enter Your Email  "];
		[friendC setPlaceholder:@"Enter Your Name "];
	}
	

	
	submit_status = LUCKYDRAW_INPUT_MORE_FRIEND;
	
	CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 90.0);
	[alert setTransform: moveUp];
	[alert addSubview:friendB];
	[alert addSubview:friendC];
	[alert show];
	[alert release];
	
}


-(void)showInputEmailAccount 
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Email and Name"
													message:@"\n\n\n"
												   delegate:self
										  cancelButtonTitle:@"Next"
										  otherButtonTitles:nil,nil];
	
	emailAccount = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)];
	[emailAccount setBackgroundColor:[UIColor whiteColor]];
	emailAccount.secureTextEntry = NO;
	
	friendA = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)];
	[friendA setBackgroundColor:[UIColor whiteColor]];
	friendA.secureTextEntry = NO;
	
	
   if(submit_status == LUCKYDRAW_SUBMIT_EMPYTACCOUNT)
   {
	   if(field_1 == nil)
	   {
			[emailAccount setPlaceholder:@"Enter Your Email  "];
	   }
	   else
	   {
		   if([field_1 length] == 0)
		   {
			   [emailAccount setPlaceholder:@"Enter Your Email  "];
		   }
		   else
		   {
			   [emailAccount setPlaceholder:field_1];
			   emailAccount.text = field_1;
		   }
	   }
	   
	   if(field_2 == nil)
	   {
			[friendA setPlaceholder:@"Enter Your Name "];
	   }
	   else
	   {
		   if([field_2 length] == 0)
		   {
			   [friendA setPlaceholder:@"Enter Your Name "];
		   }
		   else
		   {
			   [friendA setPlaceholder:field_2];
			   friendA.text = field_2;
		   }
	   }
   }
   else
   {
	   	[emailAccount setPlaceholder:@"Enter Your Email  "];
		[friendA setPlaceholder:@"Enter Your Name "];
   }

	
	submit_status = LUCKYDRAW_SUBMIT_ENTERACCOUNT;
	
	CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 90.0);
	[alert setTransform: moveUp];
	[alert addSubview:emailAccount];
	[alert addSubview:friendA];
	[alert show];
	[alert release];
}


-(void)showAfterSubmitInfo
{
	
	//[myScrollViewObj setContentSize:CGSizeMake(contentWidth, contentHeight)];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
													message:@""
												   delegate:self
										  cancelButtonTitle:@"Back"
										  otherButtonTitles:@"Watch Us:YouTube",@"Find Us:Facebook",@"Visit Us:GameMeMore",nil];
	
	submit_status = LUCKYDRAW_FINISH;
	[alert show];
	[alert release];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0)
	{
	
		switch(submit_status)
		{
			case LUCKYDRAW_SUBMIT_ENTERACCOUNT:
			{
				
				if(field_1 != nil)
				{
					[field_1 release];
					field_1 = nil;
				}
				
				if(field_2 != nil)
				{
					[field_2 release];
					field_2 = nil;
				}
				
				if(([emailAccount.text length]) == 0 || ([friendA.text length] ==0 ))
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																	message:@"Email Or Name Can't be Empty. Please Try Again"
																   delegate:self
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil ,nil];
					
					submit_status = LUCKYDRAW_SUBMIT_EMPYTACCOUNT;
					sub_status = LUCKYDRAW_SUBMIT_ENTERACCOUNT;
					
					if([emailAccount.text length] !=0)
						field_1 = [[NSString alloc] initWithFormat:@"%@",emailAccount.text];
					
					if([friendA.text length] != 0)
						field_2 = [[NSString alloc] initWithFormat:@"%@",friendA.text];	
					
					[alert show];
					[alert release];
					
				}
				else if(![self emailValidate:emailAccount.text])//robert liao check the invalidly email address
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																	message:@"Email address is invalid"
																   delegate:self
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil ,nil];
					
					submit_status = LUCKYDRAW_SUBMIT_EMPYTACCOUNT;
					sub_status = LUCKYDRAW_SUBMIT_ENTERACCOUNT;
					
					if([emailAccount.text length] !=0)
						field_1 = [[NSString alloc] initWithFormat:@"%@",emailAccount.text];
					
					if([friendA.text length] != 0)
						field_2 = [[NSString alloc] initWithFormat:@"%@",friendA.text];	
					
					[alert show];
					[alert release];
				}
				else
				{
					
					str_email = [[NSString alloc] initWithFormat:@"%@",emailAccount.text];
					str_frienda = [[NSString alloc] initWithFormat:@"%@",friendA.text];	
					[self showInputMoreFriends];
				}
				break;
			}
			case LUCKYDRAW_SUBMIT_EMPYTACCOUNT:
			{
				if(sub_status ==LUCKYDRAW_SUBMIT_ENTERACCOUNT)
				{
					[self showInputEmailAccount];
					
				}else if(sub_status == LUCKYDRAW_INPUT_MORE_FRIEND)
				{
					[self showInputMoreFriends];					
				}
			}
				break;
			case LUCKYDRAW_SHOW_INFO:
				[self showInputEmailAccount];
				break;	
			case LUCKYDRAW_INPUT_MORE_FRIEND:
			{
				
				if(field_1 != nil)
				{
					[field_1 release];
					field_1 = nil;
				}
				
				if(field_2 != nil)
				{
					[field_2 release];
					field_2 = nil;
				}
				
				if(([friendB.text length]) == 0 || ([friendC.text length] ==0 ))
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																	message:@"Email Can't be Empty. Please Try Again"
																   delegate:self
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil ,nil];
					
					submit_status = LUCKYDRAW_SUBMIT_EMPYTACCOUNT;
					sub_status = LUCKYDRAW_INPUT_MORE_FRIEND;
					
					if([friendB.text length] !=0)
						field_1 = [[NSString alloc] initWithFormat:@"%@",friendB.text];
					
					if([friendC.text length] != 0)
						field_2 = [[NSString alloc] initWithFormat:@"%@",friendC.text];	
					
					[alert show];
					[alert release];
				}
				else if(![self emailValidate:friendB.text])//robert liao check the invalidly email address
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																	message:@"Email address is invalid"
																   delegate:self
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil ,nil];					
					submit_status = LUCKYDRAW_SUBMIT_EMPYTACCOUNT;
					sub_status = LUCKYDRAW_INPUT_MORE_FRIEND;

					if([friendB.text length] !=0)
						field_1 = [[NSString alloc] initWithFormat:@"%@",friendB.text];
					
					if([friendC.text length] != 0)
						field_2 = [[NSString alloc] initWithFormat:@"%@",friendC.text];		

					[alert show];
					[alert release];
				}
				else if(![self emailValidate:friendC.text])
				{
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
																	message:@"Email address is invalid"
																   delegate:self
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil ,nil];					
					submit_status = LUCKYDRAW_SUBMIT_EMPYTACCOUNT;
					sub_status = LUCKYDRAW_INPUT_MORE_FRIEND;

					if([friendB.text length] !=0)
						field_1 = [[NSString alloc] initWithFormat:@"%@",friendB.text];
					
					if([friendC.text length] != 0)
						field_2 = [[NSString alloc] initWithFormat:@"%@",friendC.text];	

					[alert show];
					[alert release];
				
				}
				else
				{
					str_friendb = [[NSString alloc] initWithFormat:@"%@",friendB.text];
					str_friendc = [[NSString alloc] initWithFormat:@"%@",friendC.text];	
					submit_status = LUCKYDRAW_SUBMIT_TOSERVER;
					[self setLuckydraw:LUCKYDRAW_SUBMIT_GAME_TO_SERVER];
				}
			}
				break;	
			case LUCKYDRAW_AFTER_SUBMITINFO:
				[self showAfterSubmitInfo];
				break;
			case LUCKYDRAW_FINISH:
				break;
				
		}
		
	}
	else if(buttonIndex == 1)
	{
		switch(submit_status)
		{
			case LUCKYDRAW_FINISH:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@YOUTUBEWEBSITE]];	
			break;
		}
	}else if(buttonIndex == 2)
	{
		switch(submit_status)
		{
			case LUCKYDRAW_FINISH:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@GAMEMEMOREFACEBOOK]];
				break;
		}
	}else if(buttonIndex == 3)
	{
		switch(submit_status)
		{
			case LUCKYDRAW_FINISH:
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@OFFICIALWEBSITE]];	
				break;
		}
		
	}
}

-(void)executeLuckyDraw:(id)view
{
	NSInteger lastcheckstatus = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_LastCheckStatus"];
	switch (lastcheckstatus) {
		case NETWORK_CHECK_SUCCESS:
			[self getLuckydrawdate:view];
		break;
		
		case NOTWORK_CHECK_FAIL:
			[self getLuckydrawdate:view];
		break;
		
		case LUCKYDRAW_SUBMIT_NONE:
			[self getLuckydrawdate:view];
		break;
		
		default:
			break;
	}
	
}

-(void)getLuckydrawdate:(id)view
{
	EAGLView *gameView = pView;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMdd"];
	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HHmmss"];
	
	NSDate *now = [[NSDate alloc] init];
	
	NSString *theDate = [dateFormat stringFromDate:now];
	//NSString *theTime = [timeFormat stringFromDate:now];
	
	NSInteger currentdata = [theDate integerValue];
	//NSInteger time = [theTime integerValue];
	
	NSInteger lastcheckdate = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_LastCheckDate"];
	
	if(lastcheckdate == 0) 
	{
		[self checkLuckyDrawIsExpired:LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED];
		
	}else if((currentdata - lastcheckdate) >0 )
	{
		[self checkLuckyDrawIsExpired:LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED];
	}
	else if ((currentdata - lastcheckdate) == 0)
	{
		
		NSInteger isExpired = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_LastLuckydrawExpired"];	
		if(isExpired == 1)
		{
			gameView.showLuckydrawIcon = YES;
		}
		else
		{
			gameView.showLuckydrawIcon = NO;
		}
	}

	
	[dateFormat release];
	[timeFormat release];
	[now release];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// append the new data to the receivedData
	// receivedData is declared as a method instance elsewhere
	[_receivedData appendData:data];	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
	
	//NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
	
	EAGLView *gameView = pView;
	
    NSString *aStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
    if(aStr) {
		//NSLog(aStr);
		[aStr release];
	}
	
	switch (current_status) 
	{
		case LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED:
		{
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			NSRange YesRange = [recievedStr rangeOfString:@"YES"];
			NSRange NoRange = [recievedStr rangeOfString:@"NO"];
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"yyyyMMdd"];
			
			NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
			[timeFormat setDateFormat:@"HHmmss"];
			
			NSDate *now = [[NSDate alloc] init];
			
			NSString *theDate = [dateFormat stringFromDate:now];
			//NSString *theTime = [timeFormat stringFromDate:now];
			
			NSInteger data = [theDate integerValue];
			//NSInteger time = [theTime integerValue];
			if(YesRange.location != NSNotFound )
			{
				gameView.showLuckydrawIcon = YES;
			}
			else if(NoRange.location != NSNotFound)
			{
				gameView.showLuckydrawIcon = NO;				
			}
			
			[[NSUserDefaults standardUserDefaults] setInteger:NETWORK_CHECK_SUCCESS forKey:@"NV_LastCheckStatus"];
			[[NSUserDefaults standardUserDefaults] setInteger:data forKey:@"NV_LastCheckDate"];
			[[NSUserDefaults standardUserDefaults] setInteger:gameView.showLuckydrawIcon forKey:@"NV_LastLuckydrawExpired"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[dateFormat release];
			[timeFormat release];
			[recievedStr release];
			[now release];
		}
			break;
			
		case LUCKYDRAW_SUBMIT_GAME_TO_SERVER:
		{
			
			UIAlertView *alert;
			NSString *recievedStr = [[NSString alloc] initWithData:_receivedData encoding:NSASCIIStringEncoding];
			NSRange YesRange = [recievedStr rangeOfString:@"YES"];
			NSRange NoRange = [recievedStr rangeOfString:@"NO"];
			
			if(YesRange.location != NSNotFound )
			{
				alert = [[UIAlertView alloc] initWithTitle:@"Now you are in our lucky draw list! Good luck!\nSee you on the iPad!"
																message:@""
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil,nil];
			}
			else if(NoRange.location != NSNotFound)
			{
				alert = [[UIAlertView alloc] initWithTitle:@"Your device have been registered for this game"
																message:@""
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil,nil];			
			}
			else
			{
				alert = [[UIAlertView alloc] initWithTitle:@"Network Error,Please Try Again"
												   message:@""
												  delegate:self
										 cancelButtonTitle:@"OK"
										 otherButtonTitles:nil,nil];	
			}
			

			
			submit_status = LUCKYDRAW_AFTER_SUBMITINFO;
			[alert show];
			[alert release];
			[recievedStr release];

		}
			break;
			
		default:
			break;
	}
	
	
	//NEED TO RELEASE _receivedData ??
	
	[self releaseStr];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
	NSString *errorNote = nil;
    // release the connection, and the data object
    [theConnection release];
    // receivedData is declared as a method instance elsewhere
    [_receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	NSLog(@"error.code = %d",error.code);
	
	int errorcode = error.code;
	switch (errorcode){
		case -1009:// no internet connection
			errorNote = @"No Internet connection";
			break;
		case -1012://Invalid user or PW 
			errorNote = @"Invalid Username or Password  Please re-enter";
			break;
		default:
			errorNote = @"Unknow Error Occurred!";
			break;
			
	}
	
	switch (current_status) 
	{
		case LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED:
		{
			
			current_status = LUCKYDRAW_SUBMIT_NONE;
			[[NSUserDefaults standardUserDefaults] setInteger:NOTWORK_CHECK_FAIL forKey:@"NV_LastCheckStatus"];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
			
			break;
			
		case LUCKYDRAW_SUBMIT_GAME_TO_SERVER:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
															message:errorNote
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil ,nil];
			
			
			current_status = LUCKYDRAW_SUBMIT_NONE;
			
			[alert show];
			[alert release];
		}
			break;
			
		default:
			break;
	}
	
	[self releaseStr];
}

-(void)releaseStr
{
  if(str_email != nil)	
	  [str_email release];
	str_email =nil;
	
  if(str_frienda != nil)	
	[str_frienda release];	
	str_friendc = nil;
	
  if(str_friendb != nil)	
		[str_friendb release]; 
	str_friendb =nil;
	
  if(str_friendc != nil)	
		[str_friendc release];	
	str_friendc = nil;
	
	if(waitAlert != nil){ //if there is have any UIAlert at screen
		[waitAlert dismissWithClickedButtonIndex:0 animated:TRUE];
		waitAlert = nil;
	}
	
}

-(BOOL)emailValidate:(NSString *)email
{
	
	//Based on the string below
	NSString *strEmailMatchstring=@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
	if([email isMatchedByRegex:strEmailMatchstring])
		return YES;
	else
		return NO;
	
#if 0
	//Quick return if @ Or . not in the string
	if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound)
		return NO;
	
	//Break email address into its components
	NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
	email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
	
	//????not present in substring
	if([email rangeOfString:@"."].location==NSNotFound)
		return NO;
	NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
	NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
	
	//username, domainname and subdomain name should not contain the following charters below
	//filter for user name
	NSString *unWantedInUName =@"~!@#$^&*()={}[]|;':\",.,?/`";

	//filter for domain
	NSString *unWantedInDomain = @"~!@#$%^&*()={}[]|;':\"<>,+?/`";
	//filter for subdomain 
	NSString *unWantedInSub = @"`~!@#$%^&*()={}[]:\";',.,?/1234567890";
	
	//subdomain should not be less that 2 and not greater 6
	if(!(subDomain.length>=2 && subDomain.length<=6)) return NO;
	
	if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
		return NO;
	
	return YES;
	
#endif	
}


- (void)dealloc {
	
	if(field_1 != nil)
		[field_1 release];
	
	if(field_2 != nil)
		[field_2 release];
	
	[deviceID release];
	[emailAccount release];
	[super dealloc];
}



@end
