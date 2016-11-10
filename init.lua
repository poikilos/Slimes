minetest.register_entity("slimes:slime", {
	initial_properties = {
		physical = false,
		collide_with_objects = false,
		collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5}, 
		visual = "mesh",
		mesh = "slime.x",
		--visual_size = {3,3},slime_inside
		textures = {"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},
		automatic_face_movement_dir = 0.0,
	},
	on_activate = function(self)
		self.object:set_animation({x=10,y=50},7, 0)
		--self.object:set_animation({x=70,y=95},40, 0)
	end,
})


mobs:register_mob("slimes:grass_slime",{
	type = "animal",
	passive = "true",
	visual  = "mesh",
	mesh    = "slime.x",
	textures = {{"slime_outside.png","slime_inside.png","eye_right.png","eye_left.png","mouth.png"},},
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5}, 
	
	makes_footstep_sound = false,
	sounds = green_sounds,
	attack_type = "dogfight",
	attacks_monsters = true,
	damage = 1,
	walk_velocity = 2,
	run_velocity = 3,
	walk_chance = 0,
	jump_chance = 30,
	jump_height = 3,
	armor = 100,
	view_range = 10,
	drops = {
		{name = "mesecons_materials:glue", chance = 4, min = 1, max = 2},
	},
	drawtype = "front",
	water_damage = 0,
	lava_damage = 10,
	light_damage = 0,
	animation = {
		speed_normal = 10,
		speed_run    = 15,
		stand_start  = 10,
		stand_end    = 50,
		walk_start   = 80,
		walk_end     = 95,
	
	}
})





 mobs:spawn({name = "slimes:grass_slime",
       nodes = {"default:dirt_with_grass"},
       max_light = 13,
       min_light = 0,
       interval = 5,
       chance = 1,
    })
