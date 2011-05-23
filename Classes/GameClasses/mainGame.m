//
//  mainGame.m
//  game
//
//  Created by StevenKao on 2009/9/14.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "mainGame.h"
#import "stageinfo.h"
#import "EAGLView.h"
//Max Pan{
#import "foodObj.h"
#import "dataDefine.h"
#import "sqObj.h"
//Max Pan}
#import "ZooManager.h"
#import "failCntObj.h"
#import "SimpleButton.h"

#if FIG_GLOBAL_RANKING
#import "RankRecordObj.h"
#import "RankHelper.h"
#endif
/**/

FOODGROUP foodGroup1[]=
{
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE7,	1	,	2},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE4,	1	,	1},
{0,0}
};

FOODGROUP foodGroup2[]=
{
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE7,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{0,0}
};


FOODGROUP foodGroup3[]=
{
{EN_FOODTYPE7,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE7,	1	,	0},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE2,	1	,	1},
{0,0}
};

FOODGROUP foodGroup4[]=
{								
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE3,	1	,	2},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE7,	1	,	0},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE6,	1	,	0},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE3,	1	,	2},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE3,	1	,	0},
{0,0}
};

/*
 EN_FOODTYPE1 monkey
 EN_FOODTYPE2 griff
 EN_FOODTYPE3 lion
 EN_FOODTYPE4 rabbit
 EN_FOODTYPE5 horse 
 */ 

FOODGROUP foodGroup5[]=
{
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE3,	1	,	1},
{EN_FOODTYPE6,	1	,	0},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE8,	1	,	2},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE7,	1	,	0},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE8,	1	,	0},
{EN_FOODTYPE3,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE6,	1	,	0},
{EN_FOODTYPE8,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE7,	1	,	2},
{0,0}
};

FOODGROUP foodGroup6[]=
{
{EN_FOODTYPE3,	1	,	1}, 
{EN_FOODTYPE1,	1	,	2}, 
{EN_FOODTYPE5,	1	,	3}, 
{EN_FOODTYPE2,	1	,	0}, 
{EN_FOODTYPE5,	1	,	2}, 
{EN_FOODTYPE3,	1	,	0}, 
{EN_FOODTYPE2,	1	,	1}, 
{EN_FOODTYPE4,	1	,	3}, 
{EN_FOODTYPE4,	1	,	0}, 
{EN_FOODTYPE5,	1	,	2}, 
{EN_FOODTYPE1,	1	,	1}, 
{EN_FOODTYPE3,	1	,	3}, 
{EN_FOODTYPE5,	1	,	1}, 
{EN_FOODTYPE3,	1	,	0}, 
{EN_FOODTYPE2,	1	,	2},
{0,0}
};

FOODGROUP foodGroup7[]=
{
{EN_FOODTYPE5,	1	,	3}, 
{EN_FOODTYPE2,	1	,	0}, 
{EN_FOODTYPE4,	1	,	2}, 
{EN_FOODTYPE2,	1	,	1}, 
{EN_FOODTYPE1,	1	,	3}, 
{EN_FOODTYPE4,	1	,	0}, 
{EN_FOODTYPE1,	1	,	2}, 
{EN_FOODTYPE3,	1	,	0}, 
{EN_FOODTYPE5,	1	,	3}, 
{EN_FOODTYPE2,	1	,	0}, 
{EN_FOODTYPE3,	1	,	1}, 
{EN_FOODTYPE5,	1	,	2}, 
{EN_FOODTYPE2,	1	,	1}, 
{EN_FOODTYPE4,	1	,	3}, 
{EN_FOODTYPE3,	1	,	0},
{0,0}           
};

