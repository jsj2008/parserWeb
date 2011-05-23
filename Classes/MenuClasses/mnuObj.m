//
//  pauseMenu.m
//  game
//
//  Created by Taco on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "EAGLView.h"
#import "mnuObj.h"
#import "AnimObjManager.h"

#define MK_SPH_FRQ 33
#define MK_SPH_FRQ1 40

enum {
	STATEMKSTART,
	STATEMKCRY,
	STATEMKSTRONG,
	STATEMKOK,
	STATEMK_MAX
};

#define SPEECH_CHANGE_SEC 6

int mkyState;
int waitCnt;
int spchStat;

@implementation mnuObj

-(id)initMnuObj:(int)mnuType view:(id) view
{
	EAGLView *gameView = view;
	if (self = [super init]) 
	{
		switch (mnuType)
		{
			case MNU_OBJ_TITLE:
				[self loadImageFromFile:@"MNU_Zooff_C_Main_Title.png" tileWidth:320 tileHeight:120];
				self.pos = CGPointMake(160.0, 420.0);
				break;
			case MNU_OBJ_SPEACH:
			{
				CFURLRef fileURL;
#if 0
				NSArray *strSpch = [[NSArray alloc] initWithObjects:@"SFX_01MyComrades",
					@"SFX_02WeCannotKeepAllowing",
					@"SFX_03HowManyNights",
					@"SFX_04WeNeedAChange",
					@"SFX_05IStandHereToday",
					nil];
#endif				
				sndEft = gameView.soundEffect; 
				bundle = gameView.bundle;
				
#if 0
				for(int i = 0; i < 5; i++)
				{
					NSString *tmpSpch = [strSpch objectAtIndex:(NSUInteger) i];
					CFURLRef fileURL;					
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Monkey_Right" ofType:@"wav"]] retain];
					soundObjMk = [sndEft requestSEWithURL:fileURL];
					CFRelease(fileURL);				
				}	
#endif			
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:@"SFX_Monkey_Right" ofType:@"wav"]] retain];
				soundObjMk = [sndEft requestSEWithURL:fileURL];
				CFRelease(fileURL);
				
				hasPlayed = 0;
				
				[self loadImageFromFile:@"MNU_Zooff_MonkeySpeech.png" tileWidth:291 tileHeight:100];
				self.pos = CGPointMake(160.0, 320.0);				

				spchStat = 0;
			}	
				break;				
			case MNU_OBJ_MONKEY:				
				[self loadImageFromFile:@"MNU_Zooff_C_Main_Monkey.png" tileWidth:200 tileHeight:160];
				self.pos = CGPointMake(160.0, 260.0);
				mkyState = STATEMKSTART;
				break;
			case MNU_OBJ_BOX:
				[self loadImageFromFile:@"MNU_Zooff_C_Main_Beer.png" tileWidth:160 tileHeight:200];
				self.pos = CGPointMake(160.0, 160.0);
				break;
			case MNU_OBJ_ANIMAL:
				[self loadImageFromFile:@"MNU_Zooff_C_Main_Animal.png" tileWidth:320 tileHeight:240];
				self.pos = CGPointMake(160.0, 160.0);
				break;	
			case MNU_OBJ_SPEACHRESPONSE:
			{	
#if 1
				NSArray *strSpchRes = [[NSArray alloc] initWithObjects:@"SFX_Res01YeahGiraffe",
									@"SFX_Res02AsWoooo",
									@"SFX_Res03WeChange",
									@"SFX_Res04YeahChangeChange",
									nil];				
								
				sndEft = gameView.soundEffect; 
				bundle = gameView.bundle;
				
				for(int i = 0; i < 4; i++)
				{
					NSString *tmpSpch = [strSpchRes objectAtIndex:(NSUInteger) i];
					CFURLRef fileURL;					
					fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle pathForResource:tmpSpch ofType:@"wav"]] retain];
					soundObjRep[i] = [sndEft requestSEWithURL:fileURL];
					CFRelease(fileURL);				
				}	
#endif				
				[strSpchRes release];
				[self loadImageFromFile:@"talk1respon.png" tileWidth:240 tileHeight:120];
				self.pos = CGPointMake(205.0, 190.0);
				_alpha = 0;
				_state = -1;
			}
				break;
			case MNU_OBJ_TRACK:
				[self loadImageFromFile:@"MNU_Zooff_C_Main_btn_trans.png" tileWidth:320 tileHeight:80];
				self.pos = CGPointMake(160.0, 40.0);				
				break;
				
		}
		self.type = mnuType;
		mnuCnt = 0;
		_state = 0;
	}	
	
	return self;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
	mnuCnt ++ ;
	
	switch (self.type)
	{
		case MNU_OBJ_TITLE:
			_no = (gameView.frameCount/5)%4;
			break;
		case MNU_OBJ_MONKEY:	
			switch(spchStat)
			{
				case 0:
				case 1:
					_no = 0;
					mkyState = 0;
					break;
				case 2:
					_no = 1;
					mkyState = 1;
					break;
				case 3:
				case 4:
				case 5:	
					_no = 2;
					mkyState = 2;					
					break;
				case 6:	
					_no = 3;
					mkyState = 3;
					break;
			}
			break;
		case MNU_OBJ_SPEACH:			
			if(_no == 6)
			{
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
					//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*10)) 
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no = 0;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;								
			}
			else				
			if(_no == 5)
			{
				
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
					//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*3)) 
				{
					hasPlayed = 1;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;								
			}
			else
			if(_no == 4)
			{
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}	
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*3)) 
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;				
			}				
			else
			if(_no == 3)
			{
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}	
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*3)) 
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;				
			}	
			else			
			if(_no == 2)
			{					
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}	
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*3)) 
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;				
			}	
			else
			if(_no == 1)
			{
				if(hasPlayed == 0 )
				{
					hasPlayed = 1;
//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}	
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_*7) )
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;				
			}	
			else
			if(_no == 0)
			{

				if(hasPlayed == 0 && mnuCnt > 45)
				{
					hasPlayed = 1;
//					tmpSndObj=soundObjMk[_no];
					[sndEft play:soundObjMk sourceNumber:2];
				}	
				
				if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 4) )
				{
					hasPlayed = 0;
					mnuCnt = 0;
					_no ++;					
				}
				else /*if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 2) )*/
					spchStat = _no;
			}
			else
				spchStat = _no +1;

