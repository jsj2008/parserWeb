//
//  LuckyDrawScrollView.m
//  game
//
//  Created by YiChun on 2010/2/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LuckyDrawScrollView.h"
#import "EAGLView.h"

@implementation LuckyDrawScrollView

@synthesize pView;
@synthesize MessageText;

-(id)init:(id)view
{
	EAGLView *gameView = view;
	
//	self = [[super init]initWithFrame:CGRectMake(20,20,430,270)];
	self = [[super init]initWithFrame:CGRectMake(0,0,480,320)];
	//self = [super init];
	[self setBackgroundColor:[UIColor darkGrayColor]];
	self.userInteractionEnabled = YES;
	self.center = CGPointMake(160.0,240.0);
	self.transform = CGAffineTransformMakeRotation((M_PI * (90) / 180.0));


	//Add text message
	MessageText = [[UITextView alloc]initWithFrame:CGRectMake(15,15,450,270)];
	[MessageText setBackgroundColor:[UIColor whiteColor]];
	MessageText.editable =NO;
	MessageText.text= @"Apple Inc. is Not associated in any aspect with the Lucky Draw activities held by Evenwell Digitech Inc.\n\n Join the Lucky Draw to win US$500 NOW! >>>>\nEvent period\nNow ~ 31st May 2010.\n\nPrize\n3 Winners: US$500 \nplease read the notification for the prize distribution rules.\n\nHow to participate the event \n1.As long as you purchase our paid apps, and enter your email address in this event page, and you will have a chance to win US$500!!\n2.If you use our email suggestion function in the event to suggest our game to your friends and they purchase our game, then you will have one more chance to win the prize.\n\nSchedule\nEvent period : Now ~ 31st May 2010\nWinner announcement: 3rd June 2010\nPrize distribution:PayPal.\n\nNotification\nEvents are sponsored by Evenwell Digitech Inc. The events are governed by these official rules. By participating in an event, each entrant agrees to these official rules, including all eligibility requirements, and understands that the results of the event are final in all respects. The event is subject to all federal, state and local laws and regulations and is void where prohibited by law.\nGamememore.com may disqualify any user if Gamememore, in its sole discretion, discovers any abuse or misconduct on the part of said user in connection with this event. Evenwell Digitech Inc. reserves the right to change the rules for this event at any time and without notice.\n\nPRIZE WINNER ANNOUNCEMENTS: \nEvent prizing is limited to United States, Canada and Taiwan residents only. If applicable, prize winners will be announced (as per the PRIZES section above) the day following the winning date in the associated game's announcement section. If necessary, any changes to these dates will additionally be posted within the associated game's announcement section.\n\nWinners will be individually notified via their registered email address in the event. Evenwell Digitech Inc. requires email, shipping addresses, and phone numbers for all physical prizes. Winning prizes will not be shipped until shipping addresses or information are verified. In the event a winner does not or cannot accept the prize for any reason within seven (7) days after being notified by Evenwell Digitech Inc. by email that he/she is the winner or any efforts to deliver the Prize to a winner by Evenwell Digitech Inc. has failed because of an incorrect email or mailing address, his/her prize will be forfeited. We are not responsible for delivery schedules, times, or accuracy and you hold Evenwell Digitech Inc. harmless for shipped but not delivered prizes. Gamememore.com protects the privacy of their users.\n\nELIGIBILITY: \nYou must have a connection to the internet and an e-mail account prior to the first date of this event. The event is open to all gamememore game users who are residents of Canada ,the United States and Taiwan. All entrants must be at least 13 years old or older to participate. Void where restricted, taxed, or prohibited by law. Employees of Evenwell Digitech Inc. and its affiliates, its dealers, its advertising and promotional agencies, in judging organization, manufacturers or distributors of the event materials and their immediate families in the same household are not eligible. Evenwell Digitech Inc., Inc. reserves the right to verify the eligibility of each winner.\n\nLIMITATION OF LIABILITY: Any and all disputes, claims, and causes of action arising out of or connected with this event, or any prizes awarded, shall be resolved individually, without resort to any form of class action, and exclusively by arbitration. Evenwell Digitech Inc. reserves the right, in its sole discretion, to cancel or suspend any part or all of the event should virus, bugs, non-authorized human intervention or other causes beyond the control of sponsor corrupt or impair the administration, security, fairness, or proper play of the event. In such case Evenwell Digitech Inc. may award prizes in a random drawing from all eligible entries received up to the date of cancellation or suspension. Evenwell Digitech Inc. and its promotion and advertising agencies are not responsible for technical, hardware, software, or telephone failures of any kind, lost or unavailable network connections, fraud, incomplete, garbled, or delayed computer transmissions whether caused by Evenwell Digitech Inc., users, or by any of the equipment or programming associated with or utilized in the promotion or by any technical or human error which may occur in the processing of submissions which may damage a user's system or limit a participant's ability to participate in the promotion. Evenwell Digitech Inc. may prohibit an entrant from participating in the event or winning a prize if, in its sole discretion, it determines that said entrant is attempting to undermine the legitimate operation of the event by cheating, hacking, deception, or other unfair playing practices (including the use of automated quick entry programs), or intending to annoy, abuse, threaten, or harass any other entrants or Sponsor representatives.\n\nCAUTION:\nANY ATTEMPT BY AN ENTRANT TO DELIBERATELY DAMAGE THE WEBSITE OR UNDERMINE THE LEGITIMATE OPERATION OF THE EVENT MAY BE IN VIOLATION OF CRIMINAL AND CIVIL LAWS AND SHOULD SUCH AN ATTEMPT BE MADE, NHN USA RESERVES THE RIGHT TO SEEK REMEDIES AND DAMAGES (INCLUDING ATTORNEY'S FEES) FROM ANY SUCH ENTRANT TO THE FULLEST EXTENT OF THE LAW, INCLUDING CRIMINAL PROSECUTION.\n";
	self.pView = gameView;
	[self addSubview:MessageText];
	
	
	//Add button
	Agreebutton = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(380.0f, 275.0f, 100.0f, 50.0f)];
	Cancelbutton = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:CGRectMake(5.0f, 275.0f, 100.0f, 50.0f)];
	[Agreebutton setTitle:@"Agree" forState: UIControlStateHighlighted];
	[Agreebutton setTitle:@"Agree" forState: UIControlStateNormal];	

	[Agreebutton addTarget:self action:@selector(pressAgreeButton) forControlEvents:UIControlEventTouchUpInside];
	
	[Cancelbutton setTitle:@"Cancel" forState: UIControlStateHighlighted];
	[Cancelbutton setTitle:@"Cancel" forState: UIControlStateNormal];	
	[Cancelbutton addTarget:self action:@selector(pressCancelButton) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:Agreebutton];
	[self addSubview:Cancelbutton];
	return self;
	
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"BEGAN");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"MOVE");	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//	NSLog(@"END");
}

-(void)pressAgreeButton
{
	EAGLView *gameView = self.pView;
	[MessageText removeFromSuperview];
	[Agreebutton removeFromSuperview];
	[Cancelbutton removeFromSuperview];
	[self removeFromSuperview];
	
	[gameView.main_LuckyDraw showInputEmailAccount];
	
	[self release];
}

-(void)pressCancelButton
{
	
	[MessageText removeFromSuperview];
	[Agreebutton removeFromSuperview];
	[Cancelbutton removeFromSuperview];
	[self removeFromSuperview];
	
	[self release];
}


-(void)dealloc
{

#if 0
	if(MessageText!=nil)
		[MessageText release];
	if(Agreebutton!=nil)
		[Agreebutton release];
	if(Cancelbutton!=nil)
		[Cancelbutton release];
#endif	
	
	[super dealloc]	;
}

@end
