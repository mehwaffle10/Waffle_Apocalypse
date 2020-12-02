
funcdef void fxn();

void KegRain() {
	if(getGameTime() % 3 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos;
		pos.x = XORRandom(x);
		CBlob@ keg = server_CreateBlob('keg', 9, pos);
		keg.SendCommand(keg.getCommandID('activate')); // Light the keg
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 - 1;
		keg.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
	}
}

void GiveAllPlayersLitKeg()
{
	if(getGameTime() % 30 == 0)
	{
		// Get list of all player blobs
		CBlob@[] player_blobs;
		getBlobsByTag('player', @player_blobs);
		for(u8 i = 0; i < player_blobs.length(); i++) // Give each player a lit keg
		{
			CBlob@ player_blob = player_blobs[i];
			if(player_blob != null)
			{
				CBlob@ keg = server_CreateBlob('keg', 9, player_blob.getPosition());
				keg.SendCommand(keg.getCommandID('activate'));
				player_blob.server_Pickup(keg);
			}
		}
	}
}

void TrampMineRain() {
	// Get the width of the map
	CMap@ map = getMap();
	u64 x = map.tilemapwidth * map.tilesize + 100;
	Vec2f pos;
	if(!getRules().get_bool("apocalypse_ran")) // Only run once
	{ 
		for(u64 i = 0; i < x; i = i + 30) // Spawn layer of trampolines with spinning tramps on top
		{
			pos.y = map.getLandYAtX(i) * map.tilesize / 2;
			CBlob@ trampoline1 = server_CreateBlob('trampoline', 9, pos);
			trampoline1.Tag("ignore fall"); // Ignore fall damageso it doesn't break on impact on tall maps
			pos.y = pos.y - 30;
			CBlob@ trampoline2 = server_CreateBlob('trampoline', 9, pos);
			trampoline2.Tag("ignore fall"); // Ignore fall damageso it doesn't break on impact on tall maps
			trampoline2.setAngularVelocity(XORRandom(101) - 50); // Give random spin
			pos.x = i;
		}
	}	

	// Spawn mines
	if(getGameTime() % 2 == 0)
	{
		pos.y = 0;
		pos.x = XORRandom(x);
		CBlob@ mine = server_CreateBlob('mine', 9, pos);
		mine.SendCommand(mine.getCommandID('mine_primed')); // Deploy the mine
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		mine.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
	}
}

void RandomArrowRain()
{
	if(getGameTime() % 1 == 0) // In case we want to lower the spawn rate
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ arrow = server_CreateBlobNoInit('arrow');
		if(arrow !is null)
		{
			arrow.set_u8('arrow type', XORRandom(4)); // Give it a random type
			s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
			arrow.setVelocity(Vec2f(spread,1)); // Give it random horizontal momentum, needs a nonzero velocity or the arrow will break immediately
			arrow.setPosition(pos);
			arrow.Init();
		}
	}
}

void BallistaRain()
{
	if(getGameTime() % 1 == 0) // In case we want to lower the spawn rate
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ ballista_bolt = server_CreateBlob('ballista_bolt', 9, pos);
		ballista_bolt.Tag('bomb ammo'); // Explosive Upgrade
		ballista_bolt.getSprite().SetFrame(1);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		ballista_bolt.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
	}
}

void SharkRain()
{
	if(getGameTime() % 3 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ shark = server_CreateBlob('shark', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		shark.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
		shark.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
	}
}

void BisonRain()
{
	if(getGameTime() % 3 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ bison = server_CreateBlob('bison', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		bison.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
		bison.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
	}
}

void SpikeRain()
{
	if(getGameTime() % 1 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ spike = server_CreateBlob('spikes', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		spike.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
	}
	if(getGameTime() % 5 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ longboat = server_CreateBlob('longboat', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		longboat.setVelocity(Vec2f(spread,4)); // Give it random horizontal momentum
		longboat.RemoveScript('Wooden');
		longboat.setAngularVelocity(XORRandom(101)-50); // Spin it cause memes
	}
}

void BombRain()
{
	if(getGameTime() % 1 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ bomb = server_CreateBlob('bomb', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		bomb.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
	}
}

void GetiBombs()
{
	if(getGameTime() % 5 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), map.getLandYAtX(x) * map.tilesize / 2); // Spawn near ground
		CBlob@ princess = server_CreateBlob('princess', 3, pos);
		princess.getAttachments().AddAttachmentPoint('KEG',true).offset = Vec2f(-8,-5); // Add an attachment point to the princess for keg to be in, needs an offset to look normal
		CBlob@ keg = server_CreateBlob('keg', 9, pos);
		princess.server_AttachTo(keg, 'KEG'); // Attach the keg to the princess
		keg.SendCommand(keg.getCommandID('activate')); // Light the keg
	}
}

void BoulderRain()
{
	if(getGameTime() % 1 == 0)
	{
		// Get the width of the map
		CMap@ map = getMap();
		u64 x = map.tilemapwidth * map.tilesize + 100;
		Vec2f pos = Vec2f(XORRandom(x), 0);
		CBlob@ boulder = server_CreateBlob('boulder', 9, pos);
		s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
		boulder.setVelocity(Vec2f(spread,0)); // Give it random horizontal momentum
		boulder.getShape().getConsts().mapCollisions = false;
		boulder.getShape().getConsts().collidable = false;
	}
}

void OrbRain()
{
	if(getGameTime() % 1 == 0)
	{
		for(int i = 0; i < 3; i++) {
			// Get the width of the map
			CMap@ map = getMap();
			u64 x = map.tilemapwidth * map.tilesize + 100;
			Vec2f pos = Vec2f(XORRandom(x), 0);
			CBlob@ orb = server_CreateBlob('orb', XORRandom(6) + 2, pos); // Random color
			orb.set_f32("explosive_radius", 50.0f);
			orb.set_f32("explosive_damage", 4.0f);
			orb.set_f32("map_damage_radius", 50.0f);
			orb.set_f32("map_damage_ratio", 100.0f);
			s8 spread = XORRandom(getRules().get_u8('spread')) - getRules().get_u8('spread')/2 + 1;
			orb.setVelocity(Vec2f(spread,XORRandom(10) + map.getLandYAtX(x)/20)); // Give it random horizontal momentum
		}
	}
}

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
	@OrbRain				// 11
};

void onTick(CRules@ this)
{	
	// Check if the game is over
	if(this.getCurrentState() == GAME_OVER) {
		if(this.get_u8('apocalypse') < apocalypses.length())	// Avoid out of bounds access
		{					
			apocalypses[this.get_u8('apocalypse')](); 	// Execute apocalypse
		}
		this.set_bool("apocalypse_ran", true);			// Flag for apocalypses to execute once
	}
}

void onRestart(CRules@ this)
{
	Reset(this);
}

void onInit(CRules@ this)
{
	Reset(this);
	this.set_u8('spread', 10);
	this.set_u8('team change delay', 3);
	this.AddScript('SpamFromFace');
}

void Reset(CRules@ this)
{
	this.set_bool("apocalypse_ran", false);
	this.set_u8('apocalypse', XORRandom(apocalypses.length()));
}