-- GarbageBenchmark.spec.lua

return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GarbageItemService = require(ReplicatedStorage.Shared.GarbageItemService)

    describe("Benchmark GarbageItemService vs Destroy", function()
        beforeAll(function()
            -- Réinitialiser Garbage
            if ReplicatedStorage:FindFirstChild("Garbage") then
                ReplicatedStorage.Garbage:Destroy()
            end
            local folder = Instance.new("Folder")
            folder.Name = "Garbage"
            folder.Parent = ReplicatedStorage

            -- Base Part pour clonage
            local base = Instance.new("Part")
            base.Name = "RainDrop"
            base.Anchored = true
            base.Size = Vector3.new(1,1,1)
            base.Parent = ReplicatedStorage
        end)

        local GarbageItemService
        beforeEach(function()
            GarbageItemService = require(ReplicatedStorage.Shared.GarbageItemService)
            if GarbageItemService._resetForTests then
                GarbageItemService._resetForTests()
            end
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

        it("benchmark GarbageItemService AddInGarbage (sans timeLimit)", function()
            local start = os.clock()

            for i = 1, ITERATIONS do
                local drop = GarbageItemService.Clone("RainDrop")
                drop.Position = Vector3.new(0, 100, 0)
                drop.Parent = workspace
                GarbageItemService.AddInGarbage(drop)
            end

            local duration = os.clock() - start
            print("[GarbageItemService - AddInGarbage]", ITERATIONS, "ops in", duration, "sec")
        end)

        it("benchmark GarbageItemService AddInGarbage (avec timeLimit)", function()
            local start = os.clock()

            for i = 1, ITERATIONS do
                local drop = GarbageItemService.Clone("RainDrop")
                drop.Position = Vector3.new(0, 100, 0)
                drop.Parent = workspace
                -- Suppression auto après 0.01s
                GarbageItemService.AddInGarbage(drop, 0.01)
            end

            local duration = os.clock() - start
            print("[GarbageItemService - AddInGarbage + timeLimit]", ITERATIONS, "ops in", duration, "sec")
        end)

        it("benchmark GarbageItemService Clone réutilisation", function()
            -- On envoie des objets dans Garbage d’abord
            for i = 1, 100 do
                local drop = GarbageItemService.Clone("RainDrop")
                drop.Parent = ReplicatedStorage.Garbage
            end

            local start = os.clock()

            for i = 1, ITERATIONS do
                local drop = GarbageItemService.Clone("RainDrop")
                drop.Position = Vector3.new(0, 100, 0)
                drop.Parent = workspace
                GarbageItemService.AddInGarbage(drop)
            end

            local duration = os.clock() - start
            print("[GarbageItemService - Réutilisation depuis Garbage]", ITERATIONS, "ops in", duration, "sec")
        end)
    end)
end