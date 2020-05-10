/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "shaft miner locker"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/fill()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/shovel(src)
	new /obj/item/pickaxe(src)
	new /obj/item/gun/custom_ka/frame01/prebuilt(src)
	new /obj/item/ore_radar(src)
	new /obj/item/key/minecarts(src)
	new /obj/item/device/gps/mining(src)
	new /obj/item/book/manual/ka_custom(src)
	new /obj/item/clothing/accessory/storage/overalls/mining(src)

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	desc = "A mining lantern."
	icon_state = "lantern"
	item_state = "lantern"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_mining.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_mining.dmi',
		)
	light_power = 1
	brightness_on = 6
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/*****************************Pickaxe********************************/

/obj/item/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining implements. Surely this is a joke?"
	icon = 'icons/obj/tools.dmi'
	icon_state = "pickaxe"
	item_state = "pickaxe"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_mining.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_mining.dmi',
		)
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 4.0
	force = 10.0
	w_class = 4.0
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/digspeed //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = "pickaxe"
	var/drill_verb = "excavating"
	var/autodrill = 0 //pickaxes must be manually swung to mine, drills can mine rocks via bump
	sharp = TRUE

	var/can_wield = TRUE

	var/excavation_amount = 40
	var/wielded = FALSE
	var/force_unwielded = 5.0
	var/force_wielded = 15.0
	var/digspeed_unwielded = 30
	var/digspeed_wielded = 5
	var/drilling = FALSE

	action_button_name = "Wield pick/drill"

/obj/item/pickaxe/proc/unwield()
	wielded = FALSE
	force = force_unwielded
	digspeed = digspeed_unwielded
	name = initial(name)
	update_icon()

/obj/item/pickaxe/proc/wield()
	wielded = TRUE
	force = force_wielded
	digspeed = digspeed_wielded
	update_icon()

/obj/item/pickaxe/update_icon()
	..()
	if(wielded)
		item_state = "[initial(icon_state)]-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/pickaxe/mob_can_equip(M, slot)
	//Cannot equip wielded items.
	if(wielded)
		to_chat(M, SPAN_WARNING("Unwield the [initial(name)] first!"))
		return FALSE

	return ..()

/obj/item/pickaxe/dropped(mob/user)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/pickaxe/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return unwield()

/obj/item/pickaxe/pickup(mob/user)
	..()
	unwield()

/obj/item/pickaxe/attack_self(mob/user)
	..()

	if(!can_wield)
		return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(issmall(H))
			to_chat(user, SPAN_WARNING("It's too heavy for you to wield fully."))
			return
	else
		return

	if(!istype(user.get_active_hand(), src))
		to_chat(user, SPAN_WARNING("You need to be holding \the [src] in your active hand."))
		return

	if(wielded) //Trying to unwield it
		unwield()
		to_chat(user, SPAN_NOTICE("You are now carrying \the [src] with one hand."))

		var/obj/item/pickaxe/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()

	else //Trying to wield it
		if(user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("Your other hand needs to be empty."))
			return
		wield()
		to_chat(user, SPAN_NOTICE("You grab \the [src] with both hands."))

		var/obj/item/pickaxe/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]."
		user.put_in_inactive_hand(O)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	return

/obj/item/pickaxe/ui_action_click()
	if(src in usr)
		attack_self(usr)

/obj/item/pickaxe/verb/wield_pick()
	if(can_wield)
		set name = "Wield pick/drill"
		set category = "Object"
		set src in usr

		attack_self(usr)

/obj/item/pickaxe/offhand
	w_class = 5
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	item_state = null
	name = "offhand"
	simulated = FALSE

	action_button_name = null

/obj/item/pickaxe/proc/copy_stats(obj/item/pickaxe/parent)
	digspeed_wielded = parent.digspeed_wielded
	excavation_amount = parent.excavation_amount
	force = parent.force_wielded

