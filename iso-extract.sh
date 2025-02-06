#!/bin/bash

# Décompilateur d'ISO debian avec les verifications 
# Script largement inspiré du script présent sur le forum Debian
# https://forum-debian.fr/wiki/Modification_d_iso
# Fork by Docteur

#####################################
# Syntax d'utilisation du programme #
#####################################

if [ $# -ne 1 ]; then
    echo "Usage: $0 image.iso"
    exit 1
fi

ISO_FILE="$1"

##############################
# Vérification existance ISO #
##############################

if [ ! -f "$ISO_FILE" ]; then
    echo "[KO]Erreur : fichier $ISO_FILE non trouvé."
    exit 1
fi

##########################################
# Initialisation des variable de montage #
##########################################

MOUNT_POINT="./loopdir"
EXTRACT_DIR="./${ISO_FILE}.extract"

mkdir -p "$MOUNT_POINT"


LOOP_DEVICE=$(losetup -f)
losetup "$LOOP_DEVICE" "$ISO_FILE"

####################
# Montage de l'ISO #
####################

if ! mount "$LOOP_DEVICE" "$MOUNT_POINT"; then
    echo "[KO]Erreur : impossible de monter l'ISO."
    losetup -d "$LOOP_DEVICE"
    rmdir "$MOUNT_POINT"
    exit 1
fi
mkdir -p "$EXTRACT_DIR"
cp -r "$MOUNT_POINT"/* "$EXTRACT_DIR"

if [ "$(id -u)" -eq 0 ]; then
    chown -R 1000:1000 "$EXTRACT_DIR"
fi
chmod -R +w "$EXTRACT_DIR"
umount "$MOUNT_POINT"
losetup -d "$LOOP_DEVICE"
rmdir "$MOUNT_POINT"
echo "[OK]Extraction terminée : $EXTRACT_DIR"
