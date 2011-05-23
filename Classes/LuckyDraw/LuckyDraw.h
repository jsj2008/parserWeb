//
//  LuckyDraw.h
//  game
//
//  Created by YiChun on 2010/1/20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "checkPrivacy.h"
#import "dataDefine.h"
#import "RegexKitLite.h"

#define FIG_GAME_LUCKYDRAW_SERVER @"http://www.gamememore.com/"
#define FIG_LUCKYDRAW_PATH @"game/luckydraw.php?"
#define FIG_CHECKLUCKDRAW  @"game/checkGameluckydraw.php?"
#define LUCKDRAW_TABLE_NAME @"Luckydraw"

#define OFFICIALWEBSITE	"http://www.gamememore.com"

#define EVENWELLAPPSTORE "http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?entity=software&media=softwareAndITunesU&restrict=true&submit=seeAllLockups&term=evenwell" 
//"http://ax.search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?entity=software&media=all&restrict=true&submit=seeAllLockups&term=evenwell" //"http://bit.ly/bTFwtm" //"http://itunes.apple.com/us/artist/evenwell-digitech-inc/id335767196"

#define YOUTUBEWEBSITE "http://www.youtube.com/gamememore"
#define GAMEMEMOREFACEBOOK "http://www.facebook.com/GameMeMore?ref=ts"

#define KEYFORGAMENAME @"ApplicationName"
#define GAMENAME @"RACEHOME"

@interface LuckyDraw : NSObject {
	NSMutableData *_receivedData;
	NSMutableURLRequest *request; 
	NSURLConnection		*theConnection;
	
	UITextField *emailAccount;
	UITextField *friendA;
	UITextField *friendB;
	UITextField *friendC;
	
	NSString *str_email;
	NSString *str_frienda;
	NSString *str_friendb;
	NSString *str_friendc;	
	
	NSString *_hostName;
	NSString *_tableName;
	
	NSString *field_1;
	NSString *field_2;
	
	
	
	NSString *deviceID;
	NSString *palyingGamename;
	BOOL     isPirateVersion;
	
	UIDevice *device;
	
	checkPrivacy *privacyobj;
	
	LUCKYDRAW_SUBMIT_STATUS submit_status;
	LUCKYDRAW_SUBMIT_STATUS current_status; //only LUCKYDRAW_CHECKLUCKYDRAW_EXPIRED and LUCKYDRAW_SUBMIT_GAME_TO_SERVER
	LUCKYDRAW_SUBMIT_STATUS sub_status;
	
	id pView;
	
	UIAlertView *waitAlert;
	UIActivityIndicatorView *activityView;

}


@property (readwrite, retain) NSMutableData *receivedData;
@property (readwrite, retain) NSString *hostName;
@property (readwrite, retain) NSString *tableName;
@property (readwrite, retain) NSString *deviceID;
@property (readwrite, retain) NSString *palyingGamename;
@property (readwrite, retain) UIDevice *device;
@property(nonatomic, assign ) UITextField *emailAccount;
@property 	BOOL     isPirateVersion;

-(id)init:(id)view;
-(BOOL)setLuckydraw:(LUCKYDRAW_SUBMIT_STATUS)status;
-(void)initDefaultValues:(id)view;
-(void)showInputEmailAccount;
-(BOOL)checkLuckyDrawIsExpired :(LUCKYDRAW_SUBMIT_STATUS)status;
-(void)executeLuckyDraw:(id)view;
-(void)getLuckydrawdate:(id)view;
-(void)showLuckyDrawInfo:(id)view;
-(void)showInputMoreFriends;
-(void)showAfterSubmitInfo;
-(void)releaseStr;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (BOOL)emailValidate:(NSString *)email;

@end
