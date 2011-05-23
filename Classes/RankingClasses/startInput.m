//
//  startInput.m
//  game
//
//  Created by FIH on 2009/9/16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// When Game over owner will call 	
// NSInteger a = xxx;
// [gameView setScore:a]; send to Input
//

#import "startInput.h"
//#import "EAGLView.h"
#import "InputObj.h"
#import "SimpleButton.h"

#import "RankRecordObj.h"
#import "RankHelper.h"

EDITORPOSITION landScape[] = {
{pos_x+pos_width/2+offset_x*0,pos_y-offset_y*1,pos_width,pos_height},{pos_x+pos_width+offset_x*4,pos_y-offset_y*2,pos_width,pos_height},
{pos_x+pos_width+offset_x*2,pos_y-offset_y*2,pos_width,pos_height},{pos_x+pos_width/2+offset_x*2,pos_y-offset_y*1,pos_width,pos_height},
{pos_x+offset_x*2,pos_y,pos_width,pos_height},{pos_x+pos_width/2+offset_x*3,pos_y-offset_y*1,pos_width,pos_height},
{pos_x+pos_width/2+offset_x*4,pos_y-offset_y*1,pos_width,pos_height},{pos_x+pos_width/2+offset_x*5,pos_y-offset_y*1,pos_width,pos_height},
{pos_x+offset_x*7,pos_y,pos_width,pos_height},{pos_x+pos_width/2+offset_x*6,pos_y-offset_y*1,pos_width,pos_height},
{pos_x+pos_width/2+offset_x*7,pos_y-offset_y*1,pos_width,pos_height},{pos_x+pos_width/2+offset_x*8,pos_y-offset_y*1,pos_width,pos_height},
{pos_x+pos_width+offset_x*6,pos_y-offset_y*2,pos_width,pos_height},{pos_x+pos_width+offset_x*5,pos_y-offset_y*2,pos_width,pos_height},
{pos_x+offset_x*8,pos_y,pos_width,pos_height},{pos_x+offset_x*9,pos_y,pos_width,pos_height},
{pos_x+offset_x*0,pos_y,pos_width,pos_height},{pos_x+offset_x*3,pos_y,pos_width,pos_height},
{pos_x+pos_width/2+offset_x*1,pos_y-offset_y*1,pos_width,pos_height},{pos_x+offset_x*4,pos_y,pos_width,pos_height},
{pos_x+offset_x*6,pos_y,pos_width,pos_height},{pos_x+pos_width+offset_x*3,pos_y-offset_y*2,pos_width,pos_height},
{pos_x+offset_x*1,pos_y,pos_width,pos_height},{pos_x+pos_width+offset_x*1,pos_y-offset_y*2,pos_width,pos_height},
{pos_x+offset_x*5,pos_y,pos_width,pos_height},{pos_x+pos_width+offset_x*0,pos_y-offset_y*2,pos_width,pos_height}, //sequential A to Z

//space , breakspace , Okay/Return
//{pos_x+offset_x*0,pos_y-offset_y*3,pos_width,pos_height},{pos_x+offset_x*2,pos_y-offset_y*3,pos_width,pos_height},{pos_x+offset_x*4,pos_y-offset_y*3,pos_width,pos_height},

{0, 0, 0, -1}
};
EDITORPOSITION landScapeInputName[] =
{
{input_name_x, input_name_y, input_name_width, input_name_height},//Input Name position
{0, 0, 0, -1}
};

