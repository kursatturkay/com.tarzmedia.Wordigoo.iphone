//
//  WGScoreCore.h
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GlobalEnums.h"
@class WGScoreCore;

@protocol WGScoreCoreDelegate

-(void)WGDidFinishLoading:(WGScoreCore*)sender asyncResultType:(WGScoreCoreAsyncResultType)aasyncresulttype Success:(BOOL)asuccess data:(NSData*)adata;

@end

@interface WGScoreCore : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
}
//-(id)delegate;
//-(void)setDelegate:(id)newDelegate;
+(WGScoreCore*)standartScoreCore;
@property(nonatomic,assign) id delegate;
//@property(nonatomic,assign)WGScoreCoreAsyncResultType asyncResultType;
//@property (nonatomic,retain) NSString *registerToServerResponse;
//@property (nonatomic,assign) BOOL isRegisterToServerResponded;
//@property (nonatomic,retain) CCLabelBMFont *responseLabel;
+(NSUInteger)getPointByLetterCount:(int)alettercount;

-(BOOL)isOfflineRegistered;
-(void)getIsOnlineRegistered:(NSString*)urlstr;

//-(void)registerToServer:(NSString*)urlstr withUserName:(NSString*)ausername withPassword:(NSString*)apassword;
//-(BOOL)postRankToServer:(NSString*)urlstr withUserName:(NSString*)ausername withPassword:(NSString*)apassword;
-(void)registerUserToServer:(NSString*)urlstr;
-(void)postRankToServer:(NSString*)urlstr;
-(void)getRankFromServer:(NSString*)urlstr;
-(void)saveUserNameAndPasswordOffline:(NSString*)ausername password:(NSString*)apassword;
-(void)deleteUserNameAndPasswordOffline;

//NSString *a1=[[[UIDevice currentDevice]identifierForVendor]UUIDString];
-(NSString*)getIdentifierForVendor;

//-(BOOL)getUserName;
//-(BOOL)getPassword;
-(unsigned int)getScoreOffline;

-(void)displayScoresWithParent:(CCLayer*)aparent;
-(void)saveRanksData:(NSData *)adata;
-(BOOL)clearRanksData;
@end
