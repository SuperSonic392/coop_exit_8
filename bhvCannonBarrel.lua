---@param obj Object
function bhvCannonBarrel_init(obj)
    obj_set_model_extended(obj, E_MODEL_CANNON_BARREL)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvCannonBarrel_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvCannonBarrel = hook_behavior(id_bhvCannonBarrel, OBJ_LIST_LEVEL, false, bhvCannonBarrel_init, bhvCannonBarrel_loop, "bhvCannonBarrel")