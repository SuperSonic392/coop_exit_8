A_METAL_BOX = register_amomaly("wing cap box is a metal cap box")

---@param obj Object
local function bhvInit(obj)
    if(get_id_from_behavior(obj.behavior) == id_bhvExclamationBox) then
        obj.oBehParams2ndByte = 1 -- box contents
        obj.oAnimState = 1 -- box textures
        obj.oAction = 2 -- i don't remember what this does
    end
end

anomaly_hook_event(A_METAL_BOX, HOOK_ANOMALY_BHV_INIT, bhvInit)