//
//  foodObj.h
//  game
//
//  Created by smallwin on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZooAnimal.h"
#import "AnimObj.h"
#import "Texture2D.h"

typedef enum _ENFOODTYPE{
//	EN_FOOD_NULL,
	EN_FOODTYPE1,
	EN_FOODTYPE2,
	EN_FOODTYPE3,
	EN_FOODTYPE4,
	EN_FOODTYPE5,
	EN_FOODTYPE6,
	EN_FOODTYPE7,
	EN_FOODTYPE8,
	EN_BUTTONPRESS,
	EN_LevelFail,
	EN_LevelSuccess,
	EN_FOODTYPE_MAX
}ENFOODTYPE;	

//#define _FOOD_SIZE_WITH 39
//#define _FOOD_SIZE_HEIGHT 34
#define _FOOD_SIZE_WITH 64
#define _FOOD_SIZE_HEIGHT 64
#if 1

#define EN_FILE_FOODTYPE1 @"ZM_G_Food_Banana.png"		//Monkey
#define EN_FILE_FOODTYPE2 @"ZM_G_Food_Leaf.png"			//girrafe
#define EN_FILE_FOODTYPE3 @"ZM_G_Food_Meat.png"			//lion
#define EN_FILE_FOODTYPE4 @"ZM_G_Food_Carrot.png"		//rabbit
#define EN_FILE_FOODTYPE5 @"ZM_G_Food_Roadblock.png"	//Roadblock
#define EN_FILE_FOODTYPE6 @"ZM_G_Food_Holes.png"		//Holes
#define EN_FILE_FOODTYPE7 @"GAM_Zooff_Failcount.png"	//Battery
#define EN_FILE_FOODTYPE8 @"ZM_G_Food_KY.png"			//KY

#else

#define EN_FILE_FOODTYPE1 @"GAM_Zooff_ANI_Girafee.png" 
#define EN_FILE_FOODTYPE2 @"GAM_Zooff_ANI_Lion.png"
#define EN_FILE_FOODTYPE3 @"GAM_Zooff_ANI_Rabbit.png"
#define EN_FILE_FOODTYPE4 @"GAM_Zooff_ANI_Horse.png"
#define EN_FILE_FOODTYPE5 @"ZM_G_Food_Grass.png"

#endif


@interface foodObj : AnimObj {
	ZooAnimalFoodstuff eFoodType;
	NSInteger dest;
	NSInteger cursTarget;
	Texture2D *preViewFood;
	int fSpeed;
	int lineType;
}


@property(nonatomic) ZooAnimalFoodstuff eFoodType;

- (id) initWithFoodType:(ENFOODTYPE)fType fSpeed:(int)a;
- (id) initWithFoodTypePos:(ENFOODTYPE)fType fSpeed:(int)a posType:(int) b;
- (NSInteger)foodDemoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view; 

@end
