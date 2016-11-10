slimes = {}
minetest.register_entity("slimes:slime", {
	initial_properties = {
		physical = true,
		collide_with_objects = true,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5}, 
		visual = "mesh",
		mesh = "slime.x",
		--visual_size = {3,3},slime_inside
		textures = {"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},
	},
	
	timer = 0, --timer for state
	state = 0, --0 stand, 1 jump around, 2 attack
	state_change = 0, --when to change state
	
	on_activate = function(self)
		self.object:set_animation({x=10,y=50},7, 0)
		--self.object:set_animation({x=70,y=95},40, 0)
		self.object:setacceleration({x=0,y=-10,z=0})
	end,
	on_step = function(self,dtime)
		slimes.state_change(self,dtime)
		slimes.movement(self)
	end,
})

slimes.state_change = function(self,dtime)
	self.timer = self.timer + dtime
	local vel = self.object:getvelocity()
	
	if self.timer > self.state_change then
		self.state = math.random(0,1)
		self.state_change = math.random(3,9)
		self.timer = 0
		if self.state == 0 then
			self.object:setvelocity({x=0,y=vel.y,z=0})
		elseif self.state == 1 then
			self.object:setyaw((math.random(0, 360) - 180) / 180 * math.pi)
		end
	end
end

slimes.movement = function(self)
	local pos = self.object:getpos()
	local vel = self.object:getvelocity()
	
	
	if self.state == 1 and vel.y == 0 then
		if minetest.registered_items[minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name].walkable then
			local yaw = self.object:getyaw()
			local dir_x = -math.sin(yaw) * 2
			local dir_z = math.cos(yaw) * 2
			self.object:setvelocity({x=dir_x,y=6,z=dir_z})
			
			self.object:set_animation({x=70,y=95},60, 0, false)
			minetest.after(1,function(self)
				self.object:set_animation({x=10,y=50},7, 0)
			end,self)
		end
	end
end
minetest.override_item("default:stick", {
    on_place = function(itemstack, placer, pointed_thing)
		minetest.add_entity(pointed_thing.above,"slimes:slime")
    end,
})
