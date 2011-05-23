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


@implementation foodObj

@synthesize eFoodType = eFoodType;


-(void) setAccessSpeed:(id)view
{
	EAGLView *gameView = view;
	gameView.tmpDelta = 60;
	_speed =  CGPointMake(0, -1*20);
}
-(void) setRoadblockSpeed:(id)view
{
	EAGLView *gameView = view;
	gameView.tmpDelta2 = 60;
	_speed =  CGPointMake(0, 0);
}

//	"ZM_G_Food_Banana.png"		//Monkey
//	"ZM_G_Food_Leaf.png"		//girrafe
//	"ZM_G_Food_Meat.png"		//lion
//	"ZM_G_Food_Carrot.png"		//rabbit
//	"ZM_G_Food_Roadblock.png"	//Roadblock
//	"ZM_G_Food_Holes.png"		//Holes
//	"GAM_Zooff_Failcount.png"	//Battery
//	"ZM_G_Food_KY.png"			//KY
- (id) initWithFoodType:(ENFOODTYPE)fType fSpeed:(int)a
{	
	if (self = [super init]) {

		if(fType == EN_FOODTYPE1)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE1 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE2)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE2 tileWidth:128 tileHeight:128];
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
		else if(fType == EN_FOODTYPE6) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE6 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}
		else if(fType == EN_FOODTYPE7) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE7 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}
		else if(fType == EN_FOODTYPE8) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE8 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}
		else
			return nil;

		fSpeed = a;

		
		self.type = 0;

		self.dir = 1;
		self.speed =  CGPointMake(0, -1*fSpeed);
		//currentspeed  = self.speed;
		self.eFoodType = fType;
		cursTarget = 0;
	}
	return (self);	
}

- (id) initWithFoodTypePos:(ENFOODTYPE)fType fSpeed:(int)a posType:(int) b
{	
	if (self = [super init]) {
		
		if(fType == EN_FOODTYPE1)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE1 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else if(fType == EN_FOODTYPE2)
		{	
			[self loadImageFromFile:EN_FILE_FOODTYPE2 tileWidth:128 tileHeight:128];
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
		else if(fType == EN_FOODTYPE6) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE6 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}
		else if(fType == EN_FOODTYPE7) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE7 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}
		else if(fType == EN_FOODTYPE8) 
		{
			[self loadImageFromFile:EN_FILE_FOODTYPE8 tileWidth:_FOOD_SIZE_WITH tileHeight:_FOOD_SIZE_HEIGHT];
		}	
		else
			return nil;
		
		fSpeed = a;
		
		self.dir = 1;

		lineType =b;

		if(b == 0)
		{
			self.type = 0;
			self.pos = _FOOD_START_POSITION_LINE1;

		}
		else if(b == 1)
		{
			self.type = 1;
			self.pos = _FOOD_START_POSITION_LINE2;
		}
		else if(b == 2)
		{
			self.type = 2;
			self.pos = _FOOD_START_POSITION_LINE3;
		}
		else
			printf("===========error==>\n");
		
		self.speed =  CGPointMake(0, -1*fSpeed);
		self.eFoodType = fType;
		cursTarget = 0;
	}
	return (self);	
}

- (NSInteger)foodDemoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	mainGame * maingame = gameView.main_Game;

	{
		if(maingame.DemoState == _DEMO_STATE_1)	
		{
			return -1;
		}
		else 
		{
			if(_collision == TRUE)
			{
				[maingame.zaMkObj feedWithFood:eFoodType view:gameView];
				maingame.DemoState = _DEMO_STATE_3;
				return -1;
			}		
		}		
	}	
	
	[self update];


	if(lineType==0)
	{	
		//_pos.x = (13.0*_pos.y-275.0)/59.0;
		_pos.x = (66*_pos.y+24678)/457;
	}	
	else if(lineType==1)
	{
		//_pos.x = (4.0*(_pos.y+1590.0))/59.0;
	}
	else if(lineType==2)
	{
		//_pos.x = (4.0*(3130.0-_pos.y))/59.0;
		_pos.x = (122019-67*_pos.y)/457;
		
	}
	else
		_speed.y = -1.0*fSpeed;
	
	return 0;	
}

- (NSInteger)foodRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	mainGame * maingame = gameView.main_Game;
	//NSInteger objectIdx;
	NSInteger bPassGame = 0 ;
	
	/*run*/	
	if((--gameView.tmpDelta2) >= 0)		
	{
		self.speed = CGPointMake(0, -1*0);
	}
	else if((--gameView.tmpDelta) >= 0)		
	{
		self.speed = CGPointMake(0, -1*20);
	}
	else 
	{
		self.speed = CGPointMake(0, -1*fSpeed);
	}
	
	/*run*/	
	if(maingame.gameStageState == GSStateGameOver || maingame.gameStageState == GSStateGameSucceed)
	{		
		return -1;
	}
	
	if(maingame.gameStageState == GSStateGameDemo)
	{
		//return [self foodDemoRun:man bTouch:bTouch touchMode:touchMode x:x y:y view:view];
	}	
	
	
	if(_collision == TRUE)
	{		
			if (ZAStuffKY == eFoodType)
			{
				[self setAccessSpeed:view];
			}
			if (ZAStuffBattery == eFoodType)
			{
				[[gameView.main_Game pfailCntObj]  AddFailCnt];
			}
			if (ZAStuffRoadBlock == eFoodType || ZAStuffHoles == eFoodType)
			{
				[self setRoadblockSpeed:view];
			}
			if([maingame.zaMkObj feedWithFood:eFoodType view:gameView])
			{
#if	1
				bPassGame = [ZooAnimal ZooAnimalsAllStuffed:(NSMutableArray*)gameView.main_Game.zooAnimalArray];
				
				if(bPassGame)
				{
					gameView.main_Game.gameStageState = GSStateGameSucceed;
				}
#endif				
				
				NSLog(@"ggggggggggg");				
			}
			else
			{	
				if([[gameView.main_Game pfailCntObj]  CountFailCnt])
					gameView.main_Game.gameStageState = GSStateGameOver;	
			}	
			return -1;			
	}
	
	if(_pos.y < 50)
	{
		/*
		if(lineType==0)
			objectIdx = ZAKindHorse;
		else if(lineType==1)
			objectIdx = ZAKindRabbit;
		else if(lineType==2)
			objectIdx = ZAKindLion;
		else if(lineType==3)
			objectIdx = ZAKindGiraffe;			
		
		if([[gameView.main_Game.zooAnimalArray objectAtIndex:objectIdx] feedWithFood:eFoodType])
		{
	//		NSInteger bPassGame = 0 ;
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
		*/
		return -1;
	}
	
	
	[self update];

	if(lineType==0)
	{	
		//_pos.x = (13.0*_pos.y-275.0)/59.0;
		_pos.x = (66*_pos.y+24678)/457;
		_scaleX = _scaleY = _scaleZ = 1 - ((0.7*_pos.y)/453);
	}	
	else if(lineType==1)
	{
		//_pos.x = (4.0*(_pos.y+1590.0))/59.0;
		_scaleX = _scaleY = _scaleZ = 1 - ((0.7*_pos.y)/453);
	}
	else if(lineType==2)
	{
		//_pos.x = (4.0*(3130.0-_pos.y))/59.0;
		_pos.x = (122019-67*_pos.y)/457;
		_scaleX = _scaleY = _scaleZ = 1 - ((0.7*_pos.y)/453);
	}
	else
		_speed.y = -1.0*fSpeed;
	
	return 0;	
}

- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	return [self foodRun:man bTouch:bTouch touchMode:touchMode x:x y:y view:view];
}

@end
