//
//  Score.m
//  game
//
//  Created by fih on 2009/9/28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Score.h"
#import "AnimObj.h"
#import "EAGLView.h"
#import "mainGame.h"
#import "ZooAnimal.h"
#import "SimpleButton.h"
#import "FBObj.h"
//Twitter {
#import "TwitterObj.h"
//Twitter }
#define perAddScore 30 
#define FACEBOOKPOSITION CGPointMake(100, 140)
#define TWITTERPOSITION CGPointMake(220, 136)




@implementation ScoreObj
@synthesize scoreShow;
@synthesize totalscores;
@synthesize gameStageState;

@synthesize subScoreShow;
@synthesize rightScoreShow;
@synthesize wrongScoreShow;
@synthesize timeScoreShow;

@synthesize subScores;
@synthesize rightScores;
@synthesize wrongScores;
@synthesize timeScores;
//Twitter {
@synthesize twsubmit_status; 
//Twitter }

@synthesize bSubMinus;
@synthesize bGrandMinus;
- (BOOL) initScore:(id)view
{
	EAGLView *gameView = view;
	//CGRect mainbounds = gameView.bounds;
//	mainGame* main_Game = gameView.main_Game;
	gameStageState = gameView.main_Game.gameStageState;
	
	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@"MNU_Zooff_C_Scores.png"];
	if (gameView.background != nil) {
		if ([gameView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
		{	
			// Landscape and the home button on the right side
			[gameView.background SetTileSize:img_bg_score_pos_x tileHeight:img_bg_score_pos_y];
		}
		else
		{	// Portrait mode
			[gameView.background SetTileSize:img_bg_score_pos_y tileHeight:img_bg_score_pos_x];
		}
	}
	
	gameView.frameCount = 0;  // init frame count
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		// create A character object
		//[imgScore drawImageWithNo:]
		AnimObj *obj;

		obj = [gameView.animManager requestWithObj:[[ScoreObj alloc] initWithStart] strName:@"MNU_Zooff_C_Scores.png" tileWidth:320 tileHeight:480];
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(160, 240);
			obj.no = 0;
			obj.type = 15;
		}	
		
		obj = [gameView.animManager requestWithObj:[[ScoreObj alloc] initWithStart] strName:@"END_Zoo_C_Scores_Number.png" tileWidth:SCORE_TILEWIDTH tileHeight:SCORE_TILEHEIGH];// up key
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(20, 100);
			obj.no = 0;
			obj.type = 1;
		}	
		
		//load PTS pic
		obj = [gameView.animManager requestWithObj:[[ScoreObj alloc] initWithStart] strName:@"END_Zoo_C_Scores_Pts.png" tileWidth:70 tileHeight:70];// up key
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(20, 165);
			obj.no = 0;
			obj.type = 4;
		}	
		
		//load icon pic
		obj = [gameView.animManager requestWithObj:[[ScoreObj alloc] initWithStart] strName:@"END_Zoo_C_Class.png" tileWidth:60 tileHeight:60];// up key
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(77, 260);
			obj.no = 0;
			obj.type = 13;
		}	
#if 1
		/*Max added */
	//	FBObj *toFace = [[FBObj alloc]initWithType:FBButtonType_Connect Position:CGPointMake(435, 305)];
		FBObj *toFace = [[FBObj alloc]initWithType:FBButtonType_Connect Position:FACEBOOKPOSITION];
		[gameView.animManager requestWithObj:toFace];
		/*Max added*/		

		/*Max added */
//		FBObj *toPost = [[FBObj alloc]initWithType:FBButtonType_Post Position:CGPointMake(435, 305)];
		FBObj *toPost = [[FBObj alloc]initWithType:FBButtonType_Post Position:FACEBOOKPOSITION];
		[gameView.animManager requestWithObj:toPost];
		/*Max added*/		
		
