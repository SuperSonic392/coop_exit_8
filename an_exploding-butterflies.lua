A_EXPLODING_BUTTERFLIES = register_amomaly("butterflies explode when touched")

---@param obj Object
local function bhvInit(obj)
    if(get_id_from_behavior(obj.behavior) == id_bhvButterfly) then
        -- set up the butterfly's hitbox, since they normally don't have one
        local hitbox = get_temp_object_hitbox()
        hitbox.radius = 30
        hitbox.height = 30
        hitbox.interactType = INTERACT_COIN -- this is the only interact type I could find that doesn't do anything automatically. I may just be stupid though. 
        obj_set_hitbox(obj, hitbox)
    end
end

---@param obj Object
local function bhvLoop(obj)
    if(get_id_from_behavior(obj.behavior) == id_bhvButterfly) then
        -- if the butterfly has been interacted with, explode. 
        if(obj.oInteractStatus == INT_STATUS_INTERACTED) then
            spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, obj.oPosX, obj.oPosY, obj.oPosZ, nil)
            obj.activeFlags = ACTIVE_FLAG_DEACTIVATED
        end
    end
end

anomaly_hook_event(A_EXPLODING_BUTTERFLIES, HOOK_ANOMALY_BHV_INIT, bhvInit)
anomaly_hook_event(A_EXPLODING_BUTTERFLIES, HOOK_ANOMALY_BHV_UPDATE, bhvLoop)