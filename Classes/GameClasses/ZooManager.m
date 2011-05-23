//
//  ZooManager.m
//  Animation
//
//  Created by FIH on 2009/9/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ZooManager.h"
#import "EAGLView.h"

#define ZMDISPLACEMENT 1.0
#define ZMCHECKWIDTH 20
#define ORIGINALPOS CGPointMake(370.0, 250.0)

@implementation ZooManager
@synthesize bounds = _bounds;
- (id) init {
	if (self = [super init]) {
		//[super initWithStart];
		[self loadImageFromFile: @"ZM_G_MangerS.png" tileWidth:70 tileHeight:80];
		self.pos = ORIGINALPOS;
		self.speed = CGPointMake(0.0,-(ZMDISPLACEMENT));
		self.dir = ZMDIRSouth;
		_bounds =  CGRectMake(339.0, 266, 90, 69);
	}
	return (self);
}
- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *game = gameView.main_Game;
	int r = 0;
	switch (game.gameStageState) {
		case GSStateGameOver:
			_dir = ZMDepressedCycle;
			_pos = ORIGINALPOS;
			break;
		case GSStateGameSucceed:
			_dir = ZMJoyFulCycle;
			_pos = ORIGINALPOS;
			break;
		default:
			r = rand() % 5;
			if(_pos.y > _bounds.origin.y)
			{
				_dir = ZMDIREast;
				if(_pos.x+ZMCHECKWIDTH > (_bounds.origin.x+_bounds.size.width))
				{
					_dir+=2;
					r = rand() % 3;
					
				}
				else if(_pos.x-ZMCHECKWIDTH < _bounds.origin.x )
				{
					r = rand() % 3;
				}
				
			}
			else if(_pos.y < (_bounds.origin.y-_bounds.size.height))
			{
				_dir = ZMDIRWest;
				if(_pos.x+ ZMCHECKWIDTH > (_bounds.origin.x+_bounds.size.width))
				{
					r = rand()%3;
				}
				else if(_pos.x-ZMCHECKWIDTH < _bounds.origin.x)
				{
					_dir+=02;
					r = rand()%3;
				}
				
			}
			else if(_pos.x > (_bounds.origin.x+_bounds.size.width))
			{
				_dir = ZMDIRSouth;
				if(_pos.y + ZMCHECKWIDTH > _bounds.origin.y)
				{
					r = rand()%3;
					
				}
				else if(_pos.y - ZMCHECKWIDTH < (_bounds.origin.y-_bounds.size.height))
				{
					_dir+=02;
					r = rand()%3;
				}
				
			}
			else if(_pos.x <  _bounds.origin.x)
			{
				_dir = ZMDIRNorth;
				if(_pos.y + ZMCHECKWIDTH > _bounds.origin.y)
				{
					_dir+=02;
					r = rand()%3;
					
				}
				else if(_pos.y- ZMCHECKWIDTH < (_bounds.origin.y-_bounds.size.height))
				{
					r = rand()%3;
				}
				
			}
			else /*Keep the original direction and speed*/
			{
				r = 00;
			}
			
			_dir+=r; /*picked one direction*/
			
			_dir%=8;
			
			switch (_dir) {
				case ZMDIRNorth:
					_speed.x = 0;
					_speed.y = ZMDISPLACEMENT;
					break;
				case ZMDIRNorthEast:
					_speed.x = ZMDISPLACEMENT;
					_speed.y = ZMDISPLACEMENT;
					break;
				case ZMDIREast:
					_speed.x = ZMDISPLACEMENT;
					_speed.y = 0;
					break;
				case ZMDIRSouthEast:
					_speed.x = ZMDISPLACEMENT;
					_speed.y = -(ZMDISPLACEMENT);
					break;
				case ZMDIRSouth:
					_speed.x = 0;
					_speed.y = -(ZMDISPLACEMENT);
					break;
				case ZMDIRSouthWest:
					_speed.x = -(ZMDISPLACEMENT);
					_speed.y = -(ZMDISPLACEMENT);
					break;
				case ZMDIRWest:
					_speed.x = -(ZMDISPLACEMENT);
					_speed.y = 0;
					break;
				case ZMDIRNorthWest:
					_speed.x = -(ZMDISPLACEMENT);
					_speed.y = ZMDISPLACEMENT;
					break;
				default:
					break;
			}
			if(_count%2)  //Decelerate speed
			{
				[self update];
			}
			
			break;
	}
	_no = (_count / 6) % 8 + (_dir)*14;
	_count++;
    return 0;	
}

- (void) dealloc {
	[super dealloc];
}


@end
