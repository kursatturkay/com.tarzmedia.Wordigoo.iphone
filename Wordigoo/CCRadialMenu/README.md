`CCMenu`'s builtin layouts are limited to a grid. This subclass offers a radial layout for spacing its items out evenly on a circle. The following screenshot demonstrates a `CCRadialMenu` whose items are Japanese characters:

![CCRadialMenu example](http://rpglanguage.net/kanaswirl/img/CCRadialMenu.png)

(the colored dots are a separate game element not provided by `CCRadialMenu`)

##### Usage

    #import "CCRadialMenu.h"
    
    
    NSArray *menuItems = [NSArray arrayWithObjects:
                            [CCMenuItemFont itemWithString:@"A"],
                            [CCMenuItemFont itemWithString:@"B"],
                            [CCMenuItemFont itemWithString:@"C"],
                            nil];
    CCRadialMenu *menu = [CCRadialMenu radialMenuWithArray:menuItems radius:50];
    menu.position = ccp(100, 100);
    [menu alignItemsRadially];
    [self addChild:menu];

Alternatively, if you want a swirl-out effect like in KanaSwirl,

    CCRadialMenu *menu = [CCRadialMenu radialMenuWithArray:menuItems radius:50 swirlOutDuration:1.0];

