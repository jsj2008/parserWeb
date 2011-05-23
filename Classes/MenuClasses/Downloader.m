//
//  Downloader.m
//  game
//
//  Created by caspar on 2010/2/2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

- (void) start:(NSString*) url deg:(id)deg bTry:(BOOL)bTry{  
	
	NSString *tmpPath;
	if(bTry==YES)
		tmpPath =  TMP_SAVE_DIRECTORY;
	else
		tmpPath =  DOC_SAVE_DIRECTORY;
	
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];  
	idTarget = deg;
	

    urldownload = [[URLDownload alloc] initWithRequest:req directory:tmpPath delg:self];  
}  

- (void) cancel
{
	[urldownload cancel];
}
//URLDownloadDelegate implements  
- (void)downloadDidFinish:(URLDownload *)download {  
	[idTarget downloadFinish:(NSString*)[urldownload filePath]];

}  

- (void)download:(URLDownload *)download didCancelBecauseOf:(NSException *)exception {  
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:[exception reason] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease];  
    [alert show];  

	[idTarget downloadCancel:(NSException *)exception];
	
}  

- (void)download:(URLDownload *)download didFailWithError:(NSError *)error {  
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease];  
    [alert show];  

	[idTarget downloadFail:(NSError *)error];
}  

- (void)download:(URLDownload *)download didReceiveDataOfLength:(NSUInteger)length {  
	//NSLog(@"ok: path = %@", [download filePath]);
}  

@end
