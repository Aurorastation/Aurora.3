/particles
	var/name = "particles"

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

/particles/mist
	name = "mist"
	icon = 'icons/effects/particles.dmi'
	icon_state = list("steam_1" = 1, "steam_2" = 1, "steam_3" = 1)
	count = 500
	spawning = 4
	lifespan = 5 SECONDS
	fade = 1 SECOND
	fadein = 1 SECOND
	velocity = generator("box", list(-0.5, -0.25, 0), list(0.5, 0.25, 0), NORMAL_RAND)
	position = generator("box", list(-20, -16), list(20, -2), UNIFORM_RAND)
	friction = 0.2
	grow = 0.0015

/particles/heat
	name = "heat"
	width = 500
	height = 500
	count = 250
	spawning = 15
	lifespan = 1.85 SECONDS
	fade = 1.25 SECONDS
	position = generator("box", list(-16, -16), list(16, 0), NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_ORANGE)
	color_change = 0.1
	color = 0
	gravity = list(0, 1)
	drift = generator("circle", 0.4, NORMAL_RAND)
	velocity = generator("circle", 0, 3, NORMAL_RAND)


/particles/heat/high
	name = "high heat"
	count = 600
	spawning = 35

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


//Spawner object
//Maybe we could pool them in and out

/obj/particle_emitter
	name = ""
	anchored = TRUE
	mouse_opacity = 0
	appearance_flags = PIXEL_SCALE
	var/particle_type = null


/obj/particle_emitter/Initialize(mapload, time, _color)
	. = ..()
	if (particle_type)
		particles = GLOB.all_particles[particle_type]

	if (time > 0)
		QDEL_IN(src, time)
	color = _color

/obj/particle_emitter/heat
	particle_type = "heat"
	render_target = HEAT_EFFECT_TARGET
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR


/obj/particle_emitter/heat/Initialize()
	. = ..()
	filters += filter(type = "blur", size = 1)

/obj/particle_emitter/heat/high
	particle_type = "high heat"


/obj/particle_emitter/mist
	particle_type = "mist"
	layer = FIRE_LAYER

/obj/particle_emitter/mist/back
	particle_type = "mist_back"
	layer = BELOW_OBJ_LAYER


/obj/particle_emitter/mist/back/gas
	render_target = COLD_EFFECT_BACK_TARGET

/obj/particle_emitter/mist/back/gas/Initialize(mapload, time, _color)
	. = ..()
	filters += filter(type="alpha", render_source = COLD_EFFECT_TARGET, flags = MASK_INVERSE)

//for cold gas effect
/obj/particle_emitter/mist/gas
	render_target = COLD_EFFECT_TARGET
	var/obj/particle_emitter/mist/back/b = /obj/particle_emitter/mist/back/gas

/obj/particle_emitter/mist/gas/Initialize(mapload, time, _color)
	. = ..()
	b = new b(null)
	vis_contents += b
