-- GarbageItemService.spec.lua

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GarbageItemService = require(ReplicatedStorage.Shared.GarbageItemService)

    describe("GarbageItemService", function()
        local GarbageItemService
        beforeEach(function()
            -- Nettoyer ReplicatedStorage et Garbage avant chaque test
            if ReplicatedStorage:FindFirstChild("Garbage") then
                ReplicatedStorage.Garbage:Destroy()
            end
            local folder = Instance.new("Folder")
            folder.Name = "Garbage"
            folder.Parent = ReplicatedStorage

            -- Recharger le module pour réinitialiser son état
            GarbageItemService = require(ReplicatedStorage.Shared.GarbageItemService)
            if GarbageItemService._resetForTests then
                GarbageItemService._resetForTests()
            end
        end)

        it("clones from ReplicatedStorage when not in Garbage", function()
            local obj = Instance.new("Part")
            obj.Name = "RainDrop"
            obj.Parent = ReplicatedStorage

            local clone = GarbageItemService.Clone("RainDrop")
            expect(clone).to.be.ok()
            expect(clone:IsA("Part")).to.equal(true)
            expect(clone.Name).to.equal("RainDrop")
        end)

        it("adds an item to Garbage", function()
            local part = Instance.new("Part")
            part.Name = "Trash"
            part.Parent = workspace

            GarbageItemService.AddInGarbage(part)

            local garbage = ReplicatedStorage:FindFirstChild("Garbage")
            expect(garbage:FindFirstChild("Trash")).to.equal(part)
        end)

        it("removes an item from Garbage", function()
            local garbage = ReplicatedStorage:FindFirstChild("Garbage")

            local part = Instance.new("Part")
            part.Name = "Disposable"
            part.Parent = garbage

            GarbageItemService.RemoveFromGarbage("Disposable")

            expect(garbage:FindFirstChild("Disposable")).to.equal(nil)
        end)
    end)
end
