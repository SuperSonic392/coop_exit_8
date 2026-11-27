--- @class AnomalyTable
--- @field name string
--- @field hooks table the hooks

-- anomaly specific hooks:
HOOK_ANOMALY_BHV_INIT = -1
HOOK_ANOMALY_BHV_UPDATE = -2

gGlobalSyncTable.currentAnomaly = 0

local anomaly_table = {}

local unsupportedHooks = {
    HOOK_ON_LEVEL_INIT,
    HOOK_ON_SYNC_VALID,
    HOOK_ON_OBJECT_UNLOAD,
    HOOK_ON_SYNC_OBJECT_UNLOAD,
    HOOK_ON_PAUSE_EXIT,
    HOOK_GET_STAR_COLLECTION_DIALOG,
    HOOK_USE_ACT_SELECT,
    HOOK_ON_SCREEN_TRANSITION,
    HOOK_JOINED_GAME,
    HOOK_MIRROR_MARIO_RENDER,
    HOOK_ON_SEQ_LOAD,
    HOOK_ON_GEO_PROCESS,
    HOOK_BEFORE_GEO_PROCESS,
    HOOK_ON_GEO_PROCESS_CHILDREN,
    HOOK_ON_LANGUAGE_CHANGED,
    HOOK_ON_MODS_LOADED,
    HOOK_ON_DJUI_THEME_CHANGED,
    HOOK_BEFORE_WARP,
    HOOK_ON_INSTANT_WARP
}

---@param debug_name string The name displayed in game
---@return integer
function register_amomaly(debug_name)
    local tempAnomaly = {name = debug_name, hooks = {}} ---@type AnomalyTable
    table.insert(anomaly_table, tempAnomaly)
    --log_to_console("registered anomaly: " .. debug_name)
    return #anomaly_table
end

--- @param anomalyID integer The anomaly to run the hook for
--- @param hookEventType LuaHookedEventType When a function should run
--- @param func fun(...: any): any The function to run
function anomaly_hook_event(anomalyID, hookEventType, func)
    anomaly_table[anomalyID].hooks[hookEventType] = func
    --log_to_console(tostring(anomaly_table[anomalyID].hooks[hookEventType]))
end

--- @param anomalyID integer The anomaly you want to grab
--- @return AnomalyTable
function get_anomaly(anomalyID)
    if(anomalyID == 0) then
        return {name = "no anomaly", hooks = {}}
    end
    return anomaly_table[anomalyID]
end

--- returns a random anomaly index
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