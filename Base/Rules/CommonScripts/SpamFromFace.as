
void onTick(CRules@ this)
{
	string itemToSpam = this.get_string("item to spam");
	if(itemToSpam != "")
	{
		this.set_u8("spam count",this.get_u8("spam count") + 1);
		if(this.get_u8("spam count") > this.get_u8("spam delay"))
		{
			this.set_u8("spam count", 0);
			CBlob@[] b;
			getBlobsByTag("player",@b);
			for(u8 i=0;i<b.length;i++)
			{
				CBlob@ c=b[i];
				if(c !is null)
				{
					Vec2f pos = c.getPosition();
					Vec2f mouse = c.getAimPos();
					CBlob@ item = server_CreateBlobNoInit(itemToSpam);
					if(item !is null)
					{
						if(this.get_bool("boom?"))
						{
							if(itemToSpam == "arrow")
								item.set_u8("arrow type", 3);
							else if(itemToSpam == "ballista_bolt")
								item.Tag("bomb ammo");
								item.getSprite().SetFrame(1);
						}
						if(itemToSpam == "keg")
							item.SendCommand(item.getCommandID("activate"));
						if(itemToSpam == "mine")
							item.SendCommand(item.getCommandID("mine_primed"));
						item.server_setTeamNum(c.getTeamNum());
						item.setPosition(pos);
						item.setVelocity(Vec2f(mouse - pos) * (.1f));
						item.AddScript("TimedTeamChange");
						item.Init();
					}
				}
			}
		}
	}
}

void onInit(CRules@ this)
{
	Reset();
}

void onRestart(CRules@ this)
{
	Reset();
}

void Reset()
{
	CRules@ rules = getRules();
	rules.set_string('item to spam', '');
	rules.set_bool('boom?', false);
	rules.set_u8('spam delay', 8);
}