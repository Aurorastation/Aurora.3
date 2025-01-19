/obj/effect/fusion_particle_catcher
	icon = 'icons/effects/effects.dmi'
	density = TRUE
	anchored = TRUE
	invisibility = 101
	light_color = COLOR_BLUE
	var/obj/effect/fusion_em_field/parent
	var/mysize = 0

/obj/effect/fusion_particle_catcher/Destroy()
	parent.particle_catchers -= src
	parent = null

	. = ..()

/obj/effect/fusion_particle_catcher/proc/SetSize(newsize)
	name = "collector [newsize]"
	mysize = newsize
	UpdateSize()

/obj/effect/fusion_particle_catcher/proc/AddParticles(name, quantity = 1)
	if(parent && parent.size >= mysize)
		parent.AddParticles(name, quantity)
		return 1
	return 0

/obj/effect/fusion_particle_catcher/proc/UpdateSize()
	if(parent.size >= mysize)
		density = TRUE
		name = "collector [mysize] ON"
	else
		density = FALSE
		name = "collector [mysize] OFF"

/obj/effect/fusion_particle_catcher/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	parent.AddEnergy(hitting_projectile.damage)
	update_icon()

/obj/effect/fusion_particle_catcher/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(mover?.movement_type & PHASING)
		return TRUE
	return ismob(mover)

/obj/effect/fusion_particle_catcher/add_point_filter()
	return