FOODGROUP foodGroup8[]=
{
{EN_FOODTYPE3,	1	,	1},
{EN_FOODTYPE4,	1	,	0}, 
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE5,	1	,	3}, 
{EN_FOODTYPE3,	1	,	1}, 
{EN_FOODTYPE2,	1	,	0}, 
{EN_FOODTYPE1,	1	,	1}, 
{EN_FOODTYPE1,	1	,	2}, 
{EN_FOODTYPE4,	1	,	0}, 
{EN_FOODTYPE5,	1	,	3}, 
{EN_FOODTYPE2,	1	,	1}, 
{EN_FOODTYPE3,	1	,	3}, 
{EN_FOODTYPE5,	1	,	2}, 
{EN_FOODTYPE1,	1	,	1}, 
{EN_FOODTYPE4,	1	,	0},
{0,0}
};

FOODGROUP foodGroup9[]=
{
{	EN_FOODTYPE5,	1	,	3}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE3,	1	,	1}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE5,	1	,	1}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE3,	1	,	2}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE4,	1	,	0}, {EN_FOODTYPE5,	1	,	2	},
{0,0}           
};              

FOODGROUP foodGroup10[]=
{
{	EN_FOODTYPE3,	1	,	1}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE1,	1	,	1}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE5,	1	,	3}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE5,	1	,	2	},
{0,0}           
};

FOODGROUP foodGroup11[]=
{
{	EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE3,	1	,	3}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE4,	1	,	0}, {EN_FOODTYPE3,	1	,	1}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE2,	1	,	3}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE5,	1	,	2	},
{0,0}
};

FOODGROUP foodGroup12[]=
{
{	EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE1,	1	,	1}, {EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE4,	1	,	0}, {EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE3,	1	,	3}, {EN_FOODTYPE5,	1	,	1}, {EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE3,	1	,	1}, {EN_FOODTYPE4,	1	,	3	},
{0,0}
};

FOODGROUP foodGroup13[]=
{
{	EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE3,	1	,	3}, {EN_FOODTYPE5,	1	,	1}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE2,	1	,	0}, {EN_FOODTYPE1,	1	,	1}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE5,	1	,	3}, {EN_FOODTYPE3,	1	,	1}, {EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE5,	1	,	1	},
{0,0}
};

FOODGROUP foodGroup14[]=
{
{	EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE4,	1	,	3}, {EN_FOODTYPE2,	1	,	2}, {EN_FOODTYPE5,	1	,	1}, {EN_FOODTYPE1,	1	,	0}, {EN_FOODTYPE3,	1	,	3}, {EN_FOODTYPE2,	1	,	1}, {EN_FOODTYPE3,	1	,	0}, {EN_FOODTYPE4,	1	,	2}, {EN_FOODTYPE5,	1	,	3}, {EN_FOODTYPE2,	1	,	3}, {EN_FOODTYPE4,	1	,	1}, {EN_FOODTYPE5,	1	,	2}, {EN_FOODTYPE1,	1	,	3}, {EN_FOODTYPE3,	1	,	0	},
{0,0}
};

FOODGROUP foodGroup15[]=
{
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE1,	1	,	0},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE8,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE3,	1	,	2},
{EN_FOODTYPE4,	1	,	0},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE7,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE8,	1	,	2},
{EN_FOODTYPE2,	1	,	1},
{EN_FOODTYPE6,	1	,	2},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE3,	1	,	1},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	1},
{EN_FOODTYPE6,	1	,	1},
{EN_FOODTYPE2,	1	,	2},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE5,	1	,	0},
{EN_FOODTYPE7,	1	,	0},
{EN_FOODTYPE4,	1	,	2},
{EN_FOODTYPE8,	1	,	1},
{EN_FOODTYPE2,	1	,	0},
{EN_FOODTYPE5,	1	,	2},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE4,	1	,	1},
{EN_FOODTYPE5,	1	,	1},
{EN_FOODTYPE1,	1	,	2},
{EN_FOODTYPE3,	1	,	0},
{EN_FOODTYPE5,	1	,	1},
{0,0}
};

FOODGROUP foodGroup16[]=
{
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE1,1,3 },
{EN_FOODTYPE5,1,1 },
{EN_FOODTYPE4,1,0 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE4,1,2 },
{EN_FOODTYPE2,1,2 },
{EN_FOODTYPE5,1,3 },
{EN_FOODTYPE3,1,0 },
{0,0}
};

