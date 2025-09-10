-- Services
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local TestEZ = require(ReplicatedStorage.ModuleScripts.Services.TestEZ)

TestEZ.run(script, function (callbackReturn)
	print(callbackReturn)
end)