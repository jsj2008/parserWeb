//
//  startFullVersion.h
//  game
//
//  Created by FIH on 2009/11/5.
//  Copyright 2009 Foxconn International Gaming. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface startFullVersion : NSObject {
	NSInteger selItemType;

}
@property NSInteger selItemType;
-(BOOL)initFullVer:(id)view;
-(BOOL)processFullVer:(id)view;
-(BOOL)endFullVer:(id)view;

@end
