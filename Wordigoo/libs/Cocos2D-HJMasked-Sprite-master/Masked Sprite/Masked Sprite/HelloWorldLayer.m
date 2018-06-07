//
//  HelloWorldLayer.m
//  Masked Sprite
//
//  Created by Harrison Jackson on 10/29/12.



// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"HJMaskedSprite Demo" fontName:@"Marker Felt" fontSize:55];

	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height-label.boundingBox.size.height);
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Masked Sprite with image overlaying text
		//
        demoSprite = [[HJMaskedSprite alloc] initWithFile:@"stickman.png" andImageOverlay:@"Default-Landscape~ipad.png"];
        [demoSprite setScale:(size.width/4)/demoSprite.boundingBox.size.width];
        [demoSprite setPosition:ccp(size.width-size.width/4, size.height/2)];
        [self addChild:demoSprite];
        
        
        overlaySprite = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
        //[overlaySprite setScale:(size.width/6)/overlaySprite.boundingBox.size.width];
        [overlaySprite setPosition:ccp(size.width-size.width/4-overlaySprite.boundingBox.size.height, size.height/2-overlaySprite.boundingBox.size.height)];
        [self addChild:overlaySprite];
        
        normalSprite = [CCSprite spriteWithFile:@"stickman.png"];
        [normalSprite setScale:(size.width/4)/normalSprite.boundingBox.size.width];
        [normalSprite setPosition:ccp(size.width-size.width/4+overlaySprite.boundingBox.size.height/2, size.height/2-overlaySprite.boundingBox.size.height)];
        [self addChild:normalSprite];
        
        
        
        
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Overlaying Text Menu Item using blocks
		CCMenuItem *itemOverText= [CCMenuItemFont itemWithString:@"Image overlaying Image" block:^(id sender) {
            [demoSprite.parent removeChild:demoSprite cleanup:YES];
			demoSprite = [[HJMaskedSprite alloc] initWithFile:@"stickman.png" andImageOverlay:@"Default-Landscape~ipad.png"];
            //[demoSprite setScale:(size.width/4)/demoSprite.boundingBox.size.width];
            [demoSprite setPosition:ccp(size.width-size.width/4, size.height/2)];
            [self addChild:demoSprite];
			
		}];
        
        // Overlaying Text with Sprite Menu Item using blocks
		CCMenuItem *itemOverTextWithSprite = [CCMenuItemFont itemWithString:@"Image overlaying text" block:^(id sender) {
			[demoSprite.parent removeChild:demoSprite cleanup:YES];
            CCLabelTTF * demoLabel = [CCLabelTTF labelWithString:@"Demo Text Overlay" fontName:@"Arial" fontSize:40];
			demoSprite = [[HJMaskedSprite alloc] initWithSprite:demoLabel andImageOverlay:@"Default-Landscape~ipad.png"];
           // [demoSprite setScale:(size.width/4)/demoSprite.boundingBox.size.width];
            [demoSprite setPosition:ccp(size.width-size.width/4, size.height/2)];
            [self addChild:demoSprite];
			
			
		}];

		// Overlaying Image Menu Item using blocks
		CCMenuItem *itemOverImage = [CCMenuItemFont itemWithString:@"Sprite overlaying Text" block:^(id sender) {
			[demoSprite.parent removeChild:demoSprite cleanup:YES];
            CCLabelTTF * demoLabel = [CCLabelTTF labelWithString:@"Demo Text Overlay" fontName:@"Arial" fontSize:50];
            CCSprite * tempSprite = [CCSprite spriteWithFile:@"Icon@2x.png"];
            demoSprite = [[HJMaskedSprite alloc] initWithSprite:demoLabel andMaskSprite:tempSprite];
            //[demoSprite setScale:(size.width/4)/demoSprite.boundingBox.size.width];
            [demoSprite setPosition:ccp(size.width-size.width/4, size.height/2)];
            [self addChild:demoSprite];
			
			
		}];
        
        
        
        
        
        
        
		
		CCMenu *menu = [CCMenu menuWithItems:itemOverText, itemOverTextWithSprite, itemOverImage, nil];
		
		[menu alignItemsVerticallyWithPadding:20];

		[menu setPosition:ccp( size.width/4, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
