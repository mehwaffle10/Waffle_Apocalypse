void onTick(CBlob@ this)
{
	if(this !is null && this.get_string("target") != "")
	{
		CPlayer@ target = getPlayerByUsername(this.get_string("target"));
		if(target != null && target.getBlob() != null)
		{
			Vec2f pos = target.getBlob().getPosition();
			f32 homing_speed = this.get_f32('homing_speed');
			if(this.getPosition().x < pos.x)
			{
				if(this.getPosition().y < pos.y)
					this.setVelocity(Vec2f(homing_speed,homing_speed));
				else
					this.setVelocity(Vec2f(homing_speed,-homing_speed));
			}
			else
			{
				if(this.getPosition().y < pos.y)
					this.setVelocity(Vec2f(-homing_speed,homing_speed));
				else
					this.setVelocity(Vec2f(-homing_speed,-homing_speed));
			}
		}
	}
}