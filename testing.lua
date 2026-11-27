if not ANOMALY_PLAYTEST then
    return
end

gServerSettings.headlessServer = 1

local msg_join = 
"Welcome to Coop Exit 8 / Exit 64 (still working on the title)\
If you find an anomaly, go through the pipe. If you don't, go through the front door.\
\
Nothing related to the HUD is an anomaly.\
I've only implemented a few anomalies so far, so if you have any anomaly ideas, feel free to send them in the chat. \
also the lack of scrolling textures is not an anomaly. "

local msg_qna_start = 
"Facts and Questions:\
\
Q: Is this mod out yet?\
A: No, this command wouldn't exist if it was.\
\
"
local msg_qna_hosting_permissions = 
"Q: Can I rehost this mod on my own server?\
A: Not until it's officially released. \
Remember to follow the CoopNet rules. \
\
"
local msg_qna_exit8 = 
"Q: What is Exit 64?\
A: It's an unfinished Coop DX adaptation of Exit 8. \
yknow, the spot the difference horror game?\
RTGame made a video about it... Go watch that.\
\
"
local msg_qna_anomaly = 
"Q: How many anomalies are there?\
A: Right now, 5. I do plan on adding more.\
This set was just the easiest to implement for playtesting.\
\
"
local msg_qna_toolbox = 
"Q: What is \"HyperCat's Toolbox\"?\
A: Have you ever seen those mods that are like \"{Host}'s Server?\" It's basically my version of that.\
It has a bunch of commands, some for fun, some for moderation, and some just because I could. \
\
"
local msg_qna_invisible = 
"Q: Why don't you appear on the player list?\
A: I'm a ghost, muahaha! Also because I've tricked the game into thinking it's a headless server. \
\
"
local msg_qna_headless = 
"Q: What is a headless server?\
A: It's an SM64 Coop DX feature that lets people host dedicated servers, where the host's player doesn't exist. \
It's the same feature used on all the 24/7 servers. \
\
"
local msg_qna_headless2 = 
"Q: How did you trick the server into thinking it's headless?\
A: gServerSettings.headlessServer = 1\
\
"
local msg_qna_download = 
"Q: Where can I download Exit 64?\
A: https://github.com/SuperSonic392/coop_exit_8\
Remember to read the rest of this qna.\
Since I know this is the first answer you'll see.\
"

hook_event(HOOK_JOINED_GAME, function ()
    djui_chat_message_create(msg_join)
end)

hook_chat_command("joinmsg", "- repeat the join message incase it got buried", function (msg)
    djui_chat_message_create(msg_join)
    return true
end)

hook_chat_command("qna", "- A little QNA about this server", function (msg)
    djui_chat_message_create(msg_qna_start)
    djui_chat_message_create(msg_qna_hosting_permissions)
    djui_chat_message_create(msg_qna_exit8)
    djui_chat_message_create(msg_qna_anomaly)
    djui_chat_message_create(msg_qna_toolbox)
    if(gServerSettings.headlessServer == 1) then
        djui_chat_message_create(msg_qna_invisible)
        djui_chat_message_create(msg_qna_headless)
        djui_chat_message_create(msg_qna_headless2)
    end
    djui_chat_message_create(msg_qna_download)
    return true
end)