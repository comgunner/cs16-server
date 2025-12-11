# 🤖 POD-Bot 3.0 Management Guide

This guide details how to manage the POD-Bot 3.0 plugin, which is loaded via Metamod (`podbot_mm_i386.so`) in the server container.

---

## ⚠️ SECURITY WARNING: CHANGE YOUR PASSWORDS!

The server console logs show the default test password used for RCON access is **"admin"**.

**YOU MUST CHANGE THIS IMMEDIATELY!**

1.  **RCON Password:** Change the `rcon_password` variable in your local `server_resources/cstrike/server.cfg`.
2.  **POD-Bot Password:** Change the `pb_password` variable in your local `server_resources/cstrike/podbot/podbot.cfg` (if you added this file).

---

## 1. Bot Status and Verification

The server logs confirm POD-Bot is loaded and running:
* `[ 3] POD-Bot mm RUN - podbot_mm_i386.s vV3B22`

If you encounter the error: **"No Waypoints for this Map, can't create Bot!"**, the bot is loaded correctly but lacks navigation paths for the current map.

---

## 2. Admin Access and Bot Menu

To access the administrative functions and the POD-Bot menu, you need to use the RCON password or the specific POD-Bot password key (`pb_passwordkey`).

### A. RCON (Remote Console) Access

RCON allows you to execute commands directly on the server console (required for adding bots without being in the game).

**Test Command (Using the observed password):**


# This command verifies that the server accepts the password and executes the command 'pb add'.
```bash
docker exec cs16server rcon_password "admin" pb add
```
B. In-Game Menu Access (For Waypoints)
To bring up the graphical bot menu or the Waypoint menu, you must set your client's user information (setinfo).

Set the Password Key (Client Console):
The configuration file uses pb_passwordkey "_pbadminpw".
```bash
setinfo _pbadminpw "your_password"
```
(Use the actual password you set in the pb_password cvar).

Open the Menu (Client Console):
The default bind in podbot.cfg is the equals key (=).

```bash
bind "=" "pb menu"
```
3. Key Bot Commands (Using RCON)
You must use the pb prefix for all bot commands.

Add a single bot:

Command: 
```bash
rcon pb add [skill] [personality] [team]
```

Notes: Example: rcon pb add 100 1 (Adds one expert bot, skill 100, team 1/T).

Fill server capacity:

Command: 
```bash
rcon pb fillserver
```


Notes: Fills the server up to the pb_maxbots limit (default 16).

Kick all bots:

Command: 
```bash
rcon pb removebots
```

Notes: Alias for the command pb kick all.

Waypoint Menu:

Command: 
```bash
rcon pb wpmenu
```

Notes: This command is required for building or editing bot paths on new or custom maps.