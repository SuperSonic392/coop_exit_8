---@param obj Object
function bhvButterfly_init(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvButterfly_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvButterfly = hook_behavior(id_bhvButterfly, OBJ_LIST_LEVEL, false, bhvButterfly_init, bhvButterfly_loop, "bhvButterfly")