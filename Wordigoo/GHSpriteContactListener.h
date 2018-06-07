#import "Box2D.h"
#import <vector>
#import <algorithm>

class GHSpriteContactListener : public b2ContactListener{
private:
    BOOL crystal_timeout_triggered;
public:
    GHSpriteContactListener();
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    void smoothSoundFx();
    void crystalCounter();
};
