//
//  EditText.h
//  game
//
//  Created by YiChun on 2010/1/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EditText : UIViewController< UITextViewDelegate > 
{
	UITextView * twitterMessageText;
	id pView;
}

-(id)init:(id)view;

@property (nonatomic, retain) UITextView * twitterMessageText;
@property (nonatomic, assign) id	pView;

@end