/obj/item/pickaxe/offhand/unwield()
	if(ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/pickaxe/offhand/wield()
	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/pickaxe/hammer
	name = "sledgehammer"
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."
	icon_state = "sledgehammer"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"

/obj/item/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	origin_tech = list(TECH_MATERIAL = 3)
	desc = "This makes no metallurgic sense."
	excavation_amount = 50

	digspeed_unwielded = 30
	digspeed_wielded = 5

/obj/item/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "miningdrill"
	item_state = "miningdrill"
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	digspeed = 10
	digspeed_unwielded = 15
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = FALSE
	force = 15.0

	action_button_name = null

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"
	autodrill = TRUE
	drill_sound = 'sound/weapons/sonic_jackhammer.ogg'
	digspeed = 5
	digspeed_unwielded = 10
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = FALSE
	force = 25.0

	action_button_name = null

/obj/item/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 4)
	desc = "This makes no metallurgic sense."
	excavation_amount = 40

	digspeed_unwielded = 30
	digspeed_wielded = 5

/obj/item/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head."
	excavation_amount = 50
	autodrill = TRUE
	digspeed_unwielded = 10
	digspeed_wielded = 1
	force_wielded = 25.0

/obj/item/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "diamonddrill"
	digspeed = 3 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	excavation_amount = 100

	can_wield = 0
	force = 20.0
	digspeed = 2
	digspeed_unwielded = 3
	force_unwielded = 20.0

	action_button_name = null

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 10
	digspeed_unwielded = 10
	force_unwielded = 25.0
	desc = ""
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	can_wield = FALSE
	force = 15.0
	excavation_amount = 100

	action_button_name = null

/*****************************Shovel********************************/

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_mining.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_mining.dmi',
		)
	icon_state = "shovel"
	item_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	w_class = 3.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = FALSE
	edge = TRUE

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	icon_state = "spade"
	item_state = "spade"
	force = 5.0
	throwforce = 7.0
	w_class = 2.0

// Flags.

/obj/item/stack/flag
	name = "beacons"
	desc = "A stack of light emitting beacons."
	singular_name = "flag"
	amount = 25
	max_amount = 25
	w_class = 2
	icon = 'icons/obj/mining.dmi'
	var/upright = FALSE
	var/base_state

	light_color = LIGHT_COLOR_TUNGSTEN
	light_power = 1.8

/obj/item/stack/flag/Initialize()
	. = ..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "red beacons"
	singular_name = "red beacon"
	icon_state = "redflag"
	light_color = LIGHT_COLOR_RED

/obj/item/stack/flag/red/planted
	name = "red beacon"
	icon_state = "redflag_open"
	amount = 1
	upright = TRUE
	anchored = TRUE

/obj/item/stack/flag/red/planted/Initialize()
	..()
	base_state = "redflag"
	set_light(2)

/obj/item/stack/flag/yellow
	name = "yellow beacons"
	singular_name = "yellow beacon"
	icon_state = "yellowflag"
	light_color = LIGHT_COLOR_YELLOW

/obj/item/stack/flag/green
	name = "green beacons"
	singular_name = "green beacon"
	icon_state = "greenflag"
	light_color = LIGHT_COLOR_GREEN

/obj/item/stack/flag/purple
	name = "purple beacons"
	singular_name = "purple beacon"
	icon_state = "purpflag"
	light_color = LIGHT_COLOR_PURPLE

/obj/item/stack/flag/attackby(obj/item/W, mob/user)
	if(upright && istype(W, src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user)
	if(upright)
		upright = FALSE
		icon_state = base_state
		anchored = FALSE
		set_light(0)
		src.visible_message(SPAN_NOTICE("<b>[user]</b> turns \the [src] off."))
	else
		..()

/obj/item/stack/flag/attack_self(mob/user)
	var/obj/item/stack/flag/F = locate() in get_turf(src)

	var/turf/T = get_turf(src)
	if(!T || !istype(T, /turf/unsimulated/floor/asteroid))
		to_chat(user, SPAN_WARNING("The beacon won't stand up in this terrain."))
		return

	if(F?.upright)
		to_chat(user, SPAN_WARNING("There is already a beacon here."))
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = TRUE
	newflag.anchored = TRUE
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message(SPAN_NOTICE("<b>[user]</b> plants \the [newflag] firmly in the ground."))
	newflag.set_light(2)
	src.use(1)

/**********************Miner Carts***********************/

// RRF refactored into RFD-M, found in RFD.dm

/obj/structure/track
	name = "mine track"
	desc = "Just like your grandpappy used to lay 'em in 1862."
	icon = 'icons/obj/smoothtrack.dmi'
	icon_state = "track15"
	density = FALSE
	anchored = TRUE
	w_class = 3
	layer = 2.44

/obj/structure/track/Initialize()
	. = ..()
	var/obj/structure/track/track = locate() in get_turf(src)
	if(track && track != src)
		qdel(src)
		return
	updateOverlays()
	for(var/dir in cardinal)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()

/obj/structure/track/Destroy()
	for(var/dir in cardinal)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()
	return ..()

/obj/structure/track/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/track/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user)
		return
	if(C.iswelder())
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_NOTICE("You slice apart the track."))
			new /obj/item/stack/rods(get_turf(src))
			qdel(src)
	return