EDITORPOSITION portraitInputName[] = {
{20, 20, 40, 35},//Input Name position

{0, 0, 0, -1}
};
EDITORPOSITION portrait[] = {
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35}, 
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},
{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{20, 20, 40, 35}, //A - z poition.

{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{20, 20, 40, 35}, 
{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},{20, 20, 40, 35},{20, 20, 40, 35}, // 0 - 9 position

{60, 20, 40, 35},{20, 20, 40, 35},{60, 20, 40, 35},//space, breakSpace, Okay position

{0, 0, 0, -1}
};

EDITORPOSITION *editorposition[] = {
landScape,
landScapeInputName,
portrait,
portraitInputName,
NULL
};

NSInteger NewRecordIdx;


@implementation startInput
@synthesize menuItemType;
@synthesize imgInputName;
@synthesize imgKeyPad;
@synthesize keyChar;

- (BOOL)initInput:(id)view {
	
	EAGLView *gameView = view;
	// init the name count
	gameView.inputNameCount = 0;
	// load the Display Input Name
	imgInputName =  [[Texture2D alloc] fromFile:@img_input_name];
	if (imgInputName != nil) {
		[imgInputName SetTileSize:32 tileHeight:32];
	}
	
	imgKeyPad =  [[Texture2D alloc] fromFile:@img_keypad];
	if (imgKeyPad != nil) {
		[imgKeyPad SetTileSize:pos_width tileHeight:pos_height];
	}
	
	keyChar = [[NSArray alloc] initWithObjects:
			   @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",
			   @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", //A - Z
			   //@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", // 0 - 9
			   @" ",@"",@"", //space BreakSpace Okay
			   nil];
	// load backupground
	gameView.background = [[Texture2D alloc] fromFile:@img_bg_game];
	if (gameView.background != nil) {
		
		if ([gameView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
		{	
			// Landscape and the home button on the right side
			[gameView.background SetTileSize:img_bg_input_pos_x tileHeight:img_bg_input_pos_y];
		}
		else
		{	// Portrait mode
			[gameView.background SetTileSize:img_bg_input_pos_y tileHeight:img_bg_input_pos_x];
		}
	}
	
	gameView.animManager = [[AnimObjManager alloc] initArray];
	if (gameView.animManager != nil) {
		//[imgScore drawImageWithNo:]
		AnimObj *obj = nil;
	/*	if (obj != nil) */{
			EDITORPOSITION *editPositionInfo = editorposition[ORI_LS_A_Z];//landScape or portarit. //Wayne
			
			if(editPositionInfo)
			{
				int idx = 0;
				Texture2D *image_info;
				image_info = [[Texture2D alloc] fromFile:@img_keypad];
				
				while (editPositionInfo[idx].height != -1) 
				{
					obj = [gameView.animManager requestWithObjEx:[[InputObj alloc] initWithStart] image_info:image_info tileWidth:editPositionInfo[idx].width tileHeight:editPositionInfo[idx].height];
					if (obj != nil) {
						obj.freeTexture = NO;
						obj.pos = CGPointMake(editPositionInfo[idx].x, editPositionInfo[idx].y);//set A character position
						obj.no = idx;
						obj.no2 = 0;
						obj.type = idx+1;
					}
					idx++;
				}
//space				
				obj = [gameView.animManager requestWithObj:[[InputObj alloc] initWithStart] strName:@"G-Keyboard-v_Space.png" tileWidth:186 tileHeight:42];
				if (obj != nil) {
					obj.pos = CGPointMake(159.0, 26.0);//set A character position
					//obj.pos = CGPointMake(240,25);//set A character position
					obj.no = 0;
					obj.no2 = 0;
					obj.type = idx+1;
					idx++;
			}
			
//back
				obj = [gameView.animManager requestWithObj:[[InputObj alloc] initWithStart] strName:@"G-Keyboard-v_BkSp.png" tileWidth:58 tileHeight:42];
				if (obj != nil) {
					obj.pos = CGPointMake(31.0, 26.0);//set A character position//CGPointMake(70,25);//set A character position
					obj.no = 0;
					obj.no2 = 0;
					obj.type = idx+1;
					idx++;
				}
//enter
				obj = [gameView.animManager requestWithObj:[[InputObj alloc] initWithStart] strName:@"G-Keyboard-v_Okay.png" tileWidth:58 tileHeight:42];
				if (obj != nil) {
					obj.pos = CGPointMake(287.0, 26.0);//set A character position
					obj.no = 0;
					obj.no2 = 0;
					obj.type = idx+1;
					idx++;
				}
//end			
				
			}
		}
	}
	
	[gameView.rankInputName deleteCharactersInRange:NSMakeRange(0, [gameView.rankInputName length])];//empty all
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"NV_userName"] != nil) {
		[gameView.rankInputName appendString:(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"NV_userName"]];// load from NV
		gameView.inputNameCount = [gameView.rankInputName length];
	}

	// process to next state
	[gameView fadeInWithState:GS_PROCESS_INPUT];
	
	// init frame count
	gameView.frameCount = 0;
	return TRUE;
}

-(BOOL)drawInput: (id)view fadeLevel:(GLfloat)fadeLevel
{
	EAGLView *gameView = view;
		EDITORPOSITION *editPositionInfo = editorposition[ORI_LS_INPUTNAME];//landScape or portarit. //Wayne
		int middle = 0;
		middle = middle + editPositionInfo[0].width/2*[gameView.rankInputName length];
		int x = 0;
		for(int i = 0; i < gameView.inputNameCount; i++){
			int num = [gameView.rankInputName characterAtIndex:i];
			[imgInputName drawImageWithNo:CGPointMake(editPositionInfo[0].x+x-middle, editPositionInfo[0].y) no:(num - 'A') angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
			x = x + editPositionInfo[0].width;
		}
	return	TRUE;
}

- (BOOL)processInput:(id)view {
	return TRUE;
}

- (BOOL)endInput:(id)view {
	
	EAGLView *gameView = view;
	NSInteger uScore = [gameView getScore];
	//Local Ranking
	NewRecordIdx = [gameView.scoreRanking setCurrentUserRanking:(NSString *)gameView.rankInputName UserScore:uScore];// send the name and score to DB
	
	//Global Ranking
	if(NewRecordIdx==1)
	{
		gameView.main_ranking.isSendGlobRank = YES;
		gameView.main_ranking.TopScore = uScore;
	}	
	//[self sendGlobalRank:(NSString *)gameView.rankInputName UserScore:uScore];
	
	if (imgInputName != nil)
		[imgInputName release];
	imgInputName = nil;
	if (gameView.background != nil)
		[gameView.background release];
	gameView.background = nil;
	
	if (gameView.animManager != nil)
		[gameView.animManager release];
	gameView.animManager = nil;
	
	[keyChar release];
	
	// process to next state
	gameView.main_ranking.sbType = SBTypeRankingNext;
		gameView.gameState = GS_INIT_RANKING;
	return TRUE;
}


- (void)dealloc {
	[super dealloc];
}
@end
