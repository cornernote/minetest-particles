----------------------------------
Particles for Minetest
----------------------------------

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-particles
Home Page: https://sites.google.com/site/cornernote/minetest/particles

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


----------------------------------
Description
----------------------------------

Creates 3D textured particles that scatter in random directions after digging nodes. 


----------------------------------
Modders Guide
----------------------------------

No Dig Particles:

Add no_particles=1 to the groups in the node definition.

EG:
minetest.register_node("your_mod:your_item", {
	description = "Your Item",
	groups = {no_particles=1},
})

Smoke Particles and Signal Bubbles:

Add smokes=1 or signalbubbles=1 to the groups in the node definition.

EG:
minetest.register_node("your_mod:your_item", {
	description = "Your Item",
	groups = {smokes=1},
})


----------------------------------
Credits
----------------------------------

sfan5 - coded the original particles mod which i stole and made into this one - http://minetest.net/forum/viewtopic.php?id=1129
