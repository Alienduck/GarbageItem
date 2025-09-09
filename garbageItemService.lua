-- Services
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local Utility = require(ReplicatedStorage.ModuleScripts:WaitForChild("Utility"))

-- Class
local GarbageItemService = {}

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

--========================================================
-- METHODS
--========================================================

--[[
    Clones an item from the Garbage folder or ReplicatedStorage if not found in Garbage.
    @param itemName (string): The name of the item to clone.
    @return (Instance | nil): The cloned item or nil if not found.
]]
function GarbageItemService.Clone(itemName: string): Instance | nil
    local itemsInstance: Instance? = GarbageFolder:FindFirstChild(itemName)
    if not itemsInstance then
        itemsInstance = ReplicatedStorage:FindFirstChild(itemName)
        if itemsInstance then
            return itemsInstance:Clone()
        end
    end
    return itemsInstance
end

--[[
    Adds an item to the Garbage folder.
    @param item (Instance): The item to add to the Garbage folder.
]]
function GarbageItemService.AddInGarbage(item: Instance)
    if item and item.Parent ~= GarbageFolder then
        item.Parent = GarbageFolder
    end
end

--[[
    Removes items from the Garbage folder.
    @param itemName (string): The name of the item to remove from the Garbage folder.
]]
function GarbageItemService.RemoveFromGarbage(itemName: string)
    local items: {Instance} = Utility:GetChildrenByName(GarbageFolder, itemName)
    for _, item: Instance in ipairs(items) do
        item:Destroy()
    end
end


return GarbageItemService