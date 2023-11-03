
#define SERVER_ONLY

#include "ApocalypseCommon.as"

funcdef void fxn();

// Get a random x based on the width of the map
u64 get_random_x()
{
	CMap@ map = getMap();
	return XORRandom(map.tilemapwidth * map.tilesize + 100);
}

void KegRain() {
	if(getGameTime() % 3 == 0)
	{
		Vec2f pos = Vec2f(get_random_x(), 0);
		CBlob@ keg = server_CreateBlob("keg", 9, pos);
		if (keg !is null)
		{
			keg.SendCommand(keg.getCommandID("activate")); // Light the keg
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 - 1;
			keg.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
		}
	}
}

void GiveAllPlayersLitKeg()
{
	if(getGameTime() % 30 == 0)
	{
		// Get list of all player blobs
		CBlob@[] player_blobs;
		getBlobsByTag("player", @player_blobs);
		for(u8 i = 0; i < player_blobs.length(); i++) // Give each player a lit keg
		{
			CBlob@ player_blob = player_blobs[i];
			if(player_blob != null)
			{
				CBlob@ keg = server_CreateBlob("keg", 9, player_blob.getPosition());
				if (keg !is null)
				{
					keg.SendCommand(keg.getCommandID("activate"));
					player_blob.server_Pickup(keg);
				}
			}
		}
	}
}

void TrampMineRain() {
	CMap@ map = getMap();
	u64 x = map.tilemapwidth * map.tilesize + 100;
	Vec2f pos;
	if(!getRules().get_bool(APOCALYPSE_RAN_STRING)) // Only run once
	{ 
		for(u64 i = 0; i < x; i = i + 30) // Spawn layer of trampolines with spinning tramps on top
		{
			pos.y = map.getLandYAtX(i) * map.tilesize / 2;
			CBlob@ trampoline1 = server_CreateBlob("trampoline", 9, pos);
			if (trampoline1 !is null)
			{
				trampoline1.Tag("ignore fall"); // Ignore fall damage so it doesn't break on impact on tall maps
			}
			pos.y = pos.y - 30;
			CBlob@ trampoline2 = server_CreateBlob("trampoline", 9, pos);
			if (trampoline2 !is null)
			{
				trampoline2.Tag("ignore fall"); // Ignore fall damage so it doesn't break on impact on tall maps
				trampoline2.setAngularVelocity(XORRandom(101) - 50); // Give random spin
			}
			pos.x = i;
		}
	}	

	// Spawn mines
	if(getGameTime() % 2 == 0)
	{
		pos.y = 0;
		pos.x = XORRandom(x);
		CBlob@ mine = server_CreateBlob("mine", 3, pos);
		if (mine !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			mine.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			mine.SendCommand(mine.getCommandID("mine_primed")); // Deploy the mine
			mine.AddScript("DestroyBlocks.as");
		}
	}
}

void RandomArrowRain()
{
	if(getGameTime() % 1 == 0) // In case we want to lower the spawn rate
	{
		Vec2f pos = Vec2f(get_random_x(), 0);
		CBlob@ arrow = server_CreateBlobNoInit("arrow");
		if(arrow !is null)
		{
			arrow.set_u8("arrow type", 2 + XORRandom(2)); // Make it randomly a fire or bomb arrow
			if (arrow !is null)
			{
				s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
				arrow.setVelocity(Vec2f(spread, 1)); // Give it random horizontal momentum, needs a nonzero velocity or the arrow will break immediately
				arrow.setPosition(pos);
				arrow.Init();
			}
		}
	}
}

void BallistaRain()
{
	if(getGameTime() % 1 == 0) // In case we want to lower the spawn rate
	{
		CBlob@ ballista_bolt = server_CreateBlob("ballista_bolt", 3, Vec2f(get_random_x(), 0));
		if (ballista_bolt !is null)
		{
			ballista_bolt.Tag("bomb ammo"); // Explosive Upgrade
			ballista_bolt.AddScript("BallistaBoltFrameFix.as");
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			ballista_bolt.setVelocity(Vec2f(spread, 2)); // Give it random horizontal momentum
			ballista_bolt.Init();
		}
	}
}