#endif		
		//Twitter {
		FBObj *toTwitter = [[TwitterObj alloc]initWithType:TWButtonType_Connect Position:TWITTERPOSITION];
		[gameView.animManager requestWithObj:toTwitter];
		FBObj *toTwitterPost = [[TwitterObj alloc]initWithType:TWButtonType_Post Position:TWITTERPOSITION];
		[gameView.animManager requestWithObj:toTwitterPost];
		
		twsubmit_status = TWITTER_SUBMIT_NONE;
		//Twitter }
		
		SimpleButton *nextBtn = nil;
		switch (gameStageState) {
			case GSStateGameOver:
				 nextBtn = [[SimpleButton alloc]initWithType:SBTypeScoreNext Position:CGPointMake(158, 40)];
				break;
			case GSStateGameSucceed:
				{
					if(gameView.main_Game.gameLevel < gameView.main_Game.gameMaxLevel)
					{
						nextBtn = [[SimpleButton alloc]initWithType:SBTypeScoreNextLev Position:CGPointMake(158, 40)];

					}
					else
					{
						nextBtn = [[SimpleButton alloc]initWithType:SBTypeScoreNext Position:CGPointMake(158, 40)];

					}
				}
				break;
			default:
				break;
		}
       
		[gameView.animManager requestWithObj:nextBtn];	

	}

	[gameView fadeInWithState:GS_PROCESS_SCORE];
	return TRUE;
}

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view {
	EAGLView *gameView = view;
	static BOOL play_sfx = YES;
	//static int Count_SFX = 30;
	gameStageState = gameView.main_Game.gameStageState;
	//score counting
	totalscores = gameView.main_Game.grandTotalScore;
	//subScores = gameView.main_Game.subTotalScore; // pohsu tmp
	timeScores = gameView.main_Game.timeBonus;
	wrongScores = gameView.main_Game.wrongFoodScore;
	rightScores = gameView.main_Game.rightFoodScore;
	
	
	if(gameStageState == GSStateGameSucceed)
	{	
		iconGameLevel = gameView.main_Game.gameLevel; //maxpan add
		if(21 == gameView.main_Game.gameLevel)
			iconGameLevel = 21;	
	}	
	else
		iconGameLevel = gameView.main_Game.gameLevel-1;
	
	if(rightScores < 0)
		rightScores = 0;
	if(wrongScores < 0)
		wrongScores = 0;
	if(timeScores < 0)
		timeScores =0;
    
        if(_count > 30)
        {
			//right food score
			if(rightScoreShow < rightScores)
				rightScoreShow += rightScores/perAddScore;
			else
				rightScoreShow = rightScores;
			
			//wrong food score
			if(wrongScoreShow < wrongScores)
				wrongScoreShow += wrongScores/perAddScore;
			else
				wrongScoreShow = wrongScores;
			
			//time bonus score
			if(timeScoreShow < timeScores)
				timeScoreShow += timeScores/perAddScore;
			else
				timeScoreShow = timeScores;
			
			//subtotal score
			//subScores = timeScores+rightScores -wrongScores; //tmp pohsu
			subScores = rightScores; //tmp pohsu
			if(subScores < 0)
			{
#if 1			// remove minus case		
				subScores = 0;
#else				
				subScores = abs(subScores);
				bSubMinus = TRUE;
#endif				
			}
			
			if(subScoreShow < subScores)
			{
				subScoreShow += subScores/perAddScore;
				play_sfx = YES;
			}
			else
				subScoreShow = subScores;
				

			//grand total score
			if(totalscores < 0)
			{
#if 1			// remove minus case		
				totalscores = 0;
#else				
				totalscores = abs(totalscores);
				bGrandMinus = TRUE;
#endif					
			}
			
			if(totalscores < subScores)
				totalscores = subScores;
			
        	if(scoreShow < totalscores)
			{
				scoreShow += totalscores/perAddScore;
				play_sfx = YES;
			}
			else
			{
				scoreShow = totalscores;
				play_sfx = NO;
			}
				
			//if ((--Count_SFX == 0)&&(play_sfx == YES))
			if ((_count%5 == 0)&&(play_sfx == YES))
			{
				[gameView PlaySoundEffect:EN_BUTTONPRESS playorstop:YES];
				//Count_SFX = 15;
			}
			
        }
        _count++; 
	
	return 0;
}


