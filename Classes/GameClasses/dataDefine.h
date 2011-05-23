/*
 *  dataDefine.h
 *  Animation
 *
 *  Created by smallwin on 2009/9/11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef _DATA_DEFINE_H_

#define _SYSTEM_FRAME_COUNT_PER_SEC_ 30
//#define _FOOD_START_POSITION_LINE1 CGPointMake(100.0, 475.0);
//#define _FOOD_START_POSITION_LINE2 CGPointMake(140.0, 475.0);
//#define _FOOD_START_POSITION_LINE3 CGPointMake(180.0, 475.0);
//#define _FOOD_START_POSITION_LINE4 CGPointMake(220.0, 475.0);
#define _FOOD_START_POSITION_LINE1 CGPointMake(120.0, 490.0);
#define _FOOD_START_POSITION_LINE2 CGPointMake(160.0, 490.0);
#define _FOOD_START_POSITION_LINE3 CGPointMake(200.0, 490.0);

#define _INIFINITY_TIME_LEVEL 21
#define _ENABLE_ENDLESS_MODE_ 21



#define _SPEED_FOOD_ 10.0

typedef enum {
    ZAEmotionNormal = 0,
	ZAEmotionJoyful,
    ZAEmotionAngry,
	ZAEmotionDepressed,
	ZAEmotionIsHitted
} ZooAnimalEmotion;

typedef enum {
	ZAStuffBanana = 0,
	ZAStuffLeaf,
	ZAStuffMeat,
	ZAStuffCarrot,
	ZAStuffRoadBlock,
	ZAStuffHoles,
	ZAStuffBattery,
	ZAStuffKY,
	ZAStuffMax
} ZooAnimalFoodstuff;

typedef enum {
	Car_turn_right,
	Car_turn_left,
	Car_turn_stand,
	Car_crash
}Car_Direction;

typedef enum {
//	ZAKindMonkey = 0,
	ZAKindGiraffe =0,
	ZAKindLion,
	ZAKindRabbit,
	ZAKindHorse
} ZooAnimalKind;

typedef enum
{
	EN_MONKEY_NORMAL,			//0
	EN_MONKEY_MOVE,				//1
	EN_MONKEY_GETFOOD,			//2
	EN_MONKEY_GETFOODINHAND,	//3
	EN_MONKEY_GETBANALA,		//4
	EN_MONKEY_GETKIRIN,
	EN_MONKEY_GETLION,
	EN_MONKEY_GETRABBIT,
	//EN_MONKEY_THROUGHFOOD,		//
	//EN_MONKEY_READYTOJUMP,		//
	//EN_MONKEY_JUMPPING,			//
	EN_MONKEY_FALLING,			//5
	EN_MONKEY_FAINTING,			//6
	//EN_MONKEY_HITTSUIRREL,		//
	EN_MONKEY_DEMO,				//7
	EN_MONKEY_DEMO_FINISH,		//8
	EN_MONKEY_Battery,			//9
	EN_MONKEY_RoadBlock,		//10
	EN_MONKEY_Holes,			//11
	EN_MONKEY_KY,				//12
	EN_MONKEY_MAX				//13
}MonkeyActionState;	

//For Twitter 
typedef enum _TWITTER_SUBMIT_STATUS
{
	TWITTER_SUBMIT_NONE,
	TWITTER_SUBMIT_NAMEPW,
	TWITTER_SUBMIT_INFO
}TWITTER_SUBMIT_STATUS;	
//For Twitter

//Luckydraw {
typedef enum _LUCKYDRAW_SUBMIT_STATUS 
	{
		LUCKYDRAW_SUBMIT_NONE,
		LUCKYDRAW_SUBMIT_ENTERACCOUNT,
		LUCKYDRAW_SUBMIT_EMPYTACCOUNT,
		LUCKYDRAW_SHOW_INFO,	
		LUCKYDRAW_SUBMIT_TOSERVER,
		LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED,
		LUCKYDRAW_SUBMIT_GAME_TO_SERVER,
		LUCKYDRAW_INPUT_MORE_FRIEND,
		LUCKYDRAW_AFTER_SUBMITINFO,
		LUCKYDRAW_FINISH,
		NOTWORK_CHECK_FAIL,
		NETWORK_CHECK_SUCCESS,
	}LUCKYDRAW_SUBMIT_STATUS;
//Luckydraw }


#define SUSTAINEDFRAMES		(8)
#define FOODNUMBERSOFFSET	(7)
#define SCORESCALE			(1.2f)
#define CORRECTSCORE1		(20)
#define CORRECTSCORE2		(40)
#define CORRECTSCORE3		(60)
#define CORRECTSCORE4		(100)
#define WRONGSCORE			(50) //pohsu
#define DELAYSCORE			(-30)
//Taco
#define CORRECTSCORERABBIT	(20)
#define CORRECTSCOREGIRAFFE	(40)
#define CORRECTSCOREHORSE	(60)
#define CORRECTSCORELION	(100)

//Max Pan Add animal position {
#define ZA_POS1 CGPointMake(280.0,45.0)
#define ZA_POS2 CGPointMake(200.0,45.0)
#define ZA_POS3 CGPointMake(120.0,45.0)
#define ZA_POS4 CGPointMake(40.0,45.0)
//Max Pan add animal position }
#define _ARROW_SCALE_SIZE 2.0
#define _ARROW_SCALE_DEFAULT_SIZE 0.5
#define DEFAULT_FAILED_CNT 3

#define MAP_L2  (2)
#define MAP_L3  (3)
#define _HAD_USE_GAME_FLAG_ 13
#define _HAD_DEMO_GAME_FLAG_ 19
//extern MAPDATA mapStObj[];

typedef struct _menuButtomInfo {
	int x;
	int y;
}menuButtomInfo;

#endif

