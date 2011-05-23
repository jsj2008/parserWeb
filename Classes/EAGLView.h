//
//  EAGLView.h
//  Animation
//
//  Created by FIG on 2009/9/8.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"
#import "AnimObj.h"
#import "AnimObjManager.h"
#import "startMainMenu.h"
#import "startLogo.h"
#import "startTitle.h"
#import "startInfo.h"
#import "startHelp.h"
#import "startOptions.h"
#import "startCredit.h"
#import "startMoreGame.h"
#import "pauseMenu.h"
#import "mainGame.h"
#import "zUIAccelerometer.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlaybackMgr.h"
//Wayne Add{
#import "startInput.h"
#import "startRanking.h"
#import "RankingMgr.h"
//Wayne Add}
//Max Pan{
#import "foodObj.h"
#import "dataDefine.h"
//Max Pan}
#import "Score.h" //pohsu
#import "mainGameMap.h"
#import "LoadingAnimation.h"
//#import "startFullVersion.h"

#import "TwitterRequest.h"

//LuckyDraw {
#import "LuckyDraw.h"
#import "LuckyDrawObj.h"
//LuckyDraw }

#ifdef LITE_VERSION
#import "ARRollerView.h"
#import	"ARRollerProtocol.h"
#endif

enum GAMEAPPSTATE {
	GS_NULL,
	GS_INIT_LOGO,			//LOGO
	GS_PROCESS_LOGO,
	GS_END_LOGO,
	GS_INIT_TITLE,			//TITLE
	GS_PROCESS_TITLE,
	GS_END_TITLE,
	GS_INIT_INFO,			//INFO
	GS_PROCESS_INFO,
	GS_END_INFO,
	GS_INIT_HELP,			//HELP
	GS_PROCESS_HELP,
	GS_END_HELP,
	GS_INIT_OPTIONS,		//OPTIONS
	GS_PROCESS_OPTIONS,
	GS_END_OPTIONS,
	GS_INIT_MENU,			//MENU
	GS_PROCESS_MENU,
	GS_END_MENU,
	GS_INIT_GAME,			//GAME
	GS_PROCESS_GAME,
	GS_END_GAME,
	GS_INIT_PAUSE,			//PAUSE
	GS_PROCESS_PAUSE,
	GS_END_PAUSE,
	GS_INIT_CREDIT,
	GS_PROCESS_CREDIT,
	GS_END_CREDIT,
	GS_INIT_MOREGAME,
	GS_PROCESS_MOREGAME,
	GS_END_MOREGAME,
	GS_PROCESS_FADEIN,		//fade in/out
	GS_PROCESS_FADEOUT,
//Wayne Add{	
	GS_INIT_INPUT,			//Input Name Editor
	GS_PROCESS_INPUT,
	GS_END_INPUT,
	GS_INIT_RANKING,		//Ranking Screen
	GS_PROCESS_RANKING,
	GS_END_RANKING,
//Wayne Add}	
//pohsu{
	GS_INIT_SCORE,
	GS_PROCESS_SCORE,
	GS_END_SCORE,
//pohsu }
	//Jarsh
	GS_INIT_FULLVER,
	GS_PROCESS_FULLVER,
	GS_END_FULLVER,
	//Jarsh
	GS_MAX
};

typedef enum {
	MainMenuCategory = 0,
	PauseMenuCategory
} MenuCategory;

#define FADETIME				15
#define ALPHAVAL               1.0

// FIG self function define
#define FIG_USE_NV				
#define FIG_USE_GSENSOR	
//#define FIG_USE_SIMULATOR	
#define FIG_USE_SOUNDEFFECT
//#define FIG_TWITTER_USE_TEXTVIEW

//#define LITE_VERSION //2009.11.05 JarshChen

#ifdef LITE_VERSION
#define FIG_ADWHIRL
#define TOPGAMELEVEL (5)
#else
#define TOPGAMELEVEL (5)
#endif

/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
#if defined(FIG_ADWHIRL)
@interface EAGLView : UIView <ARRollerDelegate>{
#else
@interface EAGLView : UIView {
#endif    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;

	// Texture2D Object
	Texture2D *background;
	// Animation
	AnimObjManager *animManager;
	// Animation
	AnimObjManager *PopupAnimManager;
	
