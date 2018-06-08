//
//  WordigooMacros.h
//  wordigoo
//
//  Created by Kursat Turkay on 25.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#ifndef wordigoo_WordigooMacros_h
#define wordigoo_WordigooMacros_h

/* USAGE
 SWITCH (string) {
 CASE (@"AAA") {
 break;
 }
 CASE (@"BBB") {
 break;
 }
 CASE (@"CCC") {
 break;
 }
 DEFAULT {
 break;
 }
 }
 */

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT


#endif
