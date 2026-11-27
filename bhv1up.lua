-- respawning 1up
-- this is the only one of these bhv scripts that completely overwrites its object. 

---@param obj Object
function bhv1Up_init(obj)
    -- set render flags and hitbox
    obj_set_billboard(obj)
    obj.oAction = 1
    obj.oFlags = obj.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    obj.oGraphYOffset = 30
    obj_set_hitbox(obj, get_temp_object_hitbox())
    obj_set_hitbox_radius_and_height(obj, 30, 30)

    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhv1Up_loop(obj)
    -- don't question why I used Gravity as a counter, lol
    if(obj.oGravity > 0) then
        obj.oGravity = obj.oGravity - 1

        if(obj.oGravity <= 15 and obj.oGravity > 0) then -- if we're close to respawning, flicker
            obj.oAction = (obj.oAction == 0) and 1 or 0
            obj.header.gfx.node.flags = (obj.oAction == 0) and (obj.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE) or (obj.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE)
        end

        if(obj.oGravity <= 0) then -- if we're done respawning, set everything back to normal
            obj.oAction = 1
            obj.header.gfx.node.flags = obj.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        end
    end

    -- interactions
    if(obj.oGravity <= 0 and obj_check_hitbox_overlap(obj, gMarioStates[0].marioObj)) then
        play_sound(SOUND_GENERAL_COLLECT_1UP, gGlobalSoundSource)
        obj.header.gfx.node.flags = obj.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        obj.oGravity = 100
    end
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhv1Up = hook_behavior(id_bhv1Up, OBJ_LIST_LEVEL, true, bhv1Up_init, bhv1Up_loop, "bhv1Up")