	// frame count
	GLuint frameCount;
	
	// screen mode Landscape or Portrait
	NSString	*screenMode;
	// Screen from Menu/Pause Menu
	GLuint ScreenFrom;
	
	// for touch
	BOOL	bTouch;
	NSString	*touchMode;
	NSInteger	touchX;
	NSInteger	touchY;
	
	//Wayne Add{	
	//Ranking input
	NSMutableString	*rankInputName;
	//Ranking Name Count
	GLuint inputNameCount;
	NSInteger finalScore;
	//Ranking 10 or 20 names
	RankingMgr *scoreRanking;
	NSMutableArray *topNameList;
	NSMutableArray *topScoreList;
	//Wayne Add}	
	
	// game application state
	GLuint gameState;
	GLuint gameStateNew;
	GLuint gameStateOld;
	
	// fade in/out
	GLfloat fadeLevel;
	GLfloat fadeLevelNew;
	GLfloat fadeLevelAdd;
	GLfloat isFading; 

	//PAUSE
	BOOL	isPause;
	BOOL	isResume;
	
	//Sound, Music ON/OFF
	NSInteger	soundOFF;
	NSInteger	musicOFF;

	startMainMenu  *main_menu;
	startLogo       *main_logo;
        //Wayne Add{	
	startInput *main_input;
	startRanking *main_ranking;
        //Wayne Add}
	startTitle      *main_title;
	startInfo		*main_info;
	startHelp		*main_help;
	startOptions	*main_options;
	startCredit		*main_credit;
	pauseMenu		*main_pausemenu;
	startMoreGame	*main_moregame;
	mainGame *main_Game;
	mainGameMap *main_Game_Map;
	LoadingAnimation *main_Game_loadAnim;
//	startFullVersion *main_fullversion;
//Twitter 	
	TwitterRequest *twitterMgr;
	NSString *tw_name;
	NSString *tw_pw;
	NSString  *tw_post;
	UIAlertView *twitter_wait_alert;
	BOOL isTwitterConnectSuccess;
//Twitter 	
#if defined(FIG_USE_NV)
	NSInteger endlessMode;
	NSInteger gameLevel;
	NSInteger grandTotalScore;
	NSString  *userName;
	NSInteger showDemo;
	NSInteger enableEndless;
#endif 

#if defined(FIG_USE_GSENSOR) && defined(FIG_USE_SIMULATOR)
	zUIAccelerometer *am;	
#endif
	
#if defined(FIG_USE_SOUNDEFFECT)
	AudioPlaybackMgr *soundEffect;
	SESoundObj *soundObj1;
	SESoundObj *soundObj2;
	SESoundObj *sndAnimal[10];
	SESoundObj *sndButtonPress;
	NSBundle *bundle;
#endif 
	ScoreObj *main_score;
	//pohsu}
	
//MaxPan{
	//MaxPan Buttom
	
	NSInteger isFirstUse;
	NSInteger isFirstEnterGame;
//MaxPan}
	GBMusicTrack *song; //pohsu
#if defined(FIG_ADWHIRL)
	ARRollerView *rollerView; //pohsu
	Texture2D *myAdBanner;
	BOOL useMyBanner;
#endif
	BOOL isLocalRank;
	int btnBit;
	
	//for car use
	float car_xx;
	float car_yy;
	float car_zz;
	
	//for speed up
	int tmpDelta;
	int tmpDelta2;
	CGPoint currentspeed;
	
