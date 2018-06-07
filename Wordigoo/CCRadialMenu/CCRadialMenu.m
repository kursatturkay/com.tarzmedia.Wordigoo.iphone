#import "CCRadialMenu.h"

@implementation CCRadialMenu

+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius {
    return [[[self alloc] initRadialMenuWithArray:items radius:radius swirlOutDuration:0 adjustAnchors:NO] autorelease];
}

+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration {
    return [[[self alloc] initRadialMenuWithArray:items radius:radius swirlOutDuration:swirlOutDuration adjustAnchors:NO] autorelease];
}

+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration adjustAnchors:(bool)adjustAnchors {
    return [[[self alloc] initRadialMenuWithArray:items radius:radius swirlOutDuration:swirlOutDuration adjustAnchors:adjustAnchors] autorelease];
}

-(id) initRadialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration adjustAnchors:(bool)adjustAnchors
{
    if ( (self=[super initWithArray:items]) ) {
        radius_ = radius;

        if (swirlOutDuration) {
            [self swirlItemsRadially:swirlOutDuration adjustAnchors:adjustAnchors];
        }
    }
    return self;
}

-(void) alignItemsRadially
{
    CCMenuItem *item;
    int count = [children_ count];
    double sliceAngle = (2 * 3.14) / count;
    int i = 0;

    CCARRAY_FOREACH(children_, item){
        double theta = sliceAngle * i;
        double x = radius_ * sin(theta);
        double y = radius_ * cos(theta);

        [item setPosition:ccp(x, y)];

        ++i;
    }
}

-(void) swirlItemsRadially:(float)duration {
    [self swirlItemsRadially:duration adjustAnchors:NO];
}

-(void) swirlItemsRadially:(float)duration adjustAnchors:(bool)adjustAnchors {
    CCMenuItem *item;
    int count = [children_ count];
    double sliceAngle = (2 * 3.14) / count;
    double base_length = sqrt(2) * radius_;
    int i = 0;

    CCARRAY_FOREACH(children_, item){
        double theta = sliceAngle * i;
        double x = radius_ * sin(theta);
        double y = radius_ * cos(theta);

        if (adjustAnchors) {
            if (theta <= 0.01) {
            }
            else if (theta <= M_PI) {
                [item setAnchorPoint:ccp(0.2, 0.5)];
            }
            else if (theta > M_PI) {
                [item setAnchorPoint:ccp(0.8, 0.5)];
            }
        }

        /* swirl */
        ccBezierConfig bezier;
        bezier.controlPoint_1 = ccp(radius_ * sin(theta - 3.14/4), radius_ * cos(theta - 3.14/4));
        bezier.controlPoint_2 = ccp(base_length * sin(theta - 3.14/8), base_length * cos(theta - 3.14/8));
        bezier.endPosition = ccp(x, y);
        [item runAction:[CCBezierBy actionWithDuration:duration bezier:bezier]];

        /* rotate */
        [item setRotation:90];
        [item runAction:[CCRotateBy actionWithDuration:duration angle:-90]];

        /* disable */
        [item setIsEnabled:NO];
        [item runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:duration],
                         [CCCallBlock actionWithBlock:^(void) {
                            [item setIsEnabled:YES];
                         }],
                         nil]];

        /*
         * brighten to white.
         * I use TintTo gray in 0s to avoid setColor: not being a method in CCMenuItem
         */
        [item runAction:[CCSequence actions:
                         [CCTintTo actionWithDuration:0 red:192 green:192 blue:192],
                         [CCTintTo actionWithDuration:duration red:255 green:255 blue:255],
                         nil]];

        ++i;
    }
}

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];

    CGPoint location = [self convertToNodeSpace:touchLocation];

    float distance = sqrt( location.x*location.x + location.y*location.y );

    if (distance >= radius_ * 0.5 && distance <= radius_ * 1.5) {
        int count = [children_ count];
        double factor = (2 * 3.14) / count;

        double theta = atan2(location.x, location.y);
        /* I use [0, 2pi) for layout, but atan2 returns [-pi, pi) */
        if (theta < 0) {
            theta += 2 * M_PI;
        }

        /* find closest item */
        int i = theta/factor + 0.5;

        /* don't let them tap halfway across the circle if there are few items */
        double angle_distance = fabs(factor * i - theta);
        if (angle_distance < M_PI/5) {
            /* tapping at 11 o'clock is like tapping at 1 o'clock */
            if (i == count) { i = 0; }
            CCMenuItem* item = [children_ objectAtIndex:i];
            if ( [item visible] && [item isEnabled] ) {
                return item;
            }
        }
    }

    /* delegate for items that move, etc */
    return [super itemForTouch:touch];
}

@end
