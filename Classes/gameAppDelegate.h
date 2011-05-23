//
//  gameAppDelegate.h
//  game
//
//  Created by FIG on 2009/9/10.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "EAGLView.h"
#import <UIKit/UIKit.h>
#if defined(FIG_ADWHIRL)
#import "ARRollerProtocol.h"
#endif

@class EAGLView;

#if defined(FIG_ADWHIRL)
@interface gameAppDelegate : NSObject <UIApplicationDelegate, ARRollerDelegate>{
#else
@interface gameAppDelegate : NSObject <UIApplicationDelegate> {
#endif
    UIWindow *window;
    EAGLView *glView;
	Boolean IsLauched;
	int gameStateOld;
	NSDate *gameStartTime;
	NSDate *gameEndTime;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
//global ranking{
@property (readwrite, copy) NSDate *gameStartTime;
@property (readwrite, copy) NSDate *gameEndTime;	
//global ranking}
@end
