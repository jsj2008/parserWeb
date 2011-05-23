//
//  LuckyDrawObj.m
//  game
//
//  Created by YiChun on 2010/1/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LuckyDrawObj.h"
#import "EAGLView.h"


@implementation LuckyDrawObj

@synthesize luckydraw;

- (id)initWithType:(CGPoint) pos view:(id)view {
	
	EAGLView *gameView = view;
	if (self = [super initWithStart]) {
		[self loadImageFromFile: @"LuckyDarw.png" tileWidth:128 tileHeight:32];
		self.pos = pos;
		self.no = 0;
	}
	
	gameView.main_LuckyDraw =luckydraw= [LuckyDraw alloc];
	if(luckydraw != nil)
	{
		[luckydraw initDefaultValues:view];
	}
	return self;
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

- (NSInteger) run:(id)man bTouch:(BOOL)bTouch touchMode:(NSString*)touchMode x:(int)x y:(int)y view:(id)view 
{
	
	if ([touchMode isEqualToString:@"End"]) 
	{
		if ([self isInImage:x y:y]) 
		{
			[luckydraw showLuckyDrawInfo:view];
			//[luckydraw checkLuckyDrawIsExpired:LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED];
		}
		
	}
	return 0;
}	

- (void)dealloc {
	
	if(luckydraw != nil)
		[luckydraw release];
	[super dealloc];
}


@end
