# comgunner/cs16-server


## 🚀 Run the Server

```bash
docker run -d
--name cs16-server
--platform linux/amd64
-p 27015:27015
-p 27015:27015/udp
comgunner/cs16-server:latest
```

### 🔎 Checking the Test Server Logs

To quickly check the status of the running server container (`cs16-server`), view the latest 80 lines of its console output. This is crucial for verifying successful startup and diagnosing any bot or mod loading errors.

```bash
docker logs cs16-server --tail 80
```

---

A fully enhanced Counter-Strike 1.6 Dedicated Server Docker image based on  
the original work by **b4k3r/cs16-server**, extended with:

- Metamod
- AMX Mod X
- POD-Bot
- dproto (Dual Protocol)
- ESL configs
- Custom sounds (female killsounds pack)
- Additional server.cfg tweaks
- Pre-configured addons and folders
- Auto-copy of NewMods (addons, configs, sounds)

This project provides a fully modded CS 1.6 server ready to run on Docker  
with support for both Steam and non-Steam clients.

---

## 🔧 Features Added in This Fork

- Full Metamod + AMXX environment  
- dproto support (Steam / Non-Steam dual protocol)  
- POD-Bot including auto-spawn and configs  
- Female killsounds (misc/female)  
- ESL 5on5 configuration override  
- Custom server.cfg  
- Sound, addons, and configuration auto-deployment  
- Compatible with macOS M1/M2 using `--platform linux/amd64`  

---


## 📁 Folder Structure

```bash
NewMods/
└── cstrike/
├── addons/
│ ├── amxmodx
│ ├── metamod
│ └── dproto
├── sound/
│ └── misc/
│ └── female/
├── esl_5on5.cfg
├── server.cfg
└── liblist.gam
```


Everything inside `NewMods/` is copied directly into the image.

---

## 📝 License & Credits

This project is released under the **MIT License** (see LICENSE.md).

### Credit
This repository includes enhancements inspired by:

**https://github.com/b4k3r/cs16-server**

The original project does **not include a license**, therefore ownership of the  
initial concept belongs entirely to the author *b4k3r*.  
This repository does not claim ownership of that work, and only extends it.

---

## ⚠️ dproto Disclaimer

dproto is third-party software whose ownership belongs to its original creator.  
It is included here exclusively for interoperability and testing purposes.

---

## 💬 Support / Contact

Feel free to open issues or contribute pull requests.