	//LuckyDraw {
	AnimObjManager *LuckyDrawAnimManager;
	LuckyDraw *main_LuckyDraw;
	BOOL showLuckydrawIcon;
	//LuckyDraw }

}

//MaxPan add the related {
@property NSInteger isFirstUse; 
@property NSInteger isFirstEnterGame;
@property NSInteger endlessMode;
//MaxPan add the related }
@property int btnBit;

@property NSTimeInterval animationInterval;
@property (nonatomic, assign) AnimObjManager *animManager;
@property (nonatomic, assign) AnimObjManager *PopupAnimManager;
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;
@property (nonatomic, assign) Texture2D *background;
@property (nonatomic, assign) startMainMenu *main_menu;
@property (nonatomic, assign) startInfo *main_info;
@property (nonatomic, assign) startHelp *main_help;
@property (nonatomic, assign) startCredit *main_credit;
@property (nonatomic, assign) startOptions *main_options;
@property (nonatomic, assign) startMoreGame *main_moregame;
//@property (nonatomic, assign) startFullVersion *main_fullversion;
@property (nonatomic, assign) mainGame *main_Game;
@property (nonatomic, assign) mainGameMap *main_Game_Map;
@property (nonatomic, assign) LoadingAnimation *main_Game_loadAnim;
@property (nonatomic, assign) pauseMenu *main_pausemenu;
@property (nonatomic, assign) NSString	*touchMode;
@property (nonatomic, assign) NSString	*screenMode;
@property GLuint gameState;
@property GLuint frameCount;
@property GLuint ScreenFrom;
@property NSInteger	touchX;
@property NSInteger	touchY;
@property BOOL	isPause;
@property BOOL	isResume;
@property NSInteger	soundOFF;
@property NSInteger	musicOFF;
@property NSInteger enableEndless;	
//pohsu sound {{
@property (nonatomic, assign) AudioPlaybackMgr *soundEffect; 
@property (nonatomic, assign) SESoundObj *soundObj1; 
@property (nonatomic, assign) SESoundObj *soundObj2; 
@property (nonatomic, assign) NSBundle *bundle;
@property (nonatomic, assign) GBMusicTrack *song;
//sound }}
@property (nonatomic, assign) ScoreObj	*main_score;

//Twitter	
@property (nonatomic, assign) TwitterRequest *twitterMgr;
@property (nonatomic, assign) NSString *tw_name;
@property (nonatomic, assign) NSString *tw_pw;
@property(nonatomic, retain) NSString  *tw_post;
@property (nonatomic, assign) UIAlertView *twitter_wait_alert;
@property (nonatomic, assign) BOOL isTwitterConnectSuccess;
//Twitter 
	
//Wayne Add{
@property (nonatomic, assign) NSMutableString *rankInputName;
@property (nonatomic, assign) startInput *main_input;
@property (nonatomic, assign) startRanking *main_ranking;
@property (nonatomic, assign) NSMutableArray *topNameList;
@property (nonatomic, assign) NSMutableArray *topScoreList;
@property GLuint inputNameCount;
@property NSInteger finalScore;
@property NSInteger gameLevel;
@property NSInteger showDemo;	
@property NSInteger grandTotalScore;
@property (nonatomic, assign) RankingMgr *scoreRanking;
#if defined(FIG_ADWHIRL)
@property (nonatomic,assign) ARRollerView *rollerView;
#endif
@property BOOL isLocalRank;
@property (nonatomic, assign) NSString  *userName;
@property 	float car_xx;
@property	float car_yy;
@property	float car_zz;
//Taco for speed up
@property int tmpDelta;
@property int tmpDelta2;
@property CGPoint currentspeed;
//LuckyDraw {
@property(nonatomic, assign) AnimObjManager *LuckyDrawAnimManager;
@property(nonatomic,assign) LuckyDraw *main_LuckyDraw;
@property BOOL showLuckydrawIcon;	
//LuckyDraw }
	
- (void)setScore:(NSInteger)score;
- (NSInteger)getScore;
- (BOOL)getUserName:(NSMutableArray *)playerName;

//Wayne Add}

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

- (BOOL) appStateProcess;
- (void) animation;
- (void) drawView;

- (void) startAnimation;
- (void) stopAnimation;

- (void) setFadeIn:(NSInteger)frame;
- (void) setFadeOut:(NSInteger)frame;
- (BOOL) processFadeIn;
- (BOOL) processFadeOut;
- (void) fadeInWithState:(GLuint)state;
- (void) fadeOutWithState:(GLuint)state;
- (void) PlaySoundEffect:(int)sndType playorstop:(BOOL)action;

#if defined(FIG_USE_NV)
- (void) saveToFileSystem;
- (void)writeNVitem:(NSString *)defaultName;
- (void) readFromFileSystem;
#endif

- (void)pauseAnimation;
#if defined(FIG_ADWHIRL)
-(void)DrawAPBanner:(GLfloat)fade_Level;
#endif
-(void)writeNVitemDemo;	
	
@end
