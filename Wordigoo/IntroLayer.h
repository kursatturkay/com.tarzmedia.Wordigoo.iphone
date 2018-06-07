//
//  IntroLayer.h
//  wordible
//
//  Created by callodiez on 08.07.2013.
//  Copyright tarzmedia 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCAlertView.h"
#import "AudioVisualization.h"
#import "WGScoreCore.h"
#import "GlobalEnums.h"

// HelloWorldLayer
@interface IntroLayer : CCLayerColor<AudioVisualizationProtocol,WGScoreCoreDelegate>
{
    //BOOL orient_timeout_triggered;
    CCAlertView *alertView;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene_;

@end
