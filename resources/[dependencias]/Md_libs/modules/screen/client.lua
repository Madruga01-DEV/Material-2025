Md.screen = {}

---@param duration? integer duration of the fade in ms (default: 500)
---@param needWait? boolean wait the end of the fade (default:false)
function Md.screen.fadeIn(duration,needWait)
  DoScreenFadeIn(duration or 500)
  while needWait and IsScreenFadingOut() do
    Wait(0)
  end
end

---@param duration? integer duration of the fade in ms (default: 500)
---@param needWait? boolean wait the end of the fade (default:true)
function Md.screen.fadeOut(duration,needWait)
  if (needWait == nil) then needWait = true end
  DoScreenFadeOut(duration or 500)
  while needWait and IsScreenFadingOut() do
    Wait(0)
  end
end

return Md.screen