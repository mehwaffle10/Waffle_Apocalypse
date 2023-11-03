
#define SERVER_ONLY

#include "Hitters.as"

string destruction_radius_string = "destruction radius";

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	DestroyBlocks(this);
}

void onDie(CBlob@ this)
{
	DestroyBlocks(this);
}

void DestroyBlocks(CBlob@ this)
{
	// Destroy everything around the collision
	CMap@ map = this.getMap();
	s8 radius = this.exists(destruction_radius_string) ? this.get_s8(destruction_radius_string) : 1;
	for (s8 x = -radius; x <= radius; x++)
	{
		s8 y_range = radius - Maths::Abs(x);
		for (s8 y = -y_range; y <= y_range; y++)
		{
			for (u8 hit_number = 0; hit_number < 3; hit_number++)
			{
                Vec2f pos = this.getPosition() + Vec2f(x, y) * map.tilesize;
				map.server_DestroyTile(pos, 10.0f, this);
                CBlob@[] blobs;
                map.getBlobsAtPosition(pos, blobs);
                for (u8 i = 0; i < blobs.length; i++)
                {
                    CBlob@ blob = blobs[i];
                    if (blob !is null && blob.getShape().isStatic())
                    {
                        this.server_Hit(blob, pos, Vec2f(0, 0), 10.0f, Hitters::mine, true);
                    }
                }
			}
		}
	}
}