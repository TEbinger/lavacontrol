minetest.register_node("default:lava_flowing", {
	description = "Flowing lava",
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 6,
	post_effect_color = {a=192, r=255, g=64, b=0},
	groups = {lava=3, liquid=2, hot=3, igniter=1, not_in_creative_inventory=1},
})

minetest.register_node("default:lava_source", {
	description = "Lava source",
	stack_max = 10,
	inventory_image = minetest.inventorycube("default_lava.png"),
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}
		}
	},
	special_tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
		}
	},
	paramtype = "light",
	light_source = LIGHT_MAX - 1,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "default:lava_flowing",
	liquid_alternative_source = "default:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 8,
	post_effect_color = {a=192, r=255, g=64, b=0},
	groups = {lava=3, liquid=2, hot=3, igniter=1},
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
})





--Code kopiert von https://github.com/SmallJoker/minibase_game/blob/master/mods/default/nodes.lua#L535
