-- name: Exit 64
-- description: \\#ff8b8b\\Legal note: You do not need to do 64 exits. Only 8. 

ANOMALY_DEVMODE = true
ANOMALY_PLAYTEST = false

PACKET_SECRET_PROCEED = "PACKET_SECRET_PROCEED"

local transition_timer = 0
local looping = false

gGlobalSyncTable.exitNum = 0

function debug_log(msg)
    if(network_is_server() and ANOMALY_DEVMODE) then
        log_to_console(msg)
    end
end

smlua_text_utils_course_acts_replace(COURSE_BOB, "1  Castle Grounds", "1", "2", "3", "4", "5", "6")
smlua_text_utils_course_acts_replace(COURSE_WF, "2  Castle Grounds", "1", "2", "3", "4", "5", "6")

function proceed_loop(goingForward)
    if(gGlobalSyncTable.currentAnomaly > 0) then
        goingForward = not goingForward
    end
    debug_log((goingForward and ("proceeding to exit " .. tostring(gGlobalSyncTable.exitNum + 1)) or "back to exit 0"))
    if(gNetworkPlayers[0].globalIndex == 0) then
        gGlobalSyncTable.exitNum = goingForward and (gGlobalSyncTable.exitNum + 1) or 0
    end
    transition_timer = 50
    looping = true
    play_transition(WARP_TRANSITION_FADE_INTO_COLOR, 25, 0, 0, 0)
end

function network_proceed_loop(goingForward) -- todo: vote system
    -- block players from starting 2 loops at once. 
    if(looping) then
        return
    end
    network_send(true, {PACKET_SECRET_PROCEED, goingForward})
    proceed_loop(goingForward)
end

hook_event(HOOK_UPDATE,
    function ()
        if(transition_timer > 0) then
            transition_timer = transition_timer - 1
            if(transition_timer == 25) then
                warp_to_level(LEVEL_WF, 1, 0) -- go somewhere else during the transition so that the map can properly reset in multiplayer
            end

            if(transition_timer == 26) then -- every player selects a differen anomaly... Todo: Anything else! (While still maintaining Mirage support because that would be cool)
                gGlobalSyncTable.currentAnomaly = select_random_anomaly()
                debug_log("selected new anomaly")
            end

            if(transition_timer <= 0) then
                warp_to_level(LEVEL_BOB, 1, 0)
                debug_log(get_anomaly(gGlobalSyncTable.currentAnomaly).name)
                gMarioStates[0].action = ACT_DISAPPEARED
                looping = false
                play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 25, 0, 0, 0)
            end
        end
        return run_anomaly_hooks(HOOK_UPDATE)
    end
)

hook_event(HOOK_BEFORE_MARIO_UPDATE, 
    function (m)
        return run_anomaly_hooks(HOOK_BEFORE_MARIO_UPDATE, m)
    end
)

hook_event(HOOK_ON_SET_MARIO_ACTION, 
    function (m)
        return run_anomaly_hooks(HOOK_ON_SET_MARIO_ACTION, m)
    end
)

hook_event(HOOK_BEFORE_PHYS_STEP, 
    function (m, stepType)
        return run_anomaly_hooks(HOOK_BEFORE_PHYS_STEP, m, stepType)
    end
)

hook_event(HOOK_ALLOW_PVP_ATTACK, 
    function (attacker, victim, interaction)
        return run_anomaly_hooks(HOOK_ALLOW_PVP_ATTACK, attacker, victim, interaction)
    end
)

hook_event(HOOK_ON_PVP_ATTACK, 
    function (attacker, victim, interaction)
        return run_anomaly_hooks(HOOK_ON_PVP_ATTACK, attacker, victim, interaction)
    end
)

hook_event(HOOK_ON_PLAYER_CONNECTED, 
    function (m)
        return run_anomaly_hooks(HOOK_ON_PLAYER_CONNECTED, m)
    end
)