FOODGROUP foodGroup17[]=
{
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE4,1,3 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE3,1,0 },
{EN_FOODTYPE5,1,2 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE2,1,2 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE4,1,3 },
{EN_FOODTYPE5,1,0 },
{0,0}
};

FOODGROUP foodGroup18[]=
{
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE1,1,3 },
{EN_FOODTYPE5,1,1 },
{EN_FOODTYPE4,1,0 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE4,1,2 },
{EN_FOODTYPE2,1,2 },
{EN_FOODTYPE5,1,3 },
{EN_FOODTYPE3,1,0 },
{0,0}
};

FOODGROUP foodGroup19[]=
{
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE4,1,3 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE3,1,0 },
{EN_FOODTYPE5,1,2 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE2,1,2 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE4,1,3 },
{EN_FOODTYPE5,1,0 },
{0,0}
};

FOODGROUP foodGroup20[]=
{
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE1,1,3 },
{EN_FOODTYPE5,1,1 },
{EN_FOODTYPE4,1,0 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE1,1,1 },
{EN_FOODTYPE4,1,2 },
{EN_FOODTYPE2,1,2 },
{EN_FOODTYPE5,1,3 },
{EN_FOODTYPE3,1,0 },
{0,0}
};

FOODGROUP foodGroup21[]=
{
{EN_FOODTYPE1,1,3 },
{EN_FOODTYPE2,1,3 },
{EN_FOODTYPE4,1,1 },
{EN_FOODTYPE5,1,0 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE5,1,1 },
{EN_FOODTYPE4,1,2 },
{EN_FOODTYPE3,1,2 },
{EN_FOODTYPE1,1,3 },
{EN_FOODTYPE2,1,0 },
{0,0}
};

STAGEINFO stageinfo1[]= {
	{3*_SYSTEM_FRAME_COUNT_PER_SEC_, 2, 0, 1},
	{0, 0, 0, -1}
};

//typedef struct _LEVEL_DATA{
//	int pixPerCnt;
//	int sqSec;
//	int sqWeight;
//	int sqSpeed;
//	float secPerFood;
//	int foodPerOnce;
//	int timeLimt;
//	int foodGoalM;
//	int foodGoalG;
//	int foodGoalL;
//	int foodGoalR;
//	int foodGoalH;		
//	FOODGROUP *foodGroupData;
//}LEVEL_DATA;

LEVEL_DATA lv[]=
{ 
	{_SPEED_FOOD_,	8,	 1,	4,	2.5, 1,	 45,  5,  6,  7,  8,  9,foodGroup1}, /*unused data*/ 
	{_SPEED_FOOD_,	8,	 0,	4,	0.5, 1,	 60,  4,  0,  0,  6,  0,foodGroup1},  /*food rate mov pix, food once time, time limit, goal per animal, food group*/
	{_SPEED_FOOD_,	8,	10,	4,	0.5, 2,	 80,  6,  5,  0,  6,  2,foodGroup2},
	{_SPEED_FOOD_,	8,	30,	4,	0.5, 2,	100,  8,  8,  0,  10,  2,foodGroup3},
	{_SPEED_FOOD_,	8,	50,	4,	0.5, 3,	130,  8,  10,  8,  9,  5,foodGroup4},
	{_SPEED_FOOD_,	8,	50,	4,	0.5, 3,	170, 12, 10, 10, 12,  4,foodGroup5},
	{_SPEED_FOOD_,	8,	60,	5,	0.2, 2,	240,  3,  7,  6,  3,  5,foodGroup6},
	{_SPEED_FOOD_,	6,	60,	5,	2.2, 2,	270,  3,  8,  5,  7,  5,foodGroup7},
	{_SPEED_FOOD_,	6,	60,	5,	2.2, 2, 300,  4,  7,  7,  5,  9,foodGroup8},
	{_SPEED_FOOD_,	6,	60,	5,	2.2, 2, 330,  5,  8,  9,  8,  7,foodGroup9},
	{_SPEED_FOOD_,5,70,5,2.2,2,360,5,9,10,8,9,foodGroup10},
	{_SPEED_FOOD_,5,70,6,2.1,2,390,5,11,12,10,10,foodGroup11},
	{_SPEED_FOOD_,5,70,6,2.1,2,420,6,13,10,11,14,foodGroup12},
	{_SPEED_FOOD_,4,70,6,2.1,2,450,7,11,14,14,16,foodGroup13},
	{_SPEED_FOOD_,4,70,6,2.1,2,480,8,15,15,15,19,foodGroup14},
	{_SPEED_FOOD_,3,70,6,2,2,180,10,20,20,20,20,foodGroup15},
	{_SPEED_FOOD_,8,2,6, 2.2, 2,780,7,7,7,8,7,foodGroup16},
	{_SPEED_FOOD_,8,2,6, 2.2, 2,840,8,7,7,8,8,foodGroup17},	
	{_SPEED_FOOD_,8,2,6, 2.2, 2,900,8,8,8,8,8,foodGroup18},	
	{_SPEED_FOOD_,8,2,6, 2.2, 2,990,8,9,9,8,8,foodGroup19},		
	{_SPEED_FOOD_,8,2,6, 2.2, 2,1080,9,9,9,9,9,foodGroup20},
	{_SPEED_FOOD_,8,2,6, 2.2, 2,1200,10,9,10,10,9,foodGroup21},	
{0,0,0,0,0,0,0,0,0,0,0,0, nil}
};

