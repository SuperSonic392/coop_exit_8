set_yoshi_as_not_dead() -- THIS SETS YOSHI AS *DEAD*! GOD DAMMIT! WHY DO I KEEP FINDING STUPID BUGS WHILE MAKING STUPID MODS!


---@param obj Object
function bhvYoshi_init(obj)
    run_anomaly_hooks(HOOK_ANOMALY_BHV_INIT, obj)
end

---@param obj Object
function bhvYoshi_loop(obj) -- I could temporarily keep Yoshi from despawning if I force him into YOSHI_ACT_IDLE every frame, but as soon as I stop, Yoshi pisses off and jumps off the castle. 
    run_anomaly_hooks(HOOK_ANOMALY_BHV_UPDATE, obj)
end

id_bhvYoshi = hook_behavior(id_bhvYoshi, OBJ_LIST_LEVEL, false, bhvYoshi_init, bhvYoshi_loop, "bhvYoshi")