void SharkRain()
{
	if(getGameTime() % 8 == 0)
	{
		CBlob@ shark = server_CreateBlob("shark", 3, Vec2f(get_random_x(), 0));
		if (shark !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			shark.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			shark.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
			shark.set_s8("destruction radius", 3);
			shark.AddScript("DestroyBlocks.as");
		}
	}
}

void BisonRain()
{
	if(getGameTime() % 8 == 0)
	{
		CBlob@ bison = server_CreateBlob("bison", 9, Vec2f(get_random_x(), 0));
		if (bison !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			bison.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			bison.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
			bison.set_s8("destruction radius", 3);
			bison.AddScript("DestroyBlocks.as");
		}
	}
}

void SpikeRain()
{
	if(getGameTime() % 1 == 0)
	{
		CBlob@ spike = server_CreateBlob("spikes", 9, Vec2f(get_random_x(), 0));
		if (spike !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			spike.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			spike.AddScript("DestroyBlocks.as");
		}
	}
}

void BombRain()
{
	if(getGameTime() % 1 == 0)
	{
		CBlob@ bomb = server_CreateBlob("bomb", 9, Vec2f(get_random_x(), 0));
		if (bomb !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			bomb.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
		}
	}
}

void GetiBombs()
{
	if(getGameTime() % 5 == 0)
	{
		CMap@ map = getMap();
		u64 x = get_random_x();
		Vec2f pos = Vec2f(x, map.getLandYAtX(x) * map.tilesize / 2); // Spawn near ground
		CBlob@ princess = server_CreateBlob("princess", 3, pos);
		if (princess !is null)
		{
			princess.getAttachments().AddAttachmentPoint("KEG",true).offset = Vec2f(-8,-5); // Add an attachment point to the princess for keg to be in, needs an offset to look normal
			CBlob@ keg = server_CreateBlob("keg", 9, pos);
			if (keg !is null)
			{
				princess.server_AttachTo(keg, "KEG"); // Attach the keg to the princess
				keg.SendCommand(keg.getCommandID("activate")); // Light the keg
			}
		}
	}
}

void BoulderRain()
{
	if(getGameTime() % 1 == 0)
	{
		CBlob@ boulder = server_CreateBlob("boulder", 9, Vec2f(get_random_x(), 0));
		if (boulder !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			boulder.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			boulder.getShape().getConsts().mapCollisions = false;
			boulder.getShape().getConsts().collidable = false;
			boulder.AddScript("DestroyBlocks.as");
		}
	}
}

void OrbRain()
{
	if(getGameTime() % 1 == 0)
	{
		CMap@ map = getMap();
		for(int i = 0; i < 3; i++) {
			u64 x = get_random_x();
			Vec2f pos = Vec2f(x, 0);
			CBlob@ orb = server_CreateBlob("orb", XORRandom(6) + 2, pos); // Random color
			if (orb !is null)
			{
				orb.set_f32("explosive_radius", 50.0f);
				orb.set_f32("explosive_damage", 4.0f);
				orb.set_f32("map_damage_radius", 50.0f);
				orb.set_f32("map_damage_ratio", 100.0f);
				s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
				orb.setVelocity(Vec2f(spread, XORRandom(10) + map.getLandYAtX(x)/20)); // Give it random horizontal momentum
			}
		}
	}
}

void ChickenSpawners()
{
	if (getGameTime() % 10 == 0)
	{
		CBlob@ chicken = server_CreateBlob("chicken", 9, Vec2f(get_random_x(), 0));
		if (chicken !is null)
		{
			chicken.set_string("item to spawn", "keg");
			chicken.set_u16("spawn delay", 1 * getTicksASecond());
			chicken.AddScript("ItemSpawner.as");
			CShape@ shape = chicken.getShape();
			if (shape !is null)
			{
				shape.SetGravityScale(0.1f);
			}
		}
	}
}

void SpamBombArrowsFromFace()
{
	if (!getRules().get_bool(APOCALYPSE_RAN_STRING))
	{
		CBlob@[] player_blobs;
		getBlobsByTag("player", @player_blobs);
		for(u8 i = 0; i < player_blobs.length; i++)
		{
			CBlob@ player_blob = player_blobs[i];
			if(player_blob !is null)
			{
				player_blob.set_string("item to spam", "arrow");
				player_blob.set_u8("spam delay", 8);
				player_blob.set_bool("boom?", true);
				player_blob.set_u8("team change delay", 10);
				player_blob.AddScript("SpamFromFace.as");
			}
		}
	}
}