- (void) drawImageWithFade:(GLfloat)fadelevel {
	//draw score
	//int x;
	//int y;

//	[charLayer drawImageWithNo:CGPointMake(160, 240) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	
	if(_type == 15)
	{
		[_image drawImageWithNo:CGPointMake(160, 240) no:_no angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	}	
	
	if(_type == 1)
	{
		if(_image) 
			{	
			//[self drawRightFoodScore:fadelevel];
			//[self drawWrongFoodScore:fadelevel];
			//[self drawTimeBonusScore:fadelevel];
			//[self drawSubTotalScore:fadelevel];
			[self drawGrandTotalScore:fadelevel];
		}
	}	
	//draw PTS
	else if(_type == 4)
	{
		//x = SCORE_X + 50;	
		//y = 75;
		//[_image drawImageWithNo:CGPointMake(x, y) no:_no angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	}
	//draw icon
	else if(_type == 13)
	{
		if(iconGameLevel <= 7)
		{
			_no = 0;
		}
		else if(iconGameLevel > 7 && iconGameLevel <= 14)
		{
			_no = 1;

		}
		else if(iconGameLevel > 14 && iconGameLevel <= 20)
		{
			_no = 2;
		}
		else if(iconGameLevel > 20)
		{
			_no = 3;
		}

//		[_image drawImageWithNo:CGPointMake(77, 260) no:_no angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		
	}	
	

}

- (BOOL)processScore:(id)view {
	return TRUE;
}
-(BOOL)endScore:(id)view {
	EAGLView *gameView = view;
	mainGame* main_Game = gameView.main_Game;
	
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	
	
	//Twitter {
	gameView.main_score.twsubmit_status =  TWITTER_SUBMIT_NONE;
	[gameView.tw_name  release];
	[gameView.tw_pw release];
	//Twitter }
	
	
	// process to next state
	//gameView.gameState = GS_INIT_TITLE;
	switch (gameStageState) {
		case GSStateGameSucceed:
			{
				if(main_Game.gameLevel < main_Game.gameMaxLevel) /*main_Game.gameLevel not reach max value*/
				{
					//gameView.gameState = GS_INIT_GAME;
					[gameView fadeInWithState:GS_INIT_GAME];
					
				}
				else
				{
					[gameView.main_Game endGame:view];//JarshChen 20091012 
					#ifdef LITE_VERSION
						gameView.gameState = GS_INIT_FULLVER;
					#else
						if([self isAbleToRanking:view]) 
						{
							/*if in the ranking*/
							gameView.gameState = GS_INIT_INPUT;
						}
						else
						{
							gameView.main_ranking.sbType = SBTypeRankingNext;
							gameView.gameState = GS_INIT_RANKING;
							gameView.enableEndless = _ENABLE_ENDLESS_MODE_;
						}
					#endif
						
						
				}
			}
			break;
		case GSStateGameOver:
			{
				//gameover, clean GrandTotalScore
				//write nv
				if(gameView.endlessMode == _INIFINITY_TIME_LEVEL)
					gameView.endlessMode = 0;
				
				gameView.grandTotalScore = 0;
				[gameView saveToFileSystem];
				#ifdef LITE_VERSION
				    gameView.gameState = GS_INIT_FULLVER;
				#else
					if([self isAbleToRanking:view]) /*if in the ranking*/
					{
						gameView.gameState = GS_INIT_INPUT;
					}
					else
					{
						gameView.main_ranking.sbType = SBTypeRankingNext;
						gameView.gameState = GS_INIT_RANKING;
					}
				#endif
			}
			break;
		default:
			break;
	}
	return TRUE;
}
- (void)dealloc {
	[super dealloc];
}
-(BOOL) isAbleToRanking:(id)view
{
	EAGLView *gameView = view;
	NSInteger cur_rank;
	cur_rank = [gameView.scoreRanking checkRanking:gameView.main_Game.grandTotalScore];
	if (cur_rank < 20 )
		return TRUE;
	else
		return FALSE;
}

- (BOOL) drawRightFoodScore:(GLfloat)fadelevel
{
	char str[10] = "";
	int hundred;
	int thousand;
	int million;
	int x;
	int y;
	
	hundred = rightScoreShow%1000;
	thousand = rightScoreShow/1000;
	million = rightScoreShow/1000000;
	
	//format:999
	if(rightScores<1000) 
	{
		x = SCORE_X;
		y = SCORE_Y;
		sprintf(str, "%0d", hundred);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
	}
	//format:999,999
	else if(rightScores>=1000 && rightScores<1000000)
	{	
		x = SCORE_X;
		y = SCORE_Y;
		sprintf(str, "%03d", hundred);
		for (int i = 2; i >=0 ; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
		//dot
		[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x -= 20;
		
		sprintf(str, "%0d", thousand);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}		
	}	
	//plus symbol
	[_image drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];

	return TRUE;
}


- (BOOL) drawWrongFoodScore:(GLfloat)fadelevel
{
	char str[10] = "";
	int hundred;
	int thousand;
	int million;
	int x;
	int y;
	
	hundred = wrongScoreShow%1000;
	thousand = wrongScoreShow/1000;
	million = wrongScoreShow/1000000;
	
	//format:999
	if(wrongScores<1000) 
	{
		x = SCORE_X;
		y = SCORE_Y - SCORE_NEXT_Y ;
		sprintf(str, "%d", hundred);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
	}
	//format:999,999
	else if(wrongScores>=1000 && wrongScores<1000000)
	{	
		x = SCORE_X;
		y = SCORE_Y - SCORE_NEXT_Y;
		sprintf(str, "%03d", hundred);
		for (int i = 2; i >=0 ; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
		//dot
		[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x -= 20;
		sprintf(str, "%0d", thousand);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}		
	}	
	
	//minus symbol
	[_image drawImageWithNo:CGPointMake(x, y) no:11 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	return TRUE;
}


- (BOOL) drawTimeBonusScore:(GLfloat)fadelevel
{
	char str[10] = "";
	int hundred;
	int thousand;
	int million;
	int x;
	int y;
	
	hundred = timeScoreShow%1000;
	thousand = timeScoreShow/1000;
	million = timeScoreShow/1000000;
	
	//format:999
	if(timeScores<1000) 
	{
		x = SCORE_X;
		y = SCORE_Y - 2*SCORE_NEXT_Y;
		sprintf(str, "%0d", hundred);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
	}
	//format:999,999
	else if(timeScores>=1000 && timeScores<1000000)
	{	
		x = SCORE_X;
		y = SCORE_Y - 2*SCORE_NEXT_Y;
		sprintf(str, "%03d", hundred);
		for (int i = 2; i >=0 ; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
		//dot
		[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x -= 20;
		
		sprintf(str, "%0d", thousand);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}		
	}	
	//plus symbol
	[_image drawImageWithNo:CGPointMake(x, y) no:10 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	return TRUE;
}

- (BOOL) drawSubTotalScore:(GLfloat)fadelevel
{
	char str[10] = "";
	int hundred;
	int thousand;
	int million;
	int x;
	int y;
	
	hundred = subScoreShow%1000;
	thousand = subScoreShow/1000;
	million = subScoreShow/1000000;
	
	//format:999
	if(subScores<1000) 
	{
		x = SCORE_X;
		y = SCORE_Y2;
		sprintf(str, "%0d", hundred);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
	}
	//format:999,999
	else if(subScores>=1000 && subScores<1000000)
	{	
		x = SCORE_X;
		y = SCORE_Y2;
		sprintf(str, "%03d", hundred);
		for (int i = 2; i >=0 ; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}
		//dot
		[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
		x -= 20;
		sprintf(str, "%0d", thousand);
		for (int i = strlen(str)-1; i >= 0; i--) {
			[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= SCORE_TILEWIDTH;
		}		
	}	
	
	if(bSubMinus)
	{
		//minus symbol
		[_image drawImageWithNo:CGPointMake(x, y) no:11 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];

	}
	return TRUE;
}

- (BOOL) drawGrandTotalScore:(GLfloat)fadelevel
{
		char str[10] = "";
		int hundred;
		int thousand;
		int million;
		int x;
		int y;
	
		hundred = scoreShow%1000;
		thousand = scoreShow/1000;
		million = scoreShow/1000000;
		
		//format:999
		if(totalscores<1000) 
		{
			x = SCORE_X;
			//y = SCORE_Y2 - SCORE_NEXT_Y;
			y = SCORE_Y;
			sprintf(str, "%0d", hundred);
			for (int i = strlen(str)-1; i >= 0; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}
		}
		//format:999,999
		else if(totalscores>=1000 && totalscores<1000000)
		{	
			x = SCORE_X;
			//y = SCORE_Y2 - SCORE_NEXT_Y;
			y = SCORE_Y;
			sprintf(str, "%03d", hundred);
			for (int i = 2; i >=0 ; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}
			//dot
			[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= 20;
			sprintf(str, "%0d", thousand);
			for (int i = strlen(str)-1; i >= 0; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}		
		}
		//format :999,999,999
		else if(totalscores>=1000000)
		{	
			x = SCORE_X;
			y = SCORE_Y2 - SCORE_NEXT_Y;
			sprintf(str, "%d", hundred);
			for (int i = strlen(str)-1; i >= 0; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}
			//dot
			[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= 15;
			sprintf(str, "%0d", thousand);
			for (int i = strlen(str)-1; i >= 0; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}
			//dot
			[_image drawImageWithNo:CGPointMake(x, y-10) no:12 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
			x -= 15;
			sprintf(str, "%d", million);
			for (int i = strlen(str)-1; i >= 0; i--) {
				[_image drawImageWithNo:CGPointMake(x, y) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
				x -= SCORE_TILEWIDTH;
			}				
			
		}
	if(bGrandMinus)
	{
		//minus symbol
		[_image drawImageWithNo:CGPointMake(x, y) no:11 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadelevel];
	}
		
	return TRUE;
}
@end
