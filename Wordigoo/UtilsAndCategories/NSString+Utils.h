//
//  NSString+Utils.h
//  cocos2d-ios
//
//  Created by Kursat Turkay on 06.07.2013.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

+(BOOL)stringIsNilOrEmpty:(NSString*)aString;
-(CGPoint)NSStringToCGPoint;
+(NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+(NSString*)randomAlphanumericStringWithLengthAndLetters:(NSInteger)length letters:(NSString*)aLetters;
+(NSString*)repeatString:(NSString*)aString repeat:(int)aRepeat;
+(NSString*)reBuildEnglishMostUsedLetterList;
@end
