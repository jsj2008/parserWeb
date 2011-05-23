//
//  Score.m
//  game
//
//  Created by fih on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "FBConnect.h"
#import "EAGLView.h"
#import "mainGame.h"
#import "FBObj.h"

static NSString *kApiKey = @"e0b3ad672f749b0c1605837de68e1cf2";   
static NSString *kApiKeyScecret = @"fb0c369677e29f2c59e9908886853bf3"; 
static NSString *kGetSessionProxy = nil;
static FBSession *fbsession = nil;

@implementation FBObj

- (id)initWithType:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super init]) {
		//[super initWithStart];
		
		switch (type) {	
			case FBButtonType_Connect:
				[self loadImageFromFile: @"Connect_iphone.png" tileWidth:90 tileHeight:31];
				break;
			case FBButtonType_Post:
				[self loadImageFromFile: @"FB_Post.png" tileWidth:90 tileHeight:31];
				break;				
			default:
				break;
		}
		self.pos = pos;
		self.no = 0;
		self.type = type;
		bResponse = NO;
	}
	
	return self;
}

- (void) setContainScore:(int)scoretmp
{
	tatalScore = scoretmp;
}

- (void) FBPost
{
	FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.userMessagePrompt = @"Race'em Home";
	NSString *templateData=nil;

#if 0	
//	dispLevel = gameView.gameLevel;
	
	if(15 == gameView.main_Game.gameLevel && gameStageState == GSStateGameSucceed)
		dispLevel = 15;	
	
	if(gameView.main_Game.grandTotalScore < 0)
		gameView.main_Game.grandTotalScore = 0;
#endif	
	if(endlessMode == _INIFINITY_TIME_LEVEL)
		templateData = [NSString stringWithFormat:@"{\"name\":\"Buy ''Race'em Home'' now\"," "\"href\":\"http://itunes.apple.com/us/artist/evenwell-digitech-inc/id335767196\"," "\"caption\":\"{*actor*} scores %d at Race'em Home on the iPod touch/iPhone,\",\"description\":\"and it is the endless mode.\"," "\"media\":[{\"type\":\"image\"," "\"src\":\"http://www.gamememore.com/li/fb_race/Fb_Icon_2.png\"," "\"href\":\"http://www.youtube.com/gamememore\"}]," "\"properties\":{\"Website Link\":{\"text\":\"Gamememore home page\",\"href\":\"http://www.gamememore.com/\"}}}",tatalScore];
	else
		templateData = [NSString stringWithFormat:@"{\"name\":\"Buy ''Race'em Home'' now\"," "\"href\":\"http://itunes.apple.com/us/artist/evenwell-digitech-inc/id335767196\"," "\"caption\":\"{*actor*} scores %d at Race'em Home on the iPod touch/iPhone,\",\"description\":\"and completed the level %d.\"," "\"media\":[{\"type\":\"image\"," "\"src\":\"http://www.gamememore.com/li/fb_race/Fb_Icon_2.png\"," "\"href\":\"http://www.youtube.com/gamememore\"}]," "\"properties\":{\"Website Link\":{\"text\":\"Gamememore home page\",\"href\":\"http://www.gamememore.com/\"}}}",tatalScore, dispLevel];
	
	dialog.attachment = templateData; 
	[dialog show];	
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	
	NSInteger iconGameLevel;
	NSInteger gameStageState = gameView.main_Game.gameStageState;
	
	if(gameStageState == GSStateGameSucceed)
		iconGameLevel = gameView.main_Game.gameLevel; //maxpan add
	else
		iconGameLevel = gameView.gameLevel;	
	
	endlessMode = gameView.endlessMode;
	dispLevel = gameView.gameLevel;

	if(15 == gameView.main_Game.gameLevel && gameStageState == GSStateGameSucceed)
		dispLevel = 15;		
	
//	tatalScore 
	if(gameView.main_Game.grandTotalScore < 0)
		tatalScore = 0;
	else
		tatalScore = gameView.main_Game.grandTotalScore;
	//score counting
//	iconGameLevel = gameView.gameLevel; //maxpan add
	
	//	EAGLView *gameView = view;
	switch (_type) 
	{
		case FBButtonType_Connect:
			if(fbsession)
			{
				if(fbsession.isConnected)
				{
					_alpha = 0;
				}
				else
					_alpha = 1;
			}
			else
				_alpha = 1;						
			
			break;
		case FBButtonType_Post:
			if(fbsession)
			{
				if(fbsession.isConnected)
				{
					_alpha = 1;
				}
				else
					_alpha = 0;
			}
			else
				_alpha = 0;
			
			break;
			
		default:
			return 0;
	}
	
	[self update];
	
	if(bTouch){
		if ([touchMode isEqualToString:@"Began"]){
			if ([self pointInImage:x y:y]) {
				//_no = 1;
				bResponse = YES;
			}
		}
		else if ([touchMode isEqualToString:@"Move"]){
			if (![self pointInImage:x y:y]) {
				//_no = 0;
				bResponse = NO;
				
            }
		}
	}
	else{
		if ([touchMode isEqualToString:@"End"]) 
		{
			if (bResponse && [self pointInImage:x y:y]) 
			{				
				if(fbsession.isConnected)
				{
					if(FBButtonType_Post != _type)
						return 0;
#if 1					
					[self FBPost];
#else					
					NSInteger dispLevel;					
					FBStreamDialog *dialog = [[[FBStreamDialog alloc] init] autorelease];
					dialog.delegate = self;
					dialog.userMessagePrompt = @"Race'em Home";
					NSString *templateData=nil;

					dispLevel = gameView.gameLevel;
					
					if(15 == gameView.main_Game.gameLevel && gameStageState == GSStateGameSucceed)
						dispLevel = 15;	

					if(gameView.main_Game.grandTotalScore < 0)
						gameView.main_Game.grandTotalScore = 0;
					
					if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
						templateData = [NSString stringWithFormat:@"{\"name\":\"Buy ''Race'em Home'' now\"," "\"href\":\"http://itunes.apple.com/us/artist/evenwell-digitech-inc/id335767196\"," "\"caption\":\"{*actor*} scores %d at Race'em Home on the iPod touch/iPhone,\",\"description\":\"and it is the endless mode.\"," "\"media\":[{\"type\":\"image\"," "\"src\":\"http://www.gamememore.com/li/fb_race/Fb_Icon_2.png\"," "\"href\":\"http://www.youtube.com/gamememore\"}]," "\"properties\":{\"Website Link\":{\"text\":\"Gamememore home page\",\"href\":\"http://www.gamememore.com/\"}}}",gameView.main_Game.grandTotalScore];
					else
						templateData = [NSString stringWithFormat:@"{\"name\":\"Buy ''Race'em Home'' now\"," "\"href\":\"http://itunes.apple.com/us/artist/evenwell-digitech-inc/id335767196\"," "\"caption\":\"{*actor*} scores %d at Race'em Home on the iPod touch/iPhone,\",\"description\":\"and completed the level %d.\"," "\"media\":[{\"type\":\"image\"," "\"src\":\"http://www.gamememore.com/li/fb_race/Fb_Icon_2.png\"," "\"href\":\"http://www.youtube.com/gamememore\"}]," "\"properties\":{\"Website Link\":{\"text\":\"Gamememore home page\",\"href\":\"http://www.gamememore.com/\"}}}",gameView.main_Game.grandTotalScore, dispLevel];
					
					dialog.attachment = templateData; 
					[dialog show];
#endif					
				}	
				else
				{
					if(FBButtonType_Connect != _type)
						return 0;
					if (fbsession == nil) {
						if (kGetSessionProxy) {
							fbsession = [[FBSession sessionForApplication:kApiKey getSessionProxy:kGetSessionProxy delegate:self] retain];
						} else {
							fbsession = [[FBSession sessionForApplication:kApiKey secret:kApiKeyScecret delegate:self] retain];
						}
					}
					FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbsession] autorelease]; 
					[dialog show];
				}	
			}
			
			
		}
		
	}
	
	return 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	_label.text = [NSString stringWithFormat:@"Error(%d) %@", error.code,
				   error.localizedDescription];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	_permissionButton.hidden = NO;
	_feedButton.hidden = NO;
	
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", session.uid];
	
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
	
}

- (void)sessionDidLogout:(FBSession*)session {
	_label.text = @"";
	_permissionButton.hidden = YES;
	_feedButton.hidden = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result {
	NSArray* users = result;
	NSDictionary* user = [users objectAtIndex:0];
	NSString* name = [user objectForKey:@"name"];
	_label.text = [NSString stringWithFormat:@"Logged in as %@", name];
	[self FBPost];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	_label.text = [NSString stringWithFormat:@"Error(%d) %@", error.code,
				   error.localizedDescription];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)askPermission:(id)target {
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.permission = @"status_update";
	[dialog show];
}

- (void)publishFeed:(id)target {
	FBFeedDialog* dialog = [[[FBFeedDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.templateBundleId = 9999999;
	dialog.templateData = @"{\"key1\": \"value1\"}";
	[dialog show];
}
@end
