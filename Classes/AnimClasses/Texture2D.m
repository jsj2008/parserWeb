//
//  Texture2D.m
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import "Texture2D.h"
#import <OpenGLES/ES1/glext.h>

@implementation Texture2D

@synthesize width = _width, height = _height, name = _name, maxS = _maxS, maxT = _maxT, tileWidth = _tileWidth, tileHeight = _tileHeight;

- (void) dealloc {
	if (_name)
		glDeleteTextures(1, &_name);
	
	[super dealloc];
}

- (void)SetTileSize:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	_tileWidth = tileWidth;
	_tileHeight = tileHeight;
	_maxS = (float)_tileWidth / (float)_width;
	_maxT = (float)_tileHeight / (float)_height;
}

- (id) fromFile:(NSString *)strFilename {
	if ((self = [super init]) != nil) {
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
		NSString *imgPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], strFilename];
    //NSData *texData = [[NSData alloc] initWithContentsOfFile:strFilename];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imgPath];
		
		GLint	saveName;
		
		if (image == nil)
			NSLog(@"Do real error checking here");

		glGenTextures(1, &_name);
		glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
		glBindTexture(GL_TEXTURE_2D, _name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		GLuint w = CGImageGetWidth(image.CGImage);
		GLuint h = CGImageGetHeight(image.CGImage);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		void *imageData = malloc( h * w * 4 );
		CGContextRef context = CGBitmapContextCreate( imageData, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
		CGColorSpaceRelease( colorSpace );
		CGContextClearRect( context, CGRectMake( 0, 0, w, h ) );
		CGContextTranslateCTM( context, 0, h - h );
		CGContextDrawImage( context, CGRectMake( 0, 0, w, h ), image.CGImage );
	
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
	
		glBindTexture(GL_TEXTURE_2D, saveName);
		
		CGContextRelease(context);
	
		 _width = w;
		 _height = h;
		_tileWidth = w;
		_tileHeight = h;
		_maxS = (float)_tileWidth / (float)_width;
		_maxT = (float)_tileHeight / (float)_height;
		
		 free(imageData);
		[image release];
	}
	return self;
}

- (id) fromPVSFile:(NSString *)strFilename extName:(NSString *)strExtName pvsWH:(GLuint)widthHeight {
	if ((self = [super init]) != nil) {
		NSString *str = [[NSBundle mainBundle] pathForResource:strFilename ofType:strExtName];
		NSData *texData = [NSData dataWithContentsOfFile:str];
		
		glGenTextures(1, &_name);
		glBindTexture(GL_TEXTURE_2D, _name);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG/*GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG*/, widthHeight, widthHeight, 0, [texData length], [texData bytes]);
		
		_width = widthHeight;
		_height = widthHeight;
		_tileWidth = widthHeight;
		_tileHeight = widthHeight;
		_maxS = (float)_tileWidth / (float)_width;
		_maxT = (float)_tileHeight / (float)_height;
	}
	return self;
}

- (void) drawImage:(CGPoint)pos {
	[self drawImageWithNo:pos no:0 angleX:0.0f angleY:0.0f angleZ:0.0f scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1.0f];
}

- (void) drawImageWithAlpha:(CGPoint)pos alpha:(GLfloat)alpha {
	[self drawImageWithNo:pos no:0 angleX:0.0f angleY:0.0f angleZ:0.0f scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:alpha];
}

- (void) drawImageWithNo:(CGPoint)pos no:(GLuint)no angleX:(GLfloat)angleX angleY:(GLfloat)angleY angleZ:(GLfloat)angleZ scaleX:(GLfloat)scaleX scaleY:(GLfloat)scaleY scaleZ:(GLfloat)scaleZ alpha:(GLfloat)alpha {
	if (_tileWidth > 0 && _tileHeight > 0) {
		GLuint ww = _width / _tileWidth;
		if (ww > 0) {
			GLuint x = (no % ww) * _tileWidth;
			GLuint y = (no / ww) * _tileHeight;
			GLfloat s1 = (float)x / _width;
			GLfloat s2 = s1 + _maxS;
			GLfloat t1 = (float)y / _height;
			GLfloat t2 = t1 + _maxT;
#if 0 //reflection
			GLfloat		coordinates[] = {
				s2, t2,
				s1, t2,
				s2, t1,
				s1, t1				
			};
#else			
			GLfloat		coordinates[] = {
				s1, t2,
				s2, t2,
				s1, t1,
				s2, t1
			};
#endif			
			GLfloat		w = (GLfloat)_width * _maxS,
			h = (GLfloat)_height * _maxT;
			GLfloat		vertices[] = {	-w / 2,	-h / 2,	0.0,
				w / 2,	-h / 2,	0.0,
				-w / 2,	h / 2,	0.0,
			w / 2,	h / 2,	0.0 };
			
			glBindTexture(GL_TEXTURE_2D, _name);
			glVertexPointer(3, GL_FLOAT, 0, vertices);
			glPushMatrix();
			glTranslatef(pos.x, pos.y, 0.0f);
			if (angleX != 0)
				glRotatef(angleX, 1.0, 0.0, 0.0);
			if (angleY != 0)
				glRotatef(angleY, 0.0, 1.0, 0.0);
			if (angleZ != 0)
				glRotatef(angleZ, 0.0, 0.0, 1.0);
			glScalef(scaleX, scaleY, scaleZ);
			glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
			glColor4f(1.0f, 1.0f, 1.0f, alpha);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
			glPopMatrix();
		}
	}
}

- (void) drawImageWithNo2:(CGPoint)pos no:(GLuint)no no2:(GLuint)no2 angleX:(GLfloat)angleX angleY:(GLfloat)angleY angleZ:(GLfloat)angleZ scaleX:(GLfloat)scaleX scaleY:(GLfloat)scaleY scaleZ:(GLfloat)scaleZ alpha:(GLfloat)alpha {
	if (_tileWidth > 0 && _tileHeight > 0) {
		GLuint ww = _width / _tileWidth; //ww=2
		GLuint yy = _height/_tileHeight;
		
		if (ww > 0) {
			GLuint x = (no % ww) * _tileWidth;  
			GLuint y = (no2 % yy) * _tileHeight;
			
			GLfloat s1 = (float)x / _width;
			GLfloat s2 = s1 + _maxS;
			GLfloat t1 = (float)y / _height;
			GLfloat t2 = t1 + _maxT;
			GLfloat		coordinates[] = {
				s1, t2,
				s2, t2,
				s1, t1,
				s2, t1
			};
			GLfloat		w = (GLfloat)_width * _maxS,
			h = (GLfloat)_height * _maxT;
			GLfloat		vertices[] = {	-w / 2,	-h / 2,	0.0,
				w / 2,	-h / 2,	0.0,
				-w / 2,	h / 2,	0.0,
			w / 2,	h / 2,	0.0 };
			
			glBindTexture(GL_TEXTURE_2D, _name);
			glVertexPointer(3, GL_FLOAT, 0, vertices);
			glPushMatrix();
			glTranslatef(pos.x, pos.y, 0.0f);
			if (angleX != 0)
				glRotatef(angleX, 1.0, 0.0, 0.0);
			if (angleY != 0)
				glRotatef(angleY, 0.0, 1.0, 0.0);
			if (angleZ != 0)
				glRotatef(angleZ, 0.0, 0.0, 1.0);
			glScalef(scaleX, scaleY, scaleZ);
			glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
			glColor4f(1.0f, 1.0f, 1.0f, alpha);
			glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
			glPopMatrix();
		}
	}
}



@end
