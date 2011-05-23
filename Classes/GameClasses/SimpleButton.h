//
//  SimpleButton.h
//  game
//
//  Created by FIH on 2009/9/29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "EAGLView.h"
#import "imageFileinfo.h"
typedef enum {
	SBTypePause = 0,
	//SBTypeGameOverNext,
	//SBTypeCongratulationsNext,
	SBTypeGameEndNext,
	SBTypeScoreNext,
	SBTypeScoreNextLev,
	SBTypeRankingNext,
	SBTypeInfoBack,
	SBTypeRankingBack,
	SBTypeHelpBack,
	SBTypeCreditsBack,
	SBTypeMoreGamesBack,
	//SBTypePauseBack,
	SBTypeOptionsBack,
	SBTypeOptionsSounds,
	SBTypeOptionsMusic,
	SBTypeLocalRank,
#ifdef LITE_VERSION
	SBTypeFullVerBack,
	SBTypeMenuBuyFullVer,	
	SBTypeBuyFullVersionLink,
#endif
	SBTypeEnd	
} SimpleButtonType;

@interface SimpleButton : AnimObj {
	BOOL bResponse;

}
- (id)initWithType:(NSInteger)type Position:(CGPoint) pos;
- (CGRect) getTouchRect;
- (BOOL)pointInImage:(int)x y:(int)y;
- (NSInteger)SBTypeOptionsToggleRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)SBTypePauseRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)SBTypeNextRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view ;
- (NSInteger)SBTypeBackRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)SBTypeRankingRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
#ifdef LITE_VERSION
- (NSInteger)SBTypeFullVerRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
#endif
- (void)dealloc;
@property(nonatomic) BOOL bResponse;
@end