/obj/structure/track/proc/updateOverlays()
	set waitfor = FALSE
	overlays = list()

	var/dir_sum = 0

	for(var/direction in cardinal)
		if(locate(/obj/structure/track, get_step(src, direction)))
			dir_sum += direction

	icon_state = "track[dir_sum]"
	return

/obj/vehicle/train/cargo/engine/mining
	name = "mine cart engine"
	desc = "A ridable electric minecart designed for pulling other mine carts."
	icon = 'icons/obj/cart.dmi'
	icon_state = "mining_engine"
	on = FALSE
	powered = TRUE
	move_delay = -1

	load_item_visible = TRUE
	load_offset_x = 0
	mob_offset_y = 15
	active_engines = 1

	light_power = 1
	light_range = 6
	light_wedge = LIGHT_WIDE
	light_color = LIGHT_COLOR_FIRE

/obj/vehicle/train/cargo/engine/mining/Initialize()
	. = ..()
	cell = new /obj/item/cell/high(src)
	key = null
	var/image/I = new(icon = 'icons/obj/cart.dmi', icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	turn_off() //so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/mining/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/key/minecarts))
		if(!key)
			user.drop_from_inventory(W, src)
			key = W
			verbs += /obj/vehicle/train/cargo/engine/verb/remove_key
		return
	..()

/obj/vehicle/train/cargo/engine/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/vehicle/train/cargo/engine/mining/update_car(var/train_length, var/active_engines)
	return

/obj/vehicle/train/cargo/trolley/mining
	name = "mine-cart"
	desc = "A modern day twist to an ancient classic."
	icon = 'icons/obj/cart.dmi'
	icon_state = "mining_trailer"
	anchored = FALSE
	passenger_allowed = FALSE
	move_delay = -1

	load_item_visible = TRUE
	load_offset_x = 1
	load_offset_y = 15
	mob_offset_y = 16

	light_power = 1
	light_range = 3
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/obj/vehicle/train/cargo/trolley/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/item/key/minecarts
	name = "key"
	desc = "A keyring with a small steel key, and a pickaxe shaped fob."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mine_keys"
	w_class = ITEMSIZE_TINY

/**********************Pinpointer**********************/

/obj/item/ore_radar
	name = "scanner pad"
	desc = "An antiquated device that can detect ore in a wide radius around the user."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/turf/simulated/mineral/random/sonar
	var/active = 0


/obj/item/ore_radar/attack_self(mob/user)
	if(!active)
		active = TRUE
		to_chat(user, SPAN_NOTICE("You activate the pinpointer."))
		START_PROCESSING(SSfast_process, src)
	else
		active = FALSE
		icon_state = "pinoff"
		to_chat(user, SPAN_NOTICE("You deactivate the pinpointer."))
		STOP_PROCESSING(SSfast_process, src)

/obj/item/ore_radar/process()
	if(active)
		workdisk()
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/ore_radar/proc/workdisk()
	if(!src.loc)
		active = FALSE

	if(!active)
		return

	var/closest = 15

	for(var/turf/simulated/mineral/random/R in orange(14, loc))
		if(!R.mineral)
			continue
		var/dist = get_dist(loc, R)
		if(dist < closest)
			closest = dist
			sonar = R

	if(!sonar)
		icon_state = "pinonnull"
		return
	set_dir(get_dir(loc,sonar))
	switch(get_dist(loc,sonar))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/**********************Jaunter**********************/

/obj/item/device/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated warp technology. The wormholes it creates are unpleasant to travel through, to say the least."
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "jaunter"
	item_state = "jaunter"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 2, TECH_PHORON = 4, TECH_ENGINEERING = 4)

