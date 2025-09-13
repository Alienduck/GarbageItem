--[[
    Made by Alienduck, 2025-09-09
    GarbageItemService
    Service for managing garbage items in the game.
    Example usage:
    If you make rain with BasePart named "RainDrop":
        local rainDrop = GarbageItemService.Clone("RainDrop")
        rainDrop.Position = Vector3.new(0, 50, 0)
        rainDrop.Parent = workspace
        task.wait(5)
        GarbageItemService.AddInGarbage(rainDrop) -- Move to Garbage folder
        -- or
        GarbageItemService.RemoveFromGarbage("RainDrop") -- Remove from Garbage folder
    
    What it does:
    - Clones items from the Garbage folder or ReplicatedStorage if not found in Garbage.
    - Adds items to the Garbage folder.
    - Removes items from the Garbage folder.

    What is this for ?
    - To avoid cluttering ReplicatedStorage with unused items.
    - To reuse items without having to recreate them from scratch.
    - To manage memory usage by keeping unused items in a separate folder.
]]

-- Services
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules

-- Class
local GarbageItemService = {}

-- Variables
local tracked: {[Instance]: thread} = {}

-- Create Garbage Folder
local GarbageFolder = ReplicatedStorage:FindFirstChild("Garbage")
if not GarbageFolder then
    GarbageFolder = Instance.new("Folder")
    GarbageFolder.Name = "Garbage"
    GarbageFolder.Parent = ReplicatedStorage
end

--========================================================
-- HELPERS
--========================================================

-- Récupère tous les enfants d'un instance avec un nom spécifique
local function GetChildrenByName(instance: Instance, name: string)
	local childs: {Instance} = {}
	for _, child: Instance in ipairs(instance:GetChildren()) do
		if child.Name == name then
			table.insert(childs, child)
		end
	end
	return childs
end

-- Récupère (ou crée) le dossier Garbage dans ReplicatedStorage
local function getGarbageFolder(): Folder
    if not GarbageFolder or GarbageFolder.Parent ~= ReplicatedStorage then
        GarbageFolder = ReplicatedStorage:FindFirstChild("Garbage")
        if not GarbageFolder then
            GarbageFolder = Instance.new("Folder")
            GarbageFolder.Name = "Garbage"
            GarbageFolder.Parent = ReplicatedStorage
        end
    end
    return GarbageFolder
end

-- Ajoute un objet avec un délai avant suppression
local function DebrisAdd(instance: Instance, lifetime: number)
	if not instance then return end

	-- Si déjà tracké, on annule l'ancien timer
	if tracked[instance] then
		task.cancel(tracked[instance])
	end

	-- Nouveau timer
	tracked[instance] = task.delay(lifetime, function()
		if instance and instance.Parent then
			instance:Destroy()
		end
		tracked[instance] = nil
	end)
end

-- Annule la suppression prévue
local function DebrisCancel(instance: Instance)
	if tracked[instance] then
		task.cancel(tracked[instance])
		tracked[instance] = nil
	end
end

--========================================================
-- METHODS
--========================================================

--[[
    Clones an item from the Garbage folder or ReplicatedStorage if not found in Garbage.
    @param itemName (string): The name of the item to clone | itemsFolder (Folder?): The folder to search in.
    @return (Instance | nil): The cloned item or nil if not found.
]]
function GarbageItemService.Clone(itemName: string, itemsFolder: Folder?): Instance | nil
    local gf = getGarbageFolder()
    local itemsInstance: Instance? = gf:FindFirstChild(itemName)
    if not itemsInstance then
        itemsInstance = itemsFolder and itemsFolder:FindFirstChild(itemName) or gf:FindFirstChild(itemName)
        if itemsInstance then
            return itemsInstance:Clone()
        end
    else
        DebrisCancel(itemsInstance)
    end
    return itemsInstance
end

--[[
    Adds an item to the Garbage folder.
    @param item (Instance): The item to add to the Garbage folder | timeLimit (number): The time limit before the item is removed.
]]
function GarbageItemService.AddInGarbage(item: Instance, timeLimit: number?)
    if item and item.Parent ~= getGarbageFolder() then
        item.Parent = getGarbageFolder()
    end
    if timeLimit then
        DebrisAdd(item, timeLimit)
    end
end

--[[
    Removes items from the Garbage folder.
    @param itemName (string): The name of the item to remove from the Garbage folder.
]]
function GarbageItemService.RemoveFromGarbage(itemName: string)
    local gf = getGarbageFolder()
    local items: {Instance} = GetChildrenByName(gf, itemName)
    for _, item: Instance in ipairs(items) do
        item:Destroy()
    end
end

--========================================================
-- PRIVATE METHODS
--========================================================

--[[
    Resets the service for testing purposes.
    WARNING: This will clear all tracked items and the Garbage folder.
]]
function GarbageItemService._resetForTests()
    for k in pairs(tracked) do
         tracked[k] = nil 
    end
    GarbageFolder = nil
end

return GarbageItemService