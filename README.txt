----------------------------------
Particles for Minetest
----------------------------------


Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>

Source Code: https://github.com/cornernote/minetest-particles
License: GPLv3


Inspired by Particles by sfan5: http://minetest.net/forum/viewtopic.php?id=1129


----------------------------------
Description
----------------------------------


Creates 3D textured particles after digging nodes. 

The particles scatter in random directions and bounce a little when they hit the ground.



----------------------------------
Modders Guide
----------------------------------


Dig Particles:

Add this line to your mod:

particles.register_dig_particle(node,texture,[params])
- node = the name of the node (your_mod:your_node)
- texture = a png file without the .png extension
- params = (optional) additional params that will be added to the entity table

EG:
create particles of wood after digging a bookshelf:
particles.register_dig_particle("default:bookshelf","default_wood")


Smoke Particles and Signal Bubbles:

Add smokes=1 or signalbubbles=1 to the groups in the node definition.

EG:
minetest.register_node("your_mod:your_item", {
	description = "Your Item",
	groups = {smokes=1},
})



----------------------------------
License
----------------------------------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.



----------------------------------
Credits
----------------------------------

Thank you to the minetest community who has shared their code and knowledge with me.

Special thanks in this mod to:
sfan5 - coded the original particles mod which i stole and made into this one
