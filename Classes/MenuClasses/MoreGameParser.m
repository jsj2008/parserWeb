//
//  MoreGameParser.m
//  game
//
//  Created by FIH on 2010/3/30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoreGameParser.h"


@implementation MoreGameParser
@synthesize moreGameItemList;
- (MoreGameParser *) initXMLParser {
	
	[super init];
	appDelegate = (XMLAppDelegate*)[[UIApplication sharedApplication] delegate];
	return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"MoreGames"]) {
		//Initialize the array.
		moreGameItemList = [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"MoreGame"]) {
		
		//Initialize the book.
		MoreGameItems = [[MoreGameItm alloc] init];
		
		//Extract the attribute here.
		//aBanner.bannerID = [[attributeDict objectForKey:@"id"] integerValue];
		
		//NSLog(@"Reading id value :%i", aBanner.bannerID);
	}
	#ifdef MOREGAME_DEBUG
	NSLog(@"Processing Element: %@", elementName);
#endif
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
	#ifdef MOREGAME_DEBUG
	NSLog(@"Processing Value: %@", currentElementValue);
#endif
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"MoreGames"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	if([elementName isEqualToString:@"MoreGame"]) {
		[moreGameItemList addObject:MoreGameItems];
		
		[MoreGameItems release];
		MoreGameItems = nil;
	}
	else
		[MoreGameItems setValue:currentElementValue forKey:elementName];
	
	[currentElementValue release];
	currentElementValue = nil;
}

- (void) dealloc {
	
	[MoreGameItems release];
	[currentElementValue release];
	[super dealloc];
}

@end
