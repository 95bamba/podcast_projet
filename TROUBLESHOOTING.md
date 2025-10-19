# 🔧 Guide de Dépannage - Galsen Podcast

## Erreurs d'Inscription / Login

### ❌ Erreur 409 - "Nom d'utilisateur ou email déjà utilisé"

**Symptôme** :
Lors de la création d'un compte, vous recevez l'erreur :
> "Ce nom d'utilisateur ou email est déjà utilisé"

**Cause** :
- Le nom d'utilisateur (login) que vous essayez d'utiliser existe déjà
- OU l'adresse email est déjà enregistrée dans le système

**Solutions** :

1. **Choisir un autre nom d'utilisateur** :
   - Essayez d'ajouter des chiffres : `john` → `john123`
   - Utilisez votre nom complet : `john` → `johndoe`
   - Ajoutez un underscore : `john` → `john_`

2. **Utiliser une autre adresse email** :
   - Si vous avez déjà un compte, utilisez le login à la place
   - Utilisez une adresse email différente

3. **Se connecter au lieu de s'inscrire** :
   - Si vous avez oublié avoir créé un compte, essayez de vous connecter
   - Utilisez la fonction "Mot de passe oublié" si nécessaire

**Exemple** :
```
❌ Login: "john"     → Déjà pris
✅ Login: "john2024" → Disponible

❌ Email: "test@test.com"      → Déjà pris
✅ Email: "myemail@gmail.com"  → Disponible
```

---

### ❌ Erreur 401 - "Non autorisé"

**Symptôme** :
Impossible de se connecter, message d'erreur d'authentification.

**Causes possibles** :
- Nom d'utilisateur incorrect
- Mot de passe incorrect
- Compte désactivé

**Solutions** :
1. Vérifiez l'orthographe du nom d'utilisateur
2. Vérifiez que Caps Lock n'est pas activé
3. Réinitialisez le mot de passe si nécessaire

---

### ❌ Erreur "Token expiré"

**Symptôme** :
L'application vous déconnecte automatiquement.

**Cause** :
Le token JWT a expiré (durée de vie limitée).

**Solution** :
- Reconnectez-vous simplement
- Le nouveau token sera automatiquement sauvegardé

---

## Erreurs Audio

### ❌ "Pas de fichier audio disponible"

**Symptôme** :
Le bouton play ne fonctionne pas, message d'erreur.

**Cause** :
Le podcast n'a pas de fichier audio associé (`audioFileUuid` manquant).

**Solutions** :
1. Vérifiez avec l'administrateur que le podcast a bien un fichier audio
2. Essayez un autre podcast
3. Rechargez les données (pull to refresh)

---

### ❌ Audio ne se charge pas / ne joue pas

**Symptômes** :
- Le lecteur reste bloqué sur "Chargement..."
- Erreur "Impossible de charger l'audio"

**Causes possibles** :
1. **Connexion internet** : Pas de connexion ou connexion instable
2. **Serveur GED indisponible** : Le serveur backend est hors ligne
3. **UUID invalide** : Le fichier audio n'existe plus

**Solutions** :

1. **Vérifier la connexion** :
   - Assurez-vous d'être connecté à internet
   - Essayez de passer en WiFi si vous êtes en 4G
   - Redémarrez votre connexion

2. **Vérifier le serveur** :
   ```bash
   # Tester l'accès au serveur
   curl http://51.254.204.25:2000/category
   ```

3. **Télécharger pour écoute hors-ligne** :
   - Utilisez le bouton de téléchargement 📥
   - Une fois téléchargé, l'audio joue localement

4. **Vérifier les logs** :
   - Regardez la console pour voir l'URL exacte utilisée
   - Format attendu : `http://51.254.204.25:2000/ged/preview?uuid=...`

---

### ❌ Téléchargement échoue

**Symptôme** :
Le téléchargement s'arrête ou affiche une erreur.

**Causes possibles** :
1. Connexion internet coupée
2. Espace disque insuffisant
3. Timeout (fichier trop gros)

**Solutions** :
1. **Vérifier l'espace disque** :
   - Libérez de l'espace sur votre téléphone
   - Supprimez d'anciens téléchargements

2. **Connexion stable** :
   - Utilisez WiFi pour les gros fichiers
   - Assurez-vous que la connexion reste stable

3. **Réessayer** :
   - Le téléchargement reprend là où il s'est arrêté si le fichier existe déjà

---

## Erreurs de Données

### ❌ "Aucun podcast disponible"

**Symptôme** :
La liste des podcasts est vide.

**Causes** :
1. Base de données vide (pas de podcasts créés)
2. Token expiré
3. Problème de connexion API

