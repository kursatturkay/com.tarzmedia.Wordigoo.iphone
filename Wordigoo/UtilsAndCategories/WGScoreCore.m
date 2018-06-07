//
//  WGScoreCore.m
//  wordigoo-iphone
//
//  Created by callodiez on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "WGScoreCore.h"
#import "WGThemeCore.h"

#import "KTInternetUtils.h"
#import "NSURLConnection+Blocks.h"

@implementation WGScoreCore
@synthesize delegate;

static WGScoreCore *standartStaticScoreCore=nil;

/*eg. tuesday: is 7 letters and returns 200 points*/
/*phones*/
+(NSUInteger)getPointByLetterCount:(int)alettercount
{
    NSUInteger ret_=-1;
    
    //static NSArray *letterPoints;
    //static dispatch_once_t onceToken;
    
    //dispatch_once(&onceToken, ^{
    NSArray *letterPoints=[NSArray arrayWithObjects:
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:10],
                           [NSNumber numberWithInt:20],
                           [NSNumber numberWithInt:50],
                           [NSNumber numberWithInt:100],
                           [NSNumber numberWithInt:200],
                           [NSNumber numberWithInt:500],
                           [NSNumber numberWithInt:1000],
                           [NSNumber numberWithInt:2000],
                           [NSNumber numberWithInt:5000],
                           [NSNumber numberWithInt:10000],
                           [NSNumber numberWithInt:20000],
                           [NSNumber numberWithInt:50000],
                           [NSNumber numberWithInt:100000],
                           [NSNumber numberWithInt:200000],
                           [NSNumber numberWithInt:500000],
                           [NSNumber numberWithInt:1000000],
                           [NSNumber numberWithInt:2000000],
                           [NSNumber numberWithInt:5000000],
                           [NSNumber numberWithInt:10000000],
                           [NSNumber numberWithInt:20000000],
                           [NSNumber numberWithInt:50000000],
                           nil];
    
    if (alettercount>23)ret_=0;
    else
        ret_=[[letterPoints objectAtIndex:alettercount-1] unsignedIntegerValue];
    return  ret_;
}

/*
 NSMutableData *dataStoreForRegisterUser=nil;
 NSMutableData *dataStoreForGetRank=nil;
 NSMutableData *dataStoreForPostRank=nil;
 */

/*
 arForRegisterUser,
 arForGetRank,
 arForPostRank
 */

-(void)WGDidFinishLoading:(WGScoreCore*)sender asyncResultType:(WGScoreCoreAsyncResultType)aasyncresulttype Success:(BOOL)asuccess data:(NSData*)adata
{
    
    if ( [self.delegate respondsToSelector:@selector(WGDidFinishLoading:asyncResultType:Success:data:)] )
    {
        [self.delegate WGDidFinishLoading:self asyncResultType:aasyncresulttype Success:asuccess data:adata];
    }
}

+(WGScoreCore*)standartScoreCore
{
    if (standartStaticScoreCore)
        return standartStaticScoreCore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        standartStaticScoreCore=[[WGScoreCore alloc]initSingleton];
    });
    
    return standartStaticScoreCore;
}

-(id)initSingleton
{
    if (self=[super init])
    {
        //self.isRegisterToServerResponded=NO;
        // self.registerToServerResponse=[NSString string];
        //self.AsyncResultType=arForNone;
    }
    return  self;
}

-(BOOL)isOfflineRegistered
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    NSString *onlineArenaUserName=[prefs stringForKey:@"onlineArenaUserName"];
    return (onlineArenaUserName);
}

/*
 eg. urlstr :@"http://localhost.:8080/isonlineregistered.ashx"
 */

