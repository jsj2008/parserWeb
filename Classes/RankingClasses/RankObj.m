//
//  RankObj.m
//  game
//
//  Created by FIH on 2009/9/23.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RankObj.h"
#import "EAGLView.h"

@implementation RankObj

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
		if ([touchMode isEqualToString:@"End"]) {
			EAGLView *gameView = view;
			
			switch (_type) {
				case 1 :
						gameView.main_ranking.currentStartRecord = 0;//first page
					break;
				case 2 :
						gameView.main_ranking.currentStartRecord = 10;//second page
					break;
				case 3 :
					[gameView fadeOutWithState:GS_END_RANKING];
					break;
			}
		}
	}
	return 0;	
}


- (void)dealloc {
	[super dealloc];
}

@end

