--- @class AnomalyTable
--- @field name string
--- @field hooks table the hooks

-- anomaly specific hooks:
HOOK_ANOMALY_BHV_INIT = -1
HOOK_ANOMALY_BHV_UPDATE = -2

gGlobalSyncTable.currentAnomaly = 0

local anomaly_table = {}

-- todo: give a warning when an anomaly attempts to hook any of these
local unsupportedHooks = {
    HOOK_ON_LEVEL_INIT, -- overlaps with ON_WARP, so ON_WARP is used for both scenarios. 
    HOOK_ON_SYNC_VALID, -- just use hook_event
    HOOK_ON_OBJECT_UNLOAD, -- just use hook_event
    HOOK_ON_SYNC_OBJECT_UNLOAD, -- dawg please just use hook_event
    HOOK_ON_PAUSE_EXIT, -- this is soon to be impossible
    HOOK_GET_STAR_COLLECTION_DIALOG, -- currently impossible
    HOOK_USE_ACT_SELECT, -- very impossible
    HOOK_ON_SCREEN_TRANSITION, -- please don't
    HOOK_JOINED_GAME, -- shouldn't ever be used in an anomaly
    HOOK_MIRROR_MARIO_RENDER, -- there are no mirror marios in the castle grounds
    HOOK_ON_SEQ_LOAD, -- use hook_event
    HOOK_ON_GEO_PROCESS, -- use hook_event
    HOOK_BEFORE_GEO_PROCESS, -- use hook_event
    HOOK_ON_GEO_PROCESS_CHILDREN, -- use hook_event
    HOOK_ON_LANGUAGE_CHANGED, -- why?
    HOOK_ON_MODS_LOADED, -- impossible to do even if I did properly implement it
    HOOK_ON_DJUI_THEME_CHANGED, -- use hook_event
    HOOK_BEFORE_WARP, -- again please don't
    HOOK_ON_INSTANT_WARP -- same here
}

---@param debug_name string The name displayed in game
---@return integer
-- Returns the ID of the anomaly
function register_amomaly(debug_name)
    local tempAnomaly = {name = debug_name, hooks = {}} ---@type AnomalyTable
    table.insert(anomaly_table, tempAnomaly)
    debug_log("registered anomaly: " .. debug_name)
    return #anomaly_table
end

-- hook_event but for anomalies. 
--- @param anomalyID integer The anomaly to run the hook for
--- @param hookEventType LuaHookedEventType When a function should run
--- @param func fun(...: any): any The function to run
function anomaly_hook_event(anomalyID, hookEventType, func)
    anomaly_table[anomalyID].hooks[hookEventType] = func
    debug_log(tostring(anomaly_table[anomalyID].hooks[hookEventType]))
end

-- gets an anomaly table from an anomaly ID. 
--- @param anomalyID integer The anomaly you want to grab
--- @return AnomalyTable
function get_anomaly(anomalyID)
    if(anomalyID == 0) then
        return {name = "no anomaly", hooks = {}}
    end
    return anomaly_table[anomalyID]
end

--- returns a random anomaly index (needs work)
function select_random_anomaly()
    if(gGlobalSyncTable.currentAnomaly ~= 0 and random_float() < 0.25) then
        return 0
    else
        local datetime = get_date_and_time() ---@type DateTime
        math.randomseed(datetime.second + (datetime.minute * 60) + (datetime.hour * 60 * 60))
        return math.random(1, #anomaly_table)
    end
end

---@param HookedEventType LuaHookedEventType
---@param ... any
function run_anomaly_hooks(HookedEventType, ...)
    if(gNetworkPlayers[0].currLevelNum ~= LEVEL_BOB) then
        return
    end
    if(gGlobalSyncTable.currentAnomaly > 0) then
        local anomalyTable = get_anomaly(gGlobalSyncTable.currentAnomaly)
        if(anomalyTable.hooks[HookedEventType] ~= nil) then
            return anomalyTable.hooks[HookedEventType](...)
        end
    end
end