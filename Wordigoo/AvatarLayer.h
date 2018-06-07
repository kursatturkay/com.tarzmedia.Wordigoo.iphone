//
//  AvatarLayer.h
//  wordigoo-iphone
//
//  Created by callodiez on 15.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "PhotoSprite.h"

@interface AvatarLayer : CCLayerColor<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //UIImagePickerController *pickerController;

}
@property(nonatomic,retain) UIImage *img;
@property(nonatomic,assign)PhotoSprite *photoSprite;
+(CCScene*)scene_;
@end