void SpamBombBoltsFromFace()
{
	if (!getRules().get_bool(APOCALYPSE_RAN_STRING))
	{
		// Increase the delay before swapping teams to avoid killing the thrower
		getRules().set_u8("team change delay", 4);

		CBlob@[] player_blobs;
		getBlobsByTag("player", @player_blobs);
		for(u8 i = 0; i < player_blobs.length; i++)
		{
			CBlob@ player_blob = player_blobs[i];
			if(player_blob !is null)
			{
				player_blob.set_string("item to spam", "ballista_bolt");
				player_blob.set_u8("spam delay", 8);
				player_blob.set_bool("boom?", true);
				player_blob.set_u8("team change delay", 10);
				player_blob.AddScript("SpamFromFace.as");
			}
		}
	}
}

void HomingMinesOfDoom()
{
    CMap@ map = getMap();
	u64 x = map.tilemapwidth * map.tilesize + 100;
	Vec2f pos;
	if(getGameTime() % (2 * getTicksASecond()) == 0)
	{
		pos.y = 0;
		pos.x = XORRandom(x);
		CBlob@ mine = server_CreateBlob("mine", 3, pos);
		if (mine !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			mine.setVelocity(Vec2f(spread, 0)); // Give it random horizontal momentum
			mine.SendCommand(mine.getCommandID("mine_primed")); // Deploy the mine
            mine.AddScript("SmoothHoming.as");
            mine.set_f32("homing_speed", 0.1f);
			mine.AddScript("DestroyBlocks.as");
            mine.set_s8("destruction radius", 2);
		}
	}
}

/*
void LongboatRain()
{
	if(getGameTime() % 5 == 0)
	{
		CBlob@ longboat = server_CreateBlob("longboat", 9, Vec2f(get_random_x(), 0));
		if (longboat !is null)
		{
			s8 spread = XORRandom(getRules().get_u8(APOCALYPSE_SPREAD_STRING)) - getRules().get_u8(APOCALYPSE_SPREAD_STRING)/2 + 1;
			longboat.setVelocity(Vec2f(spread, 4)); // Give it random horizontal momentum
			longboat.RemoveScript("Wooden");
			longboat.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
			longboat.set_s8("destruction radius", 2);
			longboat.AddScript("DestroyBlocks.as");
		}
	}
}
*/

fxn@[] apocalypses = {		// Apocalypse Index
	@KegRain,				// 0
	@GiveAllPlayersLitKeg,	// 1
	@TrampMineRain,			// 2
	@RandomArrowRain,		// 3
	@BallistaRain,			// 4
	@SharkRain,				// 5
	@BisonRain,				// 6
	@SpikeRain,				// 7
	@BombRain,				// 8
	@GetiBombs,				// 9
	@BoulderRain,			// 10
	@OrbRain,				// 11
	@ChickenSpawners,		// 12
	@SpamBombArrowsFromFace,// 13
	@SpamBombBoltsFromFace, // 14
    @HomingMinesOfDoom      // 15
};

void onStateChange(CRules@ this, const u8 oldState)
{
    // Check if the game is over

	if(this.getCurrentState() == GAME_OVER && !this.get_bool(APOCALYPSE_TOGGLE_STRING))
	{
		StartApocalypse(this);
	}
}

void onTick(CRules@ this)
{
	// Run the apocalypse
	if(this.get_bool(APOCALYPSE_TOGGLE_STRING) && this.get_s8(APOCALYPSE_ID_STRING) >= 0 && this.get_s8(APOCALYPSE_ID_STRING) < apocalypses.length())	// Avoid out of bounds access
	{
		// Execute apocalypse				
		apocalypses[this.get_s8(APOCALYPSE_ID_STRING)]();

		// Flag for apocalypses to execute once
		if (!this.get_bool(APOCALYPSE_RAN_STRING))
		{
			this.set_bool(APOCALYPSE_RAN_STRING, true);
		}
	}
}

void onInit(CRules@ this)
{
	Reset(this);
	this.set_u8(APOCALYPSE_SPREAD_STRING, 10);
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void Reset(CRules@ this)
{
	this.set_s8(APOCALYPSE_ID_STRING, XORRandom(apocalypses.length()));
	this.set_bool(APOCALYPSE_TOGGLE_STRING, false);
}