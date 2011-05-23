//
//  startRanking.h
//  game
//
//  Created by FIH on 2009/9/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "startInput.h"
#import "RankObj.h"
#import "RankRecordObj.h"
#import "RankHelper.h"
#define back_object_x 160.0 //position x of back object
#define back_object_y 50.0 //position y of back object
#define upPage_x 160.0 //position x of upPage object
#define upPage_y 420.0 //position y of upPage object
#define downPage_x 160.0 //position x of downPage object
#define downPage_y 35.0 //position y of downPage object
#define btn_x  260 //position x of return button
#define	btn_y  18  //position x of return button

#define rank_x 30 //init position x of name //50
#define rank_y 410 //init position y of name //250
#define rank_offset_x 240 // offset between name and score //290
#define rank_offset_y 40 //every rank line offset //25
#define rank_name_width 16 //rank name width //20
#define rank_name_height 16 //rank name height //15
#define rank_number_width 16 //rank number width
#define rank_number_height 16 //rank number wheight
#define rank_bar_width 300 //bar width
#define rank_bar_height 30 //bar height
#define img_upDownBack_width 23 //Width of upPage key downPage key Back key
#define img_upDownBack_height 27 //Height of upPage key downPage key Back key
#define img_bg_ranking_name "MNU_Race_C_Rank_BG.png" //image of ranking backgruound
#define img_up_down_back_name "END_Zoo_C_Ranking_Button.PNG" //image of ranking uppage downpage back key
#define img_bg_ranking_pos_x 480 //x of ranking screen
#define img_bg_ranking_pos_y 320 //y of ranking screen
#define img_number_name "Trebuchet MS0-9.png"	// 0 - 9 number of ranking
#define img_ranking_name "Trebuchet MS_A~Z.png" // A - Z of ranking
#define img_ranking_bar "MNU_Zooff_C_Rank_Bar2.png"//"ZM_Menu-Info-R_Bar.png" //score bar
#define img_focus_bar "MNU_Zooff_C_Rank_Bar1.png" //focus bar
#define STRING_OFFSET 8
typedef enum
	{
		RANK_LS = 0,
		RANK_PT,
	}rankOrientation;

@interface startRanking : NSObject {
	Texture2D *imgRankingScore;
	Texture2D *imgRankingName;
	Texture2D *imgRankingBar;
	Texture2D *imgFocusBar;
	int currentStartRecord;
	int recordPerPage;
	NSInteger sbType ; //Jarsh
#ifdef FIG_GLOBAL_RANKING
	RankHelper *rankHelper;
	//Texture2D *loadingImg;
	NSMutableArray *rnkArray;
	NSMutableArray *topIndexList;
	NSMutableArray *topNameList;
	NSMutableArray *topScoreList;
	NSInteger TopScore;
	BOOL isSendGlobRank;
	//BOOL isLoading;
	id pView;
	id RankingBtn;
#endif	
}
@property (nonatomic, assign) Texture2D *imgRankingScore;
@property (nonatomic, assign) Texture2D *imgRankingName;
@property (nonatomic, assign) Texture2D *imgRankingBar;
@property (nonatomic, assign) Texture2D *imgFocusBar;
@property int currentStartRecord;
@property int recordPerPage;
@property NSInteger sbType; //Jarsh
#ifdef FIG_GLOBAL_RANKING
@property (nonatomic, assign) NSMutableArray *topIndexList;
@property (nonatomic, assign) NSMutableArray *topNameList;
@property (nonatomic, assign) NSMutableArray *topScoreList;
//@property BOOL isLoading;
@property (nonatomic, assign)	NSInteger TopScore;
@property BOOL isSendGlobRank;
#endif
-(BOOL)initRanking:(id)view;
-(BOOL)processRanking:(id)view;
-(BOOL)endRanking:(id)view;
-(BOOL)drawLocalRanking:(id)view fadeLevel:(GLfloat)fadeLevel;
#ifdef FIG_GLOBAL_RANKING
-(BOOL)drawGlobalRanking:(id)view fadeLevel:(GLfloat)fadeLevel;
-(BOOL)insertGlobalRanking2Structure:(id)view;
-(BOOL)queryGlobalRank;
-(BOOL)getGlobalRank;
-(void)secondThread;
-(void)initWithThread;
-(void)endSecondThread;
- (void)sendGlobalRank:(NSString *)name UserScore:(NSInteger)score;
-(BOOL)sendGLobalRankCB;
-(void)getGlobalRankingFromServer:view;
#endif

@end