STAGEINFO stageinfo2[] = {
{100, 0, 200, 1},
{600, 0, 200, 1},
{0, 0, 0, -1}
};

STAGEINFO *stageinfo[] = {
stageinfo1,
stageinfo2,
NULL
};


@implementation mainGame
@synthesize DemoState;
@synthesize zooAnimalArray;
@synthesize pfailCntObj; //MaxPan
@synthesize zaMkObj;
//@synthesize pauseItemType;
@synthesize zaglsLoadingState;
@synthesize gameAnimManager;
@synthesize gameESAnimManager;

@synthesize gameFoodAnimManager;
@synthesize gameEnemyAnimManager;

@synthesize endScreen;
@synthesize gameBackground;
@synthesize loadingBackground;
@synthesize gameFrameCount;
@synthesize timelimit;
@synthesize gameStageState;
//pohsu{
@synthesize extraBonus;
@synthesize grandTotalScore;
@synthesize subTotalScore;
@synthesize rightFoodScore;
@synthesize wrongFoodScore;
//pohsu}
@synthesize timeBonus;
@synthesize gameMaxLevel;
@synthesize gameLevel;

-(void) gameResetVar
{
	gameFrameCount = 0;           // init game itself frame count

	idx = 0;
	fFactoryIdx = 0;
	posTyp =0;
	gamePreFrameCnt = 0;
	gameFrameCntDelta = 0;
}