hook_event(HOOK_ON_PLAYER_DISCONNECTED, 
    function (m)
        return run_anomaly_hooks(HOOK_ON_PLAYER_DISCONNECTED, m)
    end
)

hook_event(HOOK_ON_HUD_RENDER, 
    function ()
        return run_anomaly_hooks(HOOK_ON_HUD_RENDER)
    end
)

hook_event(HOOK_ON_HUD_RENDER_BEHIND, 
    function ()
        return run_anomaly_hooks(HOOK_ON_HUD_RENDER_BEHIND)
    end
)

hook_event(HOOK_ALLOW_INTERACT, 
    function (interactor, interactee, interactType)
        return run_anomaly_hooks(HOOK_ALLOW_INTERACT, interactor, interactee, interactType)
    end
)

hook_event(HOOK_ON_INTERACT, 
    function (interactor, interactee, interactType, interactValue)
        return run_anomaly_hooks(HOOK_ON_INTERACT, interactor, interactee, interactType, interactValue)
    end
)

hook_event(HOOK_ON_LEVEL_INIT, 
    function ()
        if(gNetworkPlayers[0].currLevelNum == LEVEL_WF) then
            return
        end
        if(gNetworkPlayers[0].currLevelNum ~= LEVEL_BOB) then
            warp_to_level(LEVEL_BOB, 1, 0)
        end
        set_mario_action(gMarioStates[0], ACT_EMERGE_FROM_PIPE, 0)
        return run_anomaly_hooks(HOOK_ON_WARP)
    end
)

hook_event(HOOK_ON_WARP, 
    function ()
        if(gNetworkPlayers[0].currLevelNum == LEVEL_WF) then
            gMarioStates[0].action = ACT_DISAPPEARED
            play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 9999999999999, 0, 0, 0)
            return
        end
        set_mario_action(gMarioStates[0], ACT_EMERGE_FROM_PIPE, 0)
        return run_anomaly_hooks(HOOK_ON_WARP)
    end
)

hook_event(HOOK_ON_SET_CAMERA_MODE, 
    function (Camera, mode, frames)
        return run_anomaly_hooks(HOOK_ON_SET_CAMERA_MODE, Camera, mode, frames)
    end
)

hook_event(HOOK_ON_OBJECT_RENDER, 
    function (renderedObj)
        return run_anomaly_hooks(HOOK_ON_OBJECT_RENDER, renderedObj)
    end
)

hook_event(HOOK_ON_PACKET_RECEIVE, 
---@param dataTable table
    function (dataTable)
        if(dataTable[1] == PACKET_SECRET_PROCEED) then
            proceed_loop(dataTable[2])
        end
    end
)

hook_event(HOOK_ON_CHANGE_CAMERA_ANGLE, 
    function (mode)
        return run_anomaly_hooks(HOOK_ON_CHANGE_CAMERA_ANGLE, mode)
    end
)

-- I don't really see the point in including it but there's no reason not to so whatever
hook_event(HOOK_ALLOW_HAZARD_SURFACE, 
    function (m, hazardType)
        return run_anomaly_hooks(HOOK_ALLOW_HAZARD_SURFACE, m, hazardType)
    end
)

hook_event(HOOK_ON_CHAT_MESSAGE, 
    function (messageSender, messageSent)
        return run_anomaly_hooks(HOOK_ON_CHAT_MESSAGE, messageSender, messageSent)
    end
)

hook_event(HOOK_OBJECT_SET_MODEL, 
    function (obj, modelID, modelExtendedId)
        return run_anomaly_hooks(HOOK_OBJECT_SET_MODEL, obj, modelID, modelExtendedId)
    end
)

hook_event(HOOK_CHARACTER_SOUND, 
    function (m, characterSound)
        return run_anomaly_hooks(HOOK_CHARACTER_SOUND, m, characterSound)
    end
)

hook_event(HOOK_BEFORE_SET_MARIO_ACTION, 
    function (m, incomingAction, actionArg)
        return run_anomaly_hooks(HOOK_BEFORE_SET_MARIO_ACTION, m, incomingAction, actionArg)
    end
)

