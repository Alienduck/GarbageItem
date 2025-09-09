# GarbageItemService

_Service de gestion d'objets temporaires (ou "garbage items") pour Roblox._

Créé par **Alienduck**, le **09/09/2025**

---

## 📌 À quoi ça sert ?

Le **GarbageItemService** est un module qui permet de :
- **Cloner** facilement des objets stockés dans un dossier spécial (`Garbage`) ou dans `ReplicatedStorage`.
- **Déplacer** les objets inutilisés dans un dossier dédié (`Garbage`) pour éviter d’encombrer `ReplicatedStorage`.
- **Supprimer** proprement les objets devenus obsolètes.
- **Réutiliser** des objets sans avoir à les recréer à chaque fois.

L’objectif est de **mieux gérer la mémoire et l’organisation des objets** en jeu, surtout pour des systèmes où des objets temporaires apparaissent/disparaissent souvent (particules, projectiles, effets visuels, etc.).

---

## ⚙️ Fonctionnalités principales

### 1. `Clone(itemName: string): Instance | nil`
- Clone un objet depuis le dossier `Garbage`.
- Si l’objet n’existe pas dans `Garbage`, il est cloné depuis `ReplicatedStorage`.
- Retourne l’objet cloné ou `nil` si rien n’a été trouvé.

✅ **Exemple** :
```lua
local rainDrop = GarbageItemService.Clone("RainDrop")
if rainDrop then
    rainDrop.Position = Vector3.new(0, 50, 0)
    rainDrop.Parent = workspace
end
```

---

2. AddInGarbage(item: Instance)
Déplace un objet dans le dossier Garbage.

Utile pour stocker un objet inutilisé sans le détruire.

✅ Exemple :


task.wait(5)
GarbageItemService.AddInGarbage(rainDrop)
3. RemoveFromGarbage(itemName: string)
Supprime définitivement tous les objets ayant ce nom dans le dossier Garbage.

✅ Exemple :

GarbageItemService.RemoveFromGarbage("RainDrop")
🛠️ Cas d’usage
🌧️ Pluie
Tu veux faire tomber des gouttes de pluie (RainDrop) :

Tu clones une goutte depuis ReplicatedStorage.

Tu la places dans le workspace.

Après quelques secondes, tu la déplaces dans Garbage ou tu la détruis.

lua
Copier
Modifier
local rainDrop = GarbageItemService.Clone("RainDrop")
rainDrop.Position = Vector3.new(0, 50, 0)
rainDrop.Parent = workspace

task.wait(5)
GarbageItemService.AddInGarbage(rainDrop)
🔫 Projectiles
Pour des balles tirées par une arme :

Clone la balle quand le joueur tire.

Déplace-la dans Garbage après l’impact ou après un délai.

Nettoie régulièrement les balles inutiles avec RemoveFromGarbage.

✨ Effets spéciaux
Pour des particules ou des effets visuels temporaires :

Clone l’effet depuis ReplicatedStorage.

Ajoute-le au workspace.

Après sa durée de vie, mets-le dans Garbage ou détruis-le.

📂 Organisation
Le service crée automatiquement un dossier Garbage dans ReplicatedStorage :

scss
Copier
Modifier
ReplicatedStorage
│
├── Garbage
│   ├── RainDrop
│   ├── Bullet
│   └── ParticleEffect
│
└── (autres objets et modules)
🚀 Avantages
Réutilisation : pas besoin de recréer les mêmes objets en boucle.

Organisation : ReplicatedStorage reste propre, seuls les objets actifs sont visibles.

Performance : meilleure gestion mémoire grâce à un stockage dédié.