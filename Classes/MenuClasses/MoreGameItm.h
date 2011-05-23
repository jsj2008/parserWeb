//
//  MoreGameItm.h
//  game
//
//  Created by FIH on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface MoreGameItm : NSObject {
	NSString *ID;
	NSInteger Number;
	NSString *Link;
}
@property (nonatomic, retain) NSString *ID;
@property (nonatomic, readwrite) NSInteger Number;
@property (nonatomic, retain) NSString *Link;
@end