/obj/item/device/wormhole_jaunter/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] activates \the [src]!"))
	feedback_add_details("jaunter", "U") // user activated
	activate(user)

/obj/item/device/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(user)
	if(!device_turf || device_turf.z == 0)
		to_chat(user, SPAN_NOTICE("You're having difficulties getting \the [src] to work."))
		return FALSE
	return TRUE

/obj/item/device/wormhole_jaunter/proc/get_destinations(mob/user)
	var/list/destinations = list()

	for(var/obj/item/device/radio/beacon/B in teleportbeacons)
		var/turf/T = get_turf(B)
		if(isStationLevel(T.z))
			destinations += B

	return destinations

/obj/item/device/wormhole_jaunter/proc/activate(mob/user)
	if(!turf_check(user))
		return

	var/list/L = get_destinations(user)
	if(!length(L))
		to_chat(user, SPAN_NOTICE("\The [src] found no beacons in the world to anchor a wormhole to."))
		return
	var/chosen_beacon = pick(L)
	var/obj/effect/portal/wormhole/jaunt_tunnel/J = new /obj/effect/portal/wormhole/jaunt_tunnel(get_turf(src), chosen_beacon, lifespan = 100)
	J.target = chosen_beacon
	playsound(src,'sound/effects/sparks4.ogg', 50, 1)
	qdel(src)

/obj/item/device/wormhole_jaunter/emp_act(power)
	var/triggered = FALSE
	if(power == 1)
		triggered = TRUE
	else if(power == 2 && prob(50))
		triggered = TRUE

	if(triggered)
		usr.visible_message(SPAN_WARNING("\The [src] overloads and activates!"))
		feedback_add_details("jaunter", "E") // EMP accidental activation
		activate(usr)

/obj/effect/portal/wormhole/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."

/obj/effect/portal/wormhole/jaunt_tunnel/teleport(atom/movable/M)
	if(M.anchored || istype(M, /obj/effect))
		return
	single_spark(get_turf(M))
	if(istype(M))
		if(do_teleport(M, target, 6))
			single_spark(get_turf(M))
			playsound(M,'sound/weapons/resonator_blast.ogg',50,1)
			if(iscarbon(M))
				var/mob/living/carbon/L = M
				L.Weaken(3)
				if(ishuman(L))
					shake_camera(L, 20, 1)
					addtimer(CALLBACK(L, /mob/living/carbon/human.proc/vomit), 20)

/**********************Lazarus Injector**********************/

/obj/item/lazarus_injector
	name = "lazarus injector"
	desc = "An injector with a cocktail of nanomachines and chemicals, this device can seemingly raise animals from the dead. If no effect in 3 days please call customer support."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "borghypo"
	item_state = "hypo"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	var/loaded = TRUE
	var/malfunctioning = FALSE
	var/revive_type = TYPE_ORGANIC //So you can't revive boss monsters or robots with it
	origin_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4)

/obj/item/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	if(!loaded)
		return
	if(isliving(target) && proximity_flag)
		if(istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = target
			if(!(M.find_type() & revive_type))
				to_chat(user, span("info", "\The [src] does not work on this sort of creature."))
				return
			if(M.stat == DEAD)
				if(!malfunctioning)
					M.faction = "neutral"
				M.revive()
				M.icon_state = M.icon_living
				loaded = FALSE
				user.visible_message(SPAN_NOTICE("\The [user] injects \the [M] with \the [src], reviving it."))
				feedback_add_details("lazarus_injector", "[M.type]")
				playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
				return
			else
				to_chat(user, span("info", "\The [src] is only effective on the dead."))
				return
		else
			to_chat(user, span("info", "\The [src] is only effective on lesser beings."))
			return

/obj/item/lazarus_injector/emp_act()
	if(!malfunctioning)
		malfunctioning = TRUE

/obj/item/lazarus_injector/examine(mob/user)
	..()
	if(!loaded)
		to_chat(user, span("info", "\The [src] is empty."))
	if(malfunctioning)
		to_chat(user, span("info", "The display on \the [src] seems to be flickering."))

/**********************Point Transfer Card**********************/

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = I
			C.mining_points += points
			to_chat(user, span("info", "You transfer [points] points to \the [C]."))
			points = 0
		else
			to_chat(user, span("info", "There's no points left on \the [src]."))
	..()

/obj/item/card/mining_point_card/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("There's [points] point\s on the card."))

