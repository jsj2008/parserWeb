//
//  startOptions.h
//  game
//
//  Created by Taco on 2009/9/15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface startOptions : NSObject {
	NSInteger optionsItemType;
}

@property NSInteger optionsItemType;

-(BOOL)initOptions:(id)view;
-(BOOL)processOptions:(id)view;
-(BOOL)endOptions:(id)view;

@end
