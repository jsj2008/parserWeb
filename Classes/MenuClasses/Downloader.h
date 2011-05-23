//
//  Downloader.h
//  game
//
//  Created by caspar on 2010/2/2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define TMP_SAVE_DIRECTORY NSTemporaryDirectory()
#define DOC_SAVE_DIRECTORY [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()]

#import <Foundation/Foundation.h>
#import "URLDownload.h"

@interface Downloader : NSObject<URLDownloadDeleagte> {
	URLDownload *urldownload;
	id idTarget;
}
- (void) start:(NSString*) url deg:(id)deg bTry:(BOOL)bTry;
- (void) cancel;
@end

@protocol DownloaderDelegate<NSObject>
@optional
-(void) downloadFinish:(NSString *)path;
-(void) downloadCancel:(NSException *)exception;
-(void) downloadFail:(NSError *)error;
@end