-(void)getIsOnlineRegistered:(NSString*)urlstr
{
    NSString *urlstr_full=
    [NSString stringWithFormat:@"%@?username=%@&pass=%@",urlstr,
     [self getUserNameOffline],[self getPasswordOffline]];
    
    urlstr_full=[urlstr_full stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlstr_full];
    
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url
                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3.0f];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request
                                                          onCompletion:
                                 ^(NSData *data,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForIsRegisteredBefore Success:YES data:data];
                                 }
                                                                onFail:
                                 ^(NSError *error,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForIsRegisteredBefore Success:NO data:nil];
                                 }];
    
    [connection start];
    
}
/*
 -(BOOL)isOnlineRegistered:(NSString*)urlstr;
 {
 NSString *urlstr_full=
 [NSString stringWithFormat:@"%@?username=%@&pass=%@",urlstr,
 [self getUserNameOffline],[self getPasswordOffline]];
 
 urlstr_full=[urlstr_full stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSURL *url=[NSURL URLWithString:urlstr_full];
 
 NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
 [request setHTTPMethod:@"GET"];
 NSURLResponse *response;
 NSError *error = nil;
 NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
 returningResponse:&response
 error:&error];
 
 NSString *str=[[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
 //NSLog(@"receivedData:%@",receivedData);
 //NSString *x=[url absoluteString];
 if ([str isEqualToString:@"YES"])
 {
 return YES;
 }
 else
 if([str isEqualToString:@"NO"])
 {
 return NO;
 }
 
 //NSString *errText=[NSString stringWithFormat:@"nsassert error at isOnlineRegistered method :data is nil.Host link does not responded:%@",urlstr_];
 //NSAssert(receivedData!=nil,errText);
 return NO;
 }
 */

-(void)saveUserNameAndPasswordOffline:(NSString*)ausername password:(NSString*)apassword
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setObject:ausername forKey:@"onlineArenaUserName"];
    [prefs setObject:apassword forKey:@"onlineArenaPassword"];
    [prefs synchronize];
}

/*kullanıcı bilgisine ulaşılamamışsa webserverda offline tutulmasın.*/
-(void)deleteUserNameAndPasswordOffline
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"onlineArenaUserName"];
    [prefs removeObjectForKey:@"onlineArenaPassword"];
    [prefs synchronize];
}

-(NSString*)getIdentifierForVendor
{
    NSString *ret_=[[[UIDevice currentDevice]identifierForVendor]UUIDString];
    return ret_;
}

-(NSString*)getUserNameOffline
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    NSString *onlineArenaUserName=[prefs stringForKey:@"onlineArenaUserName"];
    NSAssert((onlineArenaUserName!=nil), @"onlineArenaUserName is nil (WGScoreCore getUserNameOffline method)");
    return (onlineArenaUserName);
}

-(NSString*)getPasswordOffline
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    NSString *onlineArenaPassword=[prefs stringForKey:@"onlineArenaPassword"];
    NSAssert((onlineArenaPassword!=nil), @"onlineArenaPassword is nil (WGScoreCore getPasswordOffline method)");
    return (onlineArenaPassword);
}

-(unsigned int)getScoreOffline
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    unsigned int soloGameTotalScore=-1;
    soloGameTotalScore=[prefs doubleForKey:@"soloGameTotalScore"];
    NSAssert((soloGameTotalScore!=-1), @"getScoreOffline is -1. (WGScoreCore getScoreOffline method)");
    return (soloGameTotalScore);
}


/*
 eg. [[WGScoreCore standartScoreCore] registerUserToServer:@"http://localhost.:8080/registeruser.ashx"];
 */
-(void)registerUserToServer:(NSString*)urlstr
{
    if (![[KTInternetUtils standartUtils]isOnline])return;
    
    NSString *urlstr_=
    [NSString stringWithFormat:@"%@?username=%@&pass=%@",urlstr,
     [self getUserNameOffline],[self getPasswordOffline]];
    
    urlstr_=[urlstr_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url_=[NSURL URLWithString:urlstr_];
    
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url_
                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3.0f];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request
                                                          onCompletion:
                                 ^(NSData *data,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForRegisterUser Success:YES data:data];
                                 }
                                                                onFail:
                                 ^(NSError *error,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForRegisterUser Success:NO data:nil];
                                 }];
    [connection start];
}

//!!!TODO: burda NSUserDefaults program ilk defa kurulmuşken test et değerini.
/*
 eg. urlstr :@"http://localhost.:8080/sendrank.ashx"
 */
-(void)postRankToServer:(NSString*)urlstr;
{
    //self.asyncResultType=arForPostRank;
    NSUInteger soloGameTotalScore=[[NSUserDefaults standardUserDefaults]integerForKey:@"soloGameTotalScore"];
    
    NSString *urlstr_=
    [NSString stringWithFormat:@"%@?username=%@&pass=%@&score=%lu",urlstr,
     [self getUserNameOffline],[self getPasswordOffline],soloGameTotalScore];
    
    urlstr_=[urlstr_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url_=[NSURL URLWithString:urlstr_];
    
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url_
                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3.0f];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request
                                                          onCompletion:
                                 ^(NSData *data,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForPostRank Success:YES data:data];
                                 }
                                                                onFail:
                                 ^(NSError *error,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForPostRank Success:NO data:nil];
                                 }];
    
    [connection start];
    
}

