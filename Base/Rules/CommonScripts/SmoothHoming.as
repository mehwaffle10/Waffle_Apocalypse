void onTick(CBlob@ this)
{
	if(this !is null && this.get_string("target") != "")
	{
		CPlayer@ target = getPlayerByUsername(this.get_string("target"));
		if(target != null && target.getBlob() != null)
		{
			Vec2f new_velocity = Vec2f(), old_velocity = this.getVelocity(), pos = target.getBlob().getPosition();
			f32 homing_speed = this.get_f32("homing_speed");
			
			// Add x component
			if(this.getPosition().x < pos.x) // Are we to the left of the target?
				new_velocity.x = old_velocity.x + homing_speed;
			else
				new_velocity.x = old_velocity.x - homing_speed;

			// Add y component
			if(this.getPosition().y < pos.y) // Are we above of the target?
				new_velocity.y = old_velocity.y + homing_speed;
			else
				new_velocity.y = old_velocity.y - homing_speed;

			this.setVelocity(new_velocity);
		}
	}
}