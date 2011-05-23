//
//  TwitterObj.m
//  game
//
//  Created by YiChun on 2010/1/13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterObj.h"
#import "dataDefine.h"
#import "EAGLView.h"


@implementation TwitterObj

@synthesize twitter_pw;
@synthesize twitter_name;
@synthesize pView;
@synthesize name;

- (id)initWithType:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super initWithStart]) {
		
		switch (type) {	
			case TWButtonType_Connect:
				[self loadImageFromFile: @"Twitter.png" tileWidth:90 tileHeight:30];
				break;
			case TWButtonType_Post:
				[self loadImageFromFile: @"Twitter-post.png" tileWidth:90 tileHeight:30];
				break;
			default:
				break;
		}
		self.pos = pos;
		self.no = 0;
		self.type = type;
	}
	
	return self;
}

- (BOOL)isInImage:(GLint)x y:(GLint)y {
	CGRect rect = [self getCollisionRect];
	int left = rect.origin.x - rect.size.width / 2;
	int right = rect.origin.x + rect.size.width / 2;
	int top = rect.origin.y - rect.size.height / 2;
	int bottom = rect.origin.y + rect.size.height / 2;
	
	if (x < left || x > right || y < top || y > bottom)
		return FALSE;
	return TRUE;
};

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	pView =  gameView;
	
	switch (_type) 
	{
		case TWButtonType_Connect:	
			if(gameView.main_score.twsubmit_status == TWITTER_SUBMIT_NONE)
			{
				if(gameView.isTwitterConnectSuccess == YES)
					_alpha	= 0;
				else
					_alpha = 1;
			}
			else
				_alpha = 0;						
			
			break;
		case TWButtonType_Post:		
			if(gameView.main_score.twsubmit_status == TWITTER_SUBMIT_NAMEPW || 
			   gameView.main_score.twsubmit_status == TWITTER_SUBMIT_INFO ||
			   gameView.isTwitterConnectSuccess == YES)
			{

				_alpha = 1;
			}
			else
				_alpha = 0;
			
			break;
			
		default:
			return 0;
	}
	
	
	if ([touchMode isEqualToString:@"End"]) 
	{
		if ([self isInImage:x y:y]) 
		{
			switch(_type)
			{
				case TWButtonType_Connect:
					if(gameView.main_score.twsubmit_status == TWITTER_SUBMIT_NONE) 
					{
						if(gameView.isTwitterConnectSuccess == NO)
							[self ShowInputNameandPWDiag:gameView];
					}
					break;	
				case TWButtonType_Post:	
					if(gameView.main_score.twsubmit_status == TWITTER_SUBMIT_NAMEPW || 
						gameView.isTwitterConnectSuccess == YES)
					{
						gameView.main_score.twsubmit_status = TWITTER_SUBMIT_INFO;
						[self ShowSubmitInfoDiag:gameView];
					}
					break;
					
				break;
			}
		}
		
	}
	return 0;
}	


-(void)ShowInputNameandPWDiag:(id)view
{
	
#if 1
	EAGLView *gameView = view;
	name = [[NSUserDefaults standardUserDefaults] objectForKey:@"NV_Twitter_name"];		
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
							message:@"\n\n\n"
							delegate:self
							cancelButtonTitle:@"OK"
							otherButtonTitles:@"Cancel",nil];
	
	twitter_name = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	[twitter_name setBackgroundColor:[UIColor whiteColor]];
	twitter_name.secureTextEntry = NO;

	if(name != nil)
	{
		[twitter_name setPlaceholder:name];
		twitter_name.text = name;
	}
	else
		[twitter_name setPlaceholder:@"User Name"];
	
	twitter_pw = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)];
	[twitter_pw setBackgroundColor:[UIColor whiteColor]];
	[twitter_pw setPlaceholder:@"Password"];
	twitter_pw.secureTextEntry = YES;
	
	[alert addSubview:twitter_name];
	[alert addSubview:twitter_pw];
	
	
	CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 90.0);
	[alert setTransform: moveUp];
	

	[alert show];
	[alert release];
	
#endif	
	
#if 0	
	luckdrawobj = [LuckyDraw alloc];
	if(luckdrawobj) {
		[luckdrawobj initDefaultValues:view];
	}
	
	[luckdrawobj showInputEmailAccount];
#endif	
}

-(void)ShowSubmitInfoDiag:(id)view
{
#ifdef FIG_TWITTER_USE_TEXTVIEW
	EAGLView *gameView = view;
	EditText *contentView = [[EditText alloc]init:gameView];
	[gameView addSubview:contentView.view];
#else	
	EAGLView *gameView = view;
	NSInteger aa = gameView.main_Game.grandTotalScore ;
	if(aa < 0)
		aa =0;
	NSString *info = [[NSString alloc] initWithFormat:@"I am playing the hottest iPhone game ''Race'em Home'' and scores %d; you've got to try it too!!!!! http://tinyurl.com/yahwvoj",aa] ;

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
													message:info
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:@"Cancel",nil];
	[alert show];
	[alert release];
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	EAGLView *gameView = pView;
	NSString *nvtwname;
	NSString *nvtwpw;
	if(buttonIndex == 0)
	{
		//post to twitter
		switch(gameView.main_score.twsubmit_status)
		{
			case TWITTER_SUBMIT_NONE:
				gameView.main_score.twsubmit_status =  TWITTER_SUBMIT_NAMEPW;
				gameView.tw_name = [[NSString alloc] initWithFormat:@"%@",twitter_name.text];//twitter_name.text;
				gameView.tw_pw = [[NSString alloc] initWithFormat:@"%@",twitter_pw.text]; ;//twitter_pw.text;
				[self ShowSubmitInfoDiag:gameView];
				[twitter_name release];
				[twitter_pw release];
			break;
			case TWITTER_SUBMIT_NAMEPW:
				[gameView.twitterMgr startPicker:gameView name:gameView.tw_name pw:gameView.tw_pw];
				break;
			case TWITTER_SUBMIT_INFO:
				nvtwname = [[NSUserDefaults standardUserDefaults] objectForKey:@"NV_Twitter_name"];	
				nvtwpw = [[NSUserDefaults standardUserDefaults] objectForKey:@"NV_Twitter_pw"];	
				[gameView.twitterMgr startPicker:gameView name:nvtwname pw:nvtwpw];
				break;
		}
	}
	else
	{
		gameView.main_score.twsubmit_status =  TWITTER_SUBMIT_NONE;
	}
}




- (void)dealloc {
	if(name != nil)
		[name release];
	
	[super dealloc];
}

@end
