//
//  ZooAnimal.m
//  Animation
//
//  Created by FIH on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "EAGLView.h"
#import "ZooAnimalFeeder.h"

#define JUMPHIGHTLEVEL 100
//#define JUMPSPEED 8

float scaleState = 3.0f;
//static CGRect ButtomArea[4] ={{0.0, 350.0, 80.0, 80.0}, {80.0, 350.0, 80.0, 80.0}, {160.0, 350.0, 80.0, 80.0}, {240.0, 350.0, 80.0, 80.0}};
//static CGPoint MonkeyPoint[4] = {{38.0, 170.0},{120.0,170.0},{ 210.0, 170.0},{275.0, 170.0}};
//static int MonkeyPointX[4] = {38, 120, 210, 275};

@implementation ZooAnimalFeeder
@synthesize animalkind = _animalkind, feedingfoodtype = _feedingfoodtype, totfeedingcounts = _totfeedingcounts, curfeedingcounts = _curfeedingcounts;
@synthesize imgScore = _imgScore , isStuffed = _isStuffed , rightScores = _rightScores, wrongScores = _wrongScores;
@synthesize imgScore1 = _imgScore1,imgScore2 = _imgScore2,imgScore3 = _imgScore3;

- (CGRect) getCollisionRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y;
		aRect.size.width = _image.tileWidth * 0.5f;
		aRect.size.height = _image.tileHeight * 0.8f;
	}	
	return aRect;
}

- (id)initWithTexture2D:(Texture2D*)image No:(NSInteger)no Type:(NSInteger)type Position:(CGPoint) pos{
	if (self = [super init]) {
		//[super initWithStart];
		_image = image;
		self.freeTexture = NO;/*don't free the texture image while parent dealloc*/
		ori_no = self.no = no;
		self.pos = pos;
		self.type = type;
		bResponse = NO;
	}
	return self;	
}

- (CGRect) getTouchRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;

#if 0		
		if(mkActStat == EN_MONKEY_FALLING)
		{
			aRect.origin.x = _pos.x +10;
			aRect.origin.y = _pos.y;
			aRect.size.width = _image.tileWidth-20;
			aRect.size.height = _image.tileHeight-25;			
		}
		else
		if(mkActStat == EN_MONKEY_JUMPPING)
		{
			aRect.origin.y = _pos.y;
			aRect.size.width = _image.tileWidth*0.7;
			aRect.size.height = _image.tileHeight-30;			
		}	
		else
#endif			
		{
			aRect.origin.y = _pos.y;
			aRect.size.width = _image.tileWidth-10;
			aRect.size.height = _image.tileHeight-10;	
		}	
	}
	return aRect;
}

- (BOOL)pointInImage:(int)x y:(int)y{
	CGRect rect = [self getTouchRect];
	int left = rect.origin.x - rect.size.width / 2;
	int right = rect.origin.x + rect.size.width / 2;
	int top = rect.origin.y - rect.size.height / 2;
	int bottom = rect.origin.y + rect.size.height / 2;
	
	if (x < left || x > right || y < top || y > bottom)
		return FALSE;
	return TRUE;
}

//- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts{
- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts FeedCounts2:(uint) feedcounts2 FeedCounts3:(uint) feedcounts3 FeedCounts4:(uint) feedcounts4{
	if (self = [super init]) 
	{
		_state = ZAEmotionNormal;
		
		_feedingfoodtype = (ZooAnimalFoodstuff)_animalkind;
		_totfeedingcounts = feedcounts;
		_totfeedingcounts2 = feedcounts2;
		_totfeedingcounts3 = feedcounts3;
		_totfeedingcounts4 = feedcounts4;
		_curfeedingcounts = 0;
		_curfeedingcounts2 = 0;
		_curfeedingcounts3 = 0;
		_curfeedingcounts4 = 0;
		_isStuffed = NO;
		_rightScores = 0;
		//[self loadImageFromFile: @"GAM_Zooff_ANI_Monkey.png" tileWidth:80 tileHeight:80];
		[self loadImageFromFile: @"GAM_Zooff_ANI_Monkey.png" tileWidth:128 tileHeight:128];
		monkeypos = 0;
		monkeyState = 0;
		originMonPos = 0;
		mkActStat = EN_MONKEY_NORMAL;
		mkHdState = ZAStuffMax;
		
		_imgScore = [[Texture2D alloc] fromFile:@"ZM_G_Food-numbers.png"];
		if (_imgScore != nil) {
			[_imgScore SetTileSize:8 tileHeight:11];
		}
		_imgScore1 = [[Texture2D alloc] fromFile:@"ZM_G_Food-numbers.png"];
		if (_imgScore1 != nil) {
			[_imgScore1 SetTileSize:8 tileHeight:11];
		}
		_imgScore2 = [[Texture2D alloc] fromFile:@"ZM_G_Food-numbers.png"];
		if (_imgScore2 != nil) {
			[_imgScore2 SetTileSize:8 tileHeight:11];
		}
		_imgScore3 = [[Texture2D alloc] fromFile:@"ZM_G_Food-numbers.png"];
		if (_imgScore3 != nil) {
			[_imgScore3 SetTileSize:8 tileHeight:11];
		}
		
		plusScore = [[Texture2D alloc] fromFile:@"END_Zoo_C_Scores_Number.png"];
		if (plusScore != nil) {
			[plusScore SetTileSize:19 tileHeight:26];
		}		
	}
	
	Attach = [[Texture2D alloc] fromFile:@"GAM_Zooff_ANI_Monkey_Attack.png"];
	[Attach SetTileSize:77 tileHeight:81];

	foodIdx = [[Texture2D alloc] fromFile:@"GAM_Race_S_ICON_Monkey.png"];
	[foodIdx SetTileSize:32 tileHeight:32];
	foodIdx1 = [[Texture2D alloc] fromFile:@"GAM_Race_S_ICON_Kirin.png"];
	[foodIdx1 SetTileSize:32 tileHeight:32];
	foodIdx2 = [[Texture2D alloc] fromFile:@"GAM_Race_S_ICON_Lion.png"];
	[foodIdx2 SetTileSize:32 tileHeight:32];
	foodIdx3 = [[Texture2D alloc] fromFile:@"GAM_Race_S_ICON_Rabbit.png"];
	[foodIdx3 SetTileSize:32 tileHeight:32];
	
	//Animal in the car
	//MoreGameObj *btnObj1 = [[MoreGameObj alloc] initWithTexture2D:MoreGameItem Type:GAME_ICON_TYPE1 Position:GAME_ICON_AREA1 Number:3];
	//[gameView.animManager requestWithObj:btnObj1];
	
	AnimInCar1 = [[Texture2D alloc] fromFile:@"GAM_RACE_Animal_in_car.png"];
	[AnimInCar1 SetTileSize:128 tileHeight:128];
	
	InCar1 = InCar2 = InCar3 = InCar4 = InCar5 = InCar6 = InCar7 = InCar8 = InCar9 = InCar10 = 99;
	InCar1_ori = InCar2_ori = InCar3_ori = InCar4_ori = InCar5_ori = InCar6_ori = InCar7_ori = InCar8_ori = InCar9_ori = InCar10_ori = 99;
	totalCount = 0;
	
	Car_Ass = [[Texture2D alloc] fromFile:@"GAM_RACE_Car_ass.png"];
	[Car_Ass SetTileSize:128 tileHeight:128];
	
	origH = 0;
	return self;	
}

//- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts Point:(CGPoint) point view:(id)view{
- (id)initWithZooAnimalKind:(ZooAnimalKind)kind FeedCounts:(uint) feedcounts FeedCounts2:(uint) feedcounts2 FeedCounts3:(uint) feedcounts3 FeedCounts4:(uint) feedcounts4 Point:(CGPoint) point view:(id)view{
    EAGLView *gameView = view;
	if (self = [super init]) {
		[super initWithStart];
		[self initWithZooAnimalKind:kind FeedCounts:feedcounts FeedCounts2:feedcounts2 FeedCounts3:feedcounts3 FeedCounts4:feedcounts4];
		self.pos = point;
	}
	//init sound path {{ //pohsu
	animalSoundEffect = gameView.soundEffect; 
	bundle = gameView.bundle;
	
	return self;	
}

- (void) setDemoMode
{
	if(Demoimg == nil)
	{	
		Demoimg = [[Texture2D alloc] fromFile:@"MNU_DEMO.png"];
		if (Demoimg != nil) {
			[Demoimg SetTileSize:320 tileHeight:250];		
		}		
	}	
	mkActStat = EN_MONKEY_DEMO;
	demoTouchCnt = -1;	
}

//- (void)resetWithTotFeedingCounts:(uint)feedcounts{
- (void)resetWithTotFeedingCounts:(uint)feedcounts feedcounts2:(uint)feedcounts2 feedcounts3:(uint)feedcounts3 feedcounts4:(uint)feedcounts4{
	_state = ZAEmotionNormal;
	_totfeedingcounts = feedcounts;
	_totfeedingcounts2 = feedcounts2;
	_totfeedingcounts3 = feedcounts3;
	_totfeedingcounts4 = feedcounts4;
	_curfeedingcounts = 0;
	_curfeedingcounts2 = 0;
	_curfeedingcounts3 = 0;
	_curfeedingcounts4 = 0;
	_isStuffed = NO;
	_rightScores = 0;
	_wrongScores = 0;
	mkActStat = EN_MONKEY_NORMAL;
	mkHdState = ZAStuffMax;
	InCar1 = InCar2 = InCar3 = InCar4 = InCar5 = InCar6 = InCar7 = InCar8 = InCar9 = InCar10 = 99;
	InCar1_ori = InCar2_ori = InCar3_ori = InCar4_ori = InCar5_ori = InCar6_ori = InCar7_ori = InCar8_ori = InCar9_ori = InCar10_ori = 99;
}

