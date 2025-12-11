# 💾 Synology NAS (Docker) Deployment for Counter-Strike 1.6 Server

This guide details the installation of a dedicated **Counter-Strike 1.6** server on a Synology NAS device using the **Container Manager** (formerly known as Docker).

---

## ⚠️ Initial Considerations

* **NAS Power:** While CS 1.6 is lightweight, very low-end pre-built NAS devices might experience limited performance. Ensure your Synology has adequate resources for a smooth gaming experience.
* **DSM Version:** This guide assumes you are running DSM 7.0 or newer.

## 1. Prerequisites and Container Manager Installation

1.  Access your Synology administration interface (DSM), usually at `http://NAS-IP:5000`.
2.  Open the **Package Center**.
3.  Search for and install the **"Container Manager"** package (if you haven't already). 4.  Once installed, open **Container Manager**.

## 2. Downloading the CS 1.6 Server Image

We will use the community image `comgunner/cs16-server`.

1.  Inside **Container Manager**, navigate to the **"Registry"** tab.
2.  In the search bar, type **`comgunner`** or **`cs16-server`**.
3.  Select the image **`comgunner/cs16-server`** and click **"Download"**.
4.  In the pop-up window, select the **`latest`** tag and click **"Apply"**.

![Screenshot of searching for the cs16-server image in the Container Manager Registry](https://i.ibb.co/KjYnbWV5/1.png)

## 3. Creating the Container

1.  Navigate to the **"Image"** tab. Once the download is complete, the image will appear in the list.
2.  Select the image and click **"Run"**, or navigate to the **"Container"** tab and click **"Create"**.
3.  **General Settings:**
    * **Container Name:** Assign a name (e.g., `cs16-server-docker`).
    * **Enable auto-restart:** **Recommended** to check this option so the server starts automatically when your NAS boots.
    * Click **"Next"**.

> **❗ Network Note: USE SAME NETWORK AS DOCKER HOST.** Ensure the Network setting matches the Synology host network for direct port access.

## 4. Port and Volume Settings

### Port Settings

The standard port for Counter-Strike is **27015** and uses the **UDP** protocol.

1.  Under **Port Settings**, map the Host Port to the Container Port.
2.  Ensure the Protocol is set to **UDP**.

| Local Port (Host Port) | Container Port | Protocol |
| :--------------------: | :------------: | :--------: |
| **27015** | **27015** | **UDP** |

### Volume Settings

This allows you to save server configurations, maps, logs, and files outside the container, ensuring they persist after updates.

1.  Click **"Add Folder"**.
2.  Select the folder on your NAS where you want to store the server files (e.g., `/volume1/docker/cs16`).
3.  As the **Mount Path**, use the path where the container expects the server files: `/app/serverfiles`.

## 5. Launch and Connection

1.  Review the final settings and click **"Next"**.
2.  On the Summary screen, check the box to **"Run this container after the wizard is finished"**.
3.  Click **"Apply"**.

> **⚠️ Important Note:** The first time the container starts, it needs to download and set up the server files. **This process can take at least 5 minutes to complete.** Please wait until the container shows as "Running" before attempting to connect.

### Connecting to the Server

Once the container is running (visible in the "Container" tab):

1.  Open your Counter-Strike 1.6 game.
2.  Open the console (usually with the `` ~ `` or `` ñ `` key).
3.  Type the connection command using your Synology's IP and port:

`connect NAS-IP:27015`

**Your CS 1.6 server is now running!**

***

**_Note:_** _If you want external players to connect over the internet, you must configure **Port Forwarding** on your router, directing UDP traffic on port 27015 to your Synology's internal IP address._

## 📸 Step-by-Step Configuration Screenshots

| Step | Description | Screenshot |
| :--- | :--- | :--- |
| 1 | Container Manager Installation (Placeholder) | **** |
| 2 (Cont.) | Container Creation (General Settings) | ![Container General Settings](https://i.ibb.co/WWgPLkYC/2.png) |
| 3 | Network Settings | ![Network Settings](https://i.ibb.co/pB2BpMJn/3.png) |
| 4 | Port Mapping (27015 UDP) | ![Port Mapping Configuration](https://i.ibb.co/nq0MD5Rb/4.png) |
| 5 | Volume/Folder Mapping | ![Volume Mapping](https://i.ibb.co/vxDgGykQ/5.png) |
| 6 | Summary and Launch | ![Summary Screen](https://i.ibb.co/s9sVXNjz/6.png) |