#!/bin/bash

# Fonction pour demander et vérifier le mot de passe
get_password() {
    while true; do
        read -s -p "Entrez le mot de passe souhaité: " password1
        echo
        read -s -p "Confirmez le mot de passe: " password2
        echo
        
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