/**
*
 1 = fainting
 2 = hit squirrel
 3 = nothing
 4 = NA
*/
- (NSInteger) queryPassState
{
	if(mkActStat == EN_MONKEY_MOVE)
		return 3;
	
	if(mkActStat == EN_MONKEY_FALLING)
		return 2;

	return 1;
#if 0	
	if([self canPassed] == FALSE)
	{
		if(mkActStat == EN_MONKEY_FALLING)
			return 2;
		
		return 1;
	}	
	else
		return 3;	
#endif	
}

-(void) setMonkeyHit
{
	[self PlaySoundByAnimalType];
	
}


- (BOOL) canPassed
{		
	if(origH != 0 && (_pos.y > origH + JUMPHIGHTLEVEL/2)+40)
		return TRUE;
	
	return FALSE;
}

- (BOOL) canGetFood
{	
	if(mkActStat == EN_MONKEY_MAX)
		return TRUE;

	if(mkActStat == EN_MONKEY_NORMAL)
	{
		if(mkHdState == ZAStuffMax)
			return TRUE;
	}	
		
	return FALSE;
}

-(void) setMonkeyFaint
{
#if 0	
	if(mkActStat == EN_MONKEY_MOVE)
	{
		mkActStat = EN_MONKEY_FAINTING;		
		if(monkeyState != 0)
		{
			monkeypos = originMonPos;
			_pos = MonkeyPoint[monkeypos];
			monkeyState	= 0;
		}			
	}
#endif	
	//mkActStat = EN_MONKEY_FAINTING;	
	mkHdState = ZAStuffMax;
	monkeyState = 0;

	if(origH!=0)
		_pos.y = origH;
}

-(BOOL) canMove
{
	if(mkActStat == EN_MONKEY_NORMAL || mkActStat == EN_MONKEY_GETFOODINHAND ||mkActStat ==EN_MONKEY_MAX)
		return TRUE;
	return FALSE;	
}


-(BOOL) canJump
{
	if(mkActStat == EN_MONKEY_NORMAL || mkActStat == EN_MONKEY_GETFOODINHAND ||mkActStat ==EN_MONKEY_MAX)
		return TRUE;
	return FALSE;	
}

-(NSInteger) MonkeyDemoRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	if(bTouch == TRUE && [touchMode isEqualToString:@"Began"])
		demoTouchCnt++;
	return 0;
}

