Md.notif = {}

if not DataView then
  Md.require('dataview')
end

local function LoadDictFile(dict,waiter)
  if DoesStreamedTextureDictExist(dict) then
    if not HasStreamedTextureDictLoaded(dict) then
      RequestStreamedTextureDict(dict, true)
      while waiter and not HasStreamedTextureDictLoaded(dict) do
        Wait(0)
      end
    end
  end
end

local function UiFeedPostSampleToastRight(...)
  return Citizen.InvokeNative(0xB249EBCB30DD88E0,...)
end

local function UiFeedPostSampleToast(...)
  return Citizen.InvokeNative(0x26E87218390E6729,...)
end

local function UiFeedClearAllChannels(...)
  return Citizen.InvokeNative(0x6035E8FBCA32AC5E,...)
end

RegisterNetEvent(GetCurrentResourceName()..":client:notif", function(text, dict, icon, color, duration,soundset_ref,soundset_name)
  Md.notif.right(text, dict, icon, color, duration,soundset_ref,soundset_name)
end)

---@param text string the text of the notification
function Md.notif.rightSuccess(text)
  Md.notif.right(text,"hud_textures","check","COLOR_GREEN")
end

---@param text string the text of the notification
function Md.notif.rightError(text)
  Md.notif.right(text,"menu_textures", "cross","COLOR_RED",nil,nil,'Transaction_Negative')
end

---@param text string The text of the notification
---@param dict string The dictonnary of the icon
---@param icon string he name of the icon
---@param color? string The color of the text
---@param duration? integer The duration of the notification in ms
---@param soundset_ref? string The dictionnary of the soundset
---@param soundset_name? string The name of the soundset
function Md.notif.right(text, dict, icon, color, duration,soundset_ref,soundset_name)
  local message = {
    type = 'notificationRight',
    text = tostring(text or ''),
    dict = tostring(dict or ''),
    icon = tostring(icon or ''),
    color = tostring(color or "COLOR_WHITE"),
    duration = tonumber(duration or 3000),
    soundset_ref = soundset_ref or "Transaction_Feed_Sounds",
    soundset_name = soundset_name or "Transaction_Positive"
  }
  if not message then return end
  UiFeedClearAllChannels()
  LoadDictFile(message.dict,true)
  message.text = CreateVarString(10, "LITERAL_STRING", tostring(message.text))
  message.dict = CreateVarString(10, "LITERAL_STRING", tostring(message.dict))
  message.soundset_ref = CreateVarString(10, "LITERAL_STRING", message.soundset_ref)
  message.soundset_name = CreateVarString(10, "LITERAL_STRING", message.soundset_name)
  local struct1 = DataView.ArrayBuffer(8 * 7)
  struct1:SetInt32(8 * 0, message.duration)
  struct1:SetInt64(8 * 1, bigInt(message.soundset_ref))
  struct1:SetInt64(8 * 2, bigInt(message.soundset_name))
  local struct2 = DataView.ArrayBuffer(8 * 10)
  struct2:SetInt64(8 * 1, bigInt(message.text))
  struct2:SetInt64(8 * 2, bigInt(message.dict))
  struct2:SetInt64(8 * 3, bigInt(joaat(message.icon)))
  struct2:SetInt64(8 * 5, bigInt(joaat(message.color)))
  --if showquality then
      --struct2:SetInt32(8 * 6, quality or 1)
  --end
  UiFeedPostSampleToastRight(struct1:Buffer(), struct2:Buffer(), 1)
end

RegisterNetEvent(GetCurrentResourceName()..":client:notifLeft", function(title, subTitle, dict, icon, color, duration,soundset_ref,soundset_name)
  Md.notif.left(title, subTitle, dict, icon, color, duration,soundset_ref,soundset_name)
end)

---@param title string the title of the notification
---@param text string The text of the notification
---@param dict string The dictonnary of the icon
---@param icon string he name of the icon
---@param color? string The color of the text
---@param duration? integer The duration of the notification in ms
---@param soundset_ref? string The dictionnary of the soundset
---@param soundset_name? string The name of the soundset
function  Md.notif.left(title, text, dict, icon, color, duration,soundset_ref,soundset_name)
  local message = {
    type = 'notificationLeft',
    title = tostring(title or ''),
    text = tostring(text or ''),
    dict = tostring(dict or ''),
    icon = tostring(icon or ''),
    color = tostring(color or "COLOR_WHITE"),
    duration = tonumber(duration or 3000),
    soundset_ref = soundset_ref or "Transaction_Feed_Sounds",
    soundset_name = soundset_name or "Transaction_Positive"
  }
  if not message then return end
  UiFeedClearAllChannels()
  LoadDictFile(message.dict,true)
  local struct1 = DataView.ArrayBuffer(8 * 7)
  local struct2 = DataView.ArrayBuffer(8 * 8)
  message.soundset_ref = CreateVarString(10, "LITERAL_STRING", message.soundset_ref)
  message.soundset_name = CreateVarString(10, "LITERAL_STRING", message.soundset_name)
  struct1:SetInt32(8 * 0, message.duration)
  struct1:SetInt64(8 * 1, bigInt(message.soundset_ref))
  struct1:SetInt64(8 * 2, bigInt(message.soundset_name))
  message.title = CreateVarString(10, "LITERAL_STRING", message.title)
  message.text = CreateVarString(10, "LITERAL_STRING", message.text)
  struct2:SetInt64(8 * 1, bigInt(message.title))
  struct2:SetInt64(8 * 2, bigInt(message.text))
  struct2:SetInt32(8 * 3, 0)
  struct2:SetInt64(8 * 4, bigInt(joaat(message.dict)))
  struct2:SetInt64(8 * 5, bigInt(joaat(message.icon)))
  struct2:SetInt64(8 * 6, bigInt(joaat(message.color)))
  UiFeedPostSampleToast(struct1:Buffer(), struct2:Buffer(), 1, 1)
end

return Md.notif