#import "GHSpriteContactListener.h"
#import "SimpleAudioEngine.h"
#import "WGSoundCore.h"

GHSpriteContactListener::GHSpriteContactListener()
{
}

void GHSpriteContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
    /*
     b2Fixture *fixtureA = contact->GetFixtureA();
     b2Fixture *fixtureB = contact->GetFixtureB();
     if([((id)fixtureA->GetBody()->GetUserData()) isKindOfClass:[NSString class]]){
     if((
     fixtureB->GetBody()->GetPosition().y // Player
     - fixtureA->GetBody()->GetPosition().y // Platform
     ) >
     // player radius + platform height:
     -14.5)
     contact->SetEnabled(false);
     }else if([((id)fixtureB->GetBody()->GetUserData()) isKindOfClass:[NSString class]]){
     if((
     fixtureA->GetBody()->GetPosition().y // Player
     - fixtureB->GetBody()->GetPosition().y // Platform
     ) >
     // player radius + platform height:
     -14.5)
     contact->SetEnabled(false);
     }
     */
    //    base::PreSolve(contact, oldManifold) ]
}

void GHSpriteContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
{
  // NSLog(@"PostSolve");
}

void GHSpriteContactListener::BeginContact(b2Contact* contact)
{
    //b2Fixture* fixtureA = contact->GetFixtureA();
    //b2Fixture* fixtureB = contact->GetFixtureB();
    //[[SimpleAudioEngine sharedEngine]playEffect:@"hex1.mp3"];
    //if (contact->IsSolid()) {
    //    NSLog(@"Contact is solid");
    //NSLog(@"BeginContact");
}

void GHSpriteContactListener::smoothSoundFx()
{
    //static NSDate *start = [NSDate date];
    //NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    //static BOOL over_
}


void GHSpriteContactListener::EndContact(b2Contact* contact)
{
   // NSLog(@"end contact");
    b2Body *bodyA=contact->GetFixtureB()->GetBody();
    b2Vec2 velocity_A=bodyA->GetLinearVelocity();
    float a=velocity_A.Length();
    //NSLog(@"Hız:%f",a);
    if(a>1.0f)
    {
        int pitch_=(arc4random()%500)+1;
        [[WGSoundCore sharedDirector]playSound:@"dundin.mp3" Pitch:pitch_/200.0f Gain:0.1f];
        //[[SimpleAudioEngine sharedEngine]playEffect:@"dundin.mp3" pitch:(pitch_/200.0f) pan:0 gain:0.1f];
    }
}




