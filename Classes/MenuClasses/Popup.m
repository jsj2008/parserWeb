//
//  Popup.m
//  game
//
//  Created by FIH on 2009/10/12.
//  Copyright 2009 Foxconn International Gaming. All rights reserved.
//

#import "Popup.h"


@implementation Popup
- (id)init{
	if (self = [super init]) {
		//[super initWithStart];
		[self loadImageFromFile: @"MNU_Zooff_C_Notice.png" tileWidth:320 tileHeight:480];
		_pos = CGPointMake(160,240);
	}
	return (self);	
}
@end
