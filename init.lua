--weitere interessanter Code: https://github.com/SmallJoker/minibase_game/blob/master/mods/default/nodes.lua#L535
--Quelle: https://forum.minetest.net/viewtopic.php?p=299612#p299612

minetest.register_privilege( "lava", "Can place lava at any depth.")
local old_register_node = minetest.register_node
local old_register_craftitem = minetest.register_craftitem

minetest.register_craftitem = function ( name, fields )
   if fields.on_place then
      fields._on_place = fields.on_place
      fields.on_place = function( itemstack, player, pointed_thing )
         local pos = pointed_thing.under
         local node = minetest.get_node( pos )

         -- allow on_rightclick callback of pointed_thing to intercept item placement
         if minetest.registered_nodes[ node.name ].on_rightclick then
            minetest.registered_nodes[ node.name ].on_rightclick( pos, node, player, itemstack )
         -- otherwise placement is dependent on anti-grief rules of this item (if hook is defined)
         elseif not fields.allow_place or fields.allow_place( pos, player ) then
            return fields._on_place( itemstack, player, pointed_thing )
         end
         return itemstack
      end
   end
   old_register_craftitem( name, fields )
end

minetest.register_node = function ( name, fields )
   if fields.on_place and fields.on_place ~= minetest.rotate_node then
      fields._on_place = fields.on_place
      fields.on_place = function( itemstack, player, pointed_thing )
         local pos = pointed_thing.under
         local node = minetest.get_node( pos )

         -- allow on_rightclick callback of pointed_thing to intercept item placement
         if minetest.registered_nodes[ node.name ].on_rightclick then
            minetest.registered_nodes[ node.name ].on_rightclick( pos, node, player, itemstack )
         -- otherwise placement is dependent on anti-grief rules of this item (if hook is defined)
         elseif not fields.allow_place or fields.allow_place( pos, player ) then
            return fields._on_place( itemstack, player, pointed_thing )
         end
         return itemstack
      end
   end
   if fields.on_punch then
      fields._on_punch = fields.on_punch
      fields.on_punch = function( pos, node, player )
         -- punching is dependent on anti-grief rules of this item (currently only used by tnt)
         if not fields.allow_punch or fields.allow_punch( pos, player ) then
            fields._on_punch( pos, node, player )
         end
      end
   end
   old_register_node( name, fields )
end

local LAVA_PLACE_DEPTH = -250

local function allow_place_lava( node_pos, player )
        if node_pos.y > LAVA_PLACE_DEPTH and not minetest.check_player_privs( player, "lava" ) then
                minetest.chat_send_player( player:get_player_name( ), "You are not allowed to place explosives above " .. LAVA_PLACE_DEPTH .. "!" )
                minetest.log( "action", player:get_player_name( ) .. " tried to place default:lava_source above " .. LAVA_PLACE_DEPTH )
                return false
        end
        return true
end

minetest.override_item( "bucket:bucket_lava", {
        allow_place = allow_place_lava
} )

minetest.override_item( "default:lava_source", {
        allow_place = allow_place_lava
} )