#if 0				
			_no = (mnuCnt/(_SYSTEM_FRAME_COUNT_PER_SEC_*3)) % 7;
			
			if(_no == 0 && preCnt = mnuCnt)
			{
				preCnt = mnuCnt;
				tmpSndObj=soundObjMk[1];
				[sndEft play:tmpSndObj sourceNumber:2];
//				[soundObjMk[_no] play];
			}	
			spchStat = _no ;// (mnuCnt/(_SYSTEM_FRAME_COUNT_PER_SEC_*3)) % 7;
#endif			
			break;
		case MNU_OBJ_BOX:
			_no=0;
			break;
		case MNU_OBJ_ANIMAL:
			if(mkyState == 0)
			{
				_no = (mnuCnt/10) % 2;
				if((mnuCnt/_SYSTEM_FRAME_COUNT_PER_SEC_) >= 2) 
					_no = 1;
			}	
			else if(mkyState == STATEMKCRY)
			{	
				_no = 3;
			}	
			else if(mkyState == STATEMKSTRONG)
				_no = 4;
			else if(mkyState == STATEMKOK)
				_no = 6;	
			break;
		case MNU_OBJ_SPEACHRESPONSE:
			switch(spchStat)
			{
				case 0:
					_alpha = 0;
					mnuCnt = 0;
					preCnt = 0;
					break;
				case 1:
				{															
					if(preCnt == 0)
					{
						_alpha = 1;
						_no = 0;
						preCnt = 1;
						if(hasPlayed == 0 )
						{
							hasPlayed = 1;
							tmpSndObj=soundObjRep[_no];
							[sndEft play:tmpSndObj sourceNumber:1];
						}	
					}
					break;
				}		
					
				case 2:
				{
					if(preCnt == 1)
					{
						_alpha = 1;
						_no = 1;
						preCnt = 0;						
						tmpSndObj=soundObjRep[_no];
						[sndEft play:tmpSndObj sourceNumber:1];
					}					
#if	0
					if(mnuCnt == 0)	
					{
						preCnt = 0;
					}
					
					if(preCnt == 0)
					{
						_no = 1;
						preCnt = 1;
						tmpSndObj=soundObjRep[_no];
						[sndEft play:tmpSndObj sourceNumber:1];
					}	
#endif					
				
					break;
				}	
					
				case 3:
					_alpha = 0;
					break;
				case 4:
				{
					if(preCnt == 0)
					{
						_alpha = 1;
						_no = 2;
						preCnt = 1;						
						tmpSndObj=soundObjRep[_no];
						[sndEft play:tmpSndObj sourceNumber:1];
					}				
					
#if 0					
					if( mnuCnt > 15 )	
						_alpha = 1;
					else
					{	
						_alpha = 0;
						break;
					}	
					_no = 2;

					if(_no == 2)
					{
						if(hasPlayed == 0 )
						{
							hasPlayed = 1;
							tmpSndObj=soundObjRep[_no];
							[sndEft play:tmpSndObj sourceNumber:1];
						}	
						
						if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 4) )
						{
							hasPlayed = 0;
							mnuCnt = 0;
						}
					}	
					
#endif					
					break;	
				}		
					
				case 5:
					if(preCnt == 1)
					{
						preCnt = 0;
						mnuCnt = 0;	
					}	
					
					if( mnuCnt >= _SYSTEM_FRAME_COUNT_PER_SEC_ )
					{
						_alpha =0;
					}
					break;	
				case 6:	
				{
					if(preCnt == 0)
					{
						_alpha = 1;
						_no = 3;
						preCnt = 1;						
						tmpSndObj=soundObjRep[_no];
						[sndEft play:tmpSndObj sourceNumber:1];
					}				
					
#if	0				
					if( mnuCnt > 15 )	
						_alpha = 1;
					else
					{	
						_alpha = 0;
						break;
					}	
					
//					_alpha = 1;
					_no = 3;
					if(_no == 3)
					{
						if(hasPlayed == 0 )
						{
							hasPlayed = 1;
							tmpSndObj=soundObjRep[_no];
							[sndEft play:tmpSndObj sourceNumber:1];
						}	
						
						if( mnuCnt >= (_SYSTEM_FRAME_COUNT_PER_SEC_* 5) )
						{
							hasPlayed = 0;
							mnuCnt = 0;
						}
					}
					
#endif					
				}
				break;
				default:
					_alpha =0;
					mnuCnt = 0;
				break;
			}
			break;
	}
	return 0;
}
@end
