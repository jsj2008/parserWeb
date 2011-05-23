//
//  EditText.m
//  game
//
//  Created by YiChun on 2010/1/15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditText.h"
#import "EAGLView.h"

@implementation EditText

@synthesize twitterMessageText;
@synthesize pView;

-(id)init:(id)view
{
	EAGLView *gameView = view;
	
	self = [super init];
	twitterMessageText = [[UITextView alloc]initWithFrame:CGRectMake(2,2, 475, 175)];
	[twitterMessageText setBackgroundColor:[UIColor whiteColor]];
	twitterMessageText.returnKeyType = UIReturnKeyDone;
	self.pView = gameView;
	return self;
}

-(void)loadView
{
	[twitterMessageText setDelegate:self];	
	[twitterMessageText becomeFirstResponder];
	self.view = twitterMessageText;
	[twitterMessageText release];	
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	
	EAGLView *gameView = self.pView;
	gameView.tw_post = [[NSString alloc] initWithFormat:@"%@",twitterMessageText.text];
	[gameView.twitterMgr startPicker:gameView name:gameView.tw_name pw:gameView.tw_pw];
	[twitterMessageText removeFromSuperview];
}


-(void)dealloc
{
	if(twitterMessageText != nil)
		[twitterMessageText release];
	
	[super dealloc]	;
}

@end
