//
//  MoreGameParser.h
//  game
//
//  Created by FIH on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreGameItm.h"
@class XMLAppDelegate, MoreGameItm;

@interface MoreGameParser : NSObject {
	NSMutableString *currentElementValue;
	XMLAppDelegate *appDelegate;
	MoreGameItm *MoreGameItems;
	NSMutableArray *moreGameItemList;
}


@property (nonatomic, assign) NSMutableArray *moreGameItemList;
- (MoreGameParser *) initXMLParser;
@end
