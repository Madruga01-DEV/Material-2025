Md.me = PlayerPedId()
Md.meCoords = GetEntityCoords(me)
Md.mePlayerId = PlayerId()
Md.meServerId = GetPlayerServerId(Md.mePlayerId)
Md.meIsMale =  IsPedMale(PlayerPedId())
local timer = 1000
local timeout

if not not IsModuleLoaded('timeout') then
  Md.require('timeout')
end

local function updateMe()
  Md.forceUpdateMe()
end
timeout = Md.timeout.loop(timer,updateMe)

---@param value integer the new interval to update me values
function Md.updateMeTimer(value)
  timer = value
  if timeout then
    timeout:clear()
  end
  if timer then
    timeout = Md.timeout.loop(timer,updateMe)
  end
end

function Md.forceUpdateMe()
  Md.me = PlayerPedId()
  Md.meCoords = GetEntityCoords(Md.me)
  Md.mePlayerId = PlayerId()
  Md.meServerId = GetPlayerServerId(Md.mePlayerId)
  Md.meIsMale =  IsPedMale(Md.me)
end

return Md.me