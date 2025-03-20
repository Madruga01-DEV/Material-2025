local promptGroups = {}
local lastKey = 0

Md.prompt = {}

if not IsModuleLoaded('timeout') then
  Md.require('timeout')
end

local function UiPromptHasHoldMode(...) return Citizen.InvokeNative(0xB60C9F9ED47ABB76, ...) end
local function UiPromptSetEnabled(...) return Citizen.InvokeNative(0x8A0FB4D03A630D21,...) end
local function UiPromptIsEnabled(...) return Citizen.InvokeNative(0x0D00EDDFB58B7F28,...) end
local function UiPromptGetProgress(...) return  Citizen.InvokeNative(0x81801291806DBC50,...,Citizen.ResultAsFloat()) end

---@param group string Name of the group
---@param title string Title of the prompt
function Md.prompt.displayGroup(group,title)
  if not Md.prompt.isGroupExist(group) then return end
  local promptName  = CreateVarString(10, 'LITERAL_STRING', title)
  PromptSetActiveGroupThisFrame(promptGroups[group].group, promptName)
end

function Md.prompt.isActive(group,key)
  if not Md.prompt.isExist(group,key) then return false end
  return UiPromptIsActive(promptGroups[group].prompts[key])
end

---@param group string Name of the group
---@param key string Input
function Md.prompt.isEnabled(group,key)
  if not Md.prompt.isActive(group,key) then return false end
  return UiPromptIsEnabled(promptGroups[group].prompts[key])
end

---@param group string Name of the group
---@param key string Input
---@param value boolean
function Md.prompt.setEnabled(group,key,value)
  if not Md.prompt.isExist(group,key) then return end
  UiPromptSetEnabled(promptGroups[group].prompts[key],value)
end

---@param group string Name of the group
---@param key string Input
---@param value boolean
function Md.prompt.setVisible(group,key,value)
  if not Md.prompt.isExist(group,key) then return end
  UiPromptSetVisible(promptGroups[group].prompts[key],value)
end

---@param group string Name of the group
---@param key string Input
---@param label string Label of the prompt
function Md.prompt.editKeyLabel(group,key,label)
  if not Md.prompt.isExist(group,key) then return end
  local str = CreateVarString(10, 'LITERAL_STRING', label)
  PromptSetText(promptGroups[group].prompts[key], str)
end

---@param group string Group of the prompt
---@param key string Input
---@param fireMultipleTimes? boolean (optional) fire true until another prompt is completed
---@return boolean
function Md.prompt.isCompleted(group,key,fireMultipleTimes)
  if fireMultipleTimes == nil then fireMultipleTimes = false end
	if not Md.prompt.isGroupExist(group) then return false end
  if fireMultipleTimes then
    if Md.prompt.doesLastCompletedIs(group,key) then
      return true
    end
  end
  if not Md.prompt.isEnabled(group,key) then return false end
  if UiPromptHasHoldMode(promptGroups[group].prompts[key]) then
    if PromptHasHoldModeCompleted(promptGroups[group].prompts[key]) then
			lastKey = promptGroups[group].prompts[key]
      Md.prompt.setEnabled(group,key, false)
      Citizen.CreateThread(function()
        local group = group
        local key = key
        while IsDisabledControlPressed(0,joaat(key)) or IsControlPressed(0,joaat(key)) do
          Wait(0)
        end
        lastKey = 0
        Md.prompt.setEnabled(group,key, true)
      end)
      return true
    end
  else
    if IsControlJustPressed(0,joaat(key)) then
			lastKey = key
      CreateThread(function()
        while IsControlPressed(0,joaat(key)) do
          Wait(0)
        end
        lastKey = 0
      end)
      return true
    elseif fireMultipleTimes and IsControlPressed(0,joaat(key)) then
      return true
    end
  end
  return false
end

---@param key string Input
function Md.prompt.waitRelease(key)
  while IsDisabledControlPressed(0,joaat(key)) or IsControlPressed(0,joaat(key)) do
    Wait(0)
  end
end

---@param group string Group of the prompt
---@param key string Input
---@return boolean
function Md.prompt.doesLastCompletedIs(group,key)
  if not Md.prompt.isExist(group,key) then return false end
	return lastKey == promptGroups[group].prompts[key]
