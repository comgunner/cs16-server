# synology_install.md

## ⚠️ Initial Considerations

* **NAS Power:** While CS 1.6 is lightweight, very low-end pre-built NAS devices might experience limited performance. Ensure your Synology has adequate resources for a smooth gaming experience.
* **DSM Version:** This guide assumes you are running **DSM 7.0 or newer**.

---

## 1. Prerequisites and Container Manager Installation

> ### 🚀 Install Docker (Container Manager) on Synology
>
> 1.  Access the **Package Center** in your DSM.
> 2.  Search for **Container Manager** (formerly known as Docker).
> 3.  Press the **Install** button.

1.  Access your Synology administration interface (DSM), usually at `http://NAS-IP:5000`.
2.  Open the **Package Center**.
3.  Search for and install the **"Container Manager"** package (if you haven't already).
4.  Once installed, open **Container Manager**.

*Image Placeholder: Add a screenshot of the Package Center showing Container Manager.*

## 2. Downloading the CS 1.6 Server Image

We will use the community image `comgunner/cs16-server`.

1.  Inside **Container Manager**, navigate to the **"Registry"** tab.
2.  In the search bar, type **`comgunner`** or **`cs16-server`**.
3.  Select the image **`comgunner/cs16-server`** and click **"Download"**.
4.  In the pop-up window, select the **`latest`** tag and click **"Apply"**.

<p style="text-align: center;">
    <img src="https://i.ibb.co/KjYnbWV5/1.png" alt="Screenshot of searching for the cs16-server image in the Container Manager Registry" style="max-width: 100%; height: auto; border: 1px solid #ccc;">
</p>

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
| :--------------------- | :------------- | :------- |
| 27015                  | 27015          | UDP      |

### Volume Settings

This allows you to save server configurations, maps, logs, and files outside the container, ensuring they persist after updates.

1.  Click **"Add Folder"**.
2.  Select the folder on your NAS where you want to store the server files (e.g., `/volume1/docker/cs16`).
3.  As the **Mount Path**, use the path where the container expects the server files: **`/app/serverfiles`**.

## 5. Launch and Connection

1.  Review the final settings and click **"Next"**.
2.  On the Summary screen, check the box to **"Run this container after the wizard is finished"**.
3.  Click **"Apply"**.

> **⚠️ Important Note:** The first time the container starts, it needs to download and set up the server files. **This process can take at least 5 minutes to complete.** Please wait until the container shows as "Running" before attempting to connect.

### Connecting to the Server

Once the container is running (visible in the "Container" tab):

1.  Open your Counter-Strike 1.6 game.
2.  Open the console (usually with the `~` or `ñ` key).
3.  Type the connection command using your Synology's IP and port:
