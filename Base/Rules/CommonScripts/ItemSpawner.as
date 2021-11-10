
#define SERVER_ONLY

string spawn_counter_string = "spawn counter";
string spawn_delay_string = "spawn delay";
string item_to_spawn_string = "item to spawn";

void onTick(CBlob@ this)
{
	string item_to_spawn = this.get_string(item_to_spawn_string);
	if (item_to_spawn != "")
	{
		// Check if we're ready to spawn 
		this.set_u16(spawn_counter_string, this.get_u16(spawn_counter_string) + 1);
		if (this.get_u16(spawn_counter_string) > this.get_u16(spawn_delay_string))
		{
			// Reset the timer
			this.set_u16(spawn_counter_string, 0);

			// Spawn our item
			string item_to_spawn = this.get_string(item_to_spawn_string);
			CBlob@ item = server_CreateBlobNoInit(item_to_spawn);
			if (item !is null)
			{
				item.setPosition(this.getPosition());
				item.server_setTeamNum(this.getTeamNum());

				// Special actions
				if(item_to_spawn == "arrow")
				{
					item.set_u8("arrow type", 3);  // Make bomb arrow
				}
				else if(item_to_spawn == "ballista_bolt")
				{
					item.Tag("bomb ammo");  // Make bomb bolt
					item.AddScript("BallistaBoltFrameFix.as");
				}

				item.Init();

				// Arm Explosives
				if (item_to_spawn == "keg") {
					item.SendCommand(item.getCommandID("activate")); // Light the keg
				}
				else if (item_to_spawn == "mine")
				{
					item.SendCommand(item.getCommandID("mine_primed")); // Deploy the mine
				}
			}
		}
	}
}