/**********************"Fultons"**********************/

var/list/total_extraction_beacons = list()

/obj/item/extraction_pack
	name = "warp extraction pack"
	desc = "A complex device that warps nonliving matter to nearby locations."
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "fulton"
	w_class = 3
	var/obj/structure/extraction_point/beacon
	var/list/beacon_networks = list("station")
	var/uses_left = 3
	origin_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4, TECH_ENGINEERING = 4)

/obj/item/extraction_pack/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It has [uses_left] uses remaining."))

/obj/item/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/B in total_extraction_beacons)
		var/obj/structure/extraction_point/EP = B
		if(EP.beacon_network in beacon_networks)
			possible_beacons += EP

	if(!length(possible_beacons))
		to_chat(user, SPAN_NOTICE("There are no extraction beacons in existence!"))
		return

	else
		var/A = input(user, "Select a beacon to connect to", "Warp Extraction Pack") in possible_beacons
		if(!A)
			return
		beacon = A

/obj/item/extraction_pack/afterattack(atom/movable/A, mob/living/carbon/human/user)
	if(istype(A, /obj/item/storage/bag/ore))
		return
	if(!beacon)
		to_chat(user, SPAN_WARNING("\The [src] is not linked to a beacon, and cannot be used."))
		return
	if(!istype(A))
		return
	else
		if(istype(A, /mob/living))
			to_chat(user, SPAN_WARNING("\The [src] is not safe for use with living creatures, they wouldn't survive the trip back!"))
			return
		if(A.loc == user) // no extracting stuff you're holding
			return
		if(A.anchored)
			return
		to_chat(user, SPAN_NOTICE("You start attaching the pack to \the [A]..."))
		if(do_after(user,50))
			to_chat(user, SPAN_NOTICE("You attach the pack to \the [A] and activate it."))
			uses_left--
			if(uses_left <= 0)
				user.drop_item(src)
			single_spark(get_turf(A))
			var/list/flooring_near_beacon = list()
			for(var/turf/simulated/floor/floor in orange(1, beacon))
				flooring_near_beacon += floor
			if(length(flooring_near_beacon))
				A.forceMove(pick(flooring_near_beacon))
			else
				A.forceMove(get_turf(beacon))
			single_spark(get_turf(A))
			if(uses_left <= 0)
				qdel(src)

/obj/item/warp_core
	name = "warp extraction beacon signaller"
	desc = "Emits a signal which Warp-Item recovery devices can lock onto. Activate in hand to create a beacon."
	description_info = "You can activate this item in-hand to create a static beacon, or you can click on an ore box with it to allow the ore box to be linked to warp packed mining satchels."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"
	origin_tech = list(TECH_BLUESPACE = 1, TECH_PHORON = 1, TECH_ENGINEERING = 2)

/obj/item/warp_core/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You start placing down the beacon..."))
	if(do_after(user, 15))
		to_chat(user, SPAN_NOTICE("You successfully deploy the beacon."))
		new /obj/structure/extraction_point(get_turf(user))
		qdel(src)

/obj/structure/extraction_point
	name = "warp recovery beacon"
	desc = "A beacon for the Warp-Item recovery system. Hit a beacon with a pack to link the pack to a beacon."
	icon = 'icons/obj/mining.dmi'
	icon_state = "extraction_point"
	anchored = TRUE
	density = FALSE
	var/beacon_network = "station"

