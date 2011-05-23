//
//  StartCredit.h
//  game
//
//  Created by Taco on 2009/9/21.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface startCredit : NSObject {
	// for menu option
	NSInteger creditItemType;
}
@property NSInteger creditItemType;

-(BOOL)initCredit:(id)view;
-(BOOL)processCredit:(id)view;
-(BOOL)endCredit:(id)view;
@end
