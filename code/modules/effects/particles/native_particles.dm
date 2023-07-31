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
