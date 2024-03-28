/particles/cooking_smoke
	width = 256
	height = 256
	count = 250
	spawning = 3	//per tick
	lifespan = 30	//in ticks
	fade = 20
	fadein = 5
	position = generator("box", list(-12,16,0), list(12,-4,50)) //x,y,z bounding box, origin is in the center of the parent
	gravity = list(0.1, 1)
	friction = 0.3 //percentage
	drift = generator("sphere", 0, 1.5)
	icon = 'icons/effects/native_particles.dmi'
	icon_state = "cooking_smoke"

/particles/bar_smoke
	width = 256
	height = 256
	count = 250
	spawning = 1
	lifespan = 60
	fade = 30
	fadein = 10
	position = generator("box", list(-64,16,0), list(64,-16,50))
	gravity = list(-0.05, 0)
	friction = 0.1
	drift = generator("sphere", 0, 0.1)
	icon = 'icons/effects/native_particles.dmi'
	icon_state = "bar_smoke"

/obj/effect/map_effect/particle_emitter
	var/particles/particle_type = /particles/bar_smoke
	invisibility = 0

/obj/effect/map_effect/particle_emitter/Initialize(mapload, ...)
	. = ..()
	particles = new particle_type
	icon = null

/obj/effect/map_effect/particle_emitter/bar_smoke
	particle_type = /particles/bar_smoke
	layer = BELOW_TABLE_LAYER
	alpha = 128
