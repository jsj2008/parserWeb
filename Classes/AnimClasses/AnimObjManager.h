//
//  AnimObjManager.h
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import "AnimObj.h"

@interface AnimObjManager : NSObject {
	NSMutableArray *objArray;
}
@property (nonatomic, retain) NSMutableArray *objArray;

- (id)initArray;
- (void)dealloc;

- (AnimObj *)requestWithImageFile:(NSString *)strName tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight;
- (AnimObj *)requestWithObj:(AnimObj *)obj strName:(NSString *)strName tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight;
- (AnimObj *)requestWithObjEx:(AnimObj *)obj image_info:(Texture2D *)image_info tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight; //pohsu
/*Jarsh overloads the requestWithObj method*/
- (AnimObj *)requestWithObj:(AnimObj *)obj;
/*Jarsh overloads the requestWithObj method*/
- (void)draw;
- (void)drawWithFade:(GLfloat)fadelevel;
- (void)run:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (void)checkCollision:(AnimObjManager *)manTarget;
- (AnimObj *)getObj:(NSInteger)no;
- (NSInteger)countObj;
- (void) clearCollision;
@end
