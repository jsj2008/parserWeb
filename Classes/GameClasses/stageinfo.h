/*
 *  stageinfo.h
 *  game
 *
 *  Created by FIH on 2009/9/11.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef _STAGEINFO_H_
#define _STAGEINFO_H_

typedef enum _LEVEL_INFORM {
	ENLEVEL_INFORM_LEVEL1,
	ENLEVEL_INFORM_LEVEL2,
	ENLEVEL_INFORM_LEVEL3,
	ENLEVEL_INFORM_MAX
}LEVEL_INFORM;

typedef struct _STAGEINFO {
	int frame;
	int _speed;
	int aaa;
	int no;
} STAGEINFO;

typedef struct _FOODGROUP_ {
	int foodType;
	int foodCnt;
	int foodLine;  
}FOODGROUP;

typedef struct _LEVEL_DATA{
	int pixPerCnt;
	int sqSec;
	int sqWeight;
	int sqSpeed;
	float secPerFood;
	int foodPerOnce;
	int timeLimt;
	int foodGoalM;
	int foodGoalG;
	int foodGoalL;
	int foodGoalR;
	int foodGoalH;		
	FOODGROUP *foodGroupData;
}LEVEL_DATA;
/*
 typedef struct _STAGEINFO {
 int frame;
 int x;
 int y;
 int no;
 } STAGEINFO;
 */
#endif
