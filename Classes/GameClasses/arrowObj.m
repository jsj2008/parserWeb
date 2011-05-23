//
//  arrowObj.m
//  game
//
//  Created by smallwin on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EAGLView.h"
#import "arrowObj.h"
#import "dataDefine.h"
#import "mainGame.h"


@implementation arrowObj
@synthesize arrowType;

- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;

	if(_SCALEB1==0)
		_SCALEB1=_ARROW_SCALE_DEFAULT_SIZE;

	if(_SCALEB2==0)
		_SCALEB2=_ARROW_SCALE_DEFAULT_SIZE;
	
	if(_SCALEB3==0)
		_SCALEB3=_ARROW_SCALE_DEFAULT_SIZE;


	if(gameView.main_Game.gameStageState!=GSStateProgress)
	{
		return 0;
	}	
	
	//[self update];
	_count++;	
	_no = (_count/10) % 4 ;

	if(gameView._b1type == ENSWITCH_WEST)
	{	
		_angleZB1 = 90.0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM1_].mDirFace = MAPPATH_WEST;
	}	
	else if(gameView._b1type == ENSWITCH_SOUTH)
	{	
		_angleZB1 = 180.0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM1_].mDirFace = MAPPATH_SOUTH;
	}	
	else if(gameView._b1type == ENSWITCH_NORTH)
	{
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM1_].mDirFace = MAPPATH_NORTH;
		_angleZB1 = 0;
	}

	if(gameView._b2type == ENSWITCHLEVEL2_SOUTH)
	{	
		_angleZB2 = 180.0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM2_].mDirFace = MAPPATH_SOUTH;
	}	
	else if(gameView._b2type == ENSWITCHLEVEL2_NORTH)
	{	
		_angleZB2 = 0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM2_].mDirFace = MAPPATH_NORTH;
	}

	
	if(gameView._b3type == ENSWITCHLEVEL2_SOUTH)
	{	
		_angleZB3 = 180.0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM3_].mDirFace = MAPPATH_SOUTH;
	}	
	else if(gameView._b3type == ENSWITCHLEVEL2_NORTH)
	{	
		_angleZB3 = 0;
		mapStObj[_MAPDATA_BOUND_SWITCH_BUTTOM3_].mDirFace = MAPPATH_NORTH;
	}
	
	if((_count - _sCaleTime1) > 10)
	{
		_SCALEB1 = _ARROW_SCALE_DEFAULT_SIZE;
		_sCaleTime1 = 0;
	}	

	if((_count - _sCaleTime2) > 10)
	{	
		_SCALEB2 = _ARROW_SCALE_DEFAULT_SIZE;
		_sCaleTime2 = 0;
	}	

	if((_count - _sCaleTime3) > 10)
	{	
		_SCALEB3 = _ARROW_SCALE_DEFAULT_SIZE;
		_sCaleTime3 = 0;
	}	
	
	
	if(arrowType == _ARROW_POSITION1 && ([touchMode isEqualToString:@"Began1"]) == YES)
	{
		gameView._b1type += 1;
		gameView._b1type %= ENSWITCH_MAX;

		if(gameView._b1type == ENSWITCH_WEST)
		{	
			_angleZB1 = 90.0;
		}	
		else if(gameView._b1type == ENSWITCH_SOUTH)
			_angleZB1 = 180.0;
		else if(gameView._b1type == ENSWITCH_NORTH)
			_angleZB1 = 0;
		
		gameView._b1type += 1;
		gameView._b1type %= ENSWITCH_MAX;
		
		_SCALEB1 = _ARROW_SCALE_SIZE;		
		_sCaleTime1 = _count;
		[gameView.soundEffect play:gameView.soundObj1 sourceNumber:1];
	}	
	
	if(arrowType == _ARROW_POSITION2 && ([touchMode isEqualToString:@"Began2"]) == YES)
	{
		if(gameView._b2type == ENSWITCHLEVEL2_SOUTH)
			_angleZB2 = 180.0;
		else if(gameView._b2type == ENSWITCHLEVEL2_NORTH)
			_angleZB2 = 0;

		gameView._b2type += 1;
		gameView._b2type %= ENSWITCHLEVEL2_MAX;

		_SCALEB2 = _ARROW_SCALE_SIZE;		
		_sCaleTime2 = _count;
		[gameView.soundEffect play:gameView.soundObj1 sourceNumber:1];
		
	}	
	
	if(arrowType == _ARROW_POSITION3 && ([touchMode isEqualToString:@"Began3"]) == YES)
	{
		
		if(gameView._b3type == ENSWITCHLEVEL2_SOUTH)
	{
			_angleZB3 = 180.0;
	}	
		else if(gameView._b3type == ENSWITCHLEVEL2_NORTH)
	{
			_angleZB3 = 0;
		}

		gameView._b3type += 1;
		gameView._b3type %= ENSWITCHLEVEL2_MAX;

		_SCALEB3 = _ARROW_SCALE_SIZE;		
		_sCaleTime3 = _count;
		[gameView.soundEffect play:gameView.soundObj1 sourceNumber:1];
		
		
	}	
	
	return 0;
}

- (void) drawImageWithFade:(GLfloat)fadelevel {
	if (_image != nil && _no >= 0) {
		if(arrowType == _ARROW_POSITION1)
			[_image drawImageWithNo:_pos no:_no angleX:_angleX angleY:_angleY angleZ:_angleZB1 scaleX:_scaleX*_SCALEB1 scaleY:_scaleY*_SCALEB1 scaleZ:_scaleZ alpha:_alpha * fadelevel];
		if(arrowType == _ARROW_POSITION2)
			[_image drawImageWithNo:_pos no:_no angleX:_angleX angleY:_angleY angleZ:_angleZB2 scaleX:_scaleX*_SCALEB2 scaleY:_scaleY*_SCALEB2 scaleZ:_scaleZ alpha:_alpha * fadelevel];
		if(arrowType == _ARROW_POSITION3)
			[_image drawImageWithNo:_pos no:_no angleX:_angleX angleY:_angleY angleZ:_angleZB3 scaleX:_scaleX*_SCALEB3 scaleY:_scaleY*_SCALEB3 scaleZ:_scaleZ alpha:_alpha * fadelevel];

	}
}


@end
