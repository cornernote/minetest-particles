--[[

Particles for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-particles
License: GPLv3

MAIN LOADER

]]--


-- register dig particle
minetest.register_entity("particles:particle", {
	physical = true,
	collisionbox = {-0.05,-0.05,-0.05,0.05,0.05,0.05},
	timer = 0,
	timer2 = 0,
	on_activate = function(self, staticdata)
		-- Let the entity move random-ish arround
		local obj = self.object
		obj:setacceleration({x=0, y=-5, z=0})
		obj:setvelocity({x=(math.random(0,60)-30)/30, y=(math.random(0,60))/30, z=(math.random(0,60)-30)/30})
		obj:setyaw(math.random(0,359)/180*math.pi)
		self.timer = math.random(0, 6)/3
	end,
	on_step = function(self, dtime)
		-- stop "sliding" on the ground
		self.timer2 = self.timer2+dtime
		if self.timer2 >= 0.5 then
			if self.object:getvelocity().y == 0 then
				self.object:setvelocity({x=0, y=0, z=0})
			end
			self.timer2 = 0
		end
		-- remove after ~3 seconds
		self.timer = self.timer+dtime
		if self.timer >= 3 then
			self.object:remove()
		end
	end,
})

-- register_on_dignode
minetest.register_on_dignode(function(pos, oldnode, digger)
	local node = minetest.registered_nodes[oldnode.name]
	-- if the no_particles group is set dont add particles
	if node == nil or node.groups.no_particles then
		return
	end
	-- try to get the textures from the dig_result instead of the digged node
	local tmp = minetest.get_node_drops(oldnode.name, digger:get_wielded_item():get_name())
	if type(tmp) == "string" then
		node = minetest.registered_nodes[tmp]
	elseif type(tmp) == "table" and tmp[1] and tmp[1].get_name then
		node = minetest.registered_nodes[tmp[1]:get_name()]
	end
	-- if dig result is an item
	if node == nil then
		node = minetest.registered_nodes[oldnode.name]
		-- prevent unwanted effects
		if node == nil then
			return
		end
	end
	-- create this many particles
	for i=1,32 do
		local dx = (math.random(0,10)-5)/10
		local dy = (math.random(0,10)-5)/10
		local dz = (math.random(0,10)-5)/10
		
		-- spawn at random position in the node
		local obj = minetest.env:add_entity({x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}, "particles:particle")
		
		-- set the textures
		local textures = {}
		local max = 1
		for i=1,6 do
			if node.tiles then
				if node.tiles[i] then
					max = i
					textures[i] = node.tiles[i]
				else
					textures[i] = node.tiles[max]
				end
			else -- its a item
				textures[i] = node.inventory_image
			end
		end
		-- set size
		local vis_size= math.random(5,15)/100
		-- set drawtype
		local vis = "cube"
		-- make it upright_sprite if the drawtype of the node is not nodelike
		if node.drawtype and node.drawtype ~= "normal" then
			vis = "upright_sprite"
		end
		obj:set_properties({
			textures = textures,
			visual_size = {x=vis_size, y=vis_size},
			visual = vis,
		})
	end
end)

-- register smoke particle
minetest.register_entity("particles:smoke", {
    physical = true,
	visual_size = {x=0.25, y=0.25},
	collisionbox = {-0.05,-0.05,-0.05,0.05,0.05,0.05},
    visual = "sprite",
    textures = {"smoke_puff.png"},
    on_step = function(self, dtime)
        self.object:setacceleration({x=0, y=0.5, z=0})
        self.timer = self.timer + dtime
        if self.timer > 3 then
            self.object:remove()
        end
    end,
    timer = 0,
})

-- register smoke abm
minetest.register_abm({
	nodenames = {"group:smokes","default:torch"},
	interval = 5,
	chance = 5,
	action = function(pos)
		minetest.env:add_entity({x=pos.x+math.random()*0.5,y=pos.y+0.75,z=pos.z+math.random()*0.5}, "particles:smoke")
	end,
})

-- register signalbubble
minetest.register_entity("particles:signalbubble", {
	physical = true,
	visual_size = {x=0.10, y=0.10},
	collisionbox = {-0.05,-0.05,-0.05,0.05,0.05,0.05},
	visual = "sprite",
	textures = {"particles_signalbubble.png"},
	timer = 0,
	lifetime = 4,
	on_step = function(self, dtime)
		self.timer = self.timer + dtime
		if self.timer > self.lifetime then
			self.object:remove()
		end
	end,
	on_activate = function(self, staticdata)
		self.object:setacceleration({x=0, y=0.05, z=0})
	end,
})

-- register signalbubble abm
minetest.register_abm({
	nodenames = {"group:signalbubbles","mesecons:mesecon_on","mesecons:wall_lever_on","mesecons:mesecon_torch_on"},
	interval = 1,
	chance = 5,
	action = function(pos)
		minetest.env:add_entity({x=pos.x+math.random()*0.5,y=pos.y,z=pos.z+math.random()*0.5}, "particles:signalbubble")
	end,
})

-- log that we started
minetest.log("action", "[MOD]"..minetest.get_current_modname().." -- loaded from "..minetest.get_modpath(minetest.get_current_modname()))