-(BOOL) turn:(Car_Direction)direction view:(id)view
{
	EAGLView *gameView = view;
	
	switch (direction) {
		case Car_turn_left:
			if (InCar1_ori != 99)
				InCar1 = InCar1_ori + 3;
			if (InCar2_ori != 99)
				InCar2 = InCar2_ori + 3;
			if (InCar3_ori != 99)
				InCar3 = InCar3_ori + 3;
			if (InCar4_ori != 99)
				InCar4 = InCar4_ori + 3;
			if (InCar5_ori != 99)
				InCar5 = InCar5_ori + 3;
			if (InCar6_ori != 99)
				InCar6 = InCar6_ori + 3;
			if (InCar7_ori != 99)
				InCar7 = InCar7_ori + 3;
			if (InCar8_ori != 99)
				InCar8 = InCar8_ori + 3;
			if (InCar9_ori != 99)
				InCar9 = InCar9_ori + 3;
			if (InCar10_ori != 99)
				InCar10 = InCar10_ori + 3;
			break;
		case Car_turn_right:
			if (InCar1_ori != 99)
				InCar1 = InCar1_ori + 9;
			if (InCar2_ori != 99)
				InCar2 = InCar2_ori + 9;
			if (InCar3_ori != 99)
				InCar3 = InCar3_ori + 9;
			if (InCar4_ori != 99)
				InCar4 = InCar4_ori + 9;
			if (InCar5_ori != 99)
				InCar5 = InCar5_ori + 9;
			if (InCar6_ori != 99)
				InCar6 = InCar6_ori + 9;
			if (InCar7_ori != 99)
				InCar7 = InCar7_ori + 9;
			if (InCar8_ori != 99)
				InCar8 = InCar8_ori + 9;
			if (InCar9_ori != 99)
				InCar9 = InCar9_ori + 9;
			if (InCar10_ori != 99)
				InCar10 = InCar10_ori + 9;
			break;
		case Car_turn_stand:
			if (InCar1_ori != 99)
				InCar1 = InCar1_ori;
			if (InCar2_ori != 99)
				InCar2 = InCar2_ori;
			if (InCar3_ori != 99)
				InCar3 = InCar3_ori;
			if (InCar4_ori != 99)
				InCar4 = InCar4_ori;
			if (InCar5_ori != 99)
				InCar5 = InCar5_ori;
			if (InCar6_ori != 99)
				InCar6 = InCar6_ori;
			if (InCar7_ori != 99)
				InCar7 = InCar7_ori;
			if (InCar8_ori != 99)
				InCar8 = InCar8_ori;
			if (InCar9_ori != 99)
				InCar9 = InCar9_ori;
			if (InCar10_ori != 99)
				InCar10 = InCar10_ori;
		case Car_crash:
			if (InCar1_ori != 99)
				InCar1 = ((gameView.frameCount/5)%2)+24+InCar1_ori;
			if (InCar2_ori != 99)
				InCar2 = ((gameView.frameCount/5)%2)+24+InCar2_ori;
			if (InCar3_ori != 99)
				InCar3 = ((gameView.frameCount/5)%2)+24+InCar3_ori;
			if (InCar4_ori != 99)
				InCar4 = ((gameView.frameCount/5)%2)+24+InCar4_ori;
			if (InCar5_ori != 99)
				InCar5 = ((gameView.frameCount/5)%2)+24+InCar5_ori;
			if (InCar6_ori != 99)
				InCar6 = ((gameView.frameCount/5)%2)+24+InCar6_ori;
			if (InCar7_ori != 99)
				InCar7 = ((gameView.frameCount/5)%2)+24+InCar7_ori;
			if (InCar8_ori != 99)
				InCar8 = ((gameView.frameCount/5)%2)+24+InCar8_ori;
			if (InCar9_ori != 99)
				InCar9 = ((gameView.frameCount/5)%2)+24+InCar9_ori;
			if (InCar10_ori != 99)
				InCar10 = ((gameView.frameCount/5)%2)+24+InCar10_ori;
			break;
		default:
			break;
	}
	return YES;
}

- (NSInteger) MonkeyGsensorRun:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	EAGLView *gameView = view;
    //NSLog(@"x=%f,y=%y",_pos.x,_pos.y);
	
	if (gameView.tmpDelta2 > 0)
	{
		_no = ((gameView.frameCount/5)%2)+12;
		Car_ass_no = ((gameView.frameCount/5)%2)+12;
		[self turn:Car_crash view:gameView];
	}
	else if((gameView.car_xx <=0.03)&&(gameView.car_xx >= -0.03)){  //Speed up
		if (gameView.tmpDelta > 0)
		{
			_no = 6;
			Car_ass_no = 6;
		}
		else
		{
			_no = 0;
			Car_ass_no = 0;
			[self turn:Car_turn_stand view:gameView];
		}
	}
	else if (gameView.car_xx > 0.03)  //Turn right
	{
		if (_pos.x + 10 >= 270){
			_pos.x =  _pos.x;
			if (gameView.tmpDelta > 0)
			{
				_no = 6;
				Car_ass_no = 6;
			}
			else
			{
				_no = 0;
				Car_ass_no = 0;
				[self turn:Car_turn_stand view:gameView];
			}
		}
		else{
			_pos.x = _pos.x + 10;
			if (gameView.tmpDelta > 0)
			{
				_no = 9;
				Car_ass_no = 9;
			}
			else
			{
				_no = 5;
				Car_ass_no = 5;
				[self turn:Car_turn_right view:gameView];
			}
		}
	}
	else if (gameView.car_xx < -0.03) //Turn Left
	{
		if (_pos.x - 10 <= 38){
			_pos.x =  _pos.x;
			if (gameView.tmpDelta > 0)
			{
				_no = 6;
				Car_ass_no = 6;
			}
			else
			{
				_no = 0;
				Car_ass_no = 0;
				[self turn:Car_turn_stand view:gameView];
			}
		}
		else{
			_pos.x = _pos.x - 10;
			if (gameView.tmpDelta > 0)
			{
				_no = 11;
				Car_ass_no = 11;
			}
			else
			{
				_no = 3;
				Car_ass_no = 3;
				[self turn:Car_turn_left view:gameView];
			}
		}
	}
	return 0;
}


- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	mainGame *game = gameView.main_Game;	
	float xxx = gameView.car_xx;
	float yyy = gameView.car_yy;

	if(game.gameStageState == GSStateGameOver|| game.gameStageState == GSStateGameSucceed)
		return 0;
		
	//rtn  = [self MonkeyActionRun:self bTouch:bTouch touchMode:touchMode x:x y:y view:view];
	[self MonkeyGsensorRun:self bTouch:bTouch touchMode:touchMode x:xxx y:yyy view:view];
	
	
	if(mkActStat != EN_MONKEY_GETBANALA /*&& mkActStat != EN_MONKEY_FAINTING && mkActStat != EN_MONKEY_HITTSUIRREL*/)
	{
		_wait= 30;
	}
	else if(mkActStat == EN_MONKEY_GETBANALA /*|| mkActStat == EN_MONKEY_FAINTING || mkActStat == EN_MONKEY_HITTSUIRREL*/)	
	{
		if(--(_wait) <= 0)
		{
			mkActStat = EN_MONKEY_NORMAL;
			_state = ZAEmotionNormal;
			feedCnt = 0;
		}
	}
	
	{
		switch (mkHdState)
		{
			case ZAStuffLeaf:
				//_no = ((gameView.frameCount/20)%2)*12+7;
				//_no = 0;
				break;
			case ZAStuffMeat:
				//_no = ((gameView.frameCount/20)%2)*12+5;
				//_no = 0;
				break;
			case ZAStuffCarrot:
				//_no = ((gameView.frameCount/20)%2)*12+6;
				//_no = 0;
				break;				
			//case ZAStuffGrass:				
				//_no = ((gameView.frameCount/20)%2)*12+4;
			//	_no = 0;
			//	break;
			case ZAStuffMax:
				//_no = ((gameView.frameCount/20)%2)*12;
				//_no = 0;
				break;
		}
	}	
	
	if(mkActStat == EN_MONKEY_GETBANALA)
	{
		//_no = ((gameView.frameCount/5)%2)*12+1;
		//_no = 0;
	}
	
	//if(mkActStat == EN_MONKEY_READYTOJUMP)
	//{	
		//_no = 3;
	//	_no = 0;
	//}	
	
	if(mkActStat == EN_MONKEY_FAINTING)
	{
		//_no = ((gameView.frameCount/20)%2)*12+2;
		//_no = 8;
	}
	feedCnt++;
	return 0;
}

-(BOOL) ckMonkeyHandState
{
#if 0
	if(mkActStat == EN_MONKEY_JUMPPING || mkActStat == EN_MONKEY_FALLING)
		return FALSE;
#endif	
	if(ZAStuffBanana!=mkHdState && ZAStuffMax != mkHdState)
		return TRUE;
	
	return FALSE;
}

-(void) restMkActState
{
	mkHdState = ZAStuffMax;
	mkActStat = EN_MONKEY_NORMAL;
//	FoodOnH = nil;
}

-(ZooAnimalFoodstuff) reHandFood
{	
	if(mkHdState == ZAStuffBanana || mkHdState == ZAStuffMax)
		return ZAStuffMax;
	
	return mkHdState;
}
-(BOOL)drawAnimalInCar:(ZooAnimalFoodstuff)foodstuff
{
	//_curfeedingcounts
	//_curfeedingcounts2
	//_curfeedingcounts3
	//_curfeedingcounts4
	//NSInteger totalCount = 0;
	NSInteger pic_no = 0;
	totalCount = _curfeedingcounts + _curfeedingcounts2 + _curfeedingcounts3 + _curfeedingcounts4;
	//ZAStuffBanana = 0,
	//ZAStuffLeaf,
	//ZAStuffMeat,
	//ZAStuffCarrot,
	if (foodstuff == ZAStuffBanana) //Monkey
		pic_no = 0;
	else if (foodstuff == ZAStuffLeaf) //Leaf
		pic_no = 4;
	else if (foodstuff == ZAStuffMeat) //Lion
		pic_no = 32;
	else if (foodstuff == ZAStuffCarrot) //Rabbit
		pic_no = 36;
	
	if(totalCount == 0)
		InCar1 = InCar1_ori = pic_no;
	else if (totalCount == 1)
		InCar2 = InCar2_ori = pic_no;
	else if (totalCount == 2)
		InCar3 = InCar3_ori = pic_no;
	else if (totalCount == 3)
		InCar4 = InCar4_ori = pic_no;
	else if (totalCount == 4)
		InCar5 = InCar5_ori = pic_no;
	else if (totalCount == 5)
		InCar6 = InCar6_ori = pic_no;
	else if (totalCount == 6)
		InCar7 = InCar7_ori = pic_no;
	else if (totalCount == 7)
		InCar8 = InCar8_ori = pic_no;
	else if (totalCount == 8)
		InCar9 = InCar9_ori = pic_no;
	else if (totalCount == 9)
		InCar10 = InCar10_ori = pic_no;
	else if (totalCount > 9)
		return YES;
	
	return YES;
}

