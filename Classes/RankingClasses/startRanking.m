//
//  startRanking.m
//  game
//
//  Created by FIH on 2009/9/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#define img_bg_game "End_Zooff_C_EnterName_BG.png" // background of Input editor 
#import "startRanking.h"
#import "SimpleButton.h"

extern NSInteger NewRecordIdx;

EDITORPOSITION landScapeRanking[] = {
{rank_x, rank_y, rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*1 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*1, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*2 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*2, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*3 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*3, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*4 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*4, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*5 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*5, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*6 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*6, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*7 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*7, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*8 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*8, rank_number_width, rank_number_height},
{rank_x, rank_y - rank_offset_y*9 , rank_name_width, rank_name_height},{rank_x+rank_offset_x, rank_y - rank_offset_y*9, rank_number_width, rank_number_height},
{0, 0, 0, -1}
};
EDITORPOSITION portraitRanking[] = {
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35}, 
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{0, 0, 0, -1}
};
EDITORPOSITION *editorRanking[] = {
landScapeRanking,
portraitRanking,
NULL
};


@implementation startRanking
@synthesize imgRankingScore;
@synthesize imgRankingName;
@synthesize imgRankingBar;
@synthesize imgFocusBar;
@synthesize currentStartRecord;
@synthesize recordPerPage;
@synthesize sbType;

#ifdef FIG_GLOBAL_RANKING
@synthesize topIndexList;
@synthesize topNameList;
@synthesize topScoreList;
//@synthesize isLoading;
@synthesize TopScore;
@synthesize isSendGlobRank;
#endif

-(BOOL)initRanking:(id)view
{
	EAGLView *gameView = view;
	
	gameView.isLocalRank = YES;
	if(NewRecordIdx< 11) //the first page
	currentStartRecord = 0; // first page = 0 secode page = 10
	else
		currentStartRecord = 10;
	
	recordPerPage = 10;

	// backupground
	gameView.background = [[Texture2D alloc] fromFile:@img_bg_ranking_name];
	if (gameView.background != nil) {
		if ([gameView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
		{	
			// Landscape and the home button on the right side
			[gameView.background SetTileSize:img_bg_ranking_pos_x tileHeight:img_bg_ranking_pos_y];
		}
		else
		{	// Portrait mode
			[gameView.background SetTileSize:img_bg_ranking_pos_y tileHeight:img_bg_ranking_pos_x];
		}
	}
	gameView.frameCount = 0;  // init frame count
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		// create A character object
		//[imgScore drawImageWithNo:]
		AnimObj *obj;
		
		obj = [gameView.animManager requestWithObj:[[RankObj alloc] initWithStart] strName:@"MNU_Zooff_C_Rank_BG.png" tileWidth:160 tileHeight:400];// up key
		if (obj != nil) 
		{
			// init
			obj.pos = CGPointMake(160, 240);
			obj.no = 0;
			obj.type = 19;
		}	
		
		obj = [gameView.animManager requestWithObj:[[RankObj alloc] initWithStart] strName:@img_up_down_back_name tileWidth:img_upDownBack_width tileHeight:img_upDownBack_height];// up key
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(upPage_x, upPage_y);
			obj.no = 0;
			obj.type = 1;
		}	
		obj = [gameView.animManager requestWithObj:[[RankObj alloc] initWithStart] strName:@img_up_down_back_name tileWidth:img_upDownBack_width tileHeight:img_upDownBack_height];// down key
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(downPage_x, downPage_y);
			obj.no = 1;
			obj.type = 2;
		}
		obj = [gameView.animManager requestWithObj:[[RankObj alloc] initWithStart] strName:@"btn_back.png" tileWidth:64 tileHeight:64];// Back to the previous state
		if (obj != nil) {
			// init
			obj.pos = CGPointMake(160.0, 30.0);
			obj.no = 0;
			obj.type = 3;
		}
		/*Jarsh added */
		SimpleButton *nextBtn = [[SimpleButton alloc]initWithType:sbType Position:CGPointMake(btn_x, btn_y)];
		[gameView.animManager requestWithObj:nextBtn];
		
		RankingBtn = [[SimpleButton alloc]initWithType:SBTypeLocalRank Position:CGPointMake(160, 450)];
		[gameView.animManager requestWithObj:RankingBtn];

		/*Jarsh added*/
		
	}
	[gameView.topNameList removeAllObjects];
	[gameView.topScoreList removeAllObjects];
	[gameView.scoreRanking getAllRankingInfo:gameView.topNameList scoreInfo:gameView.topScoreList];
	
	//load the 0 - 9 score img
	imgRankingScore = [[Texture2D alloc] fromFile:@img_number_name];
	if (imgRankingScore != nil) {
		[imgRankingScore SetTileSize:rank_number_width tileHeight:rank_number_height];
	}
	//load the A-Z 0-9 imgName
	imgRankingName =  [[Texture2D alloc] fromFile:@img_ranking_name];
	if (imgRankingName != nil) {
		[imgRankingName SetTileSize:rank_name_width tileHeight:rank_name_height];	
	}
	//load score bar
	imgRankingBar =  [[Texture2D alloc] fromFile:@img_ranking_bar];
	if (imgRankingBar != nil) {
		[imgRankingBar SetTileSize:rank_bar_width tileHeight:rank_bar_height];	
	}
	//load focus bar
	imgFocusBar =  [[Texture2D alloc] fromFile:@img_focus_bar];
	if (imgFocusBar != nil) {
		[imgFocusBar SetTileSize:rank_bar_width tileHeight:rank_bar_height];	
	}

