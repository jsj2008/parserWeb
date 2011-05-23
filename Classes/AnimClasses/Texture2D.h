//
//  Texture2D.h
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>


@interface Texture2D : NSObject {
	GLuint		_name;
	GLuint		_width;
	GLuint		_height;
	GLfloat		_maxS;
	GLfloat		_maxT;
	GLuint		_tileWidth;
	GLuint		_tileHeight;
}

@property(readonly) GLuint name;
@property(readonly) GLuint width;
@property(readonly) GLuint height;
@property(readonly) GLfloat maxS;
@property(readonly) GLfloat maxT;
@property(readonly) GLuint tileWidth;
@property(readonly) GLuint tileHeight;

- (void) dealloc;

- (id) fromFile:(NSString *)strFilename;
- (id) fromPVSFile:(NSString *)strFilename extName:(NSString *)strExtName pvsWH:(GLuint)widthHeight;

- (void)SetTileSize:(GLuint)tileWidth tileHeight:(GLuint)tileHeight;

- (void) drawImage:(CGPoint)pos;
- (void) drawImageWithAlpha:(CGPoint)pos alpha:(GLfloat)alpha;
- (void) drawImageWithNo:(CGPoint)pos no:(GLuint)no angleX:(GLfloat)angleX angleY:(GLfloat)angleY angleZ:(GLfloat)angleZ scaleX:(GLfloat)scaleX scaleY:(GLfloat)scaleY scaleZ:(GLfloat)scaleZ alpha:(GLfloat)alpha;
- (void) drawImageWithNo2:(CGPoint)pos no:(GLuint)no no2:(GLuint)no2 angleX:(GLfloat)angleX angleY:(GLfloat)angleY angleZ:(GLfloat)angleZ scaleX:(GLfloat)scaleX scaleY:(GLfloat)scaleY scaleZ:(GLfloat)scaleZ alpha:(GLfloat)alpha;

@end
