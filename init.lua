local LAVA_PLACE_DEPTH = -50

minetest.register_privilege( "lava", "Can place lava at any depth.")

function allow_place_lava(itemstack, placer, pointed_thing )
        if pos.y > LAVA_PLACE_DEPTH and not minetest.check_player_privs( player, "lava" ) then
                minetest.chat_send_player( player:get_player_name( ), "You are not allowed to place lava above " .. LAVA_PLACE_DEPTH .. "!" )
                minetest.log( "action", player:get_player_name( ) .. " tried to place default:lava_source above " .. LAVA_PLACE_DEPTH )
                return false
        end
        return true
end

minetest.override_item( "bucket:bucket_lava", {
        on_place = allow_place_lava
} )

minetest.override_item( "default:lava_source", {
        on_place = allow_place_lava
} )

