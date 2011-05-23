//
//  EAGLView.m
//  Animation
//
//  Created by FIG on 2009/9/8.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "CombinedButton.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"
#if defined(FIG_ADWHIRL)
#import "ARRollerView.h"
#import "ARRollerProtocol.h"
#endif
//Wayne Add{
extern EDITORPOSITION *editorposition[];
extern EDITORPOSITION *editorRanking[];
//Wayne Add}
#define USE_DEPTH_BUFFER 0

@implementation EAGLView

@synthesize btnBit;
@synthesize twitterMgr;
@synthesize tw_name;
@synthesize tw_pw;
@synthesize tw_post;
@synthesize twitter_wait_alert;
@synthesize isTwitterConnectSuccess;

@synthesize endlessMode;
@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize background;
//@synthesize btn_pause;
@synthesize gameState;
@synthesize animManager;
@synthesize PopupAnimManager;
@synthesize main_menu;
@synthesize main_Game;
@synthesize main_Game_Map;//pohsu
@synthesize main_Game_loadAnim;
@synthesize main_info;
@synthesize main_options;
@synthesize main_help;
@synthesize main_pausemenu;
@synthesize main_credit;
@synthesize main_moregame;
//@synthesize main_fullversion;
@synthesize enableEndless;	
@synthesize frameCount;
@synthesize touchMode;
@synthesize screenMode;
//Wayne Add{
@synthesize main_input;		//main instance for name input
@synthesize main_ranking;	//main instance for ranking
@synthesize rankInputName;	//get the user name. user-input.
@synthesize inputNameCount;	//user name characters.
@synthesize finalScore;		//final score of user when Game Over.
@synthesize topNameList;	//the Top 10 name from server.
@synthesize topScoreList;   //the Top 10 Score from server.
@synthesize scoreRanking;	//SqlLite DB Mgr Jerry
//Wayne Add}
@synthesize ScreenFrom;
@synthesize touchX;
@synthesize touchY;
@synthesize isPause;
@synthesize isResume;
@synthesize soundOFF;
@synthesize musicOFF;
//MaxPan add food {
@synthesize showDemo;
@synthesize isFirstUse;
@synthesize isFirstEnterGame;
//MaxPan add food }
//sound {{ pohsu
@synthesize bundle;
@synthesize soundEffect; //pohsu
@synthesize soundObj1;
@synthesize soundObj2;
@synthesize song;
//sound }}
@synthesize main_score; //pohsu
@synthesize gameLevel;
@synthesize grandTotalScore;
#if defined(FIG_ADWHIRL)
@synthesize rollerView;//pohsu
#endif
@synthesize isLocalRank;
@synthesize userName;
@synthesize car_xx;
@synthesize car_yy;
@synthesize car_zz;
//taco for speed up
@synthesize tmpDelta;
@synthesize tmpDelta2;
@synthesize currentspeed;
//LuckyDraw {
@synthesize LuckyDrawAnimManager;
@synthesize showLuckydrawIcon;
@synthesize main_LuckyDraw;
//LuckyDraw }

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder 
{    
    if ((self = [super initWithCoder:coder])) 
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / _SYSTEM_FRAME_COUNT_PER_SEC_;
		
		//---------------------------------------------------
		// OpenGL setting
		
		// Set up OpenGL projection matrix
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glMatrixMode(GL_MODELVIEW);
		
		// Initialize OpenGL states
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_TEXTURE_2D);
		
		glDisable(GL_DEPTH_TEST);
		/*For better performance*/
		glDisable(GL_LIGHTING);
		glDisable(GL_ALPHA_TEST);
		glDisable(GL_DITHER);
		glDisable(GL_FOG);
		glDisable(GL_LOGIC_OP_MODE);
		glDisable(GL_STENCIL_TEST);
		/*For better performance*/
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		
		// get InterfaceOrientation setting from info.plist
		screenMode = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIInterfaceOrientation"];	
		//NSLog(screenMode);	//  UIInterfaceOrientationLandscapeRight  
		
		CGRect rect = [[UIScreen mainScreen] bounds];
		
		if ([screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"])	// Landscape and the home button on the right side
		{
			glOrthof(0, rect.size.height, 0, rect.size.width, -1, 1);    
		}
		else
		{
			glOrthof(0, rect.size.width, 0, rect.size.height, -1, 1);
		}
		
		//---------------------------------------------------
		// set Accelerometer
		
#if defined(FIG_USE_GSENSOR) 
#if defined(FIG_USE_SIMULATOR)
		am = [zUIAccelerometer alloc];
		[am setDelegate:self];
		[am startFakeAccelerometer];
#else
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.05];
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
#endif
#endif
		
		//---------------------------------------------------
		// Sound Effect
		
#if defined(FIG_USE_SOUNDEFFECT)
		soundEffect = [[AudioPlaybackMgr alloc] initArray];
		
		if (soundEffect){
			NSBundle *bundle2 = [NSBundle mainBundle];
			CFURLRef fileURL = nil;
			
			if (sndAnimal[0] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Monkey_Right" ofType:@"wav"]] retain];
				sndAnimal[0] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if (sndAnimal[1] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Battery" ofType:@"WAV"]] retain];
				sndAnimal[1] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if (sndAnimal[2] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_KY" ofType:@"wav"]] retain];
				sndAnimal[2] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if (sndAnimal[3] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Giraffe_Right" ofType:@"wav"]] retain];
				sndAnimal[3] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if (sndAnimal[4] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Lion_Right" ofType:@"wav"]] retain];
				sndAnimal[4] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if (sndAnimal[5] == nil){
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Rabbit_Right" ofType:@"wav"]] retain];
				sndAnimal[5] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if(sndAnimal[6] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_RoadBlock" ofType:@"wav"]] retain];
				sndAnimal[6] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			if(sndAnimal[7] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Holes" ofType:@"wav"]] retain];
				sndAnimal[7] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			
			if(sndAnimal[8] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_Fail5sec" ofType:@"m4a"]] retain];
				sndAnimal[8] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			
			if(sndAnimal[9] == nil)
			{
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"SFX_LevelSuccess5sec" ofType:@"m4a"]] retain];
				sndAnimal[9] = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			
			
			if(sndButtonPress== nil)
			{			
				fileURL = (CFURLRef)[[NSURL fileURLWithPath:[bundle2 pathForResource:@"ButtonPressed1" ofType:@"wav"]] retain];
				sndButtonPress = [soundEffect requestSEWithURL:fileURL];
				CFRelease(fileURL);
			}
			
		}
		
		//alloc song
		song = [GBMusicTrack alloc];
#endif 
		
#if defined(FIG_ADWHIRL)	
		useMyBanner = TRUE;
		
		myAdBanner =  [[Texture2D alloc] fromFile:@"banner_all.png"];
		if (myAdBanner != nil) {
			[myAdBanner SetTileSize:320 tileHeight:50];	
		}
		rollerView = [ARRollerView requestRollerViewWithDelegate:self];
	    rollerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		//rollerView.center = CGPointMake(160,290);
		
		rollerView.clipsToBounds = YES;
		[rollerView rollOver];
		[self addSubview:rollerView];
		rollerView.hidden = YES;  //Jarsh 2009.11.06
#endif 
		
		//---------------------------------------------------
		
		// create main logo/title/menu
		main_menu = [startMainMenu alloc];
		main_logo = [startLogo alloc];
		main_title = [startTitle alloc];
		main_info = [startInfo alloc];
		main_help = [startHelp alloc];
		main_options = [startOptions alloc];
		main_pausemenu = [pauseMenu alloc];
		main_credit = [startCredit alloc];
		main_moregame = [startMoreGame alloc];
		// create game platform
		main_Game = [mainGame alloc];
		main_Game_Map = [mainGameMap alloc];//pohsu
		main_Game_loadAnim = [LoadingAnimation alloc];//Jarsh
//		main_fullversion = [startFullVersion alloc];
		//LuckyDraw {
		
		showLuckydrawIcon = NO;
		
		LuckyDraw *main_luckydraw = [[LuckyDraw alloc]init:self];
		if(main_luckydraw != nil)
		{
			[main_luckydraw executeLuckyDraw:self];
		}
		[main_luckydraw release];
		//LuckyDraw }
		//Wayne Add{
		main_input = [startInput alloc];		
		main_ranking = [startRanking alloc];
		rankInputName = [[NSMutableString alloc] initWithString: @""];//init user name empty
		topNameList =[[NSMutableArray alloc]init];
		topScoreList =[[NSMutableArray alloc]init];			
		finalScore = 0;//init the user score
		// Jerry
		//userRecordScore
		scoreRanking = [[RankingMgr alloc] init];
		//Jerry		
		//Wayne Add}
		
		//pohsu{
		main_score = [[ScoreObj alloc] init];
		//pohsu}
		
		twitterMgr = [[TwitterRequest alloc] init];
		
		frameCount = 0;
		ScreenFrom = MainMenuCategory;
//		gameState = gameStateOld = gameStateNew = GS_INIT_SCORE ; //GS_INIT_SCORE;//GS_INIT_INPUT;//GS_INIT_RANKING;//GS_INIT_SCORE
		gameState = gameStateOld = gameStateNew = GS_INIT_TITLE; //correct process maxpan 20091209
		//gameState = gameStateOld = gameStateNew = GS_INIT_GAME; //test state
		fadeLevel = fadeLevelNew = 1.0;
		isFading = FALSE;
		isPause = NO;
		isResume = NO;
		gameLevel = 0; //Jarsh
		grandTotalScore = 0;
        isLocalRank = YES;
		endlessMode = 0;
		tmpDelta = 300;
		btnBit = 0;
		isTwitterConnectSuccess = NO;
		
		if ([screenMode isEqualToString:@"UIInterfaceOrientationLandscapeRight"]) 
		{	
			background = [[Texture2D alloc] fromFile:@"Default_Landscape.png"];
			if(background==nil)
				NSLog(@"broken pic LLLL");
			[background SetTileSize:480 tileHeight:320];
		}
		else
		{	// Portrait mode
			background = [[Texture2D alloc] fromFile:@"Default_Portrait.png"];
			if(background==nil)
				NSLog(@"broken pic pppp");			
			[background SetTileSize:320 tileHeight:480];
		}
    }
    return self;
}

// Main loop, for process game's status, animation, screen display...
- (void)mainAppLoop {
	
	[self appStateProcess];	// switch whole application state
	[self animation];
	[self drawView];
	
	frameCount++;
	touchMode = @"";
}

- (BOOL)appStateProcess {
	switch (gameState) {
		case GS_INIT_LOGO :
			return [main_logo initLogo:self];
		case GS_PROCESS_LOGO :
			return [main_logo processLogo:self];
		case GS_END_LOGO :
			return [main_logo endLogo:self];
		case GS_INIT_TITLE :
			return [main_title initTitle:self];
		case GS_PROCESS_TITLE :
			return [main_title processTitle:self];
		case GS_END_TITLE :
			return [main_title endTitle:self];
		case GS_INIT_INFO :
			return [main_info initInfo:self];
		case GS_PROCESS_INFO :
			return [main_info processInfo:self];
		case GS_END_INFO :
			return [main_info endInfo:self];
		case GS_INIT_HELP :
			return [main_help initHelp:self];
		case GS_PROCESS_HELP :
			return [main_help processHelp:self];
		case GS_END_OPTIONS :
			return [main_options endOptions:self];
		case GS_INIT_OPTIONS :
			return [main_options initOptions:self];
		case GS_PROCESS_OPTIONS :
			return [main_options processOptions:self];
		case GS_END_HELP :
			return [main_help endHelp:self];
		case GS_INIT_MENU :
			return [main_menu initMenu:self];
		case GS_PROCESS_MENU :
			return [main_menu processMenu:self];
		case GS_END_MENU :
			return [main_menu endMenu:self];
			//Wayne Add{			
		case GS_INIT_INPUT :
			return [main_input initInput:self];
		case GS_PROCESS_INPUT :
			return [main_input processInput:self];
		case GS_END_INPUT :
			return [main_input endInput:self];
		case GS_INIT_RANKING :
			return [main_ranking initRanking:self];
		case GS_PROCESS_RANKING :
			return [main_ranking processRanking:self];
		case GS_END_RANKING :
			return [main_ranking endRanking:self];		
			//Wayne Add}
		case GS_INIT_GAME :
			return [main_Game initGame:self];
		case GS_PROCESS_GAME :
			return [main_Game processGame:self];
		case GS_END_GAME :
			return [main_Game endGame:self];
		case GS_INIT_PAUSE :
			return [main_pausemenu initPauseMenu:self];
		case GS_PROCESS_PAUSE :
			return [main_pausemenu processPauseMenu:self];
		case GS_END_PAUSE :
			return [main_pausemenu endPauseMenu:self];
		case GS_INIT_CREDIT :
			return [main_credit initCredit:self];
		case GS_PROCESS_CREDIT :
			return [main_credit processCredit:self];
		case GS_END_CREDIT :
			return [main_credit endCredit:self];
		case GS_INIT_MOREGAME :
			return [main_moregame initMoreGame:self];
		case GS_PROCESS_MOREGAME :
			return [main_moregame processMoreGame:self];
		case GS_END_MOREGAME :
			return [main_moregame endMoreGame:self];
		case GS_PROCESS_FADEIN :
			return [self processFadeIn];
		case GS_PROCESS_FADEOUT :
			return [self processFadeOut];
		case GS_INIT_SCORE : //pohsu
			return [main_score initScore:self];
		case GS_PROCESS_SCORE :
			return [main_score processScore:self];
		case GS_END_SCORE :
			return [main_score endScore:self];
#if 0			
		case GS_INIT_FULLVER:
			return [main_fullversion initFullVer:self];

		case GS_PROCESS_FULLVER:
			return [main_fullversion processFullVer:self];
		case GS_END_FULLVER:
			return [main_fullversion endFullVer:self];
#endif
	}
	return TRUE;
}

- (void)animation {
	
	switch (gameState) {
			
		case GS_PROCESS_GAME:
		{
			
			if(main_Game.gameFoodAnimManager != nil)
			{
				[main_Game.gameFoodAnimManager checkCollision:main_Game.gameAnimManager];
				[main_Game.gameFoodAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
			}

			if(main_Game.gameAnimManager!=nil)
			{
				[main_Game.gameAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
			}
			
			
			if(main_Game.gameEnemyAnimManager != nil)
			{
				[main_Game.gameEnemyAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
			}
			
			
			switch (main_Game.gameStageState) {
				case GSStateGameOver:
				case GSStateGameSucceed:
					if(main_Game.gameESAnimManager!=nil)
					{
						[main_Game.gameESAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
					}
					break;
				default:
					break;
			}
		}
			break;
		case GS_PROCESS_MENU:
		{
			switch (main_menu.mainMenuState) {
				case MMenuStateNoticeDisp:
					if (PopupAnimManager != nil)
						[PopupAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
					break;
				default:
					if (animManager != nil)
						[animManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
					//LuckyDraw {
					if ( LuckyDrawAnimManager!= nil)
						[LuckyDrawAnimManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
					//LuckyDraw }
					break;
			}
		}
			break;
		case GS_PROCESS_LOGO:
		case GS_PROCESS_TITLE:
		case GS_PROCESS_OPTIONS:
		case GS_PROCESS_HELP:
		case GS_PROCESS_INFO:
		case GS_PROCESS_CREDIT:
		case GS_PROCESS_MOREGAME:
		case GS_PROCESS_PAUSE :
		case GS_PROCESS_FADEIN:
		case GS_PROCESS_FADEOUT:
		case GS_PROCESS_SCORE:
		case GS_PROCESS_RANKING:
		case GS_PROCESS_INPUT:
		case GS_PROCESS_FULLVER:
		{
			//[animManager checkCollision:animManagerEnemy];
			if (animManager != nil)
				[animManager run:bTouch touchMode:touchMode x:touchX y:touchY view:self];
			/*if (animManagerEnemy != nil)
			 [animManagerEnemy run:bTouch touchMode:touchMode x:touchX y:touchY view:self];*/
		}
			break;
		default:
			break;
	}
}

- (void)drawView {
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glViewport(0, 0, backingWidth, backingHeight);
	// Clear screen
	glClear(GL_COLOR_BUFFER_BIT);
	
	CGRect mainBounds = self.bounds; 
	
	//draw the background
	switch (gameState) {
		case GS_INIT_GAME:
			//#ifdef FIG_ADWHIRL
			//rollerView.hidden = YES;
			//#endif			
			[main_Game.loadingBackground drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];		
			
			break;
		case GS_PROCESS_GAME:
			//rollerView.hidden = YES;
			[main_Game.gameBackground drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
			break;
		default:
			//rollerView.hidden = NO;
			[background drawImageWithNo:CGPointMake(mainBounds.size.width/2, mainBounds.size.height/2) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
			break;
	}
	
	switch (gameState) {
		case GS_INIT_GAME :
			[main_Game_loadAnim drawLoadAnim:self fadeLevel:fadeLevel];
			break;
		case GS_PROCESS_GAME :
			[main_Game_Map drawMap:self fadeLevel:fadeLevel];
			
			//MaxPan add preview food
//			if(main_Game.preViewTexture)
//				[main_Game.preViewTexture drawImageWithNo:CGPointMake(454, 285.0) no:0 angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fadeLevel];
			//MaxPan
			break;	
			
			//Wayne Add{
		case GS_PROCESS_INPUT :
			[main_input drawInput:self fadeLevel:fadeLevel];
			break;
			
		case GS_PROCESS_RANKING :
			if(isLocalRank) //Local Rank
				[main_ranking drawLocalRanking:self fadeLevel:fadeLevel];
			else //Global Rank
				[main_ranking drawGlobalRanking:self fadeLevel:fadeLevel];
            break;
			//Wayne Add}
		default:
			//Do nothing
			break;
	}
	
	switch (gameState) {
		case GS_INIT_GAME:
			break;
		case GS_PROCESS_GAME:
		{			
			if(main_Game.gameFoodAnimManager !=nil)
			{					
				[main_Game.gameFoodAnimManager drawWithFade:fadeLevel];
			}
			
			if(main_Game.gameEnemyAnimManager !=nil)
			{	
				[main_Game.gameEnemyAnimManager drawWithFade:fadeLevel];
//				[main_Game.gameEnemyAnimManager checkCollision:main_Game.gameAnimManager];
			}	
			
			if(main_Game.gameAnimManager != nil)
			{	
				[main_Game.gameAnimManager drawWithFade:fadeLevel];
//				[main_Game.gameAnimManager checkCollision:main_Game.gameOtherAnimManager];
			}
			
			switch (main_Game.gameStageState) 
			{
				case GSStateGameOver:
				case GSStateGameSucceed:
					if(main_Game.gameESAnimManager!=nil)
					{
						[main_Game.gameESAnimManager drawWithFade:fadeLevel];
					}
					break;
				default:
					break;
			}
			break;
		}
			
		case GS_PROCESS_MENU:
		{
			if (animManager != nil)
				[animManager drawWithFade:fadeLevel];
			//LuckyDraw {
			if ( LuckyDrawAnimManager!= nil)
				[LuckyDrawAnimManager drawWithFade:fadeLevel];
			//LuckyDraw }
			switch (main_menu.mainMenuState) {
				case MMenuStateNoticeDisp:
					if (PopupAnimManager != nil)
						[PopupAnimManager drawWithFade:fadeLevel];
					break;
				default:
					break;
			}
#if defined(FIG_ADWHIRL)
			if(useMyBanner==TRUE)
				[self DrawAPBanner:fadeLevel];
#endif
		}
			break;
		case GS_PROCESS_FULLVER:
		{
			if (animManager != nil)
				[animManager drawWithFade:fadeLevel];
#if defined(FIG_ADWHIRL)
			if(useMyBanner==TRUE)
				[self DrawAPBanner:fadeLevel];
#endif
		}
			break;
		default:
			if (animManager != nil)
				[animManager drawWithFade:fadeLevel];
			break;
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}

- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFramebuffer 
{    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)startAnimation {
//	enableEndless = _ENABLE_ENDLESS_MODE_;

    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(mainAppLoop) userInfo:nil repeats:YES];
}

- (void)stopAnimation {
    self.animationTimer = nil;
}

- (void)pauseAnimation {
    [animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

// ---------------------------------------------------
// Handle touch event

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	bTouch = TRUE;
	touchMode = @"Began";
	touchX = touchPoint.x;
	touchY = backingHeight - touchPoint.y;	
	
	//Max Pan handle touch
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	touchMode = @"Move";
	//tmp solution to solve input moving event
	if(gameState == GS_PROCESS_INPUT || gameState == GS_INIT_INPUT || gameState == GS_END_INPUT)
	{
		//do nothing
	}
	else
	{
		touchX = touchPoint.x;
		touchY = backingHeight - touchPoint.y;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	bTouch = FALSE;
	touchMode = @"End";
}
// ---------------------------------------------------

// ---------------------------------------------------
// Handle accelerometer event (GSensor)

#if defined(FIG_USE_GSENSOR) 

#if defined(FIG_USE_SIMULATOR)
- (void)accelerometer:(zUIAccelerometer*) accelerometer didAccelerate:(zUIAcceleration*) acceleration 
#else
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
#endif	
{
	//float xx = acceleration.x;
	//float yy = acceleration.y;
	//float zz = acceleration.z;
	car_xx = acceleration.x;
	car_yy = acceleration.y;
	car_zz = acceleration.z;
	//NSLog(@"XX = %f, YY= %f, ZZ = %f", xx, yy, zz);
	//NSLog(@"XX = %f, YY= %f, ZZ = %f", car_xx, car_yy, car_zz);
	
	// add your code here
	
}
#endif	//FIG_USE_GSENSOR

// ---------------------------------------------------

// --------------------------------------------------- 
// Handle fade in/out

-(BOOL)processFade {
	if (isFading) {
		fadeLevel += fadeLevelAdd;
		if (fadeLevel < 0)
			fadeLevel = 0;
		if (fadeLevel > 1.0)
			fadeLevel = 1.0;
		if ((fadeLevelAdd < 0 && fadeLevel <= fadeLevelNew) ||
			(fadeLevelAdd > 0 && fadeLevel >= fadeLevelNew)) {
			isFading = FALSE;
			fadeLevel = fadeLevelNew;
		}
	}
	return isFading;
}

-(BOOL)processFadeIn {
	// fadein finish?
	if ([self processFade] == FALSE) {
		gameState = gameStateNew;
	}
	return TRUE;
}

-(BOOL)processFadeOut {
	// fadeout finish?
	if ([self processFade] == FALSE) {
		gameState = gameStateNew;
	}
	return TRUE;
}

- (void)setFadeIn:(NSInteger)frame {
	if (fadeLevel < 1.0 && frame > 0) {
		fadeLevelNew = 1.0;
		fadeLevelAdd = (fadeLevelNew - fadeLevel) / (GLfloat)frame;
		isFading = TRUE;
	}
}

- (void)setFadeOut:(NSInteger)frame {
	if (fadeLevel > 0.0 && frame > 0) {
		fadeLevelNew = 0.0;
		fadeLevelAdd = (fadeLevelNew - fadeLevel) / (GLfloat)frame;
		isFading = TRUE;
	}
}

// process to next state with fade in
-(void)fadeInWithState:(GLuint)state {
	gameStateNew = state;
	gameState = GS_PROCESS_FADEIN;
	[self setFadeIn:FADETIME];
}

// process to next state with fade out
-(void)fadeOutWithState:(GLuint)state {
	gameStateNew = state;
	gameStateOld = gameState;
	gameState = GS_PROCESS_FADEOUT;
	[self setFadeOut:FADETIME];
}
// ---------------------------------------------------
//Wayne add{
- (void)setScore:(NSInteger)score {
	finalScore = score;
}
- (NSInteger)getScore {
	return self.main_Game.grandTotalScore; //pohsu
}
/*- (void)setUserName:(NSInteger)score {
 finalScore = score;
 }*/
- (BOOL)getUserName:(NSMutableArray*)playerName {
	if(playerName == nil)
		return NO;
	[playerName addObject:rankInputName];
	//[playerName addObject:];
	return YES;
}
//Wayne add}
//
#if defined(FIG_USE_NV)

/*add by Leo to save/read information/NV for next launch*/
-(void) saveToFileSystem {
	//[[NSUserDefaults standardUserDefaults] setV:view.gameLevel forKey:@"gameLevel"];
    //userName=@"leo";//testing
	
	[[NSUserDefaults standardUserDefaults] setInteger:enableEndless forKey:@"NV_EnableEndless"];
	
	[[NSUserDefaults standardUserDefaults] setInteger:showDemo forKey:@"NV_ShowDemo"];
	[[NSUserDefaults standardUserDefaults] setInteger:gameLevel forKey:@"NV_gameLevel"];
	[[NSUserDefaults standardUserDefaults] setInteger:grandTotalScore forKey:@"NV_grandTotalScore"];
	[[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"NV_userName"];
	[[NSUserDefaults standardUserDefaults] setInteger:musicOFF forKey:@"NV_musicON"];
	[[NSUserDefaults standardUserDefaults] setInteger:soundOFF forKey:@"NV_soundON"];
	[[NSUserDefaults standardUserDefaults] setInteger:_HAD_USE_GAME_FLAG_ forKey:@"NV_isFirstUse"];

	//[[NSUserDefaults standardUserDefaults] setInteger:_HAD_USE_GAME_FLAG_ forKey:@"NV_isFirstEnterGame"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];	
}

-(void)writeNVitemDemo{
	[[NSUserDefaults standardUserDefaults] setInteger:showDemo forKey:@"NV_ShowDemo"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)writeNVitem:(NSString *)defaultName{
	[[NSUserDefaults standardUserDefaults] setInteger:_HAD_USE_GAME_FLAG_ forKey:defaultName];	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
/*add by Leo to save information for next launch*/
-(void) readFromFileSystem {	
	enableEndless = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_EnableEndless"];	
	userName=[[NSUserDefaults standardUserDefaults] objectForKey:@"NV_userName"];
	if(userName == nil) {
		userName = @"PLAYER";
		[[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"NV_userName"];
	}
	gameLevel= [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_gameLevel"];
	grandTotalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_grandTotalScore"];
	if(grandTotalScore < 0)
		grandTotalScore =0;
	musicOFF = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_musicON"];
	soundOFF = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_soundON"];
	isFirstUse = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_isFirstUse"];
	isFirstEnterGame = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_isFirstEnterGame"];
	showDemo = [[NSUserDefaults standardUserDefaults] integerForKey:@"NV_ShowDemo"];
}

#endif

- (void)dealloc {
    
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
	
	[twitterMgr release];
    [main_menu release];
	[main_logo release];
	[main_title release];
	[main_info release];
	[main_help release];
	[main_options release];
	[main_Game release];
	[main_Game_Map release];
	[main_Game_loadAnim release]; //Jarsh
	//Wayne Add{
	[main_input release];
	[main_ranking release];
	[rankInputName release];
	[topNameList release];
	[topScoreList release];
	//Wayne Add}	
#if defined(FIG_USE_GSENSOR) && defined(FIG_USE_SIMULATOR)
	[am release];	
#endif
	
#if defined(FIG_USE_SOUNDEFFECT)
	[soundEffect release];
	[song close];
	[song release];
#endif 
	
	[scoreRanking release];
	
    [context release];  
    [super dealloc];
}

#if defined(FIG_ADWHIRL)
#pragma mark ARRollerDelegate optional delegate method implementations
-(void)DrawAPBanner:(GLfloat) fade_Level
{
	int bannerNO = 0;
	bannerNO = frameCount/120%5;
	[myAdBanner drawImageWithNo:CGPointMake(160, 295) no:bannerNO angleX:0.0 angleY:0.0 angleZ:0.0 scaleX:1.0f scaleY:1.0f scaleZ:1.0f alpha:fade_Level];
}

- (void)rollerDidReceiveAd:(ARRollerView*)adWhirlView
{
	NSLog(@"Received ad from %@!", [adWhirlView mostRecentNetworkName]);
	useMyBanner = FALSE;
	
}

-(NSString*)adWhirlApplicationKey
{
	return @"e47c4a87196b102dada5b193ce4f21b9"; //change your AP Key here: return AdWhirl key;
	//return @"42b877e5bfc0102cb741df581a7911e8"; //Sample Key: return AdWhirl key;
	
}

- (void)rollerDidFailToReceiveAd:(ARRollerView*)adWhirlView usingBackup:(BOOL)YesOrNo
{
	NSLog(@"Failed to receive ad from %@.  Using Backup: %@", [adWhirlView mostRecentNetworkName], YesOrNo ? @"YES" : @"NO");
}
#endif

-(void)PlaySoundEffect:(int)sndType playorstop:(BOOL)action
{
	int sourceNum;
	
	if(soundOFF == YES)
		return;
	
	soundObj2 = nil;
	switch (sndType)
	{
		case EN_FOODTYPE1:  //Monkey right
			soundObj2 = sndAnimal[0];
			sourceNum = 2;
			break;
		case EN_FOODTYPE2:  //Battery
			soundObj2 = sndAnimal[1];
			sourceNum = 2;
			break;
		case EN_FOODTYPE3: //KY
			soundObj2 = sndAnimal[2];
			sourceNum = 2;
			break;
		case EN_FOODTYPE4: //Gira
			soundObj2 = sndAnimal[3];
			sourceNum = 2;
			break;
		case EN_FOODTYPE5: //Lion
			soundObj2 = sndAnimal[4];
			sourceNum = 2;
			break;
		case EN_FOODTYPE6:  //Rabbit
			soundObj2 = sndAnimal[5];
			sourceNum = 2;
			break;
		case EN_FOODTYPE7:	//RoadBlock
			soundObj2 = sndAnimal[6];
			sourceNum = 2;
			break;
		case EN_FOODTYPE8:	//Holes
			soundObj2 = sndAnimal[7];
			sourceNum = 2;
			break;
		case EN_LevelFail:	//Level fail
			soundObj2 = sndAnimal[8];
			sourceNum = 2;
			break;
		case EN_LevelSuccess:	//Level Success
			soundObj2 = sndAnimal[9];
			sourceNum = 2;
			break;
		case EN_BUTTONPRESS:
			soundObj2 = sndButtonPress;
			sourceNum = 1;
			break;	
		default:
			break;
	}
	
	if(soundObj2)
	{
		if(action)
			[soundEffect play:soundObj2 sourceNumber:sourceNum];
		else
			[soundEffect stop:soundObj2 sourceNumber:sourceNum];
	}
}

@end
