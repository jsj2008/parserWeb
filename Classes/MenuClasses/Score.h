//
//  Score.h
//  game
//
//  Created by fih on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "Texture2D.h"
//Twitter {
#import "dataDefine.h" 
//Twitter }
#define img_bg_score_pos_x 480
#define img_bg_score_pos_y 320
#define SCORE_TILEWIDTH 19
#define SCORE_TILEHEIGH 26
#define pts_pos_x1 355
#define pts_pos_x2 405
#define pts_pos_x3 455
#define pts_pos_y  180
#define SCORE_X 250
#define SCORE_Y 270
#define SCORE_NEXT_Y 65
#define	SCORE_Y2 143

@interface ScoreObj : AnimObj {
	NSInteger scoreShow;
	NSInteger subScoreShow;
	NSInteger rightScoreShow;
	NSInteger wrongScoreShow;
	NSInteger timeScoreShow;
	NSInteger iconGameLevel; //Max add
	NSInteger totalscores;
	NSInteger subScores;
	NSInteger rightScores;
	NSInteger wrongScores;
	NSInteger timeScores;
	int	gameStageState;
	BOOL bSubMinus;
	BOOL bGrandMinus;
	//Twitter {
	TWITTER_SUBMIT_STATUS twsubmit_status;
	//Twitter }
}
@property NSInteger scoreShow;
@property NSInteger subScoreShow;
@property NSInteger rightScoreShow;
@property NSInteger wrongScoreShow;
@property NSInteger timeScoreShow;

@property NSInteger totalscores;
@property NSInteger subScores;
@property NSInteger rightScores;
@property NSInteger wrongScores;
@property NSInteger timeScores;

@property int gameStageState;
@property BOOL bSubMinus;
@property BOOL	bGrandMinus;
//Twitter {
@property TWITTER_SUBMIT_STATUS twsubmit_status;
//Twitter }

- (BOOL) initScore:(id)view;
- (BOOL) processScore:(id)view;
- (BOOL)endScore:(id)view;
-(BOOL) isAbleToRanking:(id)view;
- (BOOL) drawRightFoodScore:(GLfloat)fadelevel;
- (BOOL) drawWrongFoodScore:(GLfloat)fadelevel;
- (BOOL) drawTimeBonusScore:(GLfloat)fadelevel;
- (BOOL) drawSubTotalScore:(GLfloat)fadelevel;
- (BOOL) drawGrandTotalScore:(GLfloat)fadelevel;

@end
