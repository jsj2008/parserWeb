//
//  InputObj.m
//  game
//
//  Created by FIH on 2009/9/17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InputObj.h"
#import "EAGLView.h"

@implementation InputObj
- (CGRect) getCollisionRect {
	CGRect aRect;
	if (_image != nil) {
		aRect.origin.x = _pos.x;
		aRect.origin.y = _pos.y;
		aRect.size.width = _image.tileWidth * 1.1f;
		aRect.size.height = _image.tileHeight * 1.1f;
	}	
	return aRect;
}

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
	if ([self isInImage:x y:y]) {
		if ([touchMode isEqualToString:@"Began"]) {
			_no2 = _no2 + 1;
		}
	}
	if ([touchMode isEqualToString:@"End"]) {
		_no2 = 0;
	}
	
	// press the icon
	if ([self isInImage:x y:y]) {
		EAGLView *gameView = view;	
		if ([touchMode isEqualToString:@"End"] ){//&&gameView.inputNameCount <= MAX_INPUT_NAME_LENGTH && gameView.inputNameCount >= MIN_INPUT_NAME_LENGTH) {
			if(_type == 28)//breakspace
			{
				if(gameView.inputNameCount > MIN_INPUT_NAME_LENGTH){
					[gameView.rankInputName deleteCharactersInRange:NSMakeRange(gameView.inputNameCount-1, 1)];
					//[gameView.rankInputName deleteCharactersInRange:NSMakeRange(4, 5)];
					gameView.inputNameCount--;
				}
			}
			else if(_type == 29)//okay,return
			{
				if(gameView.inputNameCount > MIN_INPUT_NAME_LENGTH)//retain this condiction.
				{
					gameView.userName = gameView.rankInputName;
					[[NSUserDefaults standardUserDefaults] setObject:gameView.userName forKey:@"NV_userName"];
				[gameView fadeOutWithState:GS_END_INPUT];
			}
				
			}
			else if (gameView.inputNameCount < MAX_INPUT_NAME_LENGTH)
			{
				//if(gameView.inputNameCount ==0 && _type <= 26)//add A a B b in when inputNameCount =0;
				[gameView.rankInputName appendString:[gameView.main_input.keyChar objectAtIndex:_type-1]];
				gameView.inputNameCount++;
			}
			else{}
		}
	}
	return 0;	
}

- (void)dealloc {
	[super dealloc];
}
@end
