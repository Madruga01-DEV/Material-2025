Md.ui = {}

---@param level integer
---@param xp integer
---@param xpRequired integer
function Md.ui.updateRank(level, xp, xpRequired)
  local container = DatabindingAddDataContainerFromPath("", "mp_rank_bar")
  DatabindingAddDataString(container, "rank_text", tostring(level))
  DatabindingAddDataString(container, "rank_header_text", xp .. "/" .. xpRequired)
  DatabindingAddDataInt(container, "rank_header_text_alpha", 100)
  DatabindingAddDataInt(container, "xp_bar_minimum", 0)
  DatabindingAddDataInt(container, "xp_bar_maximum", xpRequired)
  DatabindingAddDataInt(container, "xp_bar_value", xp)
end

-- Fonction pour formater le temps en minutes:secondes
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    seconds = seconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

-- Initialisation du TimerUI
function Md.ui.initTimer()
    Md.ui.TimerUI = {}
    Md.ui.TimerUI.data = {}
    Md.ui.TimerUI.data.uiFlowblock = Citizen.InvokeNative(0xC0081B34E395CE48, -119209833)

    local temp = 0
    while not UiflowblockIsLoaded(Md.ui.TimerUI.data.uiFlowblock) do
        temp = temp + 1
        if temp > 10000 then
            return
        end
        Citizen.Wait(1)
    end

    if not Citizen.InvokeNative(0x10A93C057B6BD944, Md.ui.TimerUI.data.uiFlowblock) then
        return
    end

    Md.ui.TimerUI.data.container = DatabindingAddDataContainerFromPath("", "centralInfoDatastore")
    DatabindingAddDataString(Md.ui.TimerUI.data.container, "timerMessageString", "")
    Md.ui.TimerUI.data.timer = DatabindingAddDataString(Md.ui.TimerUI.data.container, "timerString", "")
    Md.ui.TimerUI.data.show = DatabindingAddDataBool(Md.ui.TimerUI.data.container, "isVisible", false)

    UiflowblockEnter(Md.ui.TimerUI.data.uiFlowblock, `cTimer`)

    if UiStateMachineExists(1546991729) == 0 then
        Md.ui.TimerUI.data.stateMachine = UiStateMachineCreate(1546991729, Md.ui.TimerUI.data.uiFlowblock)
    end

    Md.ui.TimerUI.data.time = 0
    return Md.ui.TimerUI.data.stateMachine
end

-- Fonction pour arrêter le TimerUI
function Md.ui.stopTimer()
    if not Md.ui.TimerUI then return end
    Md.ui.TimerUI.data.time = 0
    DatabindingWriteDataBool(Md.ui.TimerUI.data.show, false)
end

-- Fonction pour démarrer le TimerUI
---@param time integer -- en secondes
---@param low? integer -- secondes à partir desquelles la couleur du timer devient rouge
function Md.ui.startTimer(time, low)
    if not Md.ui.TimerUI or UiStateMachineExists(1546991729) == 0 then return end
    DatabindingWriteDataBool(Md.ui.TimerUI.data.show, true)
    Md.ui.TimerUI.data.time = time or 60

    local function updateTimer()
        if Md.ui.TimerUI.data.time >= 0 then
            DatabindingWriteDataString(Md.ui.TimerUI.data.timer, formatTime(Md.ui.TimerUI.data.time))
            Md.ui.TimerUI.data.time = Md.ui.TimerUI.data.time - 1
            if low and Md.ui.TimerUI.data.time <= low then
                DatabindingAddDataBool(Md.ui.TimerUI.data.container, "isTimerLow", true)
            end
            Md.timeout.delay('updateTimer', 1000, updateTimer)
        else
            Md.ui.finishTimer()
        end
    end

    updateTimer()
end

-- Fonction pour terminer le TimerUI
function Md.ui.finishTimer()
    if not Md.ui.TimerUI then return end
    UiStateMachineDestroy(1546991729)
    if DatabindingIsEntryValid(Md.ui.TimerUI.data.container) then
        DatabindingRemoveDataEntry(Md.ui.TimerUI.data.container)
    end
    if DatabindingIsEntryValid(Md.ui.TimerUI.data.timer) then
        DatabindingRemoveDataEntry(Md.ui.TimerUI.data.timer)
    end
    if DatabindingIsEntryValid(Md.ui.TimerUI.data.show) then
        DatabindingRemoveDataEntry(Md.ui.TimerUI.data.show)
    end
end

return Md.ui