/*
 eg. urlstr : @"http://localhost.:8080/getrank.ashx"
 */
-(void)getRankFromServer:(NSString*)urlstr
{
    // self.asyncResultType=arForGetRank;
    NSString *urlstr_=
    [NSString stringWithFormat:@"%@?username=%@&pass=%@",urlstr,
     [self getUserNameOffline],[self getPasswordOffline]];
    
    urlstr_=[urlstr_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url_=[NSURL URLWithString:urlstr_];
    
    NSMutableURLRequest *request=[NSMutableURLRequest
                                  requestWithURL:url_
                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                  timeoutInterval:3.0f];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request
                                                          onCompletion:
                                 ^(NSData *data,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForGetRank Success:YES data:data];
                                 }
                                                                onFail:
                                 ^(NSError *error,NSInteger statuscode)
                                 {
                                     [self WGDidFinishLoading:self asyncResultType:arForGetRank Success:NO data:nil];
                                 }];
    
    [connection start];
    
}

/*amacı skorları medal içine yazmak*/
-(void)displayScoresWithParent:(CCLayer*)aparent
{
    NSArray *docPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[docPaths objectAtIndex:0];
    NSString *fn_=[docPath stringByAppendingString:@"/ranks.plist"];
    //CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:fn_])
    {
        NSDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:fn_];
        
        NSString *yourrankoftheweek=[dic valueForKey:@"yourrankoftheweek"];
        NSString *yourrankofthemonth=[dic valueForKey:@"yourrankofthemonth"];
        NSString *yourrankoftheyear=[dic valueForKey:@"yourrankoftheyear"];
        
        //NSDictionary *dic_top10oftheweek=[dic objectForKey:@"arr_top10oftheweek"];
        //NSDictionary *dic_top10ofthemonth=[dic objectForKey:@"arr_top10ofthemonth"];
        //NSDictionary *dic_top10oftheyear=[dic objectForKey:@"arr_top10oftheyear"];
        
        //NSArray *arr_top10oftheweek=[dic_top10oftheweek componentsSeparatedByString:@"|"];
        //NSArray *arr_top10ofthemonth=[dic_top10ofthemonth componentsSeparatedByString:@"|"];
        //NSArray *arr_top10oftheyear=[dic_top10oftheyear componentsSeparatedByString:@"|"];
        
        [self clearDisplayScoreLabel:aparent];
        [self createDisplayScoreLabelTo:aparent withText:@"This Week :" withX:5 withY:-10 andAlignment:kCCTextAlignmentRight];
        [self createDisplayScoreLabelTo:aparent withText:@"This Month :" withX:5 withY:-20 andAlignment:kCCTextAlignmentRight];
        [self createDisplayScoreLabelTo:aparent withText:@"This Year :" withX:5 withY:-30 andAlignment:kCCTextAlignmentRight];
        
        [self createDisplayScoreLabelTo:aparent withText:yourrankoftheweek withX:5 withY:-10 andAlignment:kCCTextAlignmentLeft];
        [self createDisplayScoreLabelTo:aparent withText:yourrankofthemonth withX:5 withY:-20 andAlignment:kCCTextAlignmentLeft];
        [self createDisplayScoreLabelTo:aparent withText:yourrankoftheyear withX:5 withY:-30 andAlignment:kCCTextAlignmentLeft];
        
    }
}

/*tag is 500*/
-(void)createDisplayScoreLabelTo:(CCLayer*)aparent withText:(NSString*)atext withX:(CGFloat)ax withY:(CGFloat)ay andAlignment:(CCTextAlignment)aalign
{
    
    CCLabelBMFont *lbl0=[CCLabelBMFont labelWithString:atext fntFile:@"chalkboard_20.fnt" width:aparent.contentSize.width/2 alignment:aalign];
    
    //[lbl1 runAction:[CCFadeOut action]];
    [lbl0 setTag:500];
    if (aalign==kCCTextAlignmentRight)
    {
        [lbl0 setAnchorPoint:ccp(1.0f,0.0f)];
        [lbl0 setPosition:ccp(ax+aparent.contentSize.width/2,ay)];
    }
    else
    {
        [lbl0 setPosition:ccp(ax+aparent.contentSize.width/2,ay)];
        [lbl0 setAnchorPoint:ccp(0.0f,0.0f)];
    }
    [aparent addChild:lbl0];
    
    
    [lbl0 setColor:[WGThemeCore getHexagonFontColor]];
}

