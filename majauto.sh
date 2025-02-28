#!/bin/bash

# Configuration
URL="https://raw.githubusercontent.com/PCRE2Project/pcre2/refs/heads/master/doc/pcre2-config.txt" # URL du fichier en ligne
FICHIER_LOCAL="/etc/nixos/pcre2-config.txt" #Chemin vers fichier local
TEMP_FILE="/etc/nixos/pcre2-config-temp.txt"
while true
do
	# Télécharger le fichier en ligne dans un fichier temp
	/run/current-system/sw/bin/wget -O "$TEMP_FILE" "$URL"

	# Vérifier si le téléchargement a réussi
	if [ $? -ne 0 ]; then
		echo "Erreur lors du téléchargement du fichier."
		exit 1
	fi

	# Comparer le fichier temp avec le fichier local 

	if !  /nix/store/3sln66ij8pg114apkd8p6nr04y37q5z2-diffutils-3.10/bin/diff "$TEMP_FILE" "$FICHIER_LOCAL"; then
		echo "Le fichier a été modifié. Mise à jour en cours..."
		mv "$TEMP_FILE" "$FICHIER_LOCAL"
		echo "Fichier mis à jour avec succès."
	else
		echo "Le fichier est à jour. Aucune modification nécessaire."
		rm "$TEMP_FILE"
	fi
	/nix/store/6wgd8c9vq93mqxzc7jhkl86mv6qbc360-coreutils-9.5/bin/sleep 10
done
