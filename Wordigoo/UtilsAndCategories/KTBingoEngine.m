//
//  KTBingoEngine.m
//  wordigoo-iphone
//
//  Created by callodiez on 10.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "KTBingoEngine.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation KTBingoEngine
{
    
}
@synthesize bingoBag;

static KTBingoEngine *sharedStaticEngine=nil;
//NSMutableString *bingoStaticBag=nil;

-(id)initSingleton
{
    if(self=[super init])
    {
        if(!bingoBag)
            bingoBag=[[NSMutableString string]retain];
        
        [self checkAndFillBingoBag];
        
    }
    return self;
}

-(void)checkAndFillBingoBag
{
    
    
    int bag_len_=[bingoBag length];
    
    if (bag_len_>10)return;
    
    //AppController *appdelegate=[[UIApplication sharedApplication]delegate];
    NSString *fg_=[[NSBundle mainBundle]pathForResource:@"words" ofType:@"rdb"];
    //[appdelegate.cachesPath stringByAppendingString:@"/words.rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:fg_];
    [db open];
    
    NSString *sql_=@"select term from words order by random() limit 10";
    
    FMResultSet *results_=[db executeQuery:sql_];
    
    while ([results_ next])
    {
        NSString *term_=[[results_ stringForColumnIndex:0]uppercaseString];
        [bingoBag appendString:term_];
        NSLog(@"term: %@",term_);
    }
    
    [db close];
    
}

-(NSString*)randomLetter
{
    //NSString *a=[NSString stringWithString:bingoBag];
    int bag_len_=[bingoBag length];
    
    int start_=0;
    int r_=start_ +(arc4random()%(bag_len_-start_)+1);
    
    NSString *ret_=[bingoBag substringWithRange:NSMakeRange(r_-1, 1)];
    [bingoBag deleteCharactersInRange:NSMakeRange(r_-1, 1)];
    [self checkAndFillBingoBag];
    return ret_;
}


+(KTBingoEngine*)sharedEngine
{
    if(sharedStaticEngine)
        return sharedStaticEngine;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStaticEngine =[[KTBingoEngine alloc]initSingleton];
    });
    
    return sharedStaticEngine;
}

- (id) retain
{
    return self;
}

- (oneway void) release
{
    // Does nothing here.
}

- (id) autorelease
{
    return self;
}

- (NSUInteger) retainCount
{
    return INT32_MAX;
}

@end
