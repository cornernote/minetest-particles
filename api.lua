--[[

Particles for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-particles
License: GPLv3

API

]]--

-- expose api
particles = {}

-- dig_particles
particles.dig_particles = 8

-- registered_dig_particles
particles.registered_dig_particles = {nodes={},textures={}}

-- register_dig_particle
particles.register_dig_particle = function(node,texture,params)
	particles.registered_dig_particles.nodes[node] = texture
	if particles.registered_dig_particles.textures[texture] ~= nil then
		return
	end
	particles.registered_dig_particles.textures[texture] = true
	local entity = {}
	entity.visual = "cube"
	entity.physical = true
	entity.collisionbox = {-0.01,-0.01,-0.01,0.01,0.01,0.01}
	entity.textures = {texture..".png",texture..".png",texture..".png",texture..".png",texture..".png",texture..".png"}
	for i=1,particles.dig_particles do
		local size = math.random(11,17)/100
		entity.visual_size = {x=size, y=size}
		entity.timer = math.random(100,150)/100
		entity.bounce = math.random(50,70)/100
		entity.on_step = function(self, dtime)
			self.timer = self.timer - dtime
			if self.timer < 0 then
				self.object:remove()
			end
			if self.timer < self.bounce then
				self.bounce = 0
				self.object:setvelocity({x=math.random()/10,y=math.random()+1,z=math.random()/10})
			end
		end
		entity.on_activate = function(self, staticdata)
			self.object:setacceleration({x=0, y=-7-(math.random()*2), z=0})
		end
		if params~=nil then for k,v in pairs(params) do
			entity[k]=v
		end end
		minetest.register_entity("particles:"..texture..i, entity)
	end
end

-- on_dignode
particles.on_dignode = function(pos, oldnode, digger)
	if not particles.registered_dig_particles.nodes[oldnode.name] then
		return
	end
	local location = {}
	local node = ""
	for i=1,particles.dig_particles do
		location.pos = {
			x = pos.x+1-(math.random()*1.5),
			y = pos.y+math.random()/2,
			z = pos.z+1-(math.random()*1.5)
		}
		location.vel = {
			x = math.random(-100,100)/100,
			y = math.random()*2,
			z = math.random(-100,100)/100
		}
		node = "particles:"..particles.registered_dig_particles.nodes[oldnode.name]..i
		e = minetest.env:add_entity(location.pos, node)
		e:setvelocity(location.vel)
		e:setyaw(math.rad(math.random(1,360)))
	end
end