-(BOOL) feedWithFood:(ZooAnimalFoodstuff)foodstuff view:(id)view
{
	EAGLView *gameView = view;
	if(mkActStat == EN_MONKEY_FAINTING)
		return NO;
	
	{
		//determine which case you do
		if(ZAStuffBanana == foodstuff)
		{			
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_GETBANALA;
			[self drawAnimalInCar:foodstuff];
		}
		else if(ZAStuffLeaf == foodstuff){
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_GETKIRIN;
			[self drawAnimalInCar:foodstuff];
		}
		else if (ZAStuffMeat == foodstuff){
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_GETLION;
			[self drawAnimalInCar:foodstuff];
		}
		else if (ZAStuffCarrot == foodstuff){
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_GETRABBIT;
			[self drawAnimalInCar:foodstuff];
		}
		else if (ZAStuffBattery == foodstuff){
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_Battery;
		}
		else if (ZAStuffRoadBlock == foodstuff){
			mkActStat = EN_MONKEY_RoadBlock;
			[self setMonkeyFaint];
		}
		else if (ZAStuffHoles == foodstuff){
			mkActStat = EN_MONKEY_Holes;
			[self setMonkeyFaint];
		}
		else if (ZAStuffKY == foodstuff){
			_state = ZAEmotionJoyful;
			mkActStat = EN_MONKEY_KY;
		}
		else
		{
			if(mkActStat == EN_MONKEY_NORMAL )
			{	
				mkActStat = EN_MONKEY_GETFOOD;
				mkHdState = foodstuff;
				return YES;
			}	
			if(mkActStat == EN_MONKEY_DEMO)
			{
				mkHdState = foodstuff;
				return YES;			
			}	
		}	
	}
	
	if(ZAStuffBanana == foodstuff)
	{
		_rightScores += CORRECTSCORE1;
		_curfeedingcounts++;
		if(_totfeedingcounts == 99)
			_isStuffed = NO;
		else
		{
			if((_curfeedingcounts>=_totfeedingcounts)&&(_curfeedingcounts2>=_totfeedingcounts2)&&(_curfeedingcounts3>=_totfeedingcounts3)&&(_curfeedingcounts4>=_totfeedingcounts4))
			{
				_isStuffed = YES;
			}				
		}	
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE1 playorstop:YES];
		return YES;
	}
	else if (ZAStuffLeaf == foodstuff){
		_rightScores += CORRECTSCORE2;
		_curfeedingcounts2++;
		if(_totfeedingcounts2 == 99)
			_isStuffed = NO;
		else
		{
			if((_curfeedingcounts>=_totfeedingcounts)&&(_curfeedingcounts2>=_totfeedingcounts2)&&(_curfeedingcounts3>=_totfeedingcounts3)&&(_curfeedingcounts4>=_totfeedingcounts4))
			{
				_isStuffed = YES;
			}				
		}	
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE4 playorstop:YES];
		return YES;
	}
	else if (ZAStuffMeat == foodstuff){
		_rightScores += CORRECTSCORE3;
		_curfeedingcounts3++;
		if(_totfeedingcounts3 == 99)
			_isStuffed = NO;
		else
		{
			if((_curfeedingcounts>=_totfeedingcounts)&&(_curfeedingcounts2>=_totfeedingcounts2)&&(_curfeedingcounts3>=_totfeedingcounts3)&&(_curfeedingcounts4>=_totfeedingcounts4))
			{
				_isStuffed = YES;
			}				
		}	
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE5 playorstop:YES];
		return YES;
	}
	else if (ZAStuffCarrot == foodstuff){
		_rightScores += CORRECTSCORE4;
		_curfeedingcounts4++;
		if(_totfeedingcounts4 == 99)
			_isStuffed = NO;
		else
		{
			if((_curfeedingcounts>=_totfeedingcounts)&&(_curfeedingcounts2>=_totfeedingcounts2)&&(_curfeedingcounts3>=_totfeedingcounts3)&&(_curfeedingcounts4>=_totfeedingcounts4))
			{
				_isStuffed = YES;
			}				
		}	
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE6 playorstop:YES];
		return YES;
	}
	else if (ZAStuffBattery == foodstuff){
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE2 playorstop:YES];
		return YES;
	}
	else if (ZAStuffKY == foodstuff){
		_state = ZAEmotionJoyful;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE3 playorstop:YES];
		return YES;
	}
	else if (ZAStuffRoadBlock == foodstuff)
	{
		_state = ZAEmotionAngry;
		//[self PlaySoundByAnimalType];
		[gameView PlaySoundEffect:EN_FOODTYPE7 playorstop:YES];
		return NO;
	}
	else if (ZAStuffHoles == foodstuff)
	{
		_state = ZAEmotionAngry;
		[gameView PlaySoundEffect:EN_FOODTYPE8 playorstop:YES];
		return NO;
	}
	else 
	{
		_state = ZAEmotionAngry;
		[gameView PlaySoundEffect:EN_FOODTYPE8 playorstop:YES];
		return NO;
	}
} 

-(void)PlaySoundByAnimalType 
{
	
}

