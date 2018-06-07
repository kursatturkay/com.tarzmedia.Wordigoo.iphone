//
//  GlobalDefines.h
//  wordible
//
//  Created by callodiez on 09.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#define IS_IPHONE4_ORLOWER (([[CCDirector sharedDirector]winSize].height-568)<0?NO:YES)
#define IS_IPHONE5 (([[CCDirector sharedDirector]winSize].height-568)?NO:YES)
#define IS_IPAD (([[CCDirector sharedDirector]winSize].height-1024)?NO:YES)


#ifndef wordigoo_GlobalDefines_h
#define wordigoo_GlobalDefines_h

/*
#define TAG_URL_SENDRANK_ASHX @"http://localhost.:8080/sendrank.ashx"
#define TAG_URL_REGISTERUSER_ASHX @"http://localhost.:8080/registeruser.ashx"
#define TAG_URL_GETRANK_ASHX @"http://localhost.:8080/getrank.ashx"
#define TAG_URL_ISONLINEREGISTERED_ASHX @"http://localhost.:8080/isonlineregistered.ashx"
*/

#define TAG_URL_SENDRANK_ASHX @"http://wordigooserver.fablesalive.com/sendrank.ashx"
#define TAG_URL_REGISTERUSER_ASHX @"http://wordigooserver.fablesalive.com/registeruser.ashx"
#define TAG_URL_GETRANK_ASHX @"http://wordigooserver.fablesalive.com/getrank.ashx"
#define TAG_URL_ISONLINEREGISTERED_ASHX @"http://wordigooserver.fablesalive.com/isonlineregistered.ashx"


#define PTM_RATIO 32.0f
#define MAX_HEXAGONS 81

/////IPAD ONLY
#define TAG_BOTTOM_BUTTON_MENU 2122
#define TAG_DUO_SCORE_MENU_LAYER 2133
#define TAG_DUO_SCORE_TIP1 2134
#define TAG_DUO_SCORE_LABEL1 2135

#define TAG_DUO_SCORE_TIP2 2367
#define TAG_DUO_SCORE_LABEL2 2137
//END OF IPAD ONLY

////////////INTRO BUTTONS
#define TAG_INTRO_ONLINEAREA_MENUITEM 401
#define TAG_INTRO_SOLOGAME_MENUITEM 402
#define TAG_INTRO_DUOGAME_MENUITEM 403
#define TAG_INTRO_CHANGETHEME_MENUITEM 404
#define TAG_INTRO_STARTUPGUIDE_MENUITEM 405
//END OF INTRO BUTTONS

// JOIN ONLINE LAYER ELEMENTS
#define TAG_JOINONLINE_OKBUTTON 406
#define TAG_JOINONLINE_CANCELBUTTON 407
#define TAG_JOINONLINE_USERNAME_CCTEXTFIELD 408
#define TAG_JOINONLINE_PASSWORD_CCTEXTFIELD 409
#define TAG_JOINONLINE_ERROR_LABEL 410
// END OF JOIN ONLINE LAYER ELEMENTS

#define TAG_CLONE_BUTTON_MENU 123

#define TAG_SOCIALBUTTONS_MENU_LAYER 122
#define TAG_INTRO_START_MENU_LAYER 124
#define TAG_INTRO_SOLOGAME_TIP 125
#define TAG_INTRO_SOLOGAME_LABEL 126

#define TAG_SOLO_SCORE_MENU_LAYER 127
#define TAG_SOLO_SCORE_TIP 128
#define TAG_SOLO_SCORE_LABEL 129

#define TAG_FOUNDWORD_TIP 131
#define TAG_FOUNDWORD_LABEL 132

#define TAG_PARTICLE_FOUND 138

#define TAG_WORD_DESCRIPTION_LABEL 139

#define TAG_TOGGLE_CLONE_MENUITEM 140
#define TAG_TOGGLE_BOMB_MENUITEM 141

//#define TAG_WORD_DESCRIPTION_LAYER 142
#define TAG_BACKGROUND_IMAGE 143

//#define TAG_CORNER_MENU1 123 //TAG_CLONE_BUTTON_MENU ile aynı olmalı
#define TAG_CORNER_MENU2 144
#define TAG_CORNER_MENU3 145
#define TAG_CORNER_MENU4 146

//MEDAL
#define TAG_MEDAL_SPRITE 500
//
#define TAG_MEDAL_YOURRANKTHISWEEK_LABEL 501
#define TAG_MEDAL_YOURRANKTHISMONTH_LABEL_VAL 502
#define TAG_MEDAL_YOURRANKTHISYEAR_LABEL 503
#define TAG_MEDAL_YOURRANKTHISWEEK_LABEL_VAL 504
#define TAG_MEDAL_YOURRANKTHISMONTH_LABEL 505
#define TAG_MEDAL_YOURRANKTHISYEAR_LABEL_VAL 506
//END OF MEDAL-
#endif
