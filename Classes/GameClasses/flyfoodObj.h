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
#import "foodObj.h"
#import "Texture2D.h"


@interface flyfoodObj : AnimObj {
	int origX;
	int origY;
	int goalX;
	int goalY;	
	float orxSx;
	float orxSy;
	float dX;
	float dY;
//	int goalType;
}

//- (id) initWithFoodTypeStartPosStopPos:(ENFOODTYPE)fType bigx:(int)bigx bigy:(int) bigy endx:(int)endx endy:(int)endy; 
- (id) initWithFoodTypeStartPosStopPos:(ENFOODTYPE)fType goalType:(int)goalType bigx:(int)bigx bigy:(int) bigy endx:(int)endx endy:(int)endy;

@end
