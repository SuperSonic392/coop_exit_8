---@param obj Object
function bhvExclamation_box_init(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvExclamation_box_loop(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvExclamationBox = hook_behavior(id_bhvExclamationBox, OBJ_LIST_SURFACE, false, bhvExclamation_box_init, bhvExclamation_box_loop, "bhvExclamationBox")