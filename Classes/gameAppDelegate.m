//
//  gameAppDelegate.m
//  game
//
//  Created by FIG on 2009/9/10.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "gameAppDelegate.h"
#import "EAGLView.h"
#import "RankHelper.h"

@implementation gameAppDelegate

@synthesize window;
@synthesize glView;
@synthesize gameStartTime, gameEndTime;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
#if defined(FIG_ADWHIRL)
	[ARRollerView startPreFetchingConfigurationDataWithDelegate:self];
#endif
	application.idleTimerDisabled = YES;
	IsLauched = NO;
	if ([glView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"])	// Landscape and the home button on the right side
	{
		glView.transform = CGAffineTransformIdentity;  
		glView.transform = CGAffineTransformMakeRotation((M_PI * (90) / 180.0)); 
		glView.bounds = CGRectMake(0.0, 0.0, 480, 320);     
		[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight; //Max add for
	}

#if defined(FIG_USE_NV)
	[glView readFromFileSystem];	//readFromFileSystem to initial game related information, ex.user 
#endif
	
	glView.animationInterval = 1.0 / _SYSTEM_FRAME_COUNT_PER_SEC_;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / _SYSTEM_FRAME_COUNT_PER_SEC_;
	gameStateOld = glView.gameState ;
	[glView pauseAnimation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(IsLauched == YES)
	{
		glView.gameState = gameStateOld;
		[glView startAnimation];
	}	

	if(IsLauched == NO)
		IsLauched = YES;
}

#if 1//FIG_GLOBAL_RANKING
- (void) saveTimeRecord
{
	int timeRecord = 0;
	
	timeRecord = [gameEndTime timeIntervalSinceDate:gameStartTime]/60;
	
	NSString *tmpStartTime = [gameStartTime description];
	int startTime = [[tmpStartTime substringWithRange:NSMakeRange(11,2)] intValue];
	
	if( 0 <= startTime && startTime < 6 )
	{
		int tmpRecord = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_A];
		timeRecord += tmpRecord;
		
		[[NSUserDefaults standardUserDefaults] setInteger:timeRecord forKey:GAME_USED_TIME_KEY_A];
	}
	else if( 6 <= startTime && startTime < 12 )
	{
		int tmpRecord = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_B];
		timeRecord += tmpRecord;
		
		[[NSUserDefaults standardUserDefaults] setInteger:timeRecord forKey:GAME_USED_TIME_KEY_B];
	}
	else if( 12 <= startTime && startTime < 18 )
	{
		int tmpRecord = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_C];
		timeRecord += tmpRecord;
		
		[[NSUserDefaults standardUserDefaults] setInteger:timeRecord forKey:GAME_USED_TIME_KEY_C];
	}
	else if( 18 <= startTime )
	{
		int tmpRecord = [[NSUserDefaults standardUserDefaults] integerForKey:GAME_USED_TIME_KEY_D];
		timeRecord += tmpRecord;
		
		[[NSUserDefaults standardUserDefaults] setInteger:timeRecord forKey:GAME_USED_TIME_KEY_D];
	}
	
}
#endif




#if defined(FIG_USE_NV)

/*add by Leo to save information for next launch*/
/*this method will call when user press Home button*/
- (void)applicationWillTerminate:(UIApplication *)application{
	application.idleTimerDisabled = NO;
    [glView saveToFileSystem];
	
#if FIG_GLOBAL_RANKING
	[self saveTimeRecord];
#endif	
	
}
/*end by Leo*/
#endif 


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

#pragma mark ARRollerView required delegate method implementation

-(NSString*)adWhirlApplicationKey
{
	  return @"e882593514db102dada5b193ce4f21b9"; //return AdWhirl key;
	//return @"42b877e5bfc0102cb741df581a7911e8"; //return AdWhirl key;
	
}

@end
