---@param obj Object
function bhvCannon_init(obj)
    obj_set_model_extended(obj, E_MODEL_CANNON_BASE)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvCannon_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvCannon = hook_behavior(id_bhvCannon, OBJ_LIST_LEVEL, false, bhvCannon_init, bhvCannon_loop, "bhvCannon")