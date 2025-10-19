# 🚀 Démarrage Rapide - Test de l'Audio

## ⚡ En 5 Minutes

### 1️⃣ Installer les Dépendances
```bash
flutter pub get
```

### 2️⃣ Lancer l'Application
```bash
flutter run
```

### 3️⃣ Se Connecter ou Créer un Compte

**Option A - Créer un nouveau compte** :
1. Cliquer sur "Créer un compte"
2. Remplir les informations :
   - Nom d'utilisateur (login)
   - Prénom
   - Nom
   - Email
   - Mot de passe (min 6 caractères)
3. (Optionnel) Ajouter une photo de profil
4. Cliquer sur "S'inscrire"
5. Vous serez redirigé vers la page de login
6. Se connecter avec vos identifiants

**Option B - Se connecter** :
1. Entrer votre login
2. Entrer votre mot de passe
3. Cliquer sur "Se connecter"

### 4️⃣ Tester l'Audio

**Méthode Rapide** - Modifier temporairement le code :

**Étape A** : Ouvrir [lib/main.dart](lib/main.dart)

**Étape B** : Trouver la ligne ~100 :
```dart
final List<Widget> _pages = [
  const home.HomePage(),
  const PlaylistPage(),
  const FavoritesPage(),
  const ProfilePage(),
];
```

**Étape C** : Remplacer par :
```dart
final List<Widget> _pages = [
  const TestAudioPage(),  // 👈 Changement ici
  const PlaylistPage(),
  const FavoritesPage(),
  const ProfilePage(),
];
```

**Étape D** : Ajouter l'import en haut du fichier :
```dart
import 'test_audio_page.dart';
```

**Étape E** : Hot reload (appuyer sur `r` dans le terminal ou ⚡ dans VS Code)

**Étape F** : Tester !
- Vous voyez maintenant la liste des podcasts
- Les podcasts avec audio ont un badge vert "Audio disponible"
- Cliquer sur un podcast
- Cliquer sur le bouton Play ▶️
- L'audio devrait se charger et jouer !

---

## 📊 Exemple de Données de Test

Si vous n'avez pas encore de podcasts dans votre base de données, créez-en un via l'API :

```bash
# 1. Se connecter et obtenir un token
TOKEN=$(curl -X POST http://51.254.204.25:2000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"login":"votre_login","password_hash":"votre_password"}' \
  | jq -r '.access_token')

# 2. Créer une catégorie
CATEGORY_UUID=$(curl -X POST http://51.254.204.25:2000/category \
  -H "Authorization: Bearer $TOKEN" \
  -F "libelle=Test Audio" \
  -F "description=Catégorie de test" \
  | jq -r '.uuid')

# 3. Créer un podcast avec audio
curl -X POST http://51.254.204.25:2000/podcast \
  -H "Authorization: Bearer $TOKEN" \
  -F "libelle=Mon Premier Podcast" \
  -F "description=Podcast de test pour la lecture audio" \
  -F "category_uuid=$CATEGORY_UUID" \
  -F "file=@/path/to/audio.mp3"
```

---

## 🎵 URLs de Test Audio Public

Si vous voulez tester avec des fichiers audio publics :

```
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3
```

---

## 🔍 Débugger

### Vérifier la Connexion API
```bash
# Test simple
curl http://51.254.204.25:2000/category

# Devrait retourner un JSON ou un message d'erreur
```

### Vérifier le Token
Dans l'app, après connexion :
```dart
// Ajouter temporairement dans le code
print('Token: ${context.read<ApiService>().token}');
```

### Vérifier l'URL Audio
Dans [podcast_detail_page.dart](lib/podcast_detail_page.dart), les URLs sont affichées automatiquement :
- UUID du fichier audio
- URL complète de l'API GED

---

## 📱 Captures d'Écran des Pages

### TestAudioPage
```
┌─────────────────────────────┐
│ ← Test Lecture Audio    🔄 │
├─────────────────────────────┤
│                             │
│ ┌─────────────────────────┐ │
│ │ 🎵    Mon Podcast       │ │
│ │      Description...     │ │
│ │      ✅ Audio dispo     │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ 🎵    Autre Podcast     │ │
│ │      Description...     │ │
│ │      ⚠️ Pas d'audio     │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### PodcastDetailPageWithAudio
```
┌─────────────────────────────┐
│ ← Mon Podcast               │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │                         │ │
│ │      Image Podcast      │ │
│ │                         │ │
│ └─────────────────────────┘ │
│                             │
│ Mon Podcast                 │
│ Description du podcast...   │
│                             │
│ ┌─────────────────────────┐ │
│ │ ═══════●────────        │ │
│ │ 01:23        03:45      │ │
│ │                         │ │
│ │   ⏮️     ▶️     ⏭️      │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

---

## ✅ Checklist de Test

- [ ] App lance sans erreur
- [ ] Page de login affichée
- [ ] Création de compte fonctionne
- [ ] Login fonctionne
- [ ] Token sauvegardé (reste connecté après redémarrage)
- [ ] TestAudioPage affiche les podcasts
- [ ] Badges "Audio disponible" visibles
- [ ] Navigation vers détail fonctionne
- [ ] Bouton Play charge l'audio
- [ ] Audio joue correctement
- [ ] Slider de progression fonctionne
- [ ] Boutons +10s/-10s fonctionnent
- [ ] Pause/Play fonctionne

---

## 🆘 Problèmes Courants

### ❌ "Aucun podcast disponible"

**Causes** :
1. Base de données vide
2. Token expiré
3. Problème de connexion

**Solutions** :
```bash
# Vérifier qu'il y a des podcasts
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://51.254.204.25:2000/podcast
```

### ❌ "Erreur lors du chargement de l'audio"

**Causes** :
1. Podcast n'a pas d'audioFileUuid
2. UUID invalide
3. Serveur GED ne répond pas

**Solutions** :
- Vérifier dans la page de détail que l'UUID est affiché
- Vérifier l'URL de l'API affichée
- Tester l'URL directement dans le navigateur

### ❌ "401 Unauthorized"

**Causes** :
- Token expiré

**Solutions** :
- Se déconnecter et se reconnecter
- Le token est automatiquement rafraîchi

---

## 📚 Aller Plus Loin

Une fois le test audio fonctionnel :

1. 📖 Lire [API_INTEGRATION.md](API_INTEGRATION.md) pour les détails complets
2. 🎵 Lire [AUDIO_TESTING.md](AUDIO_TESTING.md) pour plus de tests
3. 🎊 Lire [RESUME_INTEGRATION.md](RESUME_INTEGRATION.md) pour la vue d'ensemble

---

## 💡 Astuces

### Hot Reload
Appuyer sur `r` pour recharger rapidement après un changement de code.

### DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Logs Audio
Les logs de chargement audio sont dans la console :
```
Chargement de l'audio depuis: http://51.254.204.25:2000/ged/preview?uuid=...
```

---

Profitez bien de votre app ! 🎧
