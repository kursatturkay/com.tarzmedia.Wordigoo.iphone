//
//  SoloGameLayer+UI.h
//  wordible
//
//  Created by Kursat Turkay on 09.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "SoloGameLayer.h"

@interface SoloGameLayer (UI)
{
}
-(void)initBoard;
-(void)rePositionBoard:(UIDeviceOrientation)orientation;
-(void)setScoreLabel:(NSString*)score;
-(void)setFoundWordLabel:(NSString*)foundword;

-(void)saveSoloGameState;
-(void)loadSoloGameState;
@end
