//
//  AnimObjManager.m
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import "AnimObjManager.h"


@implementation AnimObjManager
@synthesize objArray;

- (id)initArray {
	if ((self = [super init]) != nil) {
		objArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	if (objArray) {
#if 0
		for(int idx = 0; idx < [objArray count]; idx ++)
		{
			AnimObj *releaseObj = [objArray objectAtIndex:idx];
			[releaseObj release];
		}
#else
		while([objArray count])
		{
			AnimObj *releaseObj = [objArray objectAtIndex:0];
			[objArray removeObjectAtIndex:0];
			[releaseObj release];
		}
#endif
		[objArray release];
	}
	
	[super dealloc];
}


- (AnimObj *)requestWithImageFile:(NSString *)strName tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	if (objArray == nil)
		objArray = [NSMutableArray array];
	
	if (objArray != nil) {
		AnimObj *obj = [[AnimObj alloc] initWithStart];
		
		if (obj != nil) {
			[obj loadImageFromFile:strName	tileWidth:tileWidth tileHeight:tileHeight];
			[objArray addObject:obj];
			return obj;
		}
	}
	
	return nil;
}

- (AnimObj *)requestWithObj:(AnimObj *)obj strName:(NSString *)strName tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	if (objArray == nil)
		objArray = [NSMutableArray array];
	
	if (objArray != nil) {
		if (obj != nil) {
			[obj loadImageFromFile:strName	tileWidth:tileWidth tileHeight:tileHeight];
			[objArray addObject:obj];
			return obj;
		}
	}
	
	return nil;
}
//pohsu{
- (AnimObj *)requestWithObjEx:(AnimObj *)obj image_info:(Texture2D *)image_info tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	if (objArray == nil)
		objArray = [NSMutableArray array];
	
	if (objArray != nil) {
		if (obj != nil) {
			[obj loadImageFromFileEx:image_info tileWidth:tileWidth tileHeight:tileHeight];
			[objArray addObject:obj];
			return obj;
		}
	}
	
	return nil;
}
//pohsu}
/*S:JarshChen overloads the requestWithObj method*/
- (AnimObj *)requestWithObj:(AnimObj *)obj {
	if (objArray == nil)
		objArray = [NSMutableArray array];
	
	if (objArray!= nil) {
		if (obj != nil) {
			[objArray addObject:obj];
			return obj;
		}
	}
	return nil;
}
/*E:JarshChen overloads the requestWithObj method*/

- (void)draw {
	AnimObj *obj;
	
	for (obj in objArray) {
		if (obj != nil) {
			[obj drawImage];
		}
	}
}

- (void)drawWithFade:(GLfloat)fadelevel {
	AnimObj *obj;
	
	for (obj in objArray) {
		if (obj != nil) {
			[obj drawImageWithFade:fadelevel];
		}
	}
}

- (AnimObj *)getObj:(NSInteger)no {
	if (objArray != nil && no >= 0 && no < [objArray count])
		return [objArray objectAtIndex:no];
	return nil;
}

- (NSInteger)countObj {
	if (objArray != nil) {
		return [objArray count];
	}
	return 0;
}

- (void)run:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	for (int i = 0; i < [objArray count]; i++) {
		AnimObj *obj = [objArray objectAtIndex:i];
		
		if (obj != nil) {
			if ([obj run:self bTouch:bTouch touchMode:touchMode x:x y:y view:view] == -1) {
				[objArray removeObjectAtIndex:i];
				[obj release];
				i--;
			}
		}
	}
}


- (void)clearCollision {
	if (objArray != nil) {
		for (AnimObj *obj in objArray) {
			if (obj){
				obj.collision = FALSE;
				
			}
		}
	}
}

- (void)checkCollision:(AnimObjManager *)manTarget {
	if (manTarget != nil) {
		[self clearCollision];
		[manTarget clearCollision];
		
		for (AnimObj *obj in objArray) {
			if (obj != nil) {
				if (obj.disableCollision == FALSE) {
					CGRect rectSrc = [obj getCollisionRect];
					int maxTarget = [manTarget countObj];
					
					for (int i = 0; i < maxTarget; i++) {
						AnimObj *target = [manTarget getObj:i];
						
						if (target != nil) {
							if (target.disableCollision == FALSE) {
								CGRect rectTarget = [target getCollisionRect];
								
								if ((rectSrc.origin.x - rectSrc.size.width / 2 > rectTarget.origin.x + rectTarget.size.width / 2) ||
									(rectSrc.origin.x + rectSrc.size.width / 2 < rectTarget.origin.x - rectTarget.size.width / 2) ||
									(rectSrc.origin.y - rectSrc.size.height / 2 > rectTarget.origin.y + rectTarget.size.height / 2) ||
									(rectSrc.origin.y + rectSrc.size.height / 2 < rectTarget.origin.y - rectTarget.size.height / 2)) {
								}
								else {
									obj.collision = TRUE;
									target.collision = TRUE;
								}
							}
						}
					}
				}
			}
		}
	}
}

@end
