A_NO_SWIM = register_amomaly("no swimming")

local function mario_update(m)
    m.flags = m.flags | MARIO_METAL_CAP -- make the player Metal
    m.marioBodyState.modelState = m.marioBodyState.modelState & ~MODEL_STATE_METAL -- and disable the metal flag on the model only
end

anomaly_hook_event(A_NO_SWIM, HOOK_MARIO_UPDATE, mario_update)

-- this handles replacing the metal sounds with the terrain sounds
local function on_play_sound(soundBits, pos)
    for index, value in ipairs(gMarioStates) do
        local m = gMarioStates[index - 1]

        if(compareVec3f(m.marioObj.header.gfx.cameraToObject, pos)) then
            if(m.flags & MARIO_METAL_CAP) ~= 0 then
                return replace_footsteps(soundBits, m, pos)
            end
        end
    end
end

function replace_footsteps(soundBits, m, s)
    return replace_step_sound_actions(m, soundBits, SOUND_ACTION_TERRAIN_JUMP + m.terrainSoundAddend, SOUND_ACTION_TERRAIN_LANDING + m.terrainSoundAddend, SOUND_ACTION_TERRAIN_STEP + m.terrainSoundAddend, SOUND_ACTION_TERRAIN_STEP_TIPTOE + m.terrainSoundAddend, SOUND_ACTION_BONK, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND, SOUND_ACTION_TERRAIN_HEAVY_LANDING)
end

function replace_step_sound_actions(m, soundBits, jump, land, step, tiptoe, bonk, hit_ground, ground_pound)
    if (soundBits) == SOUND_ACTION_TERRAIN_JUMP or (soundBits) == SOUND_ACTION_METAL_JUMP then
        return jump
    end
    if (soundBits) == SOUND_ACTION_TERRAIN_LANDING or (soundBits) == SOUND_ACTION_METAL_LANDING then
        return land
    end
    if (soundBits) == SOUND_ACTION_TERRAIN_STEP or (soundBits) == SOUND_ACTION_METAL_STEP then
        return step
    end
    if (soundBits) == SOUND_ACTION_TERRAIN_STEP_TIPTOE or (soundBits) == SOUND_ACTION_METAL_STEP_TIPTOE then
        return tiptoe
    end
    if (soundBits) == SOUND_ACTION_BONK or (soundBits) == SOUND_ACTION_METAL_BONK then
        return bonk
    end

    -- apparently SOUND_ACTION_METAL_HEAVY_LANDING is used for both ground pounds and landing on the ground from a bonk

    -- the sound plays during ACT_GROUND_POUND, 
    -- but because other players might be in ACT_GROUND_POUND_LAND by the time that your client plays that sound, 
    -- I felt it was better to be safe than sorry
    if (soundBits) == SOUND_ACTION_METAL_HEAVY_LANDING then
        return (m.action == ACT_GROUND_POUND or m.action == ACT_GROUND_POUND_LAND) and ground_pound or hit_ground
    end
end

-- shitty little helper function
function compareVec3f(vec3f1, vec3f2)
    return vec3f1.x == vec3f2.x and vec3f1.y == vec3f2.y and vec3f1.z == vec3f2.z
end

anomaly_hook_event(A_NO_SWIM, HOOK_ON_PLAY_SOUND, on_play_sound)

-- So yes despite this being labeled "no swimming", it actually just makes you functionally Metal. 
-- If there were any enemies in the map, you'd be able to kill them by running into them. 