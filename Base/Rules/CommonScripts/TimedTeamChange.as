void onInit(CBlob @this)
{
	if(this !is null)
		this.set_u8("team change timer", 0);
}

void onTick(CBlob@ this)
{
	if(this !is null)
	{
		this.set_u8("team change timer",this.get_u8("team change timer") + 1);
		if(this.get_u8("team change timer") > getRules().get_u8("team change delay"))
		{
			this.server_setTeamNum(3);
		}
	}
}