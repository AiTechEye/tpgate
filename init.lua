local tpgate={}

tpgate.teleport_move=function(pos,player)
	local d=minetest.registered_nodes[minetest.get_node(pos).name]
	if d and d.walkable==false then
		player:set_pos(pos)
	end
end

tpgate.teleport=function(pos,player)
	local p=player:get_pos()
	local x=math.floor((p.x-pos.x)+ 0.5)
	local y=math.floor((p.y-pos.y)+ 0.5)
	local z=math.floor(( p.z-pos.z)+ 0.5)
	if y>0 then
		tpgate.teleport_move({x=pos.x,y=pos.y-2,z=pos.z},player)
	elseif y<-1 then
		tpgate.teleport_move({x=pos.x,y=pos.y+1,z=pos.z},player)
	elseif x>0 and x>z then
		tpgate.teleport_move({x=pos.x-1,y=pos.y-1,z=pos.z},player)
	elseif x<0 and x<z then
		tpgate.teleport_move({x=pos.x+1,y=pos.y-1,z=pos.z},player)
	elseif z>0 and z>x then
		tpgate.teleport_move({x=pos.x,y=pos.y-1,z=pos.z-1},player)
	elseif z<0 and z<x then
		tpgate.teleport_move({x=pos.x,y=pos.y-1,z=pos.z+1},player)
	end
end

tpgate.inv=function(meta,show)
local text = meta:get_string("tpgtext")
meta:set_string("formspec",
	"size[7,7.8]" ..
	"list[context;tpg;2,1;1,1;]" ..
	"button_exit[0,-0.3; 1.5,1;tpgs;Save]" ..
	"textarea[0.3,1.1;7,8;tpgt;Members list;" .. text  .."]")
end

minetest.register_node("tpgate:gate", {
	tiles = {"default_meselamp.png^bubble.png^default_obsidian_glass.png"},
	description =" Teleport gate",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_stone_defaults(),
after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		local name=placer:get_player_name()
		meta:set_string("owner", name)
		meta:set_string("tpgtext", "")
		meta:set_string("infotext", "Teleportgate (" .. name .. ") punsh to activate")
		tpgate.inv(meta)
		end,
on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		tpgate.inv(meta)
		end,
can_dig = function(pos, player)
		local meta=minetest.get_meta(pos)
		local own=meta:get_string("owner")
		if player:get_player_name()~=own or own=="" then
			return false
		end
			return true
		end,
on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		if sender:get_player_name() ~= meta:get_string("owner") then
			return false
		end
		if fields.tpgs then
			meta:set_string("tpgtext", fields.tpgt)
		end
		tpgate.inv(meta)
		return true
end,
on_punch = function(pos, node, puncher, pointed_thing)
	local name=puncher:get_player_name()
	local meta=minetest.get_meta(pos)
	local text=meta:get_string("tpgtext")
	local owner=meta:get_string("owner")
	local txt=text.split(text,"\n")
	if name==owner then
		tpgate.teleport(pos,puncher)
		return true
	end
	for i in pairs(txt) do
		if name==txt[i] then
			tpgate.teleport(pos,puncher)
			return true
		end
	end
end
})

minetest.register_node("tpgate:gate_u", {
	tiles = {"default_meselamp.png^default_mineral_diamond.png^bubble.png^default_obsidian_glass.png"},
	description =" Teleport gate (unbreakable)",
	is_ground_content = false,
	groups = {unbreakable=1},
	sounds = default.node_sound_stone_defaults(),
after_place_node = function(pos, placer, itemstack)
		local meta=minetest.get_meta(pos)
		local name=placer:get_player_name()
		meta:set_string("owner", name)
		meta:set_string("tpgtext", "")
		meta:set_string("infotext", "Teleportgate (" .. name .. ") punch to activate")
		tpgate.inv(meta)
		end,
on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		tpgate.inv(meta)
		end,
can_dig = function(pos, player)
		local meta=minetest.get_meta(pos)
		local own=meta:get_string("owner")
		if player:get_player_name() ~= own or own=="" then
			return false
		end
			return true
		end,
on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos)
		if sender:get_player_name() ~= meta:get_string("owner") then
			return false
		end
		if fields.tpgs then
			meta:set_string("tpgtext", fields.tpgt)
		end
		tpgate.inv(meta)
		return true
end,
on_punch = function(pos, node, puncher, pointed_thing)
	local name=puncher:get_player_name()
	local meta=minetest.get_meta(pos)
	local text=meta:get_string("tpgtext")
	local owner=meta:get_string("owner")
	local txt=text.split(text,"\n")
	if name==owner then
		tpgate.teleport(pos,puncher)
		return true
	end
	for i in pairs(txt) do
		if name==txt[i] then
			tpgate.teleport(pos,puncher)
			return true
		end
	end
end
})

minetest.register_craft({
	output = "tpgate:gate",
	recipe = {
		{"","default:stone",""},
		{"default:stone","default:meselamp","default:stone"},
		{"","default:stone",""},
	}
})
