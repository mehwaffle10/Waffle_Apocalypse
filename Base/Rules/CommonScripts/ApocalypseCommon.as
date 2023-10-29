
string APOCALYPSE_ID_STRING = "apocalypse id";
string APOCALYPSE_TOGGLE_STRING = "apocalypse toggle";
string APOCALYPSE_RAN_STRING = "apocalypse ran";
string APOCALYPSE_SPREAD_STRING = "apocalypse spread";

void StartApocalypse(CRules@ rules)
{
    if (isServer())
    {
        rules.set_bool(APOCALYPSE_TOGGLE_STRING, true);
        rules.set_bool(APOCALYPSE_RAN_STRING, false);
    }
}