/obj/structure/extraction_point/Initialize()
	. = ..()
	var/area/area_name = get_area(src)
	name += " ([rand(100,999)]) ([area_name.name])"
	total_extraction_beacons += src
	..()

/obj/structure/extraction_point/Destroy()
	total_extraction_beacons -= src
	. = ..()

/**********************Resonator**********************/

/obj/item/resonator
	name = "resonator"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It can also be activated without a target to create a field at the user's location, to act as a delayed time trap. It's more effective in a vacuum."
	w_class = ITEMSIZE_NORMAL
	force = 15
	throwforce = 10
	var/burst_time = 30
	var/fieldlimit = 4
	var/list/fields = list()
	var/quick_burst_mod = 0.8
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/resonator/upgraded
	name = "upgraded resonator"
	desc = "An upgraded version of the resonator that can produce more fields at once."
	icon_state = "resonatoru"
	item_state = "resonatoru"
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_POWER = 2, TECH_ENGINEERING = 3)
	fieldlimit = 8
	quick_burst_mod = 1
	burst_time = 15

/obj/item/resonator/proc/CreateResonance(target, creator)
	var/turf/T = get_turf(target)
	var/obj/effect/resonance/R = locate(/obj/effect/resonance) in T
	if(R)
		R.resonance_damage *= quick_burst_mod
		R.burst(T)
		return
	if(fields.len < fieldlimit)
		playsound(src, 'sound/weapons/resonator_fire.ogg', 50, TRUE)
		var/obj/effect/resonance/RE = new /obj/effect/resonance(T, creator, burst_time, src)
		fields += RE

/obj/item/resonator/attack_self(mob/user)
	if(burst_time == 50)
		burst_time = 30
		to_chat(user, span("info", "You set the resonator's fields to detonate after 3 seconds."))
	else
		burst_time = 50
		to_chat(user, span("info", "You set the resonator's fields to detonate after 5 seconds."))

/obj/item/resonator/afterattack(atom/target, mob/user, proximity_flag)
	..()
	if(user.Adjacent(target))
		if(isturf(target))
			CreateResonance(target, user)

/obj/effect/resonance
	name = "resonance field"
	desc = "A resonating field that significantly damages anything inside of it when the field eventually ruptures."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	layer = 5
	anchored = TRUE
	mouse_opacity = 0
	var/resonance_damage = 20
	var/creator
	var/obj/item/resonator/res

/obj/effect/resonance/New(loc, set_creator, timetoburst, set_resonator)
	..()
	creator = set_creator
	res = set_resonator
	var/turf/proj_turf = get_turf(src)
	if(!istype(proj_turf))
		return
	var/datum/gas_mixture/environment = proj_turf.return_air()
	var/pressure = environment.return_pressure()
	if(pressure < 50)
		name = "strong resonance field"
		resonance_damage = 60

	addtimer(CALLBACK(src, .proc/burst, loc), timetoburst)

/obj/effect/resonance/Destroy()
	if(res)
		res.fields -= src
	return ..()

