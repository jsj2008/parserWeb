//
//  MoreGameObj.m
//  game
//
//  Created by Taco on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MoreGameObj.h"
#import "EAGLView.h"

@implementation MoreGameObj
@synthesize orig_Pos=_orig_Pos;
#if 1
- (id)initWithTexture2D:(Texture2D*)image Type:(NSInteger)type Position:(CGPoint) pos Number:(NSInteger)no
{
	if (self = [super init]) {
		//[super initWithStart];
		_image = image;
		self.freeTexture = NO;/*don't free the texture image while parent dealloc*/
		ori_no = self.no = no ; //originN0[type];
		self.pos = pos;
		_orig_Pos = pos;
		self.type = type;
		bResponse = NO;
		_delta = 0;
		_currentPos = pos;
		_correct_page = 1;
		_nextPage  =1;
		_velocity =0;
		_pageStatus = PAGE_STATUS_NONE;
		_BeginPos.x  = DEFAULT_POSITION;
	}
	return self;	
}
#else
- (id)initWithTexture2D:(Texture2D *)image {
	if((self = [super initWithStart]) != nil) {
		_image = image;
		self.needFreeTexture = NO;  //Don't need to need free because this texture is handled by startMainMenu
	}
	return self;
}
#endif
- (BOOL)isInImage:(GLint)x y:(GLint)y {
	CGRect rect = [self getCollisionRect];
	int left = rect.origin.x - rect.size.width / 2;
	int right = rect.origin.x + rect.size.width / 2;
	int top = rect.origin.y - rect.size.height / 2;
	int bottom = rect.origin.y + rect.size.height / 2;
	
	if (x < left || x > right || y < top || y > bottom)
		return FALSE;
	return TRUE;
};

- (NSInteger)run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	// press the icon
	//EAGLView *gameView = view;
	
	/*
	if ([self isInImage:x y:y]) {
		if ([touchMode isEqualToString:@"End"]) {
			  switch (_type) {
				 case GAME_ICON_TYPE1 : //Game
				 case GAME_ICON_TYPE2 : //Game
				 case GAME_ICON_TYPE3 : //Game
				 case GAME_ICON_TYPE4 : //Game
				 default:
				 gameView.main_moregame.selItemType = _type;
				 [gameView fadeOutWithState:GS_END_MOREGAME];
				 break;
				 }
			}
		}
	}
	 */
	/*Robert Liao for Next page..*/

	[self pageControl:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view];


	return 0;	
}


