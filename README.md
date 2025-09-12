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

### 2. `AddInGarbage(item: Instance)`  

- Déplacer un objet dans le dossier `Garbage`.

- Utile pour stocker un objet inutilisé sans le détruire.

✅ Exemple :

 ```lua
task.wait(5)
GarbageItemService.AddInGarbage(rainDrop)
```

---

### 3. `RemoveFromGarbage(itemName: string)`

- Supprime définitivement tous les objets ayant ce nom dans le dossier `Garbage`.

✅ Exemple :

```lua
GarbageItemService.RemoveFromGarbage("RainDrop")
```
### 🛠️ Cas d’usage

#### 🌧️ Pluie

Système de pluie avec des Parts (RainDrop) :

1. Récupérer un model ou un part.

2. Placer dans le workspace.

3. Si le part ou le model collide un autre objet, déplacer dans `Garbage` ou détruire.

```lua
local rainDrop = GarbageItemService.Clone("RainDrop")
rainDrop.Position = Vector3.new(0, 50, 0)
rainDrop.Parent = workspace
raindDrop.Touched:Once(function (hit: BasePart)
	GarbageItemService.AddInGarbage(rainDrop)
)
```  

#### 🔫 Projectiles

Pour des balles tirées par une arme :

1. Cloner la balle quand le joueur tire.

2. Déplacer dans `Garbage` après l’impact ou après un délai.

3. Nettoyer régulièrement les balles inutiles avec RemoveFromGarbage ou ajouter un délai.

#### ✨ Effets spéciaux

Pour des particules ou des effets visuels temporaires :

1. Cloner l’effet depuis ReplicatedStorage ou un dossier donner (nouveau second paramètre obsolète).

2. Ajouter au workspace.  

3. Après sa durée de vie, placer dans `Garbage` ou détruire.

#### 📂 Organisation

  Le service crée automatiquement un dossier `Garbage` dans ReplicatedStorage :

```css
ReplicatedStorage
│
├── Garbage
│   ├── RainDrop
│   ├── Bullet
│   └── ParticleEffect
│
└── (autres objets et modules)
```

🚀 Avantages

- Réutilisation : pas besoin de recréer les mêmes objets en boucle.

- Organisation : ReplicatedStorage reste propre, seuls les objets actifs sont visibles.

- Performance : meilleure gestion mémoire grâce à un stockage dédié.

---

## 🆕 Nouveau:

### 1. `AddInGarbage(item: Instance, timeLimit: number?)`

- Cette méthode accepte désormais une durée
- Elle représente le temps que restera l'objet donné dans le `Garbage`.

✅ Exemple:

```lua
local object: Instance = Instance.new("part")
object.Parent = workspace
object.Name = "Object"
GarbageItemService.AddInGarbage(object, 5)
if object then print("L'objet existe") end
task.wait(5.1)
if not object then print("L'objet n'existe pas") end

--[[
	Output:
	>L'objet existe
	>L'objet n'existe pas
]]
```

### 2. `Clone(itemName: string, itemsFolder: Folder?)`

- Cette méthode accepte désormais un dossier
- Ce dossier est celui qui contient l'objet que vous cherchez à cloner.
- Si ce paramètre n'est pas donné la méthode cherche dans le `ReplicatedStorage`

✅ Exemple:

```lua
local targetFolder: Folder = game:GetService("ReplicatedStorage").Items
local object: Instance = GarbageItemService.Clone("ObjectName", targetFolder)
```