//
//  KTInternetUtils.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "KTInternetUtils.h"
#import "Reachability.h"

@implementation KTInternetUtils

static KTInternetUtils *standartStaticUtils=nil;

-(BOOL) isOnline
{
    char const *hostname="google.com";
    struct hostent *hostinfo;
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
}
/*
+ (BOOL)connectedToInternet
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://www.google.com/"]];
    
    [request setHTTPMethod:@"HEAD"];
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}
*/

+(KTInternetUtils*)standartUtils
{
    if(standartStaticUtils)
        return standartStaticUtils;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        standartStaticUtils=[[KTInternetUtils alloc]initSingleton];
    });
    
    return standartStaticUtils;
}

-(id) initSingleton
{
    
    if (self=[super init])
    {
        //self.isOnline=[KTInternetUtils isOnline];
        /*
        Reachability *reach=[Reachability reachabilityWithHostname:@"www.google.com"];
        reach.reachableBlock=^(Reachability *reach)
        {
            NSLog(@"reachable");
            self.isOnline=YES;
        };
        
        reach.unreachableBlock=^(Reachability *reach)
        {
            NSLog(@"unreachable");
            self.isOnline=NO;
        };
        
        [reach startNotifier];
         */
    }
    return self;
}

@end
