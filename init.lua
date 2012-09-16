--[[

Particles for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-particles
License: GPLv3

MAIN LOADER

]]--

-- load api
dofile(minetest.get_modpath("particles").."/api.lua")

-- register register files for mods
dofile(minetest.get_modpath("particles").."/mod_default.lua")
if minetest.get_modpath("mesecons") ~= nil then
	dofile(minetest.get_modpath("particles").."/mod_mesecons.lua")
end

-- register_on_dignode
minetest.register_on_dignode(function(pos, oldnode, digger)
	particles.on_dignode(pos, oldnode, digger)
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