-(void)clearDisplayScoreLabel:(CCLayer*)aparent
{
    for (CCLabelBMFont *ee in aparent.children)
    {
        NSString *cls=NSStringFromClass([ee class]);
        BOOL a=([cls isEqualToString:@"CCLabelBMFont"]);
        BOOL b=([ee tag]==500);
        
        if (a&&b)
        {[ee setString:@""];
            [ee cleanup];
        }
    }
    
    
}
/*
 yourscore=345300
 yourrankoftheweek=34/1026;
 yourrankofthemonth=434/1026;
 yourrankoftheyear=34/1026;
 top10oftheweek=ali khan,100000,http:vendor_id_23466745.png|hassan osman,73000,vendor_id_23466745.png|veli osman,68000,vendor_id_23466745.png|tansu colak,43000,vendor_id_23466745.png|yeliz filiz,40500,vendor_id_23466745.png;
 top10ofthemonth=ali khan,100000,http:vendor_id_23466745.png|hassan osman,73000,vendor_id_23466745.png|veli osman,68000,vendor_id_23466745.png|tansu colak,43000,vendor_id_23466745.png|yeliz filiz,40500,vendor_id_23466745.png;
 top10oftheyear=ali khan,100000,http:vendor_id_23466745.png|hassan osman,73000,vendor_id_23466745.png|veli osman,68000,vendor_id_23466745.png|tansu colak,43000,vendor_id_23466745.png|yeliz filiz,40500,vendor_id_23466745.png
 */
/*
 parses score package and saves to ranks.plist
 */
-(void)saveRanksData:(NSData *)adata
{
    NSString *str=[[NSString alloc]initWithData:adata encoding:NSUTF8StringEncoding];
    
    NSArray *arr1=[str componentsSeparatedByString:@";"];
    
    //paket doğruysa 6 bölüm olmalı yoksa değildir. bir error mesajı gelmiştir o zaman da alttaki kodlar işlenmesi out of bounds error veriyor
    if([arr1 count]!=7)return;
    
    /////////////////////////////kişinin en büyük skorunu da websunucudan alıp kaydediyoruz
    NSString *yourScoreStr=[arr1 objectAtIndex:0];//last score of you
    NSUInteger yourScore=[yourScoreStr integerValue];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithUnsignedInteger:yourScore] forKey:@"soloGameTotalScore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ////////////////////////////
    NSString *yourrankoftheweek=[arr1 objectAtIndex:1];
    NSString *yourrankofthemonth=[arr1 objectAtIndex:2];
    NSString *yourrankoftheyear=[arr1 objectAtIndex:3];
    
    NSString *top10oftheweek=[arr1 objectAtIndex:4];
    NSString *top10ofthemonth=[arr1 objectAtIndex:5];
    NSString *top10oftheyear=[arr1 objectAtIndex:6];
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setValue:yourrankoftheweek forKey:@"yourrankoftheweek"];
    [dic setValue:yourrankofthemonth forKey:@"yourrankofthemonth"];
    [dic setValue:yourrankoftheyear forKey:@"yourrankoftheyear"];
    
    NSArray *arr_top10oftheweek=[top10oftheweek componentsSeparatedByString:@"|"];
    NSArray *arr_top10ofthemonth=[top10ofthemonth componentsSeparatedByString:@"|"];
    NSArray *arr_top10oftheyear=[top10oftheyear componentsSeparatedByString:@"|"];
    
    [dic setValue:arr_top10oftheweek forKey:@"arr_top10oftheweek"];
    [dic setValue:arr_top10ofthemonth forKey:@"arr_top10ofthemonth"];
    [dic setValue:arr_top10oftheyear forKey:@"arr_top10oftheyear"];
    
    NSArray *docPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[docPaths objectAtIndex:0];
    NSString *fn_=[docPath stringByAppendingString:@"/ranks.plist"];
    [dic writeToFile:fn_ atomically:YES];
}

-(BOOL)clearRanksData
{
    NSArray *docPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[docPaths objectAtIndex:0];
    NSString *ffn_=[docPath stringByAppendingString:@"/ranks.plist"];
    BOOL ret_=[[NSFileManager defaultManager]removeItemAtPath:ffn_ error:nil];
    return ret_;
}

@end

