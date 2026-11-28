-- This is the script I plan to use lib uv-scroll in
uvscroll = require("lib/uv-scroll")

local function uv_scroll_move_over_time(input_vtx, original_uv, current_uv, speedX, speedY)
    current_uv[1] = current_uv[1] + speedX
    current_uv[2] = current_uv[2] + speedY
end

-- Scroll the uvs in a circular motion
local function uv_scroll_spin(input_vtx, original_uv, current_uv, speed)

    -- equation for circular motion
    local t = get_global_timer() * speed
    local orig_theta = math.atan2(original_uv[2], original_uv[1])
    local orig_dist = math.sqrt(math.pow(original_uv[1], 2) + math.pow(original_uv[2], 2))
    current_uv[1] = orig_dist * math.cos(orig_theta + t)
    current_uv[2] = orig_dist * math.sin(orig_theta + t)
end

uvscroll.hook_scrolling_function("bob_dl_water_lake_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    uv_scroll_spin(input_vtx, original_uv, current_uv, 20 / 25000)
end)

uvscroll.hook_scrolling_function("bob_dl_water_moat_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    uv_scroll_spin(input_vtx, original_uv, current_uv, 15 / 25000)
end)

uvscroll.hook_scrolling_function("bob_dl_waterfall_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    uv_scroll_move_over_time(input_vtx, original_uv, current_uv, 100, 0)
end)