end

---@param group string Group of the prompt
---@param str string label of the prompt
---@param key any Input (string or list of strings)
---@param holdTime? integer (optional) time to complete
---@param page? integer (optional) page of the prompt
function Md.prompt.create(group, str, key, holdTime, page)
  --Check if group exist
	if not page then page = 0 end
	if not holdTime then holdTime = 0 end
  if (promptGroups[group] == nil) then
    if type(group) == "string" then
      promptGroups[group] = {
        group = GetRandomIntInRange(0, 0xffffff),
        prompts = {}
      }
    else
       promptGroups[group] = {
        group = group,
        prompts = {}
      }
    end
  end
  if type(key) == "table" then
    local keys = key
    key = keys[1]
    promptGroups[group].prompts[key] = PromptRegisterBegin()
    for _,k in pairs (keys) do
      promptGroups[group].prompts[k] = promptGroups[group].prompts[key]
      PromptSetControlAction(promptGroups[group].prompts[key], joaat(k))
    end
  else
    promptGroups[group].prompts[key] = PromptRegisterBegin()
    PromptSetControlAction(promptGroups[group].prompts[key], joaat(key))
  end
  str = CreateVarString(10, 'LITERAL_STRING', str)
  PromptSetText(promptGroups[group].prompts[key], str)
  PromptSetPriority(promptGroups[group].prompts[key], 2)
  PromptSetEnabled(promptGroups[group].prompts[key], true)
  PromptSetVisible(promptGroups[group].prompts[key], true)
  if holdTime > 0 then
    PromptSetHoldMode(promptGroups[group].prompts[key], holdTime)
  end
	if type(group) ~= "string" or not group:find("interaction") then
  	PromptSetGroup(promptGroups[group].prompts[key], promptGroups[group].group,page)
	end
  PromptRegisterEnd(promptGroups[group].prompts[key])
  return promptGroups[group].prompts[key]
end

function Md.prompt.deleteAllGroups()
  for group,_ in pairs (promptGroups) do
    Md.prompt.deleteGroup(group)
  end
end

---@param group string Group of the prompt
---@param key string Input
function Md.prompt.delete(group,key)
  if not Md.prompt.isExist(group,key) then return end
	PromptDelete(promptGroups[group].prompts[key])
end
Md.prompt.deletePrompt= Md.prompt.delete

---@param group string Group of the prompt
function Md.prompt.deleteGroup(group)
	if not promptGroups[group] then return end
	for _,prompt in pairs (promptGroups[group].prompts) do
		PromptDelete(prompt)
	end
  promptGroups[group] = nil
end

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then return end
  for _,group in pairs (promptGroups) do
		for _,prompt in pairs (group.prompts) do
			PromptDelete(prompt)
		end
	end
end)

---@param group string the name of the group
function Md.prompt.isGroupExist(group)
  return promptGroups[group] and true or false
end

---@param group string the name of the group
---@param key string the input of the key
function Md.prompt.isExist(group, key)
  if not Md.prompt.isGroupExist(group) then return false end
  return promptGroups[group].prompts[key] and true or false
end

Md.prompt.isPromptExist = Md.prompt.isExist

---@param group string the name of the group
---@param key string the input of the key
function Md.prompt.getProgress(group,key)
  if not Md.prompt.isExist(group,key) then return 0 end
  return UiPromptGetProgress(promptGroups[group].prompts[key])
end
Md.prompt.getPromptProgress = Md.prompt.getProgress

---@param groups table groups of prompt
function Md.prompt.setGroups(groups)
  promptGroups = groups
end

---@return table promptGroups prompt registered
function Md.prompt.getAll()
  return promptGroups
end

---@param key string the input of the key
function Md.prompt.isPressed(key)
  return IsControlPressed(0,joaat(key))
end

---@param group string the name of the group
---@param key string the input of the key
---@return integer promptId The prompt ID
function Md.prompt.get(group,key)
  if not Md.prompt.isExist(group, key) then return false end
  return promptGroups[group].prompts[key]
end

exports('Md_prompt_get', function()
  return Md.prompt
end)


return Md.prompt