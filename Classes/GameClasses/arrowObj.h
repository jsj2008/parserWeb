//
//  arrowObj.h
//  game
//
//  Created by smallwin on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"

#define _ARROW_POSITION1 1
#define _ARROW_POSITION2 2
#define _ARROW_POSITION3 3


@interface arrowObj : AnimObj {
	int arrowType;
	GLfloat _angleZB1;
	GLfloat _angleZB2;
	GLfloat _angleZB3;

	GLfloat _SCALEB1;
	GLfloat _SCALEB2;
	GLfloat _SCALEB3;

	int _sCaleTime1;
	int _sCaleTime2;
	int _sCaleTime3;
}
@property (readwrite) int arrowType;
@end
