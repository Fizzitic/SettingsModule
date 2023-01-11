local SettingsModule = {}

local Players = game:GetService("Players")

local event = script:WaitForChild("Changed")

local saving = false

function SettingsModule.new(name, value)
	if SettingsModule[name] then
		error("Duplicate name found")
	end

	SettingsModule[name] = {Name = name, Value = value}
end

function SettingsModule:HasSetting(name)
	if SettingsModule[name] == nil then
		error("Setting not found")
	else
		return SettingsModule[name]
	end
end

function SettingsModule:GetSetting(name)
	if SettingsModule:HasSetting(name) then
		return SettingsModule[name]
	end
end

function SettingsModule:ChangeSetting(name, value)
	if SettingsModule[name] then
		SettingsModule[name] = {Name = name, Value = value}
		event:Fire(name, value)
	else
		error("Setting not found")
	end
end

function SettingsModule:EnableSaving()
	if saving == false then
		saving = true
	end
end

function SettingsModule:DisableSaving()
	if saving == true then
		saving = false
	end
end

function SettingsModule:Save()
	if saving == true then
		local DataStoreService = game:GetService("DataStoreService")
		local dataStore = DataStoreService:GetDataStore("Settings")
		
		local player = Players.LocalPlayer
		
		local Success, Error = pcall(function()
			return dataStore:SetAsync(player.UserId.."Settings", SettingsModule)
		end)
		if Error then
			warn(Error)
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	if saving == true then
		local DataStoreService = game:GetService("DataStoreService")
		local dataStore = DataStoreService:GetDataStore("Settings")
		
		local save = dataStore:GetAsync(player.UserId.."Settings")
		SettingsModule = save
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if saving == true then
		local DataStoreService = game:GetService("DataStoreService")
		local dataStore = DataStoreService:GetDataStore("Settings")
		
		local Success, Error = pcall(function()
			return dataStore:SetAsync(player.UserId.."Settings", SettingsModule)
		end)
		if Error then
			warn(Error)
		end
	end
end)

return SettingsModule
