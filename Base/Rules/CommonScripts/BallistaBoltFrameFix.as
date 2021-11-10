
#define CLIENT_ONLY

void onTick(CBlob@ this)
{
	this.Tag("bomb ammo");
	this.Untag("bomb");
	this.AddScript("BallistaBoltExplosionFix.as");
	this.RemoveScript("BallistaBoltFrameFix.as");
}