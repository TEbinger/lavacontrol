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

--ab hier kopiert von https://github.com/SmallJoker/minibase_game/blob/master/mods/default/nodes.lua#L535

on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.above then
			return
		end
		if not minetest.is_singleplayer() then
			local player_name = placer:get_player_name()
			if pointed_thing.above.y > -5 then
				minetest.chat_send_player(player_name, "Do not place lava over -5m, that could end really bad!", true)
				return itemstack
			end
			if minetest.is_protected(pointed_thing.above, player_name) then
				minetest.record_protection_violation(pointed_thing.above, player_name)
				return itemstack
			end
		end
		return minetest.item_place(itemstack, placer, pointed_thing, 0)
	end
