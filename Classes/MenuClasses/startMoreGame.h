//
//  startMoreGame.h
//  game
//
//  Created by Taco on 2009/9/22.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//-----------------------------
//| Game1 (0,0) | Game3 (1,0) |
//|	type 2      | type 4      |
//|----------------------------
//| Game2 (0,1) | Game4 (1,1) |
//|	type 3      | type 5      |
//|----------------------------
#import <Foundation/Foundation.h>
#import "Texture2D.h"

#define MOREGAME_TILEWIDTH		128	/*width of tile */
#define MOREGAME_TILEHEIGHT		128 /*height of tile */
#define GAME1_URL				"http://itunes.apple.com/tw/app/mini-trickie/id336920280?mt=8" //MINI TRICKIE
#define GAME2_URL				"http://itunes.apple.com/tw/app/dance-duo/id335767193?mt=8" //DANCU DUO
#define GAME3_URL				"http://itunes.apple.com/us/app/dualspinball/id335931879?mt=8"//DSB
#define GAME4_URL				"http://itunes.apple.com/us/app/paper-fish/id353939506?mt=8"//PAPER FISH
#define GAME5_URL				"http://itunes.apple.com/us/app/fish-scooper/id335769075?mt=8"//FISH SCROOPER
#define GAME6_URL				"http://itunes.apple.com/tw/app/zoo-manager/id335771243?mt=8" // ZOO MANAGER
#define GAME7_URL				"http://www.gamememore.com/li/more/SoundScracher.html"//SoundScracher
#define GAME8_URL				"http://itunes.apple.com/us/app/zoo-manager-off/id349451546?mt=8"//ZOO OFF
#define GAME9_URL				"http://www.gamememore.com/li/more/VirusFighter.html"//VirusFighter
#define GAME10_URL				"http://www.gamememore.com/li/more/AngelInCloud.html"//ANGEL In Cloud
#define GAME11_URL				"http://www.gamememore.com/li/more/RainingCatsDogs.html"//Raining Cats & Dogs
#define GAME12_URL				"http://www.gamememore.com/li/more/Race_emHome.html"//Race'em Home
#define GAME13_URL				"http://www.gamememore.com/li/more/PaperAirplane.html"//Paper Airplane
#define GAME14_URL				"http://www.gamememore.com/li/more/SonOfFish.html"//Son Of Fish
/*
#define GAME14_URL				"http://www.gamememore.com/li/more/AngelInCloud.html"//ANGEL In Cloud
#define GAME15_URL				"http://www.gamememore.com/li/more/AngelInCloud.html"//ANGEL In Cloud
#define GAME15_URL				"http://www.gamememore.com/li/more/AngelInCloud.html"//ANGEL In Cloud
*/

#define GAMEMEMORE_URL			"http://www.gamememore.com/"


#define MOREGAME_MAX_PAGE 4
#define MOREGAME_ICON_FIRST_X 83
#define MOREGAME_ICON_FIRST_Y 318 //184

#define MOREGAME_ICON_OFFSET_X 154
#define MOREGAME_ICON_OFFSET_Y 155


#define MOREGAME_PAGE_TILE_W		30	/*width of tile */
#define MOREGAME_PAGE_TILE_H		30	/*height of tile */


#define MOREGAME_PAGE_CENTERX 160
#define MOREGAME_PAGE_CENTERY 25
#define MOREGAME_PAGE_WIDTH 10
#define MOREGAME_PAGE_SCALE 0.2

#define GAME_ICON_TYPE    200
#define MOREGAME_PAGE_TYPE 500

#define MOREGAME_ICON_ROW 4
#define MOREGAME_ICON_COL 4

#define MOREGAME_DISABLE_ICON_NUM 12





@interface startMoreGame : NSObject {
	// for menu option
	//NSInteger moregameItemType;
	NSInteger selItemType;

	Texture2D *MoreGameItem;
	Texture2D *MoreGamePage;
	//robert liao,20100119, add for next page..
	NSInteger _correct_page;
	
	CGPoint	  _pos;
	
}
//@property NSInteger moregameItemType;
@property NSInteger selItemType;
@property  (readwrite)NSInteger correct_page;

-(BOOL)initMoreGame:(id)view;
-(BOOL)inttMultiplePage:(id)view;
-(BOOL)processMoreGame:(id)view;
-(BOOL)endMoreGame:(id)view;
@end