/obj/effect/resonance/proc/burst(turf/T)
	playsound(src,'sound/weapons/resonator_blast.ogg',50,1)
	if(istype(T, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.GetDrilled(1)
	for(var/mob/living/L in T)
		if(creator)
			add_logs(creator, L, "used a resonator field on", "resonator")
		to_chat(L, SPAN_DANGER("\The [src] ruptured with you in it!"))
		L.apply_damage(resonance_damage, BRUTE)
	qdel(src)


/******************************Ore Magnet*******************************/
/obj/item/oremagnet
	name = "ore magnet"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "magneto"
	item_state = "magneto"
	desc = "A handheld device that creates a well of negative force that attracts minerals of a very specific type, size, and state to its user."
	w_class = 3
	force = 10
	throwforce = 5
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 3)

/obj/item/oremagnet/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	toggle_on(user)

/obj/item/oremagnet/process()
	for(var/obj/item/ore/O in oview(7, loc))
		if(prob(80))
			step_to(O, get_turf(src), 0)
		if(TICK_CHECK)
			return

/obj/item/oremagnet/proc/toggle_on(mob/user)
	if(!isprocessing)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	if(user)
		to_chat(user, "<span class='[isprocessing ? "notice" : "warning"]'>You switch [isprocessing ? "on" : "off"] [src].</span>")

/obj/item/oremagnet/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/******************************Ore Summoner*******************************/

/obj/item/oreportal
	name = "ore summoner"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "supermagneto"
	item_state = "jaunter"
	desc = "A handheld device that creates a well of warp energy that teleports minerals of a very specific type, size, and state to its user."
	w_class = 3
	force = 15
	throwforce = 5
	origin_tech = list(TECH_BLUESPACE = 4, TECH_ENGINEERING = 3)
	var/last_oresummon_time = 0

/obj/item/oreportal/attack_self(mob/user)
	if(world.time - last_oresummon_time >= 25)
		to_chat(user, SPAN_NOTICE("You pulse the ore summoner."))
		last_oresummon_time = world.time
		var/limit = 50
		for(var/obj/item/ore/O in orange(7, user))
			if(limit <= 0)
				break
			single_spark(get_turf(O))
			do_teleport(O, user, 0)
			limit -= 1
			CHECK_TICK
	else
		to_chat(user, SPAN_NOTICE("The ore summoner is in the middle of some calibrations."))
		return FALSE

/******************************Sculpting*******************************/
/obj/item/autochisel
	name = "auto-chisel"
	icon = 'icons/obj/tools.dmi'
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"

/obj/structure/sculpting_block
	name = "sculpting block"
	desc = "A finely chiselled sculpting block, it is ready to be your canvas."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sculpting_block"
	density = TRUE
	opacity = TRUE
	anchored = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE
	var/sculpted = FALSE
	var/mob/living/T
	var/times_carved = 0
	var/last_struck = 0

/obj/structure/sculpting_block/attackby(obj/item/C as obj, mob/user as mob)

	if (C.iswrench())
		playsound(src.loc, C.usesound, 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the [name].</span>")
		anchored = !anchored

	if(istype(C, /obj/item/autochisel))
		if(!sculpted)
			if(last_struck)
				return
			if(!T)
				var/list/choices = list()
				for(var/mob/living/M in view(7,user))
					choices += M
				T = input(user,"Who do you wish to sculpt?") as null|anything in choices
				if(!T)
					to_chat(user, SPAN_NOTICE("You decide against sculpting for now."))
				user.visible_message(SPAN_NOTICE("\The [user] begins sculpting."),
					SPAN_NOTICE("You begin sculpting."))

			var/sculpting_coefficient = get_dist(user,T)
			if(sculpting_coefficient <= 0)
				sculpting_coefficient = 1

			if(sculpting_coefficient >= 7)
				to_chat(user, SPAN_WARNING("You hardly remember what \the [T] really looks like! Bah!"))
				T = null

			user.visible_message(SPAN_NOTICE("\The [user] carves away at the sculpting block!"),
				SPAN_NOTICE("You continue sculpting."))

			if(prob(25))
				playsound(user, 'sound/items/Screwdriver.ogg', 20, TRUE)
			else
				playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, TRUE)
				spawn(3)
					playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, TRUE)
					spawn(3)
						playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, TRUE)

			last_struck = 1
			if(do_after(user,(20)))
				last_struck = 0
				if(times_carved <= 9)
					times_carved += 1
					if(times_carved < 1)
						to_chat(user, SPAN_NOTICE("You review your work and see there is more to do."))
					return
				else
					sculpted = TRUE
					user.visible_message(SPAN_NOTICE("\The [user] finishes sculpting their magnum opus!"),
						SPAN_NOTICE("You finish sculpting a masterpiece."))
					src.appearance = T
					src.color = list(
					    0.35, 0.3, 0.25,
					    0.35, 0.3, 0.25,
					    0.35, 0.3, 0.25
					)
					src.pixel_y += 8
					var/image/pedestal_underlay = image('icons/obj/mining.dmi', icon_state = "pedestal")
					pedestal_underlay.appearance_flags = RESET_COLOR
					pedestal_underlay.pixel_y -= 8
					src.underlays += pedestal_underlay
					var/title = sanitize(input(usr, "If you would like to name your art, do so here.", "Christen Your Sculpture", "") as text|null)
					if(title)
						name = title
					else
						name = "*[T.name]*"
					var/legend = sanitize(input(usr, "If you would like to describe your art, do so here.", "Story Your Sculpture", "") as message|null)
					if(legend)
						desc = legend
					else
						desc = "This is a sculpture of [T.name]. All craftsmanship is of the highest quality. It is decorated with rock and more rock. It is covered with rock. On the item is an image of a rock. The rock is [T.name]."
			else
				last_struck = 0
		return

