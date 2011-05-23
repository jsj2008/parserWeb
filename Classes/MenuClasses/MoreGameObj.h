//
//  MoreGameObj.h
//  game
//
//  Created by Taco on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"

enum MORE_GAME_TYPE {
	GAME_ICON_TYPE1 = 200,	//MINI TRICKIE
	GAME_ICON_TYPE2,		//DANCE DUO
	GAME_ICON_TYPE3,		//DSB
	GAME_ICON_TYPE4,		//PAPER FISH
	GAME_ICON_TYPE5,		//FISH SCROOPER
	GAME_ICON_TYPE6,		//ZOO MANAGER
	GAME_ICON_TYPE7,		//SOUND SCRATCHER
	GAME_ICON_TYPE8,		//ZOO MANAGER OFF
	GAME_ICON_TYPE9,		//VIRUS FIGHTER
	GAME_ICON_TYPE10,			//ANGEL IN CLOUD
	GAME_ICON_TYPE11,			//Raining cats & dogs
	GAME_ICON_TYPE12,			//Race'em home
	GAME_ICON_TYPE13,			//Paper Airplane
	GAME_ICON_TYPE14			//Son of Fish
//	GAME_ICON_TYPE14,			//???
//	GAME_ICON_TYPE15,			//???
//	GAME_ICON_TYPE16,			//???
};

enum{
	PAGE_STATUS_NONE	=	-1,
	PAGE_STATUS_START  = 0,
	PAGE_STATUS_MOVE  = 1,
	PAGE_STATUS_AUTO_MOVE =2,
	PAGE_STATUS_RETURN = 3,
	PAGE_STATUS_STOP = 4
};
#define MOREGAME_AVAILABLE_RANGE  5

#define MORE_GAME_VOLECITY_LEVEL1 40
#define MORE_GAME_VOLECITY_LEVEL2 20
#define MORE_GAME_VOLECITY_LEVEL3 10
#define MORE_GAME_VOLECITY_LEVEL4 5

#define MOREGAME_PAGE_VELOCITY 40
#define DEFAULT_POSITION -1000
#define MORE_GAME_REDUCE 4

@interface MoreGameObj : AnimObj {
	BOOL bResponse;
	NSInteger ori_no;
	CGPoint _orig_Pos;
	CGPoint _BeginPos;
	CGPoint _currentPos;
	NSInteger _delta;

	NSInteger _pageStatus;
	NSInteger _correct_page;
	NSInteger _nextPage;
	NSInteger _velocity;
	BOOL _isPause;
	
	
}
@property(readwrite) CGPoint orig_Pos;
//- (id) initWithTexture2D:(Texture2D *)image;

- (BOOL)isInImage:(GLint)x y:(GLint)y;
- (id)initWithTexture2D:(Texture2D*)image Type:(NSInteger)type Position:(CGPoint) pos Number:(NSInteger)no;
- (BOOL)pageControl:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view;
- (void)setPageStatus:(NSInteger)delta status:(NSInteger)status;
@end
