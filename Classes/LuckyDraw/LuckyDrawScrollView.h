//
//  LuckyDrawScrollView.h
//  game
//
//  Created by YiChun on 2010/2/1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LuckyDraw.h"


@interface LuckyDrawScrollView : UIView
{
	UITextView * MessageText;
	UIButton *Agreebutton;
	UIButton *Cancelbutton;
	LuckyDraw *luckyobj;
	
	id pView;
}

@property (nonatomic, retain) UITextView * MessageText;
@property (nonatomic, assign) id	pView;

@end
