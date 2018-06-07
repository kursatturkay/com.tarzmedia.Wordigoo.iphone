//
//  AppDelegate.mm
//  wordible
//
//  Created by callodiez on 08.07.2013.
//  Copyright tarzmedia 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "WGThemeCore.h"
#import "WGSoundCore.h"

@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
    return UIInterfaceOrientationMaskPortrait;
    //    return UIInterfaceOrientationMaskLandscape;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		
        bool isEverStartedUp=[[NSUserDefaults standardUserDefaults]boolForKey:@"isEverStartedUp"];
        
        if(!isEverStartedUp)
        {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isEverStartedUp"];
            [WGThemeCore initStandardUserDefaults];
            [[WGSoundCore sharedDirector]setChangeMusicOnRotationToSettings:YES];
            [[WGSoundCore sharedDirector]setMusicMutedToSettings:NO];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            //[self buttonStartupGuidePressed];
            id layer_=NSClassFromString(@"RulesLayer");
            [director runWithScene:[layer_ scene_]];
            return;
        }
        [director runWithScene: [IntroLayer scene_]];
	}
}
@end


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
//@synthesize cachesPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	// Enable multiple touches
	[glView setMultipleTouchEnabled:YES];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF HUD
	[director_ setDisplayStats:NO];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director_ setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
    [sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    [sharedFileUtils setEnableiPhoneResourcesOniPad:YES];
  
    // Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
    
    //!!!self.databaseName = @"words.rdb";
   
    //NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //self.cachesPath =[cachesPathArr objectAtIndex:0]; //[documentDir stringByAppendingPathComponent:self.databaseName];
    //[self createAndCheckDatabases];
    
	return YES;
}
/*
-(void) createAndCheckDatabases
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *words_rdb_FullPathInDocuments=[cachesPath stringByAppendingString:@"/words.rdb"];
    NSString *wordnet_FullPathInDocuments=[cachesPath stringByAppendingString:@"/wordnet30"];
    
    BOOL isSuccess_words_rdb = [fileManager fileExistsAtPath:words_rdb_FullPathInDocuments];
    BOOL isSuccess_wordnet30 = [fileManager fileExistsAtPath:wordnet_FullPathInDocuments];
    
    
    if (!isSuccess_words_rdb)
    {
        NSString *wordsrdb_PathInBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/words.rdb"];
        [fileManager copyItemAtPath:wordsrdb_PathInBundle toPath:words_rdb_FullPathInDocuments error:nil];
    }
    
    if (!isSuccess_wordnet30)
    {
        NSString *wordnet30_PathInBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/wordnet30"];
        [fileManager copyItemAtPath:wordnet30_PathInBundle toPath:wordnet_FullPathInDocuments error:nil];
    }
}
*/
// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    //[[CCDirector sharedDirector] pause];
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
    //[[CCDirector sharedDirector] pause];
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];
	
	[super dealloc];
}
@end

