//
//  map.h
//  game
//
//  Created by fih on 2009/10/5.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"

@interface mainGameMap : NSObject {
	Texture2D *trans1;
	Texture2D *trans2;
	Texture2D *btnClk[4];
	int btnCnt[4];
	CGPoint btnPos[4];
}

-(BOOL)initMap:(id)view;
-(BOOL)drawMap:(id)view fadeLevel:(GLfloat)fadeLevel;
-(BOOL)endMainGameMap:(id)view;
@end
