//
//  foodObj.m
//  game
//
//  Created by smallwin on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "failCntObj.h"
#import "foodObj.h"
#import "dataDefine.h"
#import "EAGLView.h"
#import "AnimObjManager.h"
#import "ZooAnimal.h"
#import "ZooAnimalFeeder.h"
#import "flyfoodObj.h"
#import "mainGame.h"

@implementation flyfoodObj

- (CGRect) getCollisionRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = 0;
		aRect.origin.y = 0;
		aRect.size.width = 10;
		aRect.size.height = 10;
	}	
	return aRect;
}



- (id) initWithFoodTypeStartPosStopPos:(ENFOODTYPE)fType goalType:(int)goalType bigx:(int)bigx bigy:(int) bigy endx:(int)endx endy:(int)endy 
{	
	if (self = [super init]) {
		
		if(fType == EN_FOODTYPE1)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE1 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE2)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE2 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE3) 
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE3 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE4)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE4 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE5) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE5 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else
			return nil;
		
		_type = fType;
		_pos.x = bigx;
		_pos.y = bigy;
		origX  = bigx;
		origY  = bigy;
		goalX  = endx;
		goalY  = endy;
		dX = (goalX - origX) / 50;
		dY = (goalY - origY) / 50;
		_state = goalType;
		self.dir = 1;
	}
	return (self);	
}

- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *main_Game = gameView.main_Game;
	
	if(main_Game.gameStageState == GSStateGameOver || main_Game.gameStageState == GSStateGameSucceed 
		/*|| main_Game.gameStageState == GSStateGameDemo*/)
	{
		return -1;
	}	
	
	[self update];
	_pos.x = _pos.x +dX;
	_pos.y = _pos.y +dY;
	
	if(_pos.y < goalY)
	{
#if 1
		NSInteger objectIdx;
		NSInteger bPassGame = 0;
		
		objectIdx = _state;
		
		
		if(main_Game.gameStageState == GSStateGameDemo)
		{
			if(main_Game.DemoState == _DEMO_STATE_4)
			{	
				main_Game.DemoState = _DEMO_STATE_5;
			}	
		}
	
		
		if([[gameView.main_Game.zooAnimalArray objectAtIndex:objectIdx] feedWithFood:_type])
		{
		
			bPassGame = [ZooAnimal ZooAnimalsAllStuffed:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
			
			if(bPassGame)
			{
				gameView.main_Game.gameStageState = GSStateGameSucceed;
			}
		}
		else						
		{
			if([[gameView.main_Game pfailCntObj]  CountFailCnt])
				gameView.main_Game.gameStageState = GSStateGameOver;			
		}		
#endif		
		return -1;
	}	
	return 0;
}

@end