-(BOOL)initGame:(id)view {
	EAGLView *gameView = view;
	CGRect mainbounds = gameView.bounds;
	//Read configuration form file not implement Max Pan comment by 20090918
	switch (zaglsLoadingState) {
		case ZAGLS_LoadingStart:
			{
				if(gameView.song !=nil) //close previous song
				{
					[gameView.song	close];
				}
				
				loadingBackground = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Loading_BG.png"];
				if (loadingBackground != nil) {
					[loadingBackground SetTileSize:mainbounds.size.width tileHeight:mainbounds.size.height];
				}		
				[gameView fadeInWithState:GS_INIT_GAME];
				
				//set pointer as nil here 
				gameESAnimManager = nil;
				gameFoodAnimManager = nil; //Max Pan
				sObj = nil;
				gameEnemyAnimManager = nil;
				endScreen = nil;
				
				zaglsLoadingState++;//next loading item
			}
			break;
		case ZAGLS_Dot:
			{
				[gameView.main_Game_loadAnim initLoadAnim:view];
				zaglsLoadingState++;
			}
			break;
		case ZAGLS_BGSound:
			{
				//play sound & init option sound setting	
				[gameView.song initWithPath:[[NSBundle mainBundle] pathForResource:@"GAM_ZOO_M_BG" ofType:@"m4a"]];
				[gameView.song setRepeat:YES];
				if(gameView.musicOFF==NO)
				{
					[gameView.song play];
				}
				else
				{
					[gameView.song pause];
				}
				
				if(gameView.soundOFF == YES)
					[gameView.soundEffect allstop:YES];
				//play sound END
				
				zaglsLoadingState++;				
			}
			break;
			
		case ZAGLS_AnimManager:
			{
				// create AnimManager
				gameAnimManager = [[AnimObjManager alloc] initArray];
				gameFoodAnimManager = [[AnimObjManager alloc] initArray];
				gameEnemyAnimManager = [[AnimObjManager alloc] initArray];
				zaglsLoadingState++;
			}
			break;
			
		case ZAGLS_ZooAnimals:
		    {		
#if 0	
				/*Initialize five Zoo animals */
				ZooAnimalKind zakindArr[MAXZAKIND] = {ZAKindGiraffe,ZAKindLion,ZAKindRabbit,ZAKindHorse};
				CGPoint zaPos[MAXZAKIND] = {ZA_POS1, ZA_POS2, ZA_POS3, ZA_POS4};

				ZooAnimal* zaObj = nil;
				zooAnimalArray = [[NSMutableArray alloc] init];
				
				for(int i = 0; i < MAXZAKIND; i++)
				{
					if(i==0)	
						zaObj = [[ZooAnimal alloc] initWithZooAnimalKind:zakindArr[i] FeedCounts:lv[gameLevel].foodGoalG Point:zaPos[i] view:view];
					if(i==1)	
						zaObj = [[ZooAnimal alloc] initWithZooAnimalKind:zakindArr[i] FeedCounts:lv[gameLevel].foodGoalL Point:zaPos[i] view:view];
					if(i==2)	
						zaObj = [[ZooAnimal alloc] initWithZooAnimalKind:zakindArr[i] FeedCounts:lv[gameLevel].foodGoalR Point:zaPos[i] view:view];
					if(i==3)	
						zaObj = [[ZooAnimal alloc] initWithZooAnimalKind:zakindArr[i] FeedCounts:lv[gameLevel].foodGoalH Point:zaPos[i] view:view];

					
					[gameAnimManager requestWithObj:zaObj];
					[zooAnimalArray addObject:zaObj];
				}
#endif
				//init Monkey obj
				//NSInteger ccc = gameLevel;
				zooAnimalArray = [[NSMutableArray alloc] init];
				zaMkObj = [[ZooAnimalFeeder alloc] initWithZooAnimalKind:0 FeedCounts:lv[gameLevel].foodGoalM FeedCounts2:lv[gameLevel].foodGoalG FeedCounts3:lv[gameLevel].foodGoalL FeedCounts4:lv[gameLevel].foodGoalR Point:CGPointMake(38.0, 130.0) view:view];
				[gameAnimManager requestWithObj:zaMkObj];
				
				[zooAnimalArray addObject:zaMkObj];

				
				/* no need squarre
				if(sObj!=nil)
				{	
					sObj = nil;					
				}
				sObj = [[sqObj alloc] initWithSRandeWeight:8 weight:10 view:view];
				[gameEnemyAnimManager requestWithObj:sObj];
				 */
                zaglsLoadingState++;								
		    }
			break;
			
        case ZAGLS_ZooManager:
			{
				zaglsLoadingState++;
			}
			break;
			
		case ZAGLS_Arrow:
			{
				zaglsLoadingState++;
				break;
			}
		case ZAGLS_FailCount:
			{
				pfailCntObj = [[failCntObj alloc] initWithfailCnt:DEFAULT_FAILED_CNT]; 
				[gameAnimManager requestWithObj:pfailCntObj];
				zaglsLoadingState++;
			}
			break;
			
		case ZAGLS_TimeLimit:
			{
				//NSInteger ccc = gameLevel;
				timelimit = [[DisplayClock alloc] initWithSecs:lv[gameLevel].timeLimt GameLevel:gameLevel];
				if(gameAnimManager!=nil)
				{
					[gameAnimManager requestWithObj:timelimit];
				}
				zaglsLoadingState++;
			}
			break;
		case ZAGLS_PauseButton:
			{
				SimpleButton *pauseBtn = [[SimpleButton alloc]initWithType:SBTypePause Position:CGPointMake(303.0, 463.0)];
					if (gameAnimManager != nil) {
						[gameAnimManager requestWithObj:pauseBtn];
					}
				zaglsLoadingState++;
			}
			break;

		case ZAGLS_VarDeclare:
			{
				zaglsLoadingState++;
			}
			break;
		case ZAGLS_LoadingDone:
		    {				
				[gameView readFromFileSystem];
				
				gameLevel = gameView.gameLevel ;//= 20 ; // maxpan test
									
				grandTotalScore = gameView.grandTotalScore;
				//read nv gameLevel
				//gameScores
				
				gameMaxLevel = TOPGAMELEVEL;
				gameFrameCount = 0;           // init game itself frame count

				gameLevel++;
				//if(gameView.showDemo == _HAD_DEMO_GAME_FLAG_)
				//{	
					gameStageState = GSStateProgress; //GSStateProgress;
				//}
				
				idx = 0;
				fFactoryIdx = 0;
				posTyp =0;
				gamePreFrameCnt = 0;
				gameFrameCntDelta = 0;
				
				//pohsu{ init each score
				rightFoodScore = 0;
				wrongFoodScore = 0;
				timeBonus = 0;
				subTotalScore = 0;
				extraBonus = 0;
				//pohsu}
				gameView.btnBit = 0;	
				if(gameESAnimManager!=nil)
					[gameESAnimManager release];
				gameESAnimManager = nil;
				
				if(gameView.showDemo == _HAD_DEMO_GAME_FLAG_)
				{	
					gameStageState = GSStateProgress; //GSStateProgress;
				}
				
				endScreen = nil;
				
				/****release loading animation resource****/
				if(loadingBackground != nil)
				{
					[loadingBackground release];
					loadingBackground = nil;
				}
				[gameView.main_Game_loadAnim endLoadAnim:view];
				/****release loading animation resource****/
				
				//reset level value here
#if 0
				for(int i = 0; i < MAXZAKIND; i++)
				{
					ZooAnimal* zaObj = [zooAnimalArray objectAtIndex:i];
						
					if(i==0)
						[zaObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalG];
					if(i==1)
						[zaObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalL];
					if(i==2)
						[zaObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalR];
					if(i==3)
						[zaObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalH];						
				}
#endif
					
				ZooAnimalFeeder  *zafObj = [zooAnimalArray objectAtIndex:0];
				//[zafObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalM]; 
				[zafObj resetWithTotFeedingCounts:lv[gameLevel].foodGoalM feedcounts2:lv[gameLevel].foodGoalG feedcounts3:lv[gameLevel].foodGoalL feedcounts4:lv[gameLevel].foodGoalR];

#if 0
				if(gameView.showDemo != _HAD_DEMO_GAME_FLAG_)
				{
					gameStageState = GSStateGameDemo;
					[zafObj setDemoMode];
					DemoState = _DEMO_STATE_1;					
				}
#endif			
				//[sObj resetSQAppearWeight:lv[gameLevel].sqSec weight:lv[gameLevel].sqWeight speed:lv[gameLevel].sqSpeed];
				[timelimit resetWithSecs:lv[gameLevel].timeLimt GameLevel:gameLevel];
	
				[pfailCntObj setFailCntLevel:DEFAULT_FAILED_CNT];

				//reset level value here

				/****load game map****/
				[gameView.main_Game_Map endMainGameMap:view];
			    [gameView.main_Game_Map initMap:view];
					
				/****load game map****/
				
				if(gameView.isFirstEnterGame != _HAD_USE_GAME_FLAG_)
					[gameView writeNVitem:@"NV_isFirstEnterGame"];

				if(gameView.endlessMode == _ENABLE_ENDLESS_MODE_)
				{
#if 0
					for(int i = 0; i < MAXZAKIND; i++)
					{
						ZooAnimal* zaObj = [zooAnimalArray objectAtIndex:i];
						
						if(i==0)
							[zaObj resetWithTotFeedingCounts:99];
						if(i==1)
							[zaObj resetWithTotFeedingCounts:99];
						if(i==2)
							[zaObj resetWithTotFeedingCounts:99];
						if(i==3)
							[zaObj resetWithTotFeedingCounts:99];						
					}
#endif				
					ZooAnimalFeeder  *zafObj = [zooAnimalArray objectAtIndex:0];
					//[zafObj resetWithTotFeedingCounts:99];
					[zafObj resetWithTotFeedingCounts:99 feedcounts2:99 feedcounts3:99 feedcounts4:99];
										
					[sObj resetSQAppearWeight:5 weight:50 speed:6];
					[timelimit resetWithSecs:900 GameLevel:_INIFINITY_TIME_LEVEL];
					grandTotalScore = 0;
				}
				gameView.tmpDelta = 0;
				gameView.tmpDelta2 = 0;
				gameView.gameState = GS_PROCESS_GAME;
				
				if(gameView.showDemo != _HAD_DEMO_GAME_FLAG_)
				{
					gameStageState = GSStateGameDemo;
					[gameView.main_help initHelpWithDemo:view];
				}	
			}
			break;
			
		default:
			break;
	}
	return TRUE;
}