/******************************Gains Boroughs*******************************/

/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Better this than the Quartermaster."
	icon = 'icons/obj/mining.dmi'
	icon_state = "punchingbag"
	anchored = TRUE
	layer = 5.1
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/punching_bag/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	flick("[icon_state]2", src)
	playsound(get_turf(src), pick(src.hit_sounds), 25, 1, -1)

/obj/structure/weightlifter
	name = "weight machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/mining.dmi'
	icon_state = "fitnessweight"
	density = TRUE
	anchored = TRUE

/obj/structure/weightlifter/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(in_use)
		to_chat(user, "It's already in use - wait a bit.")
		return
	else
		in_use = TRUE
		icon_state = "fitnessweight-c"
		user.dir = SOUTH
		user.Stun(4)
		user.forceMove(src.loc)
		var/image/W = image('icons/obj/mining.dmi',"fitnessweight-w")
		W.layer = 5.1
		add_overlay(W)
		var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
		user.visible_message(SPAN_NOTICE("<B>[user] is [bragmessage]!</B>"))
		var/reps = 0
		user.pixel_y = 5
		while (reps++ < 6)
			if (user.loc != src.loc)
				break

			for (var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
				sleep(3)
				animate(user, pixel_y = (user.pixel_y == 3) ? 5 : 3, time = 3)

			playsound(user,'sound/effects/spring.ogg', 60, 1)

		sleep(3)
		animate(user, pixel_y = 2, time = 3)
		sleep(3)
		playsound(user, 'sound/machines/click.ogg', 60, 1)
		in_use = 0
		animate(user, pixel_y = 0, time = 3)
		var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
		icon_state = "fitnessweight"
		cut_overlay(W)
		to_chat(user, SPAN_NOTICE("[finishmessage]"))
		user.adjustNutritionLoss(5)
		user.adjustHydrationLoss(5)

/******************************Seismic Charge*******************************/

/obj/item/plastique/seismic
	name = "seismic charge"
	desc = "A complex mining device that utilizes a seismic detonation to eliminate weak asteroid turf in a wide radius."
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_PHORON = 2)
	timer = 15

/obj/item/plastique/seismic/explode(var/turf/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	target.cut_overlay(image_overlay, TRUE)
	if(location)
		new /obj/effect/overlay/temp/explosion(location)
		playsound(location, 'sound/effects/Explosion1.ogg', 100, 1)
		for(var/atom/A in range(4,location))
			if(istype(A,/turf/simulated/mineral))
				var/turf/simulated/mineral/M = A
				M.GetDrilled(1)
			else if(istype(A, /turf/simulated/wall) && prob(66))
				var/turf/simulated/wall/W = A
				W.ex_act(2)
			else if(istype(A, /obj/structure/window))
				var/obj/structure/window/WI = A
				WI.ex_act(3)
			else if(istype(A,/mob/living))
				var/mob/living/LI = A
				LI << 'sound/weapons/resonator_blast.ogg'
				if(iscarbon(LI))
					var/mob/living/carbon/L = A
					L.Weaken(3)
					shake_camera(L, 20, 1)
					if(!isipc(L) && ishuman(L))
						addtimer(CALLBACK(L, /mob/living/carbon/human.proc/vomit), 20)

		addtimer(CALLBACK(src, .proc/drill, location), 2)

	qdel(src)

/obj/item/plastique/seismic/proc/drill(var/turf/drill_loc)
	for(var/turf/simulated/mineral/M in range(7,drill_loc))
		if(prob(75))
			M.GetDrilled(1)
