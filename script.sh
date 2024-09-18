#!/bin/bash

# Chemin vers le fichier contenant les URLs
URL_FILE="urls.txt"

# Dossier du bureau
DESKTOP_DIR="$HOME/Bureau"

# Vérifier si le fichier existe
if [[ ! -f $URL_FILE ]]; then
    echo "Le fichier $URL_FILE n'existe pas."
    exit 1
fi

# Lire le fichier ligne par ligne
while IFS= read -r url; do
    # Extraire le nom du site à partir de l'URL pour le nom du fichier .desktop
    site_name=$(echo "$url" | awk -F[/:] '{print $4}')
    
    # Créer un fichier .desktop pour chaque URL
    cat <<EOF > "$DESKTOP_DIR/$site_name.desktop"
[Desktop Entry]
Version=1.0
Name=$site_name
Type=Application
Exec=xdg-open $url
Icon=web-browser
Terminal=false
EOF

    # Rendre le fichier exécutable
    chmod +x "$DESKTOP_DIR/$site_name.desktop"

done < "$URL_FILE"

echo "Raccourcis créés sur le bureau."

