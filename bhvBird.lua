---@param obj Object
function bhvBird_init(obj)
    obj_set_model_extended(obj, E_MODEL_BIRDS)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvBird_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvBird = hook_behavior(id_bhvBird, OBJ_LIST_LEVEL, false, bhvBird_init, bhvBird_loop, "bhvBird")