-(BOOL)processGame:(id)view {
	
	EAGLView *gameView = view;

	switch (gameStageState) {
		case GSStateGameOver:			
			if(gameESAnimManager==nil)
			{
				gameESAnimManager = [[AnimObjManager alloc] initArray];
				if(endScreen==nil)
				{
					endScreen = [[EndScreen alloc]initWithStageState:gameStageState view:gameView];
					[gameESAnimManager requestWithObj:endScreen];
					
					//pohsu{
					//rightFoodScore += [ZooAnimal ZACountingScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
					rightFoodScore += [ZooAnimalFeeder ZACountingScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray]; 
					//wrongFoodScore += [ZooAnimal ZACountingFailedScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
					//timeBonus += extraBonus*CORRECTSCORE4*2; 
					//subTotalScore = rightFoodScore - wrongFoodScore;
					subTotalScore = rightFoodScore;
					if(subTotalScore < 0 )
						subTotalScore = 0;
					if(grandTotalScore < 0 )
						grandTotalScore = 0;					
					if(gameView.endlessMode == _ENABLE_ENDLESS_MODE_)
						grandTotalScore = subTotalScore;
					else	
						grandTotalScore += subTotalScore;
					//pohsu}
				}
			}
			break;
		case GSStateGameSucceed:
			if(gameESAnimManager==nil)
			{
				gameESAnimManager = [[AnimObjManager alloc] initArray];
				if(endScreen==nil)
				{
					endScreen = [[EndScreen alloc]initWithStageState:gameStageState view:gameView];
					[gameESAnimManager requestWithObj:endScreen];
										
					//pohsu{
					//rightFoodScore += [ZooAnimal ZACountingScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
					//wrongFoodScore += [ZooAnimal ZACountingFailedScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
					rightFoodScore += [ZooAnimalFeeder ZACountingScores:(NSMutableArray*)gameView.main_Game.zooAnimalArray]; 
					timeBonus += [timelimit DCCountingScores];
					timeBonus += extraBonus*CORRECTSCORE4*2; 
					//subTotalScore = rightFoodScore - wrongFoodScore + timeBonus;
					subTotalScore = rightFoodScore + timeBonus;
					if(subTotalScore < 0 )
						subTotalScore = 0;
					if(grandTotalScore < 0 )
						grandTotalScore = 0;
					grandTotalScore += subTotalScore;
					
					//pohsu}
					
					//write nv gameLevel
					if(gameLevel < gameMaxLevel)
					{
						gameView.gameLevel = gameLevel;
					}
					else
						gameView.enableEndless = _ENABLE_ENDLESS_MODE_;
					
					gameView.grandTotalScore = grandTotalScore;
					[gameView saveToFileSystem];
					//write nv gameLevel
				}
			}
			break;
		case GSStateGameDemo:
		{
			if(DemoState == _DEMO_STATE_2)
			{
				if(gameFrameCntDelta == 0)
				{
					gameFrameCntDelta ++;
					[gameFoodAnimManager requestWithObj:[[foodObj alloc] initWithFoodTypePos:EN_FOODTYPE3 fSpeed:lv[gameLevel].pixPerCnt posType:lv[gameLevel].foodGroupData[idx].foodLine]];
				}	
			}	
			break;
		}	
		default:
		{
			if((gameFrameCount-gamePreFrameCnt)==gameFrameCntDelta)
			{
				if (gameFoodAnimManager != nil) 
				{
					if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
					{
						int lineRandam = arc4random()%3;
						[gameFoodAnimManager requestWithObj:[[foodObj alloc] initWithFoodTypePos:lv[15].foodGroupData[idx].foodType fSpeed:lv[15].pixPerCnt posType:lineRandam]];
					}	
					else
						[gameFoodAnimManager requestWithObj:[[foodObj alloc] initWithFoodTypePos:lv[gameLevel].foodGroupData[idx].foodType fSpeed:lv[gameLevel].pixPerCnt posType:lv[gameLevel].foodGroupData[idx].foodLine]];
					gamePreFrameCnt = gameFrameCount;
					fFactoryIdx ++;
					if(lv[gameLevel].foodPerOnce > 1)
					{						
						if((fFactoryIdx %lv[gameLevel].foodPerOnce) == 0)
							gameFrameCntDelta = lv[gameLevel].secPerFood * _SYSTEM_FRAME_COUNT_PER_SEC_;
						else
							gameFrameCntDelta = 1.5 * _SYSTEM_FRAME_COUNT_PER_SEC_;
					}	
					else
						gameFrameCntDelta = lv[gameLevel].secPerFood * _SYSTEM_FRAME_COUNT_PER_SEC_;

					if((fFactoryIdx%lv[gameLevel].foodGroupData[idx].foodCnt)==0)
					{
						idx++;
					}

					if(0==lv[gameLevel].foodGroupData[idx].foodCnt)
					{	
						idx =0;
					}
				}	
			}
		}

		break;
	}
	
	gameFrameCount ++;

	return TRUE;
}

