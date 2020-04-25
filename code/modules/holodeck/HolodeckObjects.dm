// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/set_flooring()
	return

/turf/simulated/floor/holofloor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet
	footstep_sound = "carpet"

/turf/simulated/floor/holofloor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/holofloor/tiled/ramp
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "ramptop"
	initial_flooring = /decl/flooring/reinforced/ramp

/turf/simulated/floor/holofloor/tiled/ramp/bottom
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "rampbot"
	initial_flooring = /decl/flooring/reinforced/ramp/bottom

/turf/simulated/floor/holofloor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/holofloor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino_grey"
	initial_flooring = /decl/flooring/linoleum/grey

/turf/simulated/floor/holofloor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass
	footstep_sound = "grassstep"

/turf/simulated/floor/holofloor/snow
	name = "snow"
	base_name = "snow"
	icon = 'icons/turf/floors.dmi'
	base_icon = 'icons/turf/floors.dmi'
	icon_state = "snow"
	base_icon_state = "snow"
	footstep_sound = "gravelstep"

/turf/simulated/floor/holofloor/reinforced
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /decl/flooring/reinforced
	name = "reinforced holofloor"
	icon_state = "reinforced"
	footstep_sound = "concretestep"

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"
	footstep_sound = null
	plane = PLANE_SPACE_BACKGROUND
	dynamic_lighting = 0

/turf/simulated/floor/holofloor/space/Initialize()
	. = ..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
	var/image/I = image('icons/turf/space_parallax1.dmi',"[icon_state]")
	I.plane = PLANE_SPACE_DUST
	I.alpha = 80
	I.blend_mode = BLEND_ADD
	add_overlay(I)

/turf/simulated/floor/holofloor/beach
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	base_icon = 'icons/misc/beach.dmi'
	initial_flooring = null
	footstep_sound = "sand"

/turf/simulated/floor/holofloor/beach/sand
	name = "sand"

/turf/simulated/floor/holofloor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	base_icon_state = "sandwater"
	footstep_sound = "water"

/turf/simulated/floor/holofloor/beach/water
	name = "water"
	icon_state = "seashallow"
	base_icon_state = "seashallow"
	footstep_sound = "water"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	base_name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	base_desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"
	base_icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	initial_flooring = null
	footstep_sound = "sand"

/turf/simulated/floor/holofloor/desert/Initialize()
	. = ..()
	if(prob(10))
		add_overlay("asteroid[rand(0,9)]")

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_preview"
	anchored = 1.0

/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/window/reinforced/holowindow/Destroy()
	return ..()

/obj/structure/window/reinforced/holowindow/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting,/mob/living))
			grab_smash_attack(G, PAIN)
			return

	if(W.flags & NOBLUDGEON) return

	if(W.isscrewdriver())
		to_chat(user, ("<span class='notice'>It's a holowindow, you can't unfasten it!</span>"))
	else if(W.iscrowbar() && reinf && state <= 1)
		to_chat(user, ("<span class='notice'>It's a holowindow, you can't pry it!</span>"))
	else if(W.iswrench() && !anchored && (!state || !reinf))
		to_chat(user, ("<span class='notice'>It's a holowindow, you can't dismantle it!</span>"))
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force)
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/glass_hit.ogg', 75, 1)
		..()
	return

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)
	return

/obj/structure/window/reinforced/holowindow/disappearing/Destroy()
	return ..()

/obj/machinery/door/window/holowindoor/Destroy()
	return ..()

/obj/machinery/door/window/holowindoor/attackby(obj/item/I as obj, mob/user as mob)

	if (src.operating == 1)
		return

	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
		visible_message("<span class='danger'>[src] was hit by [I].</span>")
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick(text("[]deny", src.base_state), src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.density = 0
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/Destroy()
	return ..()

/obj/structure/bed/chair/holochair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswrench())
		to_chat(user, ("<span class='notice'>It's a holochair, you can't dismantle it!</span>"))
	return

/obj/item/holo
	damtype = PAIN
	no_attack_log = 1

/obj/item/holo/esword
	desc = "May the force be within you. Sorta."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	flags = NOBLOODY
	var/active = 0
	var/item_color

/obj/item/holo/esword/green
	New()
		item_color = "green"

/obj/item/holo/esword/red
	New()
		item_color = "red"

/obj/item/holo/esword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		spark(user.loc, 5)
		playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
		return 1
	return 0

/obj/item/holo/esword/New()
	item_color = pick("red","blue","green","purple")

/obj/item/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] is now active.</span>")
	else
		force = 3
		icon_state = "sword0"
		w_class = 2
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

//BASKETBALL OBJECTS

/obj/item/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets
	drop_sound = 'sound/items/drop/basketball.ogg'

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1

/obj/structure/holohoop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(G.state<2)
			to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
			return
		G.affecting.forceMove(src.loc)
		G.affecting.Weaken(5)
		visible_message("<span class='warning'>[G.assailant] dunks [G.affecting] into the [src]!</span>", range = 3)
		qdel(W)
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_from_inventory(W,get_turf(src))
		visible_message("<span class='notice'>[user] dunks [W] into the [src]!</span>", range = 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.forceMove(src.loc)
			visible_message("<span class='notice'>Swish! \the [I] lands in \the [src].</span>", range = 3)
		else
			visible_message("<span class='warning'>\The [I] bounces off of \the [src]'s rim!</span>", range = 3)
		return 0
	else
		return ..(mover, target, height, air_group)


/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 0 // reason is because the holodeck already takes power so this can be powered as a result.

/obj/machinery/readybutton/attack_ai(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/attackby(obj/item/W as obj, mob/user as mob)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/attack_hand(mob/user as mob)

	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return

	if(!user.IsAdvancedToolUser())
		return 0

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(usr, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

//Holocarp

/mob/living/simple_animal/hostile/carp/holodeck
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null
	light_range = 2

/mob/living/simple_animal/hostile/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		faction = "neutral"
		melee_damage_lower = 0
		melee_damage_upper = 0
		environment_smash = 0
		destroy_surroundings = 0
	else
		faction = "carp"
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)
		environment_smash = initial(environment_smash)
		destroy_surroundings = initial(destroy_surroundings)

/mob/living/simple_animal/hostile/carp/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_animal/hostile/carp/holodeck/death()
	..()
	derez()

/mob/living/simple_animal/hostile/carp/holodeck/proc/derez()
	visible_message("<span class='notice'>\The [src] fades away!</span>")
	qdel(src)

//Holo-penguin

/mob/living/simple_animal/penguin/holodeck
	icon = 'icons/mob/npc/penguins.dmi'
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	icon_gib = null
	meat_amount = 0
	meat_type = null
	light_range = 2
	hunger_enabled = FALSE

/mob/living/simple_animal/penguin/holodeck/baby
	icon_state = "penguin_baby"
	icon_living = "penguin_baby"
	icon_dead = "penguin_baby_dead"

/mob/living/simple_animal/penguin/holodeck/emperor
	name = "emperor penguin"
	desc = "Emperor of all he surveys."

/mob/living/simple_animal/penguin/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_animal/penguin/holodeck/death()
	..()
	derez()

/mob/living/simple_animal/penguin/holodeck/proc/derez()
	visible_message("<span class='notice'>\The [src] fades away!</span>")
	qdel(src)
