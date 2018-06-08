//
//  WordDescriptionLayer.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 09.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "WordDescriptionLayer.h"
#import "WGThemeCore.h"
#import "GlobalDefines.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "CCMenuAdvanced.h"
#import "ScalableMenuItemImage.h"

#import "SoloGameLayer.h"
#import "DuoGameLayer.h"
#import "NSString+ActiveSupportInflector.h"

@implementation WordDescriptionLayer
//@synthesize selectedWord;

static NSString* selword_=nil;
static NSString* backScene_=nil;

+(void)setSelectedWord:(NSString *)selword
{
    selword_=selword;
}
+(void)setBackScene:(NSString*)backscene
{
    backScene_=backscene;
}

+(CCScene*)scene_
{
    CCScene *scene=[CCScene node];
    WordDescriptionLayer *layer=[WordDescriptionLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super initWithColor:[WGThemeCore getBackgroundColor]])
    {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    //RETURN BACK BUTTON
    ScalableMenuItemImage *m2=[ScalableMenuItemImage itemWithNormalImage:@"buttonReturnback.png" selectedImage:@"buttonReturnback.png" target:self selector:@selector(buttonReturnBackPressed)];
    CCMenuAdvanced *mnu_=[CCMenuAdvanced menuWithItems:m2, nil];
    [self addChild:mnu_];
    [mnu_ alignItemsVertically];
    int mhp2=mnu_.contentSize.height/2;
    [mnu_ setPosition:ccp(wsz.width-mnu_.contentSize.width-mhp2,mhp2)];
    
}

-(void)buttonReturnBackPressed
{
    id backScene=NSClassFromString(backScene_);
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:1.0 scene:[backScene scene_]]];
}

-(void)rePositionLabel
{
    float rotation_=0;
    
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    
    BOOL isKnownRotation=(orientation==UIDeviceOrientationPortrait)||(orientation==UIDeviceOrientationPortraitUpsideDown)||
    (orientation==UIDeviceOrientationLandscapeLeft)||(orientation==UIDeviceOrientationLandscapeRight);
    if(!isKnownRotation)orientation=UIDeviceOrientationPortrait;
    
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            rotation_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotation_=180;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotation_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotation_=-90;
            break;
            
        default:
            break;
    }
    
    CCLabelBMFont *word_description_label=(CCLabelBMFont*)[self getChildByTag:TAG_WORD_DESCRIPTION_LABEL];
    
    if (word_description_label)
    {
        [word_description_label setRotation:rotation_];
    }
}

-(NSString*)getWordDescriptionFromWordNet:(NSString*)wordString
{
    wordString=[wordString lowercaseString];
    
    //AppController *appdelegate=[[UIApplication sharedApplication]delegate];
    //NSString *fg_=[appdelegate.cachesPath stringByAppendingString:@"/wordnet30"];
    NSString *fg_=[[NSBundle mainBundle]pathForResource:@"wordnet30" ofType:@""];
    FMDatabase *db = [FMDatabase databaseWithPath:fg_];
    [db open];
    
    NSString *sqltext_=[NSString stringWithFormat:
                        //@"SELECT (word.lemma||' : '||synset.definition||'\neg: ' ||sample.sample) FROM word INNER JOIN sense ON word.wordid = sense.wordid INNER JOIN synset ON sense.synsetid = synset.synsetid INNER JOIN sample ON sample.synsetid = synset.synsetid WHERE word.lemma = '%@' limit 1",
                        @"SELECT synset.definition,group_concat(sample.sample,' ')AS sample FROM word INNER JOIN sense ON word.wordid = sense.wordid INNER JOIN sample ON sample.synsetid = sense.synsetid INNER JOIN synset ON sense.synsetid = synset.synsetid WHERE word.lemma = '%@' group by definition limit 3", wordString];
    
    NSMutableString *word_description=[NSMutableString stringWithFormat:@""];//[db stringForQuery:sqltext_];
    
    FMResultSet *results_=[db executeQuery:sqltext_];
    
    while([results_ next])
    {
        NSString *desc_=[results_ stringForColumnIndex:0];
        NSString *eg_=[results_ stringForColumnIndex:1];
        NSString *row_=[NSString stringWithFormat:@"%@ : %@ eg: %@ ",wordString,desc_,eg_];
        [word_description appendString:row_];
    }
    
    [db close];
    
    if ([word_description length]==0)
        word_description=[NSString stringWithFormat:@"no description found for %@.",(!wordString)?@"":wordString];
    
    return (word_description);
}


-(void)onEnter
{
    //description label
    [super onEnter];
    CCLabelBMFont *word_description_label_=[CCLabelBMFont labelWithString:@" " fntFile:@"chalkbuster_30.fnt" width:270 alignment:kCCTextAlignmentCenter];
    [word_description_label_ setTag:TAG_WORD_DESCRIPTION_LABEL];
    [word_description_label_ setColor:[WGThemeCore getHexagonFontColor]];
    //[word_description_label_ set ZOrder:99999];
    
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    [self addChild:word_description_label_ z:999999];
    CGPoint p1=ccp(wsz.width/2,wsz.height/2);
    [word_description_label_ setPosition:p1];
    //[word_description_label_ setAnchorPoint:ccp(0,1)];
    
    NSString *singularWord_=[[selword_ lowercaseString]singularizeString];
    NSString *desc=[self getWordDescriptionFromWordNet:singularWord_];
    
    
    [self setDescriptionLabel:desc];
    
    [self setColorForWordsInDescriptionLabel:[NSString stringWithFormat:@"%@ :", selword_]  Color:[WGThemeCore getTitleColor]];
    [self setColorForWordsInDescriptionLabel:@"eg:"  Color:[WGThemeCore getTitleColor]];
    [self rePositionLabel];
    
    
}

-(void)setColorForWordsInDescriptionLabel:keyWord Color:(ccColor3B)color
{
    CCLabelBMFont *description_label_=(CCLabelBMFont*)[self getChildByTag:TAG_WORD_DESCRIPTION_LABEL];
    
    NSString *txt_=(NSString*)[description_label_ userData];
    int txt_count_=[txt_ length];
    int keyWord_count=[keyWord length];
    
    //length = [str length];//bu alttaki 3 satırı cocos hatası yüzünden yazdım normalde labelsetcolor düzgün çalışmıyor
    
    CCArray *arr=[description_label_ children];
    
    /*
     for (CCSprite *ee in [description_label_ children]) {
     [ee setColor:old_color_];
     
     }
     */
    //int sum_=[arr count];
    
    NSRange range = NSMakeRange(0, txt_count_);
    // CCArray *arr=[description_label_ children];
    
    while(range.location != NSNotFound)
    {
        range = [txt_ rangeOfString: keyWord options:NSLiteralSearch range:range];
        
        if(range.location != NSNotFound)
        {
            for (int i=0;i<keyWord_count;i++)
                [(CCSprite*)[arr objectAtIndex:range.location+i] setColor:color];
            range = NSMakeRange(range.location + range.length, txt_count_ - (range.location + range.length));
        }
    }
}

-(void)setDescriptionLabel:(NSMutableString*)description
{
    CCLabelBMFont *description_label_=(CCLabelBMFont*)[self getChildByTag:TAG_WORD_DESCRIPTION_LABEL];
    
    [description_label_ cleanup];
    [description_label_ setString:description];
    [description_label_ setUserData:description];
    
    ccColor3B c=[WGThemeCore getHexagonFontColor];
    
    for (CCSprite *ee in [description_label_ children]) {
        [ee setColor:c];
    }
    
}

-(void)dealloc
{
    [super dealloc];
}

@end
