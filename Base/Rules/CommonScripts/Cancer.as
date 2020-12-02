void onDie(CBlob@ b)
{
	if(b !is null)
	{
		for(int i = 0; i < getRules().get_u8("cancer spawns"); i++)
		{
			CBlob@ q = server_CreateBlob(b.getName(),b.getTeamNum(),b.getPosition());
			q.setVelocity(Vec2f(5-XORRandom(10),-5));
			if(getRules().get_bool("cancer"))
				q.AddScript("Cancer");
		}
	}
}