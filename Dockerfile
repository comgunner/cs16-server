# Base: la imagen original de b4k3r
FROM b4k3r/cs16-server:latest

# Fix HLDS CPU bug en entornos virtuales (Docker, Mac M1, etc.)
ENV CPU_MHZ=2000

# Vamos a modificar archivos dentro del servidor
USER root
WORKDIR /home/steam/cs16

# 1) Copiar tus addons nuevos (AMXX, dproto, metamod)
# Estructura en el host:
#   ./NewMods/cstrike/addons/amxmodx
#   ./NewMods/cstrike/addons/dproto
#   ./NewMods/cstrike/addons/metamod
COPY NewMods/cstrike/addons/amxmodx cstrike/addons/amxmodx
COPY NewMods/cstrike/addons/dproto  cstrike/addons/dproto
COPY NewMods/cstrike/addons/metamod cstrike/addons/metamod

# 2) Copiar tus sonidos personalizados (misc, female, etc.)
# Estructura en el host:
#   ./NewMods/cstrike/sound/...
COPY NewMods/cstrike/sound cstrike/sound

# 3) Sobrescribir ESL con tu versión
COPY esl_5on5.cfg cstrike/esl_5on5.cfg

# 4) Copiar configuración de DProto al root del server
COPY dproto.cfg dproto.cfg

# Permisos
RUN chown -R steam:steam /home/steam/cs16

# Volvemos al usuario original que usa la imagen
USER steam
WORKDIR /home/steam/cs16
