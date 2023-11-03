
void onTick(CBlob@ this)
{
    CShape@ shape = this.getShape();
    if (shape.getGravityScale() != 0.0f)
    {
        shape.SetGravityScale(0.0f);
        shape.getConsts().buoyancy = 0.0f;
        shape.getVars().waterDragScale = 0.0f;
    }

    CBlob@ target;
    CBlob@[] players;
    if (this.exists("target"))
    {
        CPlayer@ player = getPlayerByUsername(this.get_string("target"));
        if (player !is null)
        {
            @target = player.getBlob();
        }
    }
    else
    {
        getBlobsByTag("player", players);
        f32 min_distance = 0.0f;
        for (u8 i = 0; i < players.length; i++)
        {
            if (players[i] !is null)
            {
                f32 distance = (this.getPosition() - players[i].getPosition()).Length();
                if (min_distance == 0.0f || distance < min_distance)
                {
                    @target = players[i];
                    min_distance = distance;
                }
            }
        }
    }

	if(target is null)
	{
        return;
    }

    Vec2f new_velocity = Vec2f(), old_velocity = this.getVelocity(), pos = target.getPosition();
    f32 homing_speed = this.get_f32("homing_speed");
    
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