hook_event(HOOK_ON_OBJECT_ANIM_UPDATE, 
    function (obj)
        return run_anomaly_hooks(HOOK_ON_OBJECT_ANIM_UPDATE, obj)
    end
)

hook_event(HOOK_ON_DIALOG, 
    function (dialogId)
        return run_anomaly_hooks(HOOK_ON_DIALOG, dialogId)
    end
)

hook_event(HOOK_ON_EXIT, 
    function ()
        return run_anomaly_hooks(HOOK_ON_EXIT)
    end
)

hook_event(HOOK_DIALOG_SOUND, 
    function (dialogSound)
        return run_anomaly_hooks(HOOK_DIALOG_SOUND, dialogSound)
    end
)

hook_event(HOOK_ON_COLLIDE_LEVEL_BOUNDS, 
    function (m)
        return run_anomaly_hooks(HOOK_ON_COLLIDE_LEVEL_BOUNDS, m)
    end
)

hook_event(HOOK_MARIO_OVERRIDE_PHYS_STEP_DEFACTO_SPEED, 
    function (m)
        return run_anomaly_hooks(HOOK_MARIO_OVERRIDE_PHYS_STEP_DEFACTO_SPEED, m)
    end
)

hook_event(HOOK_ON_OBJECT_LOAD, 
    function (obj)
        return run_anomaly_hooks(HOOK_ON_OBJECT_LOAD, obj)
    end
)

hook_event(HOOK_ON_PLAY_SOUND, 
    function (soundBits, pos)
        return run_anomaly_hooks(HOOK_ON_PLAY_SOUND, soundBits, pos)
    end
)

hook_event(HOOK_ON_ATTACK_OBJECT, 
    function (attacker, victim, interactionId)
        return run_anomaly_hooks(HOOK_ON_ATTACK_OBJECT, attacker, victim, interactionId)
    end
)

hook_event(HOOK_MARIO_UPDATE, 
    ---@param m MarioState
    function(m)
        if(gNetworkPlayers[0].currLevelNum == LEVEL_WF) then
            gMarioStates[0].action = ACT_DISAPPEARED
            play_transition(WARP_TRANSITION_FADE_FROM_COLOR, 9999999999999, 0, 0, 0)
            return
        end
        m.health = 0x880
        if(m.action == ACT_PULLING_DOOR or m.action == ACT_PUSHING_DOOR) and transition_timer <= 0 and not looping then
            network_proceed_loop(true)
        end
        return run_anomaly_hooks(HOOK_MARIO_UPDATE, m)
    end
)

---@param obj Object
local function bhv_warp_pipe_init(obj)
    local hitbox = get_temp_object_hitbox()
    hitbox.height = 50
    hitbox.radius = 100
    obj_set_hitbox(obj, hitbox)
    obj.collisionData = gGlobalObjectCollisionData.warp_pipe_seg3_collision_03009AC8
    obj.oCollisionDistance = 1000
end

---@param obj Object
local function bhv_warp_pipe_loop(obj)
    load_object_collision_model()

    local m = gMarioStates[0] ---@type MarioState
    if(m.action ~= ACT_EMERGE_FROM_PIPE and m.action ~= ACT_DISAPPEARED and obj_check_hitbox_overlap(obj, m.marioObj)) then
        play_sound(SOUND_MENU_ENTER_PIPE, m.marioObj.header.gfx.cameraToObject)
        set_mario_action(m, ACT_DISAPPEARED, 0)
        network_proceed_loop(false)
    end
end

hook_event(HOOK_ON_MODS_LOADED, function ()
    gGlobalSyncTable.currentAnomaly = select_random_anomaly()
end)

id_bhvWarpPipe = hook_behavior(id_bhvWarpPipe, OBJ_LIST_SURFACE, true, bhv_warp_pipe_init, bhv_warp_pipe_loop, "bhvWarpPipe")