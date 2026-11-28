---@param obj Object
local function bhv_warp_pipe_init(obj)
    local hitbox = get_temp_object_hitbox()
    hitbox.height = 50
    hitbox.radius = 100
    obj_set_hitbox(obj, hitbox)
    obj.collisionData = gGlobalObjectCollisionData.warp_pipe_seg3_collision_03009AC8
    obj.oCollisionDistance = 1000
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
local function bhv_warp_pipe_loop(obj)
    load_object_collision_model()

    local m = gMarioStates[0] ---@type MarioState
    if(m.action ~= ACT_EMERGE_FROM_PIPE and m.action ~= ACT_PIPE_WAIT and m.action ~= ACT_DISAPPEARED and obj_check_hitbox_overlap(obj, m.marioObj)) then
        play_sound(SOUND_MENU_ENTER_PIPE, m.marioObj.header.gfx.cameraToObject)
        set_mario_action(m, ACT_PIPE_WAIT, 0)
    end
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvWarpPipe = hook_behavior(id_bhvWarpPipe, OBJ_LIST_SURFACE, true, bhv_warp_pipe_init, bhv_warp_pipe_loop, "bhvWarpPipe")