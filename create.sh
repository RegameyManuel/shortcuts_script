#!/bin/bash

# Fonction pour demander et vérifier le mot de passe
get_password() {
    while true; do
        read -s -p "Entrez le mot de passe souhaité (au moins 8 caractères): " password1
        echo
        read -s -p "Confirmez le mot de passe: " password2
        echo
        
        # Vérification de la longueur du mot de passe
        if [ ${#password1} -lt 8 ]; then
            echo "Erreur : Le mot de passe doit comporter au moins 8 caractères."
            continue
        fi
        
        # Vérification des mots de passe
        if [ "$password1" == "$password2" ]; then
            echo "Mot de passe confirmé."
            break
        else
            echo "Les mots de passe ne correspondent pas, veuillez réessayer."
        fi
    done
}

# Demander le nom d'utilisateur
read -p "Entrez le nom d'utilisateur souhaité: " username

# Vérifier si l'utilisateur existe déjà
if id "$username" &>/dev/null; then
    echo "L'utilisateur $username existe déjà."
    exit 1
fi

# Appeler la fonction pour obtenir le mot de passe
get_password

# Créer l'utilisateur
sudo useradd -m -s /bin/bash "$username"

# Ajouter le mot de passe à l'utilisateur
echo "$username:$password1" | sudo chpasswd

# Afficher un message de confirmation
echo "L'utilisateur $username a été créé avec succès."


# Chemin vers le fichier contenant les URLs
URL_FILE="urls.txt"

# Dossier du bureau
DESKTOP_DIR="/home/$username/Bureau"

# Vérifier si le répertoire Bureau existe, sinon le créer
if [ ! -d "$DESKTOP_DIR" ]; then
    sudo -u "$username" mkdir -p "$DESKTOP_DIR"
fi

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
    sudo -u "$username" bash -c "cat <<EOF > '$DESKTOP_DIR/$site_name.desktop'
[Desktop Entry]
Version=1.0
Name=$site_name
Type=Application
Exec=xdg-open $url
Icon=web-browser
Terminal=false
EOF"

    # Rendre le fichier exécutable
    sudo -u "$username" chmod +x "$DESKTOP_DIR/$site_name.desktop"

done < "$URL_FILE"

echo "Raccourcis créés sur le bureau."

