local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local ClientRingCollected = Events:WaitForChild("ClientRingCollected")

_G.active = true
while _G.active do
    local args = { "Legendary" }
    ClientRingCollected:FireServer(unpack(args))
    wait(0) 
end   
