# Introduction
This script is designed to manage non-playable characters (NPCs) within a SA-MP server. It provides functionalities to load NPC data from a MySQL database, handle player interactions with NPCs, and create new NPCs dynamically during gameplay. The script ensures that NPCs have associated properties like position, skin ID, and a floating text label above their heads to facilitate player interactions.

# How to Use

- To create an NPC, use the `/createactor [id] [skin id] [name]` command in-game. For example:
  ```
  /createactor 1 45 TsumuX
  ```

- To add an interaction script, modify the `ActorInteraction` function as follows:
  ```pawn
  Actor: ActorInteraction(playerid, actor_id)
  {
      if (actor_id == -1) return 1;

      Interaction:Actor(ActorData[actor_id][ACTOR_NAME], "TsumuX")
      {
          SendClientMessage(playerid, -1, "Script is working");
      }
      return 1;
  }
  ```

# Credits
This script was created by TsumuX. Special thanks to the SA-MP community for their continuous support and contributions and Steven that help me and give ideas.
