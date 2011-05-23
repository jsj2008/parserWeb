//
//  ZooManager.h
//  Animation
//
//  Created by JarshChen on 2009/9/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
typedef enum {
    ZMDIRNorth = 0,
    ZMDIRNorthEast,
	ZMDIREast,
	ZMDIRSouthEast,
	ZMDIRSouth,
	ZMDIRSouthWest,
	ZMDIRWest,
	ZMDIRNorthWest,
	ZMJoyFulCycle = 10,
	ZMDepressedCycle=11
} ZooManagerDirection;
@interface ZooManager : AnimObj {
	CGRect _bounds;

}
@property(nonatomic,assign) CGRect bounds;
/*- (id) init;*/

@end
