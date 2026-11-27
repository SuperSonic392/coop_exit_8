A_LOBBY_TAKEOVER = register_amomaly("chat spam")
local timer = 0
local time_until_next_popup = 20*20

-- list of messages that can be spammed, including pre-built ones for lobbies with silent players. 
local message_list = {
    -- standard stuff a real player might say
    "what is this mod?",
    "hello",
    "hola",
    "oh this is pretty cool",
    "WHAT IS THAT!?",
    "help",
    "i'm scared",
    "i'm stuck",
    "this is not ok",

    -- more random stuff
    "twitter stinks, i'm leaving", -- to quote Wario on Twitter (formerly known as Twitter). 
    "tf you mean I'm an anomaly?", -- hint hint
    "Susie Gaster Deltarune", -- deltarune shitpost
    "djui_chat_message_create", -- djui_chat_message_create
    "just pretend I put actual effort into writing these please",
    --"I'm cracking your dad", -- deltarune shitpost

    -- the rest of these are from an #out-of-context Discord channel, lol
    "little does she know that I'm an multi-dimensional being", -- quote from my brother
    "man I want to be a furry", -- quote from me
    "The Engineer is Engiqueer!", -- quote from me
    "i am the roblox roleplay griefer", -- quote from my brother
}

local function update()
    if(gMarioStates[0].area.localAreaTimer <= 1) then
        return
    end
    timer = timer + 1
    if(time_until_next_popup > 0) then
        time_until_next_popup = time_until_next_popup - 1
    end
    if(timer < 500) then
        if(time_until_next_popup <= 0) then
            djui_popup_create(generate_username_hex_code() .. generate_random_username(8) .. "\\#dcdcdc\\ connected", 1)
            time_until_next_popup = math.random(-5, 10)
            if(time_until_next_popup <= 0) then
                djui_popup_create(generate_username_hex_code() .. generate_random_username(8) .. "\\#dcdcdc\\ connected", 1)
                djui_popup_create(generate_username_hex_code() .. generate_random_username(8) .. "\\#dcdcdc\\ connected", 1)
                djui_popup_create(generate_username_hex_code() .. generate_random_username(8) .. "\\#dcdcdc\\ connected", 1)
            end
        end
    else
        if(time_until_next_popup <= 0) then
            djui_chat_message_create(generate_username_hex_code() .. generate_random_username(8) .. "\\#dcdcdc\\: " .. message_list[math.random(1, #message_list)])
            play_sound(SOUND_MENU_MESSAGE_APPEAR, gGlobalSoundSource);
            time_until_next_popup = math.random(0, 10)
        end
    end
end

anomaly_hook_event(A_LOBBY_TAKEOVER, HOOK_UPDATE, update)

hook_event(HOOK_ON_CHAT_MESSAGE, function (m, message)
    table.insert(message_list, message)
end)

anomaly_hook_event(A_LOBBY_TAKEOVER, HOOK_ON_WARP, function ()
    timer = 0
    time_until_next_popup = 20*20
end)