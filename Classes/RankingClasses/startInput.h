//
//  startInput.h
//  game
//
//  Created by FIH on 2009/9/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture2D.h"
#define pos_x 16 // init x of alphabet //60
#define pos_y 185 // init y of alphabet //150 
#define offset_x 32 //every characher offset_x //40
#define offset_y 53 //every characher offset_y
#define pos_width 28 // character width like A or B //35
#define pos_height 42 // character height like A or B //34
#define input_name_x 170 //input name x position of screen
#define input_name_y 310 //input name y position of screen
#define input_name_width 40 // input name width position of screen
#define input_name_height 40 // input name height position of screen
#define img_input_name "Arial Rounde...A~Z.png" // alphabet sequential list, like ABCDE...YZ
#define img_keypad	   "G-Keyboard-v_A~Z.png" //Keypad img
#define img_bg_game "End_Zooff_C_EnterName_BG.png" // background of Input editor 
#define img_bg_input_pos_x 480 //x of ranking screen
#define img_bg_input_pos_y 320 //y of ranking screen
#define KeyTileWidth 13 // character width like A or B //35
#define KeyTileHeight 15 // character height like A or B //34
typedef enum
	{
		ORI_LS_A_Z = 0,
		ORI_LS_INPUTNAME,
		ORI_PT_A_Z,
		ORI_PT_INPUTNAME,
	}screenOrientation;

typedef struct _EDITORPOSITION {
	int x;
	int y;
	int width;
	int height;
} EDITORPOSITION;

typedef struct _MAPTABLE{
	int x;
	int y;
	int imageID;
	char c;
}MAPTABLE;
//	
//	if ([gameView.screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
//	this is judge for Landscape or portrait

@interface startInput : NSObject {
	NSInteger menuItemType;
	Texture2D *imgInputName;
	Texture2D *imgKeyPad;
	NSArray *keyChar;
}
@property NSInteger menuItemType;
@property (nonatomic, assign) Texture2D *imgInputName;
@property (nonatomic, assign) Texture2D *imgKeyPad;
@property (nonatomic, assign) NSArray *keyChar;

-(BOOL)initInput:(id)view;
-(BOOL)processInput:(id)view;
-(BOOL)endInput:(id)view;
-(BOOL)drawInput: (id)view fadeLevel:(GLfloat)fadeLevel;
@end
