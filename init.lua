slimes = {}

--big slimes
minetest.register_entity("slimes:slime_big", {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-2.5,-2.5,-2.5, 2.5,2.5,2.5}, 
		visual = "mesh",
		mesh = "slime_big.x",
		--visual_size = {3,3},slime_inside
		textures = {"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},
	},
	slime_size = "big",
	
	timer = 0, --timer for state
	state = 0, --0 stand, 1 jump around, 2 attack
	state_change = 0, --when to change state
	
	on_activate = function(self)
		self.object:set_animation({x=10,y=50},7, 0)
		--self.object:set_animation({x=70,y=95},40, 0)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:set_hp(25)
	end,
	on_step = function(self,dtime)
		slimes.state_change(self,dtime)
		slimes.movement(self)
	end,
	on_punch = function(self)
		slimes.slime_punch(self)
	end,
})

--medium slimes
minetest.register_entity("slimes:slime_medium", {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5}, 
		visual = "mesh",
		mesh = "slime.x",
		--visual_size = {3,3},slime_inside
		textures = {"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},
	},
	slime_size = "medium",
	
	timer = 0, --timer for state
	state = 0, --0 stand, 1 jump around, 2 attack
	state_change = 0, --when to change state
	
	on_activate = function(self)
		self.object:set_animation({x=10,y=50},7, 0)
		--self.object:set_animation({x=70,y=95},40, 0)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:set_hp(10)
	end,
	on_step = function(self,dtime)
		slimes.state_change(self,dtime)
		slimes.movement(self)
	end,
	on_punch = function(self)
		slimes.slime_punch(self)
	end,
})
--small slimes
minetest.register_entity("slimes:slime_small", {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1}, 
		visual = "mesh",
		mesh = "slime_small.x",
		--visual_size = {3,3},slime_inside
		textures = {"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},
	},
	slime_size = "small",
	
	timer = 0, --timer for state
	state = 0, --0 stand, 1 jump around, 2 attack
	state_change = 0, --when to change state
	
	on_activate = function(self)
		self.object:set_animation({x=10,y=50},7, 0)
		--self.object:set_animation({x=70,y=95},40, 0)
		self.object:setacceleration({x=0,y=-10,z=0})
		self.object:set_hp(3)
	end,
	on_step = function(self,dtime)
		slimes.state_change(self,dtime)
		slimes.movement(self)
	end,
	on_punch = function(self)
		slimes.slime_punch(self)
	end,
})

local load_technic_items = false
for _,v in pairs(minetest.get_modnames()) do 
	if v == "technic" then
		load_technic_items = true
		break
	end
end

if load_technic_items == true then
	slimes.slime_drop = {"slimes:beer","slimes:hawaiin_pizza","mesecons_materials:glue"}
	minetest.register_craftitem("slimes:beer", {
		description = "Ice Cold Beer",
		inventory_image = "beer.png",
		on_use = minetest.item_eat(20),
	})
	minetest.register_craftitem("slimes:hawaiin_pizza", {
		description = "Delicious Hawaiin Pizza",
		inventory_image = "hawaiin_pizza.png",
		on_use = minetest.item_eat(20),
	})	
else
	slimes.slime_drop = {"default:sapling", "default:dirt_with_grass"}
end

