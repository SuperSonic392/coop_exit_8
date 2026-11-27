-- generates usernames that are just good enough for the obfuscation to take care of the rest
-- used for chat echos

-- edit: it's used for chat spam here. 
-- this script is from my cursed server's mod, HyperCat's Toolbox Indev. 

local star_character = ""

-- prebuilt usernames
local characters = {
    "Mario", -- surprisingly normal name among Coop DX players
    "Player", -- default name, gotta have this one
    "Netski", -- the funny Deltarune foxes
    "HyperCat", -- me
}

local vowels = {"a", "e", "i", "o", "u"}
local consonants = {"b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "z"}

-- flairs
local prefixes = {""} -- todo: more of these
local suffixes = {"64", "1"} -- todo: same

-- I finally decided to comment this function because it has come to my attention that some of my mods are so fucked up and weird, that people feel the need to examine them. 
function generate_random_username(charCount)
    -- because of this function's use of random_float, it messes with SM64's RNG. Not that it matters. 
    if(random_float() > 0.99) then
        return characters[math.random(1, #characters)]
    end

    local use_underscores = random_float() > 0.8 -- 20% chance to use snake_case instead of CamelCase for the username. 

    local has_stars = random_float() > 0.7 -- 30% chance to have the stars surrounding the name

    local returnMSG = ""

    -- 50% chance of a prefix
    if(random_float() > 0.5) then
        returnMSG = returnMSG .. prefixes[math.random(1, #prefixes)]
    end

    for i = 1, charCount do
        local char = ""
        -- odd numbers use consonants while even numbers use vowels
        if(i / 2 == math.floor(i / 2)) then
            char = vowels[math.random(1, #vowels)]
        else
            char = consonants[math.random(1, #consonants)]
            if(math.random() > 0.9) then
                char = use_underscores and ("_" .. char)  or string.upper(char)
            end
        end

        if(i == 1 and not use_underscores) then -- capitalize the first letter of a CamelCase name
            char = string.upper(char)
        end
        returnMSG = returnMSG .. char
    end

    -- 50% chance of a suffix
    if(random_float() > 0.5) then
        returnMSG = returnMSG .. suffixes[math.random(1, #suffixes)]
    end

    -- if it has the stars, surround the name in the star character
    if(has_stars) then
        returnMSG = star_character .. returnMSG .. star_character
    end

    return returnMSG
end

local function generate_random_hex_number()
    return string.format("%x", tostring(math.random(127, 254)))
end

function generate_username_hex_code()
    return "\\#" ..generate_random_hex_number()..generate_random_hex_number()..generate_random_hex_number().."\\"
end

if(network_is_server()) then
    hook_chat_command("name", "- generates a random username", function (msg)
        djui_chat_message_create(generate_username_hex_code()..generate_random_username(math.random(2, 4)*2))
        return true
    end)
end