#ifdef FIG_GLOBAL_RANKING

		
	if(topIndexList) {
		[topIndexList removeAllObjects];
	}
	topIndexList =[[NSMutableArray alloc]init];
	
	if(topNameList) {
		for(int i=0; i<[topNameList count]; i++) {
			[[topNameList objectAtIndex:i] release];
		}
		[topNameList removeAllObjects];
	}
	topNameList =[[NSMutableArray alloc]init];
	
	if(topScoreList) {
		[topScoreList removeAllObjects];
	}
	topScoreList =[[NSMutableArray alloc]init];
	
	rankHelper = [RankHelper alloc];
	if(rankHelper) {
		[rankHelper initWithView:view delegate:self];
		[rankHelper setGameName:@"RunRunRun"];
	}
	
	//isLoading = NO;
	pView = view;
    //get global ranking data
	//[self getGlobalRank];
	
#endif	
	
	[gameView fadeInWithState:GS_PROCESS_RANKING];
	return TRUE;
}


-(BOOL)drawLocalRanking:(id)view fadeLevel:(GLfloat)fadeLevel
{
	EAGLView *gameView = view;	
	if (imgRankingScore && imgRankingName) {			
		EDITORPOSITION *editorRankingInfo = editorRanking[RANK_LS];//landScape or portarit. //Wayne
		const char *str;
		int x = 0;
		for(int j = 0; j < recordPerPage; j++){
			if( (j+currentStartRecord) < [gameView.topNameList count]){
				NSString *tempScore = [[gameView.topScoreList objectAtIndex:(j+currentStartRecord)] stringValue];
				NSMutableString *tempName = [gameView.topNameList objectAtIndex:(j+currentStartRecord)];
				int _offsetName = 0;
				int _offsetScore = 0;
				str = [tempScore UTF8String];
				//draw score bar
				//if(j%2)
				//[imgRankingBar drawImageWithNo:CGPointMake(160, editorRankingInfo[j+x].y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.5f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel/2];
				//else
				//[imgRankingBar drawImageWithNo:CGPointMake(160, editorRankingInfo[j+x].y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.6f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
					
				//draw indication bar
				if( (j+currentStartRecord) == NewRecordIdx-1 )
				{
					[imgFocusBar drawImageWithNo:CGPointMake(160, editorRankingInfo[j+x].y-6) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.1f scaleY:1.2f scaleZ:1.0f alpha:fadeLevel];
				}
				
				
				//draw Ranking name 
				for(int i = 0; i < [tempName length]; i++){
					int num = [tempName characterAtIndex:i];
					[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:(num - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
					_offsetName = _offsetName+editorRankingInfo[j+x].width;
				}
				//draw score
				for (int i = strlen(str)-1; i >= 0; i--) {
					[imgRankingScore drawImageWithNo:CGPointMake(editorRankingInfo[j+x+1].x-_offsetScore, editorRankingInfo[j+x+1].y-STRING_OFFSET) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
					_offsetScore = _offsetScore+editorRankingInfo[j+x+1].width;
				}	
				x++;
			}
			else
			{
				int _offsetName = 0;
				int _offsetScore = 0;
				[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:('N' - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetName = _offsetName+editorRankingInfo[j+x].width;
				[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:('A' - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetName = _offsetName+editorRankingInfo[j+x].width;
				[imgRankingScore drawImageWithNo:CGPointMake(editorRankingInfo[j+x+1].x-_offsetScore, editorRankingInfo[j+x+1].y-STRING_OFFSET) no:('0' - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetScore = _offsetScore+editorRankingInfo[j+x+1].width;
				x++;
			}
		}
	}	
	return TRUE;
}

-(BOOL)drawGlobalRanking:(id)view fadeLevel:(GLfloat)fadeLevel
{
	//EAGLView *gameView = view;	
	//return TRUE;
	if (imgRankingScore && imgRankingName) {			
		EDITORPOSITION *editorRankingInfo = editorRanking[RANK_LS];//landScape or portarit. //Wayne
		const char *str;
		int x = 0;
		for(int j = 0; j < recordPerPage; j++){
			if( (j+currentStartRecord) < [topNameList count]){
				NSString *tempScore = [[topScoreList objectAtIndex:(j+currentStartRecord)] stringValue];
				NSMutableString *tempName = [topNameList objectAtIndex:(j+currentStartRecord)];
				int _offsetName = 0;
				int _offsetScore = 0;
				str = [tempScore UTF8String];
				//draw score bar
				//if(j%2)
				//	[imgRankingBar drawImageWithNo:CGPointMake(160, editorRankingInfo[j+x].y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.5f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel/2];
				//else
				//	[imgRankingBar drawImageWithNo:CGPointMake(160, editorRankingInfo[j+x].y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.6f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				/*
				//draw indication bar
				if( (j+currentStartRecord) == NewRecordIdx-1 )
				{
					[imgFocusBar drawImageWithNo:CGPointMake(250, editorRankingInfo[j+x].y) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				}
				*/
				
				//draw Ranking name 
				for(int i = 0; i < [tempName length]; i++){
					int num = [tempName characterAtIndex:i];
					[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:(num - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
					_offsetName = _offsetName+editorRankingInfo[j+x].width;
				}
				//draw score
				for (int i = strlen(str)-1; i >= 0; i--) {
					[imgRankingScore drawImageWithNo:CGPointMake(editorRankingInfo[j+x+1].x-_offsetScore, editorRankingInfo[j+x+1].y-STRING_OFFSET) no:(str[i] - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
					_offsetScore = _offsetScore+editorRankingInfo[j+x+1].width;
				}	
				x++;
			}
			else
			{
				int _offsetName = 0;
				int _offsetScore = 0;
				[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:('N' - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetName = _offsetName+editorRankingInfo[j+x].width;
				[imgRankingName drawImageWithNo:CGPointMake(editorRankingInfo[j+x].x+_offsetName, editorRankingInfo[j+x].y-STRING_OFFSET) no:('A' - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetName = _offsetName+editorRankingInfo[j+x].width;
				[imgRankingScore drawImageWithNo:CGPointMake(editorRankingInfo[j+x+1].x-_offsetScore, editorRankingInfo[j+x+1].y-STRING_OFFSET) no:('0' - '0') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
				_offsetScore = _offsetScore+editorRankingInfo[j+x+1].width;
				x++;
			}
		}
	}	
	return TRUE;
}

-(BOOL)queryGlobalRank
{
	NSLog(@"Get Global Rank =>");
	//isLoading = YES;
	
	if(nil == topIndexList && nil == topNameList && nil == topScoreList) {
		return NO;
	}
	
	[topIndexList removeAllObjects];
	for(int i=0; i<[topNameList count]; i++) {
		[[topNameList objectAtIndex:i] release];
	}
	[topNameList removeAllObjects];
	[topScoreList removeAllObjects];

	[rankHelper setGameName:@"RunRunRun"];
	RankRecordObj *rank = [RankRecordObj alloc];
	rank.gameLevel = 0;
		
	
		
	[rankHelper queryByRank:rank mode:@"top20"];
		
	
	//isLoading = NO;
	return TRUE;
}

- (void)didReceiveGlobalRanks:(RankHelper *)rnkhelper glView:(id)glView
{
	EAGLView* gameView = glView;
	rnkArray = [NSMutableArray arrayWithCapacity:rankHelper.topCount];
	[rankHelper getTopRanks:rnkArray];
	
	//clear global rank list
	if(nil == topIndexList && nil == topNameList && nil == topScoreList) {
		return ;
	}
	[topIndexList removeAllObjects];
	for(int i=0; i<[topNameList count]; i++) {
		[[topNameList objectAtIndex:i] release];
	}
	[topNameList removeAllObjects];
	[topScoreList removeAllObjects];
	for(int i = 0; i<[rnkArray count]; i++)
	{
		RankRecordObj *tmpRank = [rnkArray objectAtIndex:i];
		//NSLog(@"PoHsu => %@,%d,%d,%d,%d",tmpRank.playerName,tmpRank.gameLevel,tmpRank.score,tmpRank.rank,tmpRank.playTime);
		
		[topIndexList addObject:[NSNumber numberWithInt:i+1]];
		[topNameList addObject:[[NSString alloc] initWithString:tmpRank.playerName]];
		[topScoreList addObject:[NSNumber numberWithInt:tmpRank.score]];
		
	}
	//Reset current focus and page
	currentStartRecord = 0;
	gameView.isLocalRank = NO;
	[RankingBtn setNo:1];
}


-(BOOL)getGlobalRank
{	
	
	
	rnkArray = [NSMutableArray arrayWithCapacity:rankHelper.topCount];
	[rankHelper getTopRanks:rnkArray];
	
	//Check the rnkArray count, if 0 then alert
	if(rnkArray && [rnkArray count] == 0) {
		UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Connect Fail" message:@"Ranking server is not available.\n Please check the Internet connection or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		//isLoading = NO;
		return NO;
	}
	
	
	for(int i = 0; i<[rnkArray count]; i++)
	{
		RankRecordObj *tmpRank = [rnkArray objectAtIndex:i];
		NSLog(@"PoHsu => %@,%d,%d,%d,%d",tmpRank.playerName,tmpRank.gameLevel,tmpRank.score,tmpRank.rank,tmpRank.playTime);
		
		[topIndexList addObject:[NSNumber numberWithInt:i+1]];
		[topNameList addObject:[[NSString alloc] initWithString:tmpRank.playerName]];
		[topScoreList addObject:[NSNumber numberWithInt:tmpRank.score]];

	}
			return TRUE;
}


- (void)sendGlobalRank:(NSString *)name UserScore:(NSInteger)score
{
	NSLog(@"sendGlobalRank =>");
	NSLog(@"name:%s,score:%d",name,score);
	//[rankHelper setGameName:@"RunRunRun"];
	
		
	RankRecordObj *rank = [RankRecordObj alloc];
	rank.playerName = name;
	rank.gameLevel = 0;
		
	rank.score = score;
		
	[rankHelper QueryFollowsSendRecord:rank];
	
	
}

-(BOOL)sendGLobalRankCB
{
	[self getGlobalRankingFromServer:pView];
	return YES;
}

-(void)getGlobalRankingFromServer:view {
	if(nil == view)
		return;
	
	RankRecordObj *rank = [RankRecordObj alloc];
	
	if(nil == rank || nil == rankHelper) {
		[rank release];
		rank = nil;
		return;
	}
	
	rank.gameLevel = 0;
	[rankHelper queryByRank:rank mode:@"top20"];
	
	[rank release];
	rank = nil;
}

-(BOOL)insertGlobalRanking2Structure:(id)view {
	if(nil == view)
		return NO;
	
	if(nil == topIndexList && nil == topNameList && nil == topScoreList) {
		return NO;
	}
	
	[topIndexList removeAllObjects];
	for(int i=0; i<[topNameList count]; i++) {
		[[topNameList objectAtIndex:i] release];
	}
	[topNameList removeAllObjects];
	[topScoreList removeAllObjects];
	
	for(int i = 0; i<[rnkArray count]; i++)
	{
		RankRecordObj *tmpRank = [rnkArray objectAtIndex:i];
#ifdef DEBUGMSG_STARTRANKING
		NSLog(@"%@,%d,%d,%d,%d",tmpRank.playerName,tmpRank.gameLevel,tmpRank.score,tmpRank.rank,tmpRank.playTime);
#endif
		[topIndexList addObject:[NSNumber numberWithInt:i+1]];
		[topNameList addObject:[[NSString alloc] initWithString:tmpRank.playerName]];
		[topScoreList addObject:[NSNumber numberWithInt:tmpRank.score]];
	}
	
#ifdef DEBUGMSG_STARTRANKING
	NSLog(@"===indexArray, nameArray, scoreArray");
	for(int i=0; i<[topIndexList count]; i++) {
		NSLog(@"indexArray:%d",[[topIndexList objectAtIndex:i] intValue]);
	}
	
	for(int i=0; i<[topNameList count]; i++) {
		NSLog(@"nameArray:%@",[topNameList objectAtIndex:i]);
	}
	
	for(int i=0; i<[topScoreList count]; i++) {
		NSLog(@"scoreArray:%d",[[topScoreList objectAtIndex:i] intValue]);
	}
#endif
	
	return YES;
}



-(BOOL)processRanking:(id)view
{
	return TRUE;
}

-(BOOL)endRanking:(id)view
{
	EAGLView *gameView = view;
	
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	[imgRankingScore release];
	[imgRankingName release];
	
	NewRecordIdx = 0;
	// process to next state
	switch (sbType) {
		case SBTypeRankingBack:
			gameView.gameState = GS_INIT_INFO;
			break;
		case SBTypeRankingNext:
		default:
			gameView.gameState = GS_INIT_MENU;
			break;
	}
	
	return TRUE;
}

-(void)secondThread {
	//isLoading = YES;
	[NSThread detachNewThreadSelector:@selector(initWithThread) toTarget:self withObject:nil];
}

-(void)initWithThread {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if(pView)
		[self getGlobalRank];
	[self performSelectorOnMainThread:@selector(endSecondThread) withObject:nil waitUntilDone:NO];
	[pool release];
}

-(void) endSecondThread {
	//isLoading = NO;
}

-(void)dealloc
{
	[super dealloc];
}
@end
