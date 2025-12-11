# 🔒 RCON Password Security Guide

This guide ensures you replace the insecure default RCON password used during testing. **The password logged in the server console ("admin") is extremely vulnerable and must be changed.**

## ⚠️ CRITICAL SECURITY ALERT

The default RCON password is **"admin"**. Leaving this password active allows **anyone** to take full control of your server (kick, ban, change maps, shut down) using simple remote commands.

---

## 1. How to Change the RCON Password

You must edit the configuration file located in your local project directory.

### Step 1: Edit the Configuration File

Navigate to your local project folder and modify the `server.cfg` file:


```bash
cs16_docker/ └── server_resources/ └── cstrike/ └── server.cfg <-- EDIT THIS FILE
```

Open `server.cfg` and change the `rcon_password` line:

```bash
// DEFAULT (INSECURE)
rcon_password "admin" 

```

// CHANGE TO A STRONG, UNIQUE PASSWORD
```bash
rcon_password "MyNewSecureRconPass123!"
```
Step 2: Apply the Change
Since your configuration files are volume-mounted or copied into the running Docker container, you must restart the container for the new server.cfg settings to take effect.

Stop the running container:


```bash
docker-compose stop
```
Start the container with the new configuration:

```bash
docker-compose start
```
