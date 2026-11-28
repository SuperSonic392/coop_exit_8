ACT_PIPE_WAIT = allocate_mario_action(ACT_FLAG_INTANGIBLE)

local function act_pipe_wait(m)
    set_character_animation(m, CHAR_ANIM_A_POSE)
    stop_and_set_height_to_floor(m)
    m.marioObj.header.gfx.node.flags = m.marioObj.header.gfx.node.flags & ~GRAPH_RENDER_ACTIVE
    m.pos.x = -1328
    m.pos.y = 260
    m.pos.z = 4664
    m.faceAngle.y = 0x8000
    if(true) then
        set_mario_action(m, ACT_DISAPPEARED, 0)
        network_proceed_loop(false)
        return
    end
    if (m.input & INPUT_B_PRESSED) ~= 0 then
        set_mario_action(m, ACT_EMERGE_FROM_PIPE, 0)
        m.actionTimer = 11
    end
end

hook_mario_action(ACT_PIPE_WAIT, act_pipe_wait)


local function on_hud_render()
    local m = gMarioStates[0] ---@type MarioState

    if(m.action == ACT_PIPE_WAIT) then
        djui_hud_set_font(FONT_MENU)
        local string = "waiting for other players"
        djui_hud_print_text(string, (djui_hud_get_screen_width() - djui_hud_measure_text(string)) / 2, (djui_hud_get_screen_height() - 64), 1)
    end
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)