- (void) drawImageWithFade:(GLfloat)fadelevel {
	
	[super drawImageWithFade:fadelevel];
	
	if(mkActStat == EN_MONKEY_DEMO)
	{
		//if(demoTouchCnt >= 0)
		if(demoTouchCnt == -1)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt == 0)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:3 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];		
		else if(demoTouchCnt == 1)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:6 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt == 2)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:9 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt == 3)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:1 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt == 4)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:4 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt == 5 )
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:7 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		else if(demoTouchCnt >= 7 && demoTouchCnt < 90)
		{
			if(figmovD < 90)
			{	
				if(figmovD < 50)
					[finger drawImageWithNo:CGPointMake(_pos.x+30, _pos.y+figmovD) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f  scaleZ:1.0f alpha:fadelevel];			
				else	
					[finger drawImageWithNo:CGPointMake(_pos.x+30, _pos.y+figmovD) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:(1.0f+(figmovD-50)*.01) scaleY:(1.0f+(figmovD-50)*.01)  scaleZ:1.0f alpha:fadelevel];			
			}	
			else
				demoTouchCnt ++;	
		}
#if 1	
		else if(demoTouchCnt >= 99 )
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];		
#endif
	}	
	
	if(mkActStat == EN_MONKEY_DEMO_FINISH)
	{
		if((demoFinishCnt/_SYSTEM_FRAME_COUNT_PER_SEC_) == 1)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:2 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:(scaleState- 0.05*(demoFinishCnt%_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleY:(scaleState- 0.05*(demoFinishCnt%_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleZ:1.0f alpha:fadelevel];

		if((demoFinishCnt/_SYSTEM_FRAME_COUNT_PER_SEC_) == 2)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:5 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:(scaleState- 0.05*(demoFinishCnt-_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleY:(scaleState- 0.05*(demoFinishCnt-_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleZ:1.0f alpha:fadelevel];

		if((demoFinishCnt/_SYSTEM_FRAME_COUNT_PER_SEC_) == 3)
			[Demoimg drawImageWithNo:CGPointMake(160.0, 320.0) no:8 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:(scaleState- 0.05*(demoFinishCnt%_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleY:(scaleState- 0.05*(demoFinishCnt%_SYSTEM_FRAME_COUNT_PER_SEC_)) scaleZ:1.0f alpha:fadelevel];

	}
	
	if (InCar10 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x-5, _pos.y+60) no:InCar10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar9 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x-50, _pos.y+30) no:InCar9 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar8 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x+30, _pos.y+45) no:InCar8 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar7 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x-35, _pos.y+40) no:InCar7 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar6 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x+30, _pos.y+15) no:InCar6 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar5 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x, _pos.y+40) no:InCar5 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar4 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x+10, _pos.y+10) no:InCar4 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar3 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x-30, _pos.y+10) no:InCar3 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar2 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x+20, _pos.y-20) no:InCar2 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	if (InCar1 != 99)
		[AnimInCar1 drawImageWithNo:CGPointMake(_pos.x-20, _pos.y-20) no:InCar1 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	
	[Car_Ass drawImageWithNo:CGPointMake(_pos.x, _pos.y) no:Car_ass_no angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:1];
	
	if (_imgScore) //Monkey
	{
		char str[10] = "";
		int x = 20;
		int y = 430;

		[foodIdx drawImageWithNo:CGPointMake(x, y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x += 20;
		
		if(_totfeedingcounts == 99)
		{	
			sprintf(str, "%d", _curfeedingcounts);
			for (int i = 0; i < strlen(str); i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
		}	
		else
		{	
			sprintf(str, "%02d", _curfeedingcounts);
			for (int i = 0; i < 2; i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
			[_imgScore drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:SCORESCALE scaleZ:SCORESCALE alpha:fadelevel];
			x +=FOODNUMBERSOFFSET;
			sprintf(str, "%02d", _totfeedingcounts);
			for (int i = 0; i < 2; i++) {
				[_imgScore drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}								
		}	
	}
	if (_imgScore1&&_totfeedingcounts2>0) //Kiwi
	{
		char str[10] = "";
		int x = 20;
		int y = 370;
		
		[foodIdx1 drawImageWithNo:CGPointMake(x, y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x += 20;
		
		if(_totfeedingcounts2 == 99)
		{	
			sprintf(str, "%d", _curfeedingcounts2);
			for (int i = 0; i < strlen(str); i++) {
				[_imgScore1 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
		}	
		else
		{	
			sprintf(str, "%02d", _curfeedingcounts2);
			for (int i = 0; i < 2; i++) {
				[_imgScore1 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
			[_imgScore drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:SCORESCALE scaleZ:SCORESCALE alpha:fadelevel];
			x +=FOODNUMBERSOFFSET;
			sprintf(str, "%02d", _totfeedingcounts2);
			for (int i = 0; i < 2; i++) {
				[_imgScore1 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}								
		}	
	}
	if (_imgScore2&&_totfeedingcounts3>0) //Lion
	{
		char str[10] = "";
		int x = 20;
		int y = 340;
		
		[foodIdx2 drawImageWithNo:CGPointMake(x, y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x += 20;
		
		if(_totfeedingcounts3 == 99)
		{	
			sprintf(str, "%d", _curfeedingcounts3);
			for (int i = 0; i < strlen(str); i++) {
				[_imgScore2 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
		}	
		else
		{	
			sprintf(str, "%02d", _curfeedingcounts3);
			for (int i = 0; i < 2; i++) {
				[_imgScore2 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
			[_imgScore2 drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:SCORESCALE scaleZ:SCORESCALE alpha:fadelevel];
			x +=FOODNUMBERSOFFSET;
			sprintf(str, "%02d", _totfeedingcounts3);
			for (int i = 0; i < 2; i++) {
				[_imgScore2 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}								
		}	
	}
	if (_imgScore3&&_totfeedingcounts4>0) //Rabbit
	{
		char str[10] = "";
		int x = 20;
		int y = 400;
		
		[foodIdx3 drawImageWithNo:CGPointMake(x, y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x += 20;
		
		if(_totfeedingcounts3 == 99)
		{	
			sprintf(str, "%d", _curfeedingcounts4);
			for (int i = 0; i < strlen(str); i++) {
				[_imgScore3 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
		}	
		else
		{	
			sprintf(str, "%02d", _curfeedingcounts4);
			for (int i = 0; i < 2; i++) {
				[_imgScore3 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}			
			[_imgScore3 drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:SCORESCALE scaleZ:SCORESCALE alpha:fadelevel];
			x +=FOODNUMBERSOFFSET;
			sprintf(str, "%02d", _totfeedingcounts4);
			for (int i = 0; i < 2; i++) {
				[_imgScore3 drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:SCORESCALE scaleY:SCORESCALE scaleZ:1.0f alpha:fadelevel];
				x += FOODNUMBERSOFFSET;
			}								
		}	
	}
	
}

+(NSInteger) ZACountingScores:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	NSInteger totalScores = 0;
	for(idx=0;idx< zaCounts;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		totalScores += zaObj.rightScores; 
	}
	return totalScores;
}
//pohsu{
+(NSInteger) ZACountingFailedScores:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	NSInteger totalFailedScores = 0;
	for(idx=0;idx< zaCounts;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		totalFailedScores += zaObj.wrongScores; 
	}
	return totalFailedScores;
}
//pohsu}

-(BOOL) getStuffedVal
{
	return _isStuffed;
}

+(NSInteger) ZooAnimalsAllStuffed:(NSMutableArray*) zooAnimalArray{
	int idx = 0;
	int zaCounts = [zooAnimalArray count];
	ZooAnimal* zaObj;
	BOOL bStuffed;
	for(idx=0;idx< zaCounts;idx++)
	{
		zaObj = [zooAnimalArray objectAtIndex:idx];
		bStuffed = [zaObj getStuffedVal]; 
		if(bStuffed!=YES)
		{
			return 0;
		}
	}
	return 1;
}

- (void) dealloc {

	if(plusScore!= nil)
		[plusScore release];
	plusScore = nil;
	
	if(Demoimg!= nil)
		[Demoimg release];
	Demoimg = nil;
	
	if(finger != nil)
		[finger release];
	finger = nil;
		
	if(_imgScore!=nil)
		[_imgScore release];
	_imgScore = nil;
	if(_imgScore1!=nil)
		[_imgScore1 release];
	_imgScore1 = nil;
	if(_imgScore2!=nil)
		[_imgScore2 release];
	_imgScore2 = nil;
	if(_imgScore3 !=nil)
		[_imgScore3 release];
	_imgScore3 = nil;
	
	if(plusScore !=nil)
		[plusScore release];
	plusScore = nil;
	
	if(plusScore !=nil)
		[plusScore release];
	plusScore = nil;

	if(foodIdx !=nil)
		[foodIdx release];
	foodIdx = nil;
	 
	if(foodIdx1 !=nil)
		[foodIdx1 release];
	foodIdx1 = nil;
	
	if(foodIdx2 !=nil)
		[foodIdx2 release];
	foodIdx2 = nil;
	
	if(foodIdx3 !=nil)
		[foodIdx3 release];
	foodIdx3 = nil;
	
	if(AnimInCar1 !=nil)
		[AnimInCar1 release];
	AnimInCar1 = nil;
	
	if (Car_Ass != nil)
		[Car_Ass release];
	Car_Ass = nil;
	
	[SESoundObj release];
	[super dealloc];
}
@end