--when a slime is punched
slimes.slime_punch = function(self)
	local hp = self.object:get_hp()
	local size_check = 0
	local pos = self.object:getpos()
	if self.slime_size == "big" then
		size_check = 3
	elseif self.slime_size == "medium" then
		size_check = 0.5
	elseif self.slime_size == "small" then
		size_check = 0.1
	end
	minetest.sound_play("slime_hit", {
		max_hear_distance = 20,
		gain = 10.0,
		object = self.object,
	})
	--die
	if hp <= 0 then
		minetest.add_particlespawner({
			amount = 80,
			time = 0.1,
			minpos = {x=pos.x-(size_check), y=pos.y-(size_check), z=pos.z-(size_check)},
			maxpos = {x=pos.x+(size_check), y=pos.y+(size_check), z=pos.z+(size_check)},
			minvel = {x=-5, y=-5, z=-5},
			maxvel = {x=5, y=5, z=5},
			minacc = {x=0, y=-10, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 1,
			maxexptime = 1,
			minsize = size_check*2,
			maxsize = size_check,
			collisiondetection = true,
			vertical = false,
			texture = "slime_particles.png",
		})
		slimes.slime_duplicate(self)
		if self.slime_size == "small" then
			minetest.add_item(pos,slimes.slime_drop[math.random(1,table.getn(slimes.slime_drop))])
		end
	--hurt
	else
		minetest.add_particlespawner({
			amount = 40,
			time = 0.1,
			minpos = {x=pos.x-(size_check), y=pos.y-(size_check), z=pos.z-(size_check)},
			maxpos = {x=pos.x+(size_check), y=pos.y+(size_check), z=pos.z+(size_check)},
			minvel = {x=-2, y=-2, z=-2},
			maxvel = {x=2, y=2, z=2},
			minacc = {x=0, y=-10, z=0},
			maxacc = {x=0, y=-10, z=0},
			minexptime = 1,
			maxexptime = 1,
			minsize = size_check*2,
			maxsize = size_check,
			collisiondetection = true,
			vertical = false,
			texture = "slime_particles.png",
		})
	end
	
end


--the state timer for slimes
slimes.state_change = function(self,dtime)
	self.timer = self.timer + dtime
	local vel = self.object:getvelocity()
	
	if self.timer > self.state_change then
		self.state = math.random(0,1)
		self.state_change = math.random(3,9)
		self.timer = 0
		
		if self.state == 1 then
			self.object:setyaw((math.random(0, 360) - 180) / 180 * math.pi)
		end
	end
end

--how slimes check to move around
slimes.movement = function(self)
	local pos = self.object:getpos()
	local vel = self.object:getvelocity()
	
	local y_check = 0
	if self.slime_size == "big" then
		y_check = 3
	elseif self.slime_size == "medium" then
		y_check = 1
	elseif self.slime_size == "small" then
		y_check = 0.2
	end

	--standing still
	if self.state == 0 and vel.y <= 0 then
		if vel.y == 0 then
			self.object:setvelocity({x=0,y=vel.y,z=0})
		end
	end
	--jumping around
	if self.state == 1 and vel.y <= 0.5 then
		if vel.y == 0 then
			--check for node below before jumping
			if minetest.registered_items[minetest.get_node({x=pos.x,y=pos.y-y_check,z=pos.z}).name].walkable then
				slimes.jump(self,pos)
			end
		end
	end
end

--how a slime moves around
slimes.jump = function(self,pos)
	local y_check = 0
	local jump_height = 0
	if self.slime_size == "big" then
		y_check = 3
		jump_height = 16
	elseif self.slime_size == "medium" then
		y_check = 1
		jump_height = 6
	elseif self.slime_size == "small" then
		y_check = 0.2
		jump_height = 6
	end
	
	minetest.add_particlespawner({
		amount = y_check*25, -- this only works for mobs dividing by 5 on size
		time = 0.1,
		minpos = {x=pos.x-(y_check/2), y=pos.y-(y_check/2), z=pos.z-(y_check/2)},
		maxpos = {x=pos.x+(y_check/2), y=pos.y-(y_check/2), z=pos.z+(y_check/2)},
		minvel = {x=0, y=1, z=0},
		maxvel = {x=0, y=2, z=0},
		minacc = {x=0, y=-10, z=0},
		maxacc = {x=0, y=-10, z=0},
		minexptime = 1,
		maxexptime = 1,
		minsize = y_check*2,
		maxsize = y_check,
		collisiondetection = true,
		vertical = false,
		texture = "slime_particles.png",
	})
	local yaw = self.object:getyaw()
	local dir_x = -math.sin(yaw) * (y_check*2)
	local dir_z = math.cos(yaw) * (y_check*2)
	self.object:setvelocity({x=dir_x,y=jump_height,z=dir_z})
	
	self.object:set_animation({x=70,y=95},60, 0, false)
	--a hack to make slimes animated correctly
	minetest.after(1,function(self)
		self.object:set_animation({x=10,y=50},7, 0)
	end,self)
	minetest.sound_play("slime_jump", {
		max_hear_distance = 6,
		gain = 1.0,
		object = self.object,
	})
end

--add smaller slimes on die
slimes.slime_duplicate = function(self)
	local pos = self.object:getpos()

	if self.slime_size == "big" then
		for i = 1,math.random(4,8) do
			minetest.add_entity({x=pos.x-math.random(-2.5,2.5),y=pos.y,z=pos.z-math.random(-2.5,2.5)}, "slimes:slime_medium")
		end
	elseif self.slime_size == "medium" then
		for i = 1,math.random(6,16) do
			minetest.add_entity({x=pos.x-math.random(-0.5,0.5),y=pos.y,z=pos.z-math.random(-0.5,0.5)}, "slimes:slime_small")
		end
	end
end

minetest.override_item("default:stick", {
    on_place = function(itemstack, placer, pointed_thing)
		pointed_thing.above.y = pointed_thing.above.y + 2.5
		minetest.add_entity(pointed_thing.above,"slimes:slime_big")
    end,
})