-(BOOL)endGame:(id)view {	
	EAGLView *gameView = view;

	if (gameBackground != nil)
	{
		[gameBackground release];
		gameBackground = nil;
	}
	
	if(gameFoodAnimManager != nil)
		[gameFoodAnimManager release];	
	gameFoodAnimManager = nil;

	if(gameEnemyAnimManager != nil)
		[gameEnemyAnimManager release];	
	gameEnemyAnimManager = nil;
	
	if (gameAnimManager != nil)
		[gameAnimManager release];
	gameAnimManager = nil;
//	sObj = nil;
	if(gameESAnimManager!=nil)
		[gameESAnimManager release];
	gameESAnimManager = nil;
	endScreen = nil;
	
	if(zooAnimalArray!=nil)
		[zooAnimalArray release];
	zooAnimalArray = nil;

	//close song
	[gameView.song close];
    
	if(strPreviewFood!=nil)
		[strPreviewFood release];
	strPreviewFood = nil;
		
//	zaMkObj = nil;
	//release mainGameMap
	[gameView.main_Game_Map endMainGameMap:view];
	//release main_Game_loadAnim
	[gameView.main_Game_loadAnim endLoadAnim:view];
	zaglsLoadingState = ZAGLS_LoadingStart;
	
	switch (gameStageState) {
		case GSStateGameOver:
			gameView.gameState = GS_INIT_SCORE;
			break;
		default:
			break;
	}
	return TRUE;
}

- (void)dealloc {
	[super dealloc];
}

@end
