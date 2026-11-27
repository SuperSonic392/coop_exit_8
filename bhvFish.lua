---@param obj Object
function bhvFish_init(obj)
    obj_set_model_extended(obj, E_MODEL_FISH)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvFish_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvFish = hook_behavior(id_bhvFish, OBJ_LIST_LEVEL, false, bhvFish_init, bhvFish_loop, "bhvFish")