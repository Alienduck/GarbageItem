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

local function GetChildrenByName(instance: Instance, name: string)
	local childs: {Instance} = {}
	for _, child: Instance in ipairs(instance:GetChildren()) do
		if child.Name == name then
			table.insert(childs, child)
		end
	end
	return childs
end

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
    local items: {Instance} = GetChildrenByName(GarbageFolder, itemName)
    for _, item: Instance in ipairs(items) do
        item:Destroy()
    end
end


return GarbageItemService