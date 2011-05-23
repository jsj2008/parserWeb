//
//  LuckyDrawObj.h
//  game
//
//  Created by YiChun on 2010/1/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimObj.h"
#import "LuckyDraw.h"


@interface LuckyDrawObj : AnimObj {

	LuckyDraw *luckydraw;
}

@property(nonatomic,assign) LuckyDraw *luckydraw;

- (id)initWithType:(CGPoint)pos view:(id)view;

@end
