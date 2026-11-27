---@param obj Object
function bhvDoor_init(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvDoor_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvDoor = hook_behavior(id_bhvDoor, OBJ_LIST_SURFACE, false, bhvDoor_init, bhvDoor_loop, "bhvDoor")