- (BOOL)pageControl:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view
{
	EAGLView *gameView = view;
	BOOL rtnVal = YES;
	int l_iDelta = 0;
	//Robert Liao for Next page..
	if(self.type < 400 && self.type >=200)//icon type range
	{
		if([touchMode isEqualToString:@"Began"])
		{
			//	_BeginPos = CGPointMake(x,y);
			if(_pageStatus == PAGE_STATUS_NONE)
			{
				_pageStatus = PAGE_STATUS_START;
				_BeginPos.x = x;
				_currentPos.x = _pos.x;
				_delta = 0;
				_isPause = NO;
			}
			else
			{
				_isPause = YES;
			
			}
			
			//if(self.type ==200)
			//	NSLog(@"Begin _pos.x = %f,_currentPos = %f , _BeginPos = %f,x = %d ",_pos.x,_currentPos.x,_BeginPos.x,x);
			
			
		}
		else if ([touchMode isEqualToString:@"Move"])
		{
			if(_isPause == NO)
			{
				if(_BeginPos.x  == DEFAULT_POSITION)
				{
					_currentPos.x = _pos.x;
					_BeginPos.x = x;
				}
				_pos.x  = _currentPos.x+x-_BeginPos.x;
				l_iDelta=_BeginPos.x-x;
				if(abs(l_iDelta)>MOREGAME_AVAILABLE_RANGE)
					_pageStatus = PAGE_STATUS_MOVE;
				else
					_pageStatus = PAGE_STATUS_START;
				 
			}
		}
		else if([touchMode isEqualToString:@"End"])
		{
			if(_isPause == NO)
			{
				l_iDelta=_BeginPos.x-x;
				_delta =_currentPos.x- _pos.x;
				
				if(_pageStatus == PAGE_STATUS_START)
				{
					if ([self isInImage:x y:y]) 
					{
						if(_type< 400 && _type >=200)
						{
							gameView.main_moregame.selItemType = _type;
							[gameView fadeOutWithState:GS_END_MOREGAME];
						}
					}
					_pageStatus = PAGE_STATUS_NONE;
					
				}
				else if(_pageStatus == PAGE_STATUS_MOVE)
				{
					if(abs(l_iDelta)>30)
					{
						if(l_iDelta>0)
						{
							_nextPage++;
						}
						else
						{
							_nextPage--;
						}
						//Boundary case..
						if(_nextPage<1 || _nextPage >MOREGAME_MAX_PAGE)
						{
							[self setPageStatus:l_iDelta status:PAGE_STATUS_RETURN];
						}
						else
						{
							_delta = 320-abs(_delta);
							[self setPageStatus:l_iDelta status:PAGE_STATUS_AUTO_MOVE];
						}
						
					}
					else
					{
						[self setPageStatus:l_iDelta status:PAGE_STATUS_RETURN];
						
					}
					
					_delta = abs(_delta);
				}//	
			}
			
		}
	

		if(_pageStatus == PAGE_STATUS_AUTO_MOVE || _pageStatus == PAGE_STATUS_RETURN)
		{
			int l_velocity = _velocity;
			
			if(self.type ==200)
			{
				//		NSLog(@"_pos.x = %f,_BeginPos.x = %f delta = %f , m_count = %d",_pos.x,_BeginPos.x,_pos.x-_BeginPos.x,m_count);
				//		NSLog(@"gameView.main_moregame.velocity = %d, m_count = %d",gameView.main_moregame.velocity,m_count);
			}
			if(_delta< MORE_GAME_VOLECITY_LEVEL1 && _delta>MORE_GAME_VOLECITY_LEVEL2)
				l_velocity = _velocity/MORE_GAME_REDUCE;
			else if(_delta<= MORE_GAME_VOLECITY_LEVEL2 && _delta>MORE_GAME_VOLECITY_LEVEL3)
				l_velocity = _velocity/(MORE_GAME_REDUCE*2);
			else if(_delta<= MORE_GAME_VOLECITY_LEVEL3)
				l_velocity = _velocity/(MORE_GAME_REDUCE*3);
			_pos.x  += l_velocity;
			_delta -= abs(l_velocity);
			
				
			if(_delta<=0)
			{
				_pageStatus = PAGE_STATUS_STOP;
				_correct_page = _nextPage;
			}
			
		}	
		else if(_pageStatus == PAGE_STATUS_STOP)
		{
		//	if(self.type ==200)
		//		NSLog(@"Before _pos.x = %f,correct_page = %d",_pos.x,_correct_page);
			_pos.x  = _orig_Pos.x-(_correct_page-1)*320;
			_currentPos.x = _pos.x;
			_BeginPos.x  = DEFAULT_POSITION;
			_pageStatus =  PAGE_STATUS_NONE;
			_isPause = NO;
			gameView.main_moregame.correct_page   = _correct_page;
			/*
			if(self.type ==200)
			{
				gameView.main_moregame.resetPagePonit = YES;
				gameView.main_moregame.correct_page   = _correct_page;
			}
			 */
		}

	}

	if(self.type>=MOREGAME_PAGE_TYPE)
	{
//		if(gameView.main_moregame.resetPagePonit == YES)
		{
			int typeNo = _type%MOREGAME_PAGE_TYPE;
			if(typeNo ==gameView.main_moregame.correct_page-1)
			{
				self.no = 0;
			}
			else
			{
				self.no = 1;
			}
		//	_resetPagePonit = NO;
		}
		
	}
	return rtnVal;
}

/*
//reset the volecity for currect page status..
//---------touchX-------Beginx
//         <------
 */
- (void)setPageStatus:(NSInteger)delta status:(NSInteger)status
{
	_pageStatus = status;
	if(_pageStatus==PAGE_STATUS_AUTO_MOVE )
	{
		if(delta>0)
		{
			_velocity = -MOREGAME_PAGE_VELOCITY;
		}
		else
		{
			_velocity = MOREGAME_PAGE_VELOCITY;
		}
	}
	else if(_pageStatus==PAGE_STATUS_RETURN)
	{
		if(delta>0)
		{
			_velocity = MOREGAME_PAGE_VELOCITY;
		}
		else
		{
			_velocity = -MOREGAME_PAGE_VELOCITY;
		}
		
		if(_nextPage<1)
			_nextPage = 1;
		else if(_nextPage >MOREGAME_MAX_PAGE)
			_nextPage = MOREGAME_MAX_PAGE;
	}
	else
	{
		NSLog(@"More Game Error Handle..");
	}

}

 
- (void)dealloc {
	[super dealloc];
}
@end
