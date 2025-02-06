# Décompilateur et Recompilateur d'ISO Debian

Ce projet contient deux scripts permettant d'extraire et de reconstruire une image ISO Debian tout en effectuant des vérifications et en maintenant les permissions.

## Fichiers

### `iso-extract.sh`
Script permettant d'extraire le contenu d'une image ISO Debian.

### `iso-rebuild.sh`
Script permettant de reconstruire une image ISO Debian bootable ou standard à partir d'un dossier extrait.

## Installation

```bash
git clone https://github.com/DocteurMoriarty/iso-tools.git  
cd iso-tools  
chmod +x iso-extract.sh  
chmod +x iso-rebuild.sh  
