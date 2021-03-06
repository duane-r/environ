-- Environ nodes.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)


local mod = environ
local mod_name = 'environ'
local clone_node = mod.clone_node
local newnode
local light_max = 10

local singl = (minetest.get_mapgen_setting('mg_name') == 'singlenode')


do
	for k, v in pairs(minetest.registered_nodes) do
		local g = v.groups
		if v.name:find('default:stone_with') then
			g.ore = 1
			minetest.override_item(v.name, { groups = g })
		end
		if (g.stone or v.name:find('default:.*sandstone') or g.ore) and not (v.name:find('brick') or v.name:find('block') or v.name:find('stair') or v.name:find('slab') or v.name:find('default:.*cobble') or v.name:find('walls:.*cobble')) then
			g.natural_stone = 1
			minetest.override_item(v.name, { groups = g })
		end
	end
end


-- check
local function register_node_and_alias(n, t)
	minetest.register_node(mod_name..':'..n, t)
	--minetest.register_alias('default:'..n, mod_name..':'..n)
end


do
	minetest.register_node(mod_name..':basalt', {
		description = 'Basalt',
		tiles = { 'environ_basalt.png' },
		is_ground_content = true,
		groups = { cracky = 1, level = 2, natural_stone = 1 },
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})

	minetest.register_node(mod_name..':granite', {
		description = 'Granite',
		tiles = { 'environ_granite.png' },
		is_ground_content = true,
		groups = { cracky = 1, level = 3, natural_stone = 1 },
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})


	-- stone with lichen
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Lichen'
	newnode.tiles = { 'default_stone.png^environ_lichen.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_lichen', newnode)

	-- stone with algae
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Algae'
	newnode.tiles = { 'default_stone.png^environ_algae.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_algae', newnode)

	-- stone with moss
	newnode = clone_node('default:stone')
	newnode.description = 'Cave Stone With Moss'
	newnode.tiles = { 'default_stone.png^environ_moss.png' }
	newnode.groups = { stone = 1, cracky = 3, crumbly = 3, natural_stone = 1 }
	newnode.sounds = default.node_sound_dirt_defaults({
		footstep = { name = 'default_grass_footstep', gain = 0.25 },
	})
	minetest.register_node(mod_name..':stone_with_moss', newnode)

	-- salt
	minetest.register_node(mod_name..':stone_with_salt', {
		description = 'Cave Stone with Salt',
		tiles = { 'environ_salt.png' },
		paramtype = 'light',
		use_texture_alpha = singl,
		drawtype = 'glasslike',
		sunlight_propagates = false,
		is_ground_content = true,
		groups = { stone = 1, crumbly = 3, cracky = 3 },
		sounds = default.node_sound_glass_defaults(),
	})

	-- salt, radioactive ore
	newnode = clone_node(mod_name..':stone_with_salt')
	newnode.description = 'Salt With Radioactive Ore'
	newnode.tiles = { 'environ_radioactive_ore.png' }
	newnode.light_source = 5
	minetest.register_node(mod_name..':radioactive_ore', newnode)

	minetest.register_node(mod_name..':glowing_fungal_stone', {
		description = 'Glowing Fungal Stone',
		tiles = { 'default_stone.png^environ_glowing_fungal.png', },
		is_ground_content = true,
		light_source = 5,
		groups = { cracky = 3, stone = 1 },
		drop = { items = { { items = { 'default:cobble' }, }, { items = { mod_name..':glowing_fungus', }, }, }, },
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_node(mod_name..':glowing_gem', {
		description = 'Glowing gems',
		tiles = { 'environ_glowing_gem.png', },
		is_ground_content = true,
		paramtype = 'light',
		use_texture_alpha = true,
		drawtype = 'glasslike',
		light_source = 5,
		groups = { cracky = 3, stone = 1 },
		--drop = { items = { { items = { 'default:cobble' }, }, { items = { mod_name..':glowing_fungus', }, }, }, },
		sounds = default.node_sound_stone_defaults(),
	})

	-- black (oily) sand
	newnode = clone_node('default:sand')
	newnode.description = 'Black Sand'
	newnode.tiles = { 'environ_black_sand.png' }
	newnode.groups['falling_node'] = 0
	minetest.register_node(mod_name..':black_sand', newnode)

	-- rocks, hot
	minetest.register_node(mod_name..':hot_rock', {
		description = 'Hot Rocks',
		--tiles = { 'environ_hot_rock.png' },
		tiles = { 'default_cobble.png^[colorize:#990000:100' },
		--tiles = { 'default_desert_stone.png^[colorize:#FF0000:50' },
		is_ground_content = true,
		groups = { crumbly = 2, surface_hot = 3 },
		--light_source = 5,
		damage_per_second = 1,
		sounds = default.node_sound_stone_defaults({
			footstep = { name = 'default_stone_footstep', gain = 0.25 },
		}),
	})

	-- Glowing fungus grows underground.
	minetest.register_craftitem(mod_name..':glowing_fungus', {
		description = 'Glowing Fungus',
		drawtype = 'plantlike',
		paramtype = 'light',
		tiles = { 'environ_glowing_fungus.png' },
		inventory_image = 'environ_glowing_fungus.png',
		groups = { dig_immediate = 3 },
	})

	local giant_mushroom_cap_node_box = {
		type = 'fixed', 
		fixed = {
			{ -0.3, -0.25, -0.3, 0.3, 0.5, 0.3 },
			{ -0.3, -0.25, -0.4, 0.3, 0.4, -0.3 },
			{ -0.3, -0.25, 0.3, 0.3, 0.4, 0.4 },
			{ -0.4, -0.25, -0.3, -0.3, 0.4, 0.3 },
			{ 0.3, -0.25, -0.3, 0.4, 0.4, 0.3 },
			{ -0.4, -0.5, -0.4, 0.4, -0.25, 0.4 },
			{ -0.5, -0.5, -0.4, -0.4, -0.25, 0.4 },
			{ 0.4, -0.5, -0.4, 0.5, -0.25, 0.4 },
			{ -0.4, -0.5, -0.5, 0.4, -0.25, -0.4 },
			{ -0.4, -0.5, 0.4, 0.4, -0.25, 0.5 },
		}
	}

	local huge_mushroom_cap_node_box = {
		type = 'fixed', 
		fixed = {
			{ -0.5, -0.5, -0.33, 0.5, -0.33, 0.33 }, 
			{ -0.33, -0.5, 0.33, 0.33, -0.33, 0.5 }, 
			{ -0.33, -0.5, -0.33, 0.33, -0.33, -0.5 }, 
			{ -0.33, -0.33, -0.33, 0.33, -0.17, 0.33 }, 
		}
	}

	local giant_mushroom_stem_node_box = {
		type = 'fixed',
		fixed = {
			{ -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 },
		}
	}

	minetest.register_node(mod_name..':giant_mushroom_cap', {
		description = 'Giant Mushroom Cap',
		tiles = { 'environ_mushroom_giant_cap.png', 'environ_mushroom_giant_under.png', 'environ_mushroom_giant_cap.png' },
		is_ground_content = false,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = giant_mushroom_cap_node_box,
		light_source = 5,
		groups = { fleshy=1, dig_immediate=3, flammable=2, plant=1 },
	})


	-- mushroom cap, huge
	minetest.register_node(mod_name..':huge_mushroom_cap', {
		description = 'Huge Mushroom Cap',
		tiles = { 'environ_mushroom_giant_cap.png', 'environ_mushroom_giant_under.png', 'environ_mushroom_giant_cap.png' },
		is_ground_content = false,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = huge_mushroom_cap_node_box,
		light_source = 5,
		groups = { fleshy=1, dig_immediate=3, flammable=2, plant=1 },
	})

	-- mushroom stem, giant or huge
	minetest.register_node(mod_name..':giant_mushroom_stem', {
		description = 'Giant Mushroom Stem',
		tiles = { 'environ_mushroom_giant_stem.png', 'environ_mushroom_giant_stem.png', 'environ_mushroom_giant_stem.png' },
		is_ground_content = false,
		groups = { choppy=2, flammable=2,  plant=1 }, 
		sounds = default.node_sound_wood_defaults(),
		sunlight_propagates = true,
		paramtype = 'light',
		drawtype = 'nodebox',
		node_box = giant_mushroom_stem_node_box,
	})


	-- spikes, hot -- silicon-based life
	local spike_size = { 1.0, 1.2, 1.4, 1.6, 1.7 }
	mod.hot_spikes = { }

	for i in ipairs(spike_size) do
		if i == 1 then
			nodename = mod_name..':hot_spike'
		else
			nodename = mod_name..':hot_spike_'..i
		end

		table.insert(mod.hot_spikes, nodename)

		vs = spike_size[i]

		minetest.register_node(nodename, {
			description = 'Stone Spike',
			tiles = { 'environ_hot_spike.png' },
			is_ground_content = true,
			groups = { cracky = 3, oddly_breakable_by_hand = 1, surface_hot = 3 },
			damage_per_second = 1,
			sounds = default.node_sound_stone_defaults(),
			paramtype = 'light',
			drawtype = 'plantlike',
			walkable = false,
			light_source = i * 2 + 2,
			buildable_to = true,
			visual_scale = vs,
			selection_box = {
				type = 'fixed',
				fixed = { -0.5*vs, -0.5*vs, -0.5*vs, 0.5*vs, -5/16*vs, 0.5*vs },
			}
		})
	end

	mod.hot_spike = { }
	for i = 1, #mod.hot_spikes do
		mod.hot_spike[mod.hot_spikes[i] ] = i
	end


	--[[
	register_node_and_alias('will_o_wisp_glow', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = { 'will_o_wisp.png' },
		paramtype = 'light',
		sunlight_propagates = true,
		light_source = 8,
		walkable = false,
		diggable = false,
		pointable = false,
		is_ground_content = false,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 30
			if timer then
				timer:set(max, math.random(max - 1))
			end
		end,
		on_timer = function(pos, elapsed)
			--local nod = minetest.get_node_or_nil(pos)
			minetest.set_node(pos, { name = mod_name..':will_o_wisp_dark' })
		end,
	})

	register_node_and_alias('will_o_wisp_dark', {
		description = 'Will-o-wisp',
		drawtype = 'plantlike',
		visual_scale = 0.75,
		tiles = { 'will_o_wisp.png' },
		paramtype = 'light',
		sunlight_propagates = true,
		walkable = false,
		diggable = false,
		pointable = false,
		is_ground_content = false,
		on_construct = function(pos)
			local timer = minetest.get_node_timer(pos)
			local max = 30
			if timer then
				timer:set(max, math.random(max - 1))
			end
		end,
		on_timer = function(pos, elapsed)
			--local nod = minetest.get_node_or_nil(pos)
			minetest.set_node(pos, { name = mod_name..':will_o_wisp_glow' })
		end,
	})

	--mod.add_construct(mod_name..':will_o_wisp_glow')
	--mod.add_construct(mod_name..':will_o_wisp_dark')



	newnode = clone_node('air')
	newnode.drowning = 1
	minetest.register_node(mod_name..':inert_gas', newnode)


	-- kelp-like water plant?
	minetest.register_node(mod_name..':wet_fungus', {
		description = 'Leaves',
		tiles = { 'wet_fungus.png' },
		light_source = 2,
		groups = { snappy = 3 },
		drop = '',
		sounds = default.node_sound_leaves_defaults(),
	})
	--]]
end


do
	-- What's a cave without speleothems?
	local spel = {
		{ stalac = 'stalactite', stalag = 'stalagmite', tile = 'default_stone.png', place_on = { 'default:stone' }, biomes = { 'stone' }, },
		{ stalac = 'stalactite_slimy', stalag = 'stalagmite_slimy', tile = 'default_stone.png^environ_algae.png', light = light_max-6, place_on = { mod_name..':stone_with_algae' }, biomes = { 'algae' }, },
		{ stalac = 'stalactite_mossy', stalag = 'stalagmite_mossy', tile = 'default_stone.png^environ_moss.png', light = light_max-6, place_on = { mod_name..':stone_with_moss' }, biomes = { 'mossy' }, },
		{ stalac = 'stalactite_lichen', stalag = 'stalagmite_lichen', tile = 'default_stone.png^environ_lichen.png', light = light_max-6, place_on = { mod_name..':stone_with_lichen' }, biomes = { 'lichen' }, },
		--{ stalac = 'stalactite_crystal', stalag = 'stalagmite_crystal', tile = 'environ_radioactive_ore', light = light_max },
		{ stalac = 'icicle_down', stalag = 'icicle_up', desc = 'Icicle', tile = 'default_ice.png', drop = 'default:ice', place_on = { 'default:ice' }, biomes = { 'ice', }, },
	}

	for _, desc in pairs(spel) do
		minetest.register_node(mod_name..':'..desc.stalac, {
			description = (desc.desc or 'Stalactite'),
			tiles = { desc.tile },
			is_ground_content = true,
			walkable = false,
			light_source = desc.light,
			paramtype = 'light',
			drop = (desc.drop or mod_name..':stalactite'),
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{ -0.07, 0.0, -0.07, 0.07, 0.5, 0.07 },
				{ -0.04, -0.25, -0.04, 0.04, 0.0, 0.04 },
				{ -0.02, -0.5, -0.02, 0.02, 0.25, 0.02 },
			} },
			groups = { rock = 1, cracky = 3 },
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_node(mod_name..':'..desc.stalag, {
			description = (desc.desc or 'Stalagmite'),
			tiles = { desc.tile },
			is_ground_content = true,
			walkable = false,
			paramtype = 'light',
			light_source = desc.light,
			drop = mod_name..':stalagmite',
			drawtype = 'nodebox',
			node_box = { type = 'fixed',
			fixed = {
				{ -0.07, -0.5, -0.07, 0.07, 0.0, 0.07 },
				{ -0.04, 0.0, -0.04, 0.04, 0.25, 0.04 },
				{ -0.02, 0.25, -0.02, 0.02, 0.5, 0.02 },
			} },
			groups = { rock = 1, cracky = 3 },
			sounds = default.node_sound_stone_defaults(),
		})

		minetest.register_decoration({
			deco_type = 'simple',
			place_on = desc.place_on,
			sidelen = 16,
			fill_ratio = 0.1,
			biomes = desc.biomes,
			decoration = mod_name..':'..desc.stalac,
			name = desc.stalac,
			flags = 'all_ceilings',
		})

		minetest.register_decoration({
			deco_type = 'simple',
			place_on = desc.place_on,
			sidelen = 16,
			fill_ratio = 0.1,
			biomes = desc.biomes,
			decoration = mod_name..':'..desc.stalag,
			name = desc.stalag,
			flags = 'all_floors',
		})
	end
	--[[


	minetest.register_node(mod_name..':bound_spirit', {
		description = 'Tormented Spirit',
		tiles = { 'spirit.png' },
		use_texture_alpha = true,
		light_source = 1,
		paramtype2 = 'facedir',
		walkable = false,
		pointable = false,
		groups = { poison = 1 },
		drawtype = 'plantlike',
	})
	--]]
end
