//
//  NSString+Utils.m
//  cocos2d-ios
//
//  Created by Kursat Turkay on 06.07.2013.
//
//

#import "NSString+Utils.h"

@implementation NSString (Random)

+(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

-(CGPoint)NSStringToCGPoint
{
    float x_=[[[self componentsSeparatedByString:@","]objectAtIndex:0]floatValue];
    float y_=[[[self componentsSeparatedByString:@","]objectAtIndex:1]floatValue];
    return CGPointMake(x_,y_);
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}
+(NSString*)randomAlphanumericStringWithLengthAndLetters:(NSInteger)length letters:(NSString *)aLetters
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [aLetters characterAtIndex:arc4random() % [aLetters length]]];
    }
    
    return randomString;
}
+(NSString*)repeatString:(NSString*)aString repeat:(int)aRepeat
{
    NSString *ret_=[NSString string];
    
    for (int i=0; i<aRepeat; i++) {
        ret_=[ret_ stringByAppendingString:aString];
    }
    return ret_;
}

+(NSString*)reBuildEnglishMostUsedLetterList
{
    NSString *ret_=[NSString string];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"A" repeat:80]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"B" repeat:16]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"C" repeat:30]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"D" repeat:44]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"E" repeat:120]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"F" repeat:25]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"G" repeat:17]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"H" repeat:64]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"I" repeat:80]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"J" repeat:4]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"K" repeat:8]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"L" repeat:40]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"M" repeat:30]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"N" repeat:30]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"O" repeat:80]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"P" repeat:17]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"Q" repeat:5]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"R" repeat:62]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"S" repeat:80]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"T" repeat:90]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"U" repeat:34]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"V" repeat:12]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"W" repeat:20]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"X" repeat:4]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"Y" repeat:20]];
    ret_=[ret_ stringByAppendingString:[self repeatString:@"Z" repeat:2]];
    
    return ret_;
}
@end
