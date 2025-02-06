#! /bin/bash


# Décompilateur d'ISO debian avec les verifications 
# Script largement inspiré du script présent sur le forum Debian
# https://forum-debian.fr/wiki/Modification_d_iso
# Fork by Docteur

#####################################
# Syntax d'utilisation du programme #
#####################################

if [ $# -ne 2 ]; then
    echo "Usage: $0 répertoire_in.extract image_out.iso"
    exit 1
fi

SOURCE_DIR="$1"
OUTPUT_ISO="$2"

#######################################################
# Verification de l'existance du repertoire à compiler#
#######################################################

if [ ! -d "$SOURCE_DIR" ]; then
    echo "[KO]Erreur : le répertoire $SOURCE_DIR n'existe pas."
    exit 1
fi

##########################
# Calcul des hash en MD5 #
##########################

echo "[OK]Calcul du fichier hash md5sum..."
cd "$SOURCE_DIR" || exit 1
find . -type f ! -name "md5sum.txt" ! -path "./isolinux/*" -print0 | xargs -0 md5sum > md5sum.txt
cd - > /dev/null


########################
# Verification du boot #
########################

if [ -f "$SOURCE_DIR/isolinux/isolinux.bin" ]; then
    ISO_CMD="genisoimage -J -r -v -o \"$OUTPUT_ISO\" -V \"mon_iso_bidouillee\" \
        -b isolinux/isolinux.bin -c isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \"$SOURCE_DIR\""
else
    ISO_CMD="genisoimage -J -r -v -o \"$OUTPUT_ISO\" -V \"mon_iso_bidouillee\" \"$SOURCE_DIR\""
fi
echo "[OK]Compilation image ISO en cours..."
eval $ISO_CMD > /dev/null 2>&1 &
PID=$!

SPIN='-\|/'
while kill -0 $PID 2>/dev/null; do
    for i in $(seq 0 3); do
        echo -ne "\r[${SPIN:$i:1}] Compilation ISO..."
        sleep 0.2
    done
done


echo -ne "\r[OK] ISO générée : $OUTPUT_ISO\n"

