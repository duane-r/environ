-- Environ leaf_decay.lua

-- This section is modified from the minetest code,
--  because the original is poorly contrived.

-- GNU Lesser General Public License, version 2.1
-- Copyright (C) 2011-2018 celeron55, Perttu Ahola <celeron55@gmail.com>
-- Copyright (C) 2011-2018 Various Minetest developers and contributors


local mod = environ


do
	--
	-- Leafdecay
	--

	-- Prevent decay of placed leaves

	mod.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
		if placer and placer:is_player() and not placer:get_player_control().sneak then
			local node = minetest.get_node(pos)
			node.param2 = 1
			minetest.set_node(pos, node)
		end
	end

	-- Leafdecay
	local function leafdecay_after_destruct(pos, oldnode, def)
		for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, def.radius),
				vector.add(pos, def.radius), def.leaves)) do
			local node = minetest.get_node(v)
			local timer = minetest.get_node_timer(v)
			------------------------------------
			-- This check fails on my mapgen, because the code
			--  that places schematics rotates their nodes
			--  properly, unlike the game.
			------------------------------------
			--if node.param2 == 0 and not timer:is_started() then
			if node.param2 < 4 and not timer:is_started() then
				timer:start(math.random(20, 120) / 10)
			end
			------------------------------------
		end
	end

	local function leafdecay_on_timer(pos, def)
		if minetest.find_node_near(pos, def.radius, def.trunks) then
			return false
		end

		local node = minetest.get_node(pos)
		local drops = minetest.get_node_drops(node.name)
		for _, item in ipairs(drops) do
			local is_leaf
			for _, v in pairs(def.leaves) do
				if v == item then
					is_leaf = true
				end
			end
			if minetest.get_item_group(item, "leafdecay_drop") ~= 0 or
					not is_leaf then
				minetest.add_item({
					x = pos.x - 0.5 + math.random(),
					y = pos.y - 0.5 + math.random(),
					z = pos.z - 0.5 + math.random(),
				}, item)
			end
		end

		minetest.remove_node(pos)
		minetest.check_for_falling(pos)
	end

	function mod.register_leafdecay(def)
		assert(def.leaves)
		assert(def.trunks)
		assert(def.radius)
		for _, v in pairs(def.trunks) do
			minetest.override_item(v, {
				after_destruct = function(pos, oldnode)
					leafdecay_after_destruct(pos, oldnode, def)
				end,
			})
		end
		for _, v in pairs(def.leaves) do
			minetest.override_item(v, {
				on_timer = function(pos)
					leafdecay_on_timer(pos, def)
				end,
			})
		end
	end
end
