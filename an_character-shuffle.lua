A_CHARACTER_SHUFFLE = register_amomaly("character shuffle")

character_shuffle_table = {
    [CT_MARIO] = CT_TOAD,
    [CT_LUIGI] = CT_WARIO,
    [CT_TOAD] = CT_WALUIGI,
    [CT_WALUIGI] = CT_LUIGI,
    [CT_WARIO] = CT_MARIO,
}

character_shuffle_model = {
    [CT_MARIO] = E_MODEL_TOAD_PLAYER,
    [CT_LUIGI] = E_MODEL_WARIO,
    [CT_TOAD] = E_MODEL_WALUIGI,
    [CT_WALUIGI] = E_MODEL_LUIGI,
    [CT_WARIO] = E_MODEL_MARIO,
}

local function mario_update(m)
    obj_set_model_extended(m.marioObj, character_shuffle_model[m.character.type])
end

anomaly_hook_event(A_CHARACTER_SHUFFLE, HOOK_MARIO_UPDATE, mario_update)

---@param m MarioState
local function character_sound(m, characterSound)
    -- Waluigi is a special case because of his voice pitch
    -- Waluigi and Toad (since he becomes Waluigi) don't have any voice clip variations because of it. 
    if(m.character.type == CT_WALUIGI or character_shuffle_table[m.character.type] == CT_WALUIGI) then
        play_sound_with_freq_scale(gCharacters[character_shuffle_table[m.character.type]].sounds[characterSound + 1], m.marioObj.header.gfx.cameraToObject, gCharacters[character_shuffle_table[m.character.type]].soundFreqScale)
        return NO_SOUND
    else
        return gCharacters[character_shuffle_table[m.character.type]].sounds[characterSound + 1]
    end
end

anomaly_hook_event(A_CHARACTER_SHUFFLE, HOOK_CHARACTER_SOUND, character_sound)