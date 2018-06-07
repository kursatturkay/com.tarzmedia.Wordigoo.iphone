//
//  NSString+blab.m
//  YasayanMasallar
//
//  Created by callodiez on 12.02.2013.
//
//

#import "GeneralUtilities.h"
#import <unistd.h>
#import <netdb.h>

BOOL isOnline()
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

BOOL is24HourSet()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    [formatter release];
    NSLog(@"%@\n",(is24h ? @"YES" : @"NO"));
    return is24h;
}


int getCurrentHour()
{
    int res_=-1;
    
    NSDate *curDate=[NSDate date];
    //NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //[formatter  setDateFormat:@"hh:mm:ss a"];
    //NSLog(@"Date Time is Now:%@",[formatter stringFromDate:curDate]);
    
    //[formatter release];
    NSCalendar *cal=[NSCalendar currentCalendar];
    NSDateComponents *datecomp_=[cal components:NSHourCalendarUnit fromDate:curDate];
    res_= [datecomp_ hour];
    return res_;
}

CGRect CGRectFromSpriteRect(CGRect spriteRect)
{
    CGRect res_=spriteRect;
    res_.origin.x=res_.origin.x-(res_.size.width/2);
    res_.origin.y=res_.origin.y-(res_.size.height/2);
    return res_;
}

//srand(time(NULL));süre bazlı

float randFloatBetween(float low,float high)
{
    
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

int randIntBetween(int min_n, int max_n)
{
    //somesays arc4random() is better than srand()
    srandom(time(NULL));
    return rand() % (max_n - min_n + 1) + min_n;
}

//use 0,0 to reset henüz yazılmadı resetleme
int randIntReservedBetween(int min_n, int max_n)
{
    //somesays arc4random() is better than srand()
    srandom(time(NULL));
    static int blacklist_count=0;
    static NSMutableArray *blacklist_arr=nil;
    
    if ((min_n==0)&&(max_n==0))
    {
        [blacklist_arr removeAllObjects];
        blacklist_count=0;
        return -1;
    }
    
    
    if (!blacklist_arr)
        blacklist_arr=[[NSMutableArray alloc]init];
    
    int selected_no;
    NSUInteger objIdx;
    
    do
    {
        selected_no=arc4random() % (max_n - min_n + 1) + min_n;
        objIdx=[blacklist_arr indexOfObject:[NSNumber numberWithInt:selected_no]];
        
        if(objIdx==NSNotFound)
        {
            [blacklist_arr addObject:[NSNumber numberWithInt:selected_no]];
            blacklist_count++;
        }
        
        if (blacklist_count>=max_n)
        {
            blacklist_count=0;
            [blacklist_arr removeAllObjects];
            NSLog(@"randIntReservedBetween CLEARED");
        }
    }
    while(objIdx!=NSNotFound);
    NSLog(@"randIntReservedBetween: %d",selected_no);
    return  selected_no;
}


BOOL hasRetinaDisplay()
{
    // checks for iPhone 4. will return a false positive on iPads, so use the above function in conjunction with this to determine if it's a 3GS or below, or an iPhone 4.
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
        return YES;
    else
        return NO;
}