-- GarbageBenchmark.spec.lua

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GarbageItemService = require(ReplicatedStorage.Shared.GarbageItemService)

    describe("Benchmark GarbageItemService vs Destroy", function()
        beforeAll(function()
            -- Préparer Garbage folder propre
            if ReplicatedStorage:FindFirstChild("Garbage") then
                ReplicatedStorage.Garbage:Destroy()
            end
            local folder = Instance.new("Folder")
            folder.Name = "Garbage"
            folder.Parent = ReplicatedStorage

            -- Préparer un objet de base pour clonage
            local base = Instance.new("Part")
            base.Name = "RainDrop"
            base.Anchored = true
            base.Size = Vector3.new(1,1,1)
            base.Parent = ReplicatedStorage
        end)

        local ITERATIONS = 1000

        it("benchmark Destroy direct", function()
            local start = os.clock()

            for i = 1, ITERATIONS do
                local drop = ReplicatedStorage.RainDrop:Clone()
                drop.Position = Vector3.new(0, 100, 0)
                drop.Parent = workspace
                drop:Destroy()
            end

            local duration = os.clock() - start
            print("[Destroy direct]", ITERATIONS, "ops in", duration, "sec")
        end)

        it("benchmark GarbageItemService", function()
            local start = os.clock()

            for i = 1, ITERATIONS do
                local drop = GarbageItemService.Clone("RainDrop")
                drop.Position = Vector3.new(0, 100, 0)
                drop.Parent = workspace
                GarbageItemService.AddInGarbage(drop)
            end

            local duration = os.clock() - start
            print("[GarbageItemService]", ITERATIONS, "ops in", duration, "sec")
        end)
    end)
end
