//
//  AnimObj.m
//  iPhone Game Lib
//
//  Created by FIG on 2009/9/8.
//  Copyright 2009 __Genzin__. All rights reserved.
//

#import "AnimObj.h"


@implementation AnimObj

@synthesize no = _no, no2=_no2, pos = _pos, speed = _speed, accel = _accel, wait = _wait, count = _count, 
dir = _dir, state = _state, type = _type, alpha = _alpha, angleX = _angleX, angleY = _angleY, angleZ = _angleZ, scaleX = _scaleX, scaleY = _scaleY, scaleZ = _scaleZ,
collision = _collision, disableCollision = _disableCollision, freeTexture = _freeTexture;

- (id) init {
	if ((self = [super init]) != nil) {
		_alpha = 1.0f;
		_angleX = _angleY = _angleZ = 0.0f;
		_scaleX = _scaleY = _scaleZ = 1.0f;
		_freeTexture = YES;//Default
	}
	return self;
}
- (id) initWithStart {
	if ((self = [super init]) != nil) {
		_alpha = 1.0f;
		_angleX = _angleY = _angleZ = 0.0f;
		_scaleX = _scaleY = _scaleZ = 1.0f;
		_freeTexture = YES;//Default
	}
	return self;
}

- (void) dealloc {
	if(_freeTexture == YES)
	{
		if (_image)
		{
			[_image release];
		}
		_image = nil;
		//printf("_image release!\n");
	}
	//printf("animObj dealloc!\n");
	[super dealloc];
}


- (Texture2D *) loadImageFromFile:(NSString *)strFile tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	GLuint w, h;
	
	_image = [[Texture2D alloc] fromFile:strFile];
	
	if (_image != nil) {
		if (tileWidth > 0 && tileWidth <= _image.width)
			w = tileWidth;
		else
			w = _image.width;
		if (tileHeight > 0 && tileHeight <= _image.height)
			h = tileHeight;
		else
			h = _image.height;
		[_image SetTileSize:w	tileHeight:h];
	}
	return _image;
}

//pohsu{
- (Texture2D *) loadImageFromFileEx:(Texture2D *)image_info tileWidth:(GLuint)tileWidth tileHeight:(GLuint)tileHeight {
	GLuint w, h;
	[_image release];
	//_image = [[Texture2D alloc] fromFile:strFile];
	_image = image_info;
	
	if (_image != nil) {
		if (tileWidth > 0 && tileWidth <= _image.width)
			w = tileWidth;
		else
			w = _image.width;
		if (tileHeight > 0 && tileHeight <= _image.height)
			h = tileHeight;
		else
			h = _image.height;
		[_image SetTileSize:w	tileHeight:h];
	}
	return _image;
}
//pohsu}

- (void) drawImage {
	
	if (_image != nil && _no >= 0) 
	{
        if(_no2>0)
		[_image drawImageWithNo2:_pos no:_no no2:_no2 angleX:_angleX angleY:_angleY angleZ:_angleZ scaleX:_scaleX scaleY:_scaleY scaleZ:_scaleZ alpha:_alpha];
		else	
		[_image drawImageWithNo:_pos no:_no angleX:_angleX angleY:_angleY angleZ:_angleZ scaleX:_scaleX scaleY:_scaleY scaleZ:_scaleZ alpha:_alpha];
	}
}

- (void) drawImageWithFade:(GLfloat)fadelevel {
	if (_image != nil && _no >= 0) {
		if(_no2>0)
			[_image drawImageWithNo2:_pos no:_no no2:_no2 angleX:_angleX angleY:_angleY angleZ:_angleZ scaleX:_scaleX scaleY:_scaleY scaleZ:_scaleZ alpha:_alpha];
		else
			[_image drawImageWithNo:_pos no:_no angleX:_angleX angleY:_angleY angleZ:_angleZ scaleX:_scaleX scaleY:_scaleY scaleZ:_scaleZ alpha:_alpha * fadelevel];
	}
}


- (void) update {
	_pos.x += _speed.x;
	_pos.y += _speed.y;
	_speed.x += _accel.x;
	_speed.y += _accel.y;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	return 0;
}


- (CGRect) getCollisionRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y;
		aRect.size.width = _image.tileWidth * 0.8f;
		aRect.size.height = _image.tileHeight * 0.8f;
	}	
	return aRect;
}

@end
