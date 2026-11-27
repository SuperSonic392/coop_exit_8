A_SIGN_TEXT_SCRAMBLE = register_amomaly("sign text is scrambled")

-- function taken from my cursed server's "HyperCat's Toolbox Indev"
local function scramble_string(msg, chance)
    local returnMSG = ""
    for i = 1, string.len(msg) do
        char = string.sub(msg, i, i)
        if(math.random() < chance) then
            char = string.char(math.random(35, 122))
        end
        returnMSG = returnMSG .. char
    end
    return returnMSG
end

local function on_dialogue(dialogId)
    return true, scramble_string(smlua_text_utils_dialog_get(dialogId).text, .25)
end

anomaly_hook_event(A_SIGN_TEXT_SCRAMBLE, HOOK_ON_DIALOG, on_dialogue)