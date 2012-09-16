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
particles.dig_particles = 64

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
	entity.collisionbox = {-0.05,-0.05,-0.05,0.05,0.05,0.05}
	entity.textures = {texture..".png",texture..".png",texture..".png",texture..".png",texture..".png",texture..".png"}
	for i=1,particles.dig_particles do
		local size = math.random(5,9)/100
		entity.visual_size = {x=size, y=size}
		entity.timer = math.random(200,250)/100
		entity.lastpos = nil
		entity.bounced = 0
		entity.on_step = function(self, dtime)
			self.timer = self.timer - dtime
			if self.timer < 0 then
				self.object:remove()
			end
			local pos = self.object:getpos()
			if self.bounced < 2 and self.lastpos and self.lastpos.y == pos.y then
				if self.bounced==2 then
					self.object:remove()
				elseif self.bounced==1 then
					self.object:setvelocity({x=0,y=math.random()+1,z=0})
				else
					local vel = self.object:getvelocity()
					self.object:setvelocity({x=vel.x/2,y=math.random(),z=vel.z/2})
				end
				self.bounced = self.bounced+1
			end
			self.lastpos = pos
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
			x = math.random(-300,300)/100,
			y = math.random(100,500)/100,
			z = math.random(-300,300)/100
		}
		node = "particles:"..particles.registered_dig_particles.nodes[oldnode.name]..i
		e = minetest.env:add_entity(location.pos, node)
		e:setvelocity(location.vel)
		e:setyaw(math.rad(math.random(1,360)))
	end
end
