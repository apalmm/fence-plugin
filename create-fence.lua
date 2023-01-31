--fences
--AidanThDev

script.Parent:WaitForChild("PluginGui")

local Activated = script.Parent.Activated.Value
local mouse = plugin:GetMouse() --get the users mouse
local toolbar = plugin:CreateToolbar("Fences")
local undo = game:GetService("ChangeHistoryService")

local button = toolbar:CreateButton(
	"Aidan's Fence Creator",
	"Create Fencess",
	"http://www.roblox.com/asset/?id=1461889428"	
)

local fencePost = script.Parent.FilteredParts.FencePart1
local redPart = script.Parent.FilteredParts.redPart
local close = script.Parent.PluginGui.Frame.close

local fenceModel = Instance.new("Model")
local Spacing = 10

local newFenceModel
local ghostPart
local newFencePost
local line1
local newLine1
local line2
local newLine2
local dist
local count

local LERP = {}

function off ()
	if game.CoreGui:FindFirstChild("PluginGui") then --remove GUI
		game.CoreGui:FindFirstChild("PluginGui"):Destroy()
	end
	button:SetActive(false)
	plugin:Deactivate()
		
	if newFenceModel:FindFirstChild("FencePostGhostPart") then
		newFenceModel:FindFirstChild("FencePostGhostPart"):Destroy()
	end
	
	if newFenceModel:FindFirstChild("FenceGhostPart2") then
		newFenceModel:FindFirstChild("FenceGhostPart2"):Destroy()
	end
	
	if newFenceModel:FindFirstChild("FenceGhostPart1") then
		newFenceModel:FindFirstChild("FenceGhostPart1"):Destroy()
	end
	
	if ghostPart then
		ghostPart:Destroy()
	end
	
	for i_,v in pairs (newFenceModel:GetChildren()) do
		if v.Name == "DividerGhostPart" then
			v:Destroy()
		end
	end
	
	
	
	for i=0, #LERP do
		table.remove(LERP, i)
	end
	
	dist = nil
	line1 = nil
	line2 = nil
	newLine1 = nil
	newLine2 = nil
end



button.Click:connect(PluginButtonClick)

close.MouseButton1Click:Connect(function(mouse)
	off()
end)

function createLines ()
	if newFencePost and ghostPart then
		dist = (newFencePost.Position - ghostPart.Position).magnitude
		
		line1 = redPart:Clone()
		line2 = redPart:Clone()
		
		line1.Parent = newFenceModel
		line2.Parent = newFenceModel
		
		line1.Name = "FenceGhostPart1"
		line2.Name = "FenceGhostPart2"
		
		line1.CFrame = CFrame.new(newFencePost.Position, ghostPart.Position) * CFrame.new(0, -1.25, (-dist/2))
		line2.CFrame = CFrame.new(newFencePost.Position, ghostPart.Position) * CFrame.new(0, 1.25, (-dist/2))
		
		line1.Size = Vector3.new(redPart.Size.X, redPart.Size.Y, dist)
		line2.Size = Vector3.new(redPart.Size.X, redPart.Size.Y, dist)
	end
	if dist and dist >= Spacing then
		dist = (dist + 0.5) - (dist + 0.5) % 1
		local lerpDist = dist/Spacing
		if dist%Spacing >= 0 then
			count = 1
			for i=0, lerpDist do
				local Divider = fencePost:Clone()
				Divider.Parent = newFenceModel
				Divider.Name = "DividerGhostPart"
				Divider.BrickColor = BrickColor.new("Really red")
				Divider.Material = Enum.Material.SmoothPlastic
				Divider.CFrame = newFencePost.CFrame:Lerp(ghostPart.CFrame, ((1/(lerpDist+1)) * count))
				count = count+1
			end
		end
	end
end

mouse.Move:connect(function()
	if mouse.Target then
		if mouse.Target.Name ~= "FencePost" then
			mouse.TargetFilter = newFenceModel
			if mouse.Target and mouse.Target:IsA("BasePart") and ghostPart then
				local p = mouse.Hit.p
				ghostPart.Position = Vector3.new(math.ceil(p.X), (mouse.Target.Position.Y + (mouse.Target.Size.Y/2)) + (ghostPart.Size.Y/2), math.ceil(p.Z))
			end
		else
			ghostPart.CFrame = CFrame.new(mouse.Target.Position)
		end
		if line1 and line2 then
			wait()
			line1:Destroy()
			line2:Destroy()
			for i_,v in pairs (newFenceModel:GetChildren()) do
				if v.Name == "DividerGhostPart" then
					v:Destroy()
				end
			end
		end
		createLines()
	end
end)

mouse.Button1Down:connect(function() -- Binds function to left click
	newFencePost = fencePost:Clone()
	if fencePost then --create the final part
		newFencePost.Parent = newFenceModel
		newFencePost.Name = "FencePost"
		newFencePost.Transparency = 0
		newFencePost.CFrame = ghostPart.CFrame
		table.insert(LERP, newFencePost.CFrame)
	end
	if line1 and line2 then
		newLine1 = line1:Clone()
		newLine2 = line2:Clone()
		local function apply (existingPart, newPart)
			newPart.Parent = newFenceModel
			newPart.Name = "Part"
			newPart.Transparency = 0
			newPart.Material = Enum.Material.WoodPlanks
			newPart.BrickColor = BrickColor.new("Brown")
			newPart.CFrame = existingPart.CFrame
			newPart.Size = existingPart.Size
		end
		apply(line1, newLine1)
		apply(line2, newLine2)
		
		local totalDist = newLine1.Size.Z
		totalDist = (totalDist + 0.5) - (totalDist + 0.5) % 1
		local actualDistance =  totalDist /(count) 
		if totalDist%10 ~= 0 and totalDist >= 10 then
			for i = 0, (count-1) do
				local updatedSeparator = fencePost:Clone()
				updatedSeparator.Parent = newFenceModel
				updatedSeparator.Name = "FencePost"
				updatedSeparator.Transparency = 0
				updatedSeparator.CFrame = LERP[1]:Lerp(LERP[2], ((actualDistance / totalDist) * count) - 1)
				count = count + 1
			end
		else		
			for i_,v in pairs (newFenceModel:GetChildren()) do
				if v.Name == "DividerGhostPart" then
					local newDivider = v:Clone()
					apply(v, newDivider)
				end
			end
		end
		
		if LERP [1] then
			table.remove(LERP, 1)
		end
		
		if LERP [2] then
			table.remove(LERP, 2)
		end
		
	end
end)
