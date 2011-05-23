//
//  CombinedButton.h
//  game
//
//  Created by FIH on 2009/10/2.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "EAGLView.h"
#import "imageFileinfo.h"
typedef enum{
	CBTypeInfoCredit = 50,
	CBTypeInfoHelp,
    CBTypeInfoBuy,
	CBTypeInfoWebsite,
	CBTypeInfoRanking,
	CBTypePauseResume,
	CBTypePauseRestart,
	CBTypePauseOptions,
	CBTypePauseHelp,
	CBTypePauseMainMenu,
	CBTypeMainNewGame,
	CBTypeMainResume,
	CBTypeMainOptions,
	CBTypeMainMoreGames,
	CBTypeMainInfo,
	CBTypeMainNoticeYes,
	CBTypeMainNoticeNo,
	CBTypeMainEndlessMode
}ComBinedButtonType;

@interface CombinedButton : AnimObj {
	BOOL bResponse;
	NSInteger ori_no;
	int originX;
	int markX;
	int preiousTime;
}
- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos;
- (CGRect) getTouchRect;
- (BOOL)pointInImage:(int)x y:(int)y;
- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)CBTypePauseRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)CBTypeMainMnuNoticeRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)CBTypeMainMnuRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (NSInteger)CBTypeInfoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
//- (void)dealloc;
@property(nonatomic) BOOL bResponse;
@property(readwrite) NSInteger ori_no;
@end
