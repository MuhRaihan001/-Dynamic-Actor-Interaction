#define MAX_ACTOR     (50)
#define Actor:%0(%1)                    forward %0(%1); public %0(%1)
#define Interaction:Actor(%0,%1) if(strcmp(%0, %1, true) == 0)

enum actor_data
{
    ACTOR_ID,
    ACTOR_NAME[64],
    ACTOR_SKIN,
    Float: ACTOR_POS[4],
    Text3D: ACTOR_TEXT
}
new ActorData[MAX_ACTOR][actor_data];

Actor:LoadActor()
{
    new Cache: result, query[150];

	result = mysql_query(mysql, "SELECT * FROM actor", true);
	for(new i = 0; i < cache_num_rows(); i ++)
    {
        cache_get_field_content(i, "name", ActorData[i][ACTOR_NAME], mysql, 61);
        ActorData[i][ACTOR_ID] = cache_get_field_content_int(i, "id", mysql);
        ActorData[i][ACTOR_SKIN] = cache_get_field_content_int(i, "skin_id", mysql);
        ActorData[i][ACTOR_POS][0] = cache_get_field_content_float(i, "x", mysql);
        ActorData[i][ACTOR_POS][1] = cache_get_field_content_float(i, "y", mysql);
        ActorData[i][ACTOR_POS][2] = cache_get_field_content_float(i, "z", mysql);
        ActorData[i][ACTOR_POS][3] = cache_get_field_content_float(i, "r", mysql);
        
        format(query, sizeof query, "%s\nUse 'H' to talk", ActorData[i][ACTOR_NAME]);
        CreateActor(ActorData[i][ACTOR_SKIN], ActorData[i][ACTOR_POS][0], ActorData[i][ACTOR_POS][1], ActorData[i][ACTOR_POS][2], ActorData[i][ACTOR_POS][3]);
        ActorData[i][ACTOR_TEXT] = Create3DTextLabel(query, 0xFFFFFFFF, ActorData[i][ACTOR_POS][0], ActorData[i][ACTOR_POS][1], ActorData[i][ACTOR_POS][2], 20.0, 0);
    }
    print("[Actor-System] Semua Actor Telah Di Muat");
    cache_delete(result);
    return 1;
}

Actor:NearestActorId(playerid)
{
    for(new i; i < MAX_ACTOR; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.5, ActorData[i][ACTOR_POS][0], ActorData[i][ACTOR_POS][1], ActorData[i][ACTOR_POS][2]))
        {
            return i;
        }
    }
    return -1;
}


Actor: ActorInteraction(playerid, actor_id)
{
    if(actor_id == -1) return 1;

    Interaction:Actor(ActorData[actor_id][ACTOR_NAME], "Kontolodon")
    {
        SendClientMessage(playerid, -1, "workass [Kontolodon]");
    }
    return 1;
}

CMD:createactor(playerid, params[])
{
    new id, skin_id;
    new name[64];
    new query[510], text[100];
    
    if(sscanf(params, "dds[64]", id, skin_id, name)) return SendClientMessage(playerid, 0xCECECEFF, "Use: /createactor [id] [id skin] [name]");
    
    if(GetPlayerAdminEx(playerid) < 6) return 1;
    
    new Float: x, Float: y, Float: z, Float: r;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, r);
    format(text, sizeof text, "%s\nUse 'H' to talk", name);
    CreateActor(skin_id, x, y, z, r);
    ActorData[id][ACTOR_TEXT] = Create3DTextLabel(text, 0xFFFFFFFF, x, y, z, 20.0, 0);
    mysql_format(mysql, query, sizeof query, "INSERT INTO actor (`name`, `id`, `skin_id`, `x`, `y`, `z`, `r`) VALUES ('%s', %d, %d, %f, %f, %f, %f)", name, id, skin_id, x, y, z, r);
    mysql_query(mysql, query, false);
    SendClientMessage(playerid, -1, "Npc berhasil dibuat");
    return 1;
}

CMD:interaksi(playerid)
{
    new id = NearestActorId(playerid);
    new i[90];
    format(i, sizeof(i), "%d", id);
    print(i);
    if(id == -1) return SendClientMessage(playerid, 0xCECECEFF, "Tidak ada npc di sekitar");
    ActorInteraction(playerid, id);
    return 1;
}
