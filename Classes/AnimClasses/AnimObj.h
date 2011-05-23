//
//  AnimObj.h
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import "Texture2D.h"


@interface AnimObj : NSObject {

@protected	
	Texture2D *	_image;
	NSInteger	_no;
	NSInteger	_no2;
	
	CGPoint		_pos;
	CGPoint		_speed;
	CGPoint		_accel;
	NSInteger	_count;
	NSInteger	_wait;
	NSInteger	_dir;
	NSInteger	_state;
	NSInteger	_type;
	GLfloat		_alpha;
	GLfloat		_angleX;
	GLfloat		_angleY;
	GLfloat		_angleZ;
	GLfloat		_scaleX;
	GLfloat		_scaleY;
	GLfloat		_scaleZ;
	//Á¢∞Ê??ÉÊï∏
	BOOL		_collision;
	//?ØÂê¶?ïÁ?Á¢∞Ê?
	BOOL		_disableCollision;
	BOOL        _freeTexture;     /*JarshChen*/
}

@property(readwrite) NSInteger no;
@property(readwrite) NSInteger no2;
@property(readwrite) CGPoint pos;
@property(readwrite) CGPoint speed;
@property(readwrite) CGPoint accel;
@property(readwrite) NSInteger wait;
@property(readwrite) NSInteger count;
@property(readwrite) NSInteger dir;
@property(readwrite) NSInteger state;
@property(readwrite) NSInteger type;
@property(readwrite) GLfloat alpha;
@property(readwrite) GLfloat angleX;
@property(readwrite) GLfloat angleY;
@property(readwrite) GLfloat angleZ;
@property(readwrite) GLfloat scaleX;
@property(readwrite) GLfloat scaleY;
@property(readwrite) GLfloat scaleZ;
@property(readwrite) BOOL collision;
@property(readwrite) BOOL disableCollision;
@property(readwrite) BOOL freeTexture;/*JarshChen*/



- (id) initWithStart;
- (void) dealloc;

- (Texture2D *) loadImageFromFile:(NSString *)strFile tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight;
- (Texture2D *) loadImageFromFileEx:(Texture2D *)image_info tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight; //pohsu
- (void) drawImage;
- (void) drawImageWithFade:(GLfloat)fadelevel;
- (void) update;
- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (CGRect) getCollisionRect;

@end