**Solutions** :
1. **Reconnectez-vous** pour rafraîchir le token
2. **Vérifiez l'API** :
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     http://51.254.204.25:2000/podcast
   ```
3. **Demandez à l'admin** d'ajouter des podcasts

---

### ❌ Images ne s'affichent pas

**Symptôme** :
Les images des podcasts/catégories ne s'affichent pas.

**Causes** :
1. Chemin d'image invalide
2. Serveur ne sert pas les images
3. Connexion internet

**Solutions** :
1. Vérifiez que `imagePath` n'est pas null
2. Testez l'URL directement dans un navigateur
3. Vérifiez la connexion internet

---

## Erreurs de Build / Installation

### ❌ APK ne s'installe pas

**Symptôme** :
"Application non installée" ou erreur lors de l'installation.

**Solutions** :

1. **Activer "Sources inconnues"** :
   - Paramètres → Sécurité → Sources inconnues
   - Ou : Paramètres → Applications → Accès spécial → Installer des apps inconnues

2. **Vérifier la signature** :
   - Désinstallez l'ancienne version si elle existe
   - Réinstallez la nouvelle

3. **Vérifier l'espace disque** :
   - Libérez au moins 100 MB

4. **Utiliser ADB** :
   ```bash
   adb install -r build/app/outputs/flutter-apk/app-release.apk
   ```

---

### ❌ App crash au démarrage

**Symptôme** :
L'application se ferme immédiatement après le lancement.

**Solutions** :

1. **Voir les logs** :
   ```bash
   adb logcat | grep flutter
   ```

2. **Réinstaller** :
   ```bash
   adb uninstall com.example.podcast
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Utiliser debug APK** :
   ```bash
   flutter build apk --debug
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

---

## Erreurs Réseau

### ❌ "Erreur de connexion au serveur"

**Symptôme** :
Impossible d'accéder aux données, timeouts.

**Causes** :
1. Serveur backend hors ligne
2. Pas de connexion internet
3. Firewall bloquant l'accès

**Solutions** :

1. **Ping le serveur** :
   ```bash
   ping 51.254.204.25
   ```

2. **Tester l'API** :
   ```bash
   curl http://51.254.204.25:2000/category
   ```

3. **Vérifier le WiFi/4G** :
   - Assurez-vous d'être connecté
   - Testez avec un navigateur web

4. **Vérifier les permissions** :
   - Android : Permission INTERNET dans le manifest
   - iOS : Configuration réseau

---

## Dépannage Général

### 🔍 Comment voir les logs

**Android (via ADB)** :
```bash
# Logs Flutter
adb logcat | grep flutter

# Tous les logs
adb logcat

# Logs en temps réel
adb logcat -s flutter
```

**iOS** :
```bash
# Via Xcode
# Ouvrir Xcode → Window → Devices and Simulators
# Sélectionner l'appareil → View Device Logs
```

---

### 🔄 Réinitialiser l'Application

**Supprimer les données** :
1. Paramètres du téléphone
2. Applications
3. Galsen Podcast
4. Stockage
5. Effacer les données

**Ou via ADB** :
```bash
adb shell pm clear com.example.podcast
```

---

### 🆘 Obtenir de l'Aide

**Étapes de diagnostic** :

1. **Identifier l'erreur** :
   - Notez le message d'erreur exact
   - Notez quand ça se produit

2. **Reproduire** :
   - Essayez de refaire l'action qui cause l'erreur
   - Notez les étapes exactes

3. **Collecter les informations** :
   - Version de l'app : 1.0.0
   - Version Android/iOS
   - Logs (via adb logcat)

4. **Vérifier la documentation** :
   - [API_INTEGRATION.md](API_INTEGRATION.md)
   - [AUDIO_TESTING.md](AUDIO_TESTING.md)
   - [BUILD_INFO.md](BUILD_INFO.md)

---

## Codes d'Erreur HTTP

| Code | Signification | Action |
|------|---------------|--------|
| 200 | ✅ Succès | Aucune |
| 201 | ✅ Créé | Aucune |
| 400 | ❌ Requête invalide | Vérifier les données envoyées |
| 401 | ❌ Non autorisé | Se reconnecter |
| 403 | ❌ Interdit | Vérifier les permissions |
| 404 | ❌ Non trouvé | Ressource n'existe pas |
| 409 | ❌ Conflit | Déjà existant (voir ci-dessus) |
| 500 | ❌ Erreur serveur | Contacter l'admin |

---

## Checklist de Dépannage

Avant de demander de l'aide :

- [ ] J'ai vérifié ma connexion internet
- [ ] J'ai essayé de me reconnecter
- [ ] J'ai redémarré l'application
- [ ] J'ai vérifié les logs
- [ ] J'ai essayé avec un autre compte (si pertinent)
- [ ] J'ai consulté cette documentation
- [ ] J'ai noté le message d'erreur exact

---

**Besoin d'aide ?**
Consultez la documentation complète dans le projet.
