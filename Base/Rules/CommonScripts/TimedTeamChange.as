
#define SERVER_ONLY

string team_change_timer_string = "team change timer";
string team_change_delay_string = "team change delay";

void onTick(CBlob@ this)
{
	// Check if it's time to change teams
	this.set_u8(team_change_timer_string, this.get_u8(team_change_timer_string) + 1);
	if(this.get_u8(team_change_timer_string) > this.get_u8(team_change_delay_string))
	{
		// Change teams and remove script
		this.server_setTeamNum(3);
		this.RemoveScript("TimedTeamChange.as");
	}
}