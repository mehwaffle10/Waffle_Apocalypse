
#define SERVER_ONLY

#include "ActivationThrowCommon.as"

string item_to_spam_string = "item to spam";
string spam_timer_string = "spam counter";
string spam_delay_string = "spam delay";

void onTick(CBlob@ this)
{
	string item_to_spam = this.get_string(item_to_spam_string);
	if(item_to_spam != "")
	{
		// Check if we're ready to spam
		this.set_u8(spam_timer_string, this.get_u8(spam_timer_string) + 1);
		if(this.get_u8(spam_timer_string) > this.get_u8(spam_delay_string))
		{
			// Reset the timer
			this.set_u8(spam_timer_string, 0);
			
			// Spawn our item
			CBlob@ item = server_CreateBlobNoInit(item_to_spam);
			if(item !is null)
			{
                CPlayer@ player = this.getPlayer();
                if (player !is null)
                {
                    item.SetDamageOwnerPlayer(player);
                }
				// Special actions
				if(this.get_bool("boom?"))
				{
					if(item_to_spam == "arrow")
					{
						item.set_u8("arrow type", 3);  // Make bomb arrow
					}
					else if(item_to_spam == "ballista_bolt")
					{
						item.Tag("bomb ammo");  // Make bomb bolt
						item.AddScript("BallistaBoltFrameFix.as");
					}
				}

                if (item_to_spam == "mine")
				{
					item.set_u8("mine_state", 1);  // Arm mine
				}

				// Configure item
				item.server_setTeamNum(this.getTeamNum());
				Vec2f pos = this.getPosition();
				item.setPosition(pos);
				item.setVelocity(Vec2f(this.getAimPos() - pos) * (.1f));
				item.set_u8("team change delay", this.get_u8("team change delay"));
				item.AddScript("TimedTeamChange.as");
				item.Init();

				if(item_to_spam == "keg")
				{
					server_Activate(item);
				}

                // Destroy terrain
                s8 destruction_radius = this.get_s8("spam destruction radius");
                if (destruction_radius > 0)
                {
                    item.set_s8("destruction radius", destruction_radius);
                    item.AddScript("DestroyBlocks.as");
                }
			}
		}
	}
}
