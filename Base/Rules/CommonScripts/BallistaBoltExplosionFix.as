
#define CLIENT_ONLY

#include "Explosion.as";

void onDie(CBlob@ this)
{
	Explode(this, 16.0f, 2.0f);
	//LinearExplosion(this, velocity, 64.0f, 8.0f, 2, 4.0f, Hitters::bomb);
}