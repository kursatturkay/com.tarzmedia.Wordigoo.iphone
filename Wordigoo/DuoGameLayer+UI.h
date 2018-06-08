//
//  SoloGameLayer+UI.h
//  wordible
//
//  Created by Kursat Turkay on 09.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "DuoGameLayer.h"

@interface DuoGameLayer (UI)
{
}
-(void)initBoard;
-(void)rePositionBoard:(UIDeviceOrientation)orientation;
-(void)setScoreLabel:(NSString*)score forPlayer:(PlayerType)Player;
-(void)setFoundWordLabel:(NSString*)foundword;

-(void)saveDuoGameState;
-(void)loadDuoGameState;
@end
