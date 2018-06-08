//
//  NSString+blab.h
//  YasayanMasallar
//
//  Created by Kursat Turkay on 12.02.2013.
//
//
#ifndef GeneralUtilities_h
#define GeneralUtilities_h

#import <Foundation/Foundation.h>

BOOL isOnline();
int getCurrentHour();
BOOL hasRetinaDisplay();
CGRect CGRectFromSpriteRect(CGRect spriteRect);
float randFloatBetween(float low,float high);
int randIntBetween(int min_n, int max_n);
int randIntReservedBetween(int min_n, int max_n);

#endif
