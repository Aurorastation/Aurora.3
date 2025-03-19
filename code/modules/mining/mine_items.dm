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
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 4.0
	force = 15
	w_class = WEIGHT_CLASS_BULKY
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/digspeed //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	hitsound = 'sound/weapons/rapidslice.ogg'
	surgerysound = 'sound/weapons/rapidslice.ogg'
	var/drill_sound = /singleton/sound_category/pickaxe_sound
	var/drill_verb = "excavating"
	var/autodrill = 0 //pickaxes must be manually swung to mine, drills can mine rocks via bump
	sharp = TRUE

	var/can_wield = TRUE

	var/excavation_amount = 40
	var/wielded = FALSE
	var/wield_sound = /singleton/sound_category/generic_wield_sound
	var/unwield_sound = null
	var/force_unwielded = 5.0
	var/force_wielded = 15.0
	var/digspeed_unwielded = 30
	var/digspeed_wielded = 5
	var/drilling = FALSE

	action_button_name = "Wield pick/drill"

/obj/item/pickaxe/can_swap_hands(mob/user)
	if(wielded)
		return FALSE
	return ..()

/obj/item/pickaxe/proc/unwield()
	wielded = FALSE
	force = force_unwielded
	digspeed = digspeed_unwielded
	name = initial(name)
	if(src.unwield_sound)
		playsound(src.loc, unwield_sound, 25, 1)
	update_icon()

/obj/item/pickaxe/proc/wield()
	wielded = TRUE
	force = force_wielded
	digspeed = digspeed_wielded
	if(src.wield_sound)
		playsound(src.loc, wield_sound, 25, 1)
	update_icon()

/obj/item/pickaxe/update_icon()
	..()
	if(wielded)
		item_state = "[initial(icon_state)]-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()

/obj/item/pickaxe/mob_can_equip(M, slot, disable_warning = FALSE)
	//Cannot equip wielded items.
	if(wielded)
		to_chat(M, SPAN_WARNING("Unwield the [initial(name)] first!"))
		return FALSE

	return ..()

/obj/item/pickaxe/dropped(mob/user)
	. = ..()
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
	w_class = WEIGHT_CLASS_HUGE
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	item_state = null
	name = "offhand"
	simulated = FALSE
	action_button_name = null
	drop_sound = null
	pickup_sound = null
	equip_sound = null

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
	item_state = "sledgehammer"
	icon = 'icons/obj/weapons.dmi'

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
	desc = "Yours is the drill that will pierce through the rock walls."
	icon = 'icons/obj/item/drills.dmi'
	icon_state = "miningdrill"
	item_state = "miningdrill"
	contained_sprite = TRUE
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	digspeed = 10
	digspeed_unwielded = 15
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = FALSE
	force = 22

	action_button_name = null

/obj/item/pickaxe/drill/weak
	name = "shaft drill"
	desc = "Baby's first mining drill. Slow, but reliable."
	icon_state = "drill"
	item_state = "drill"
	digspeed = 5
	digspeed_unwielded = 10
	excavation_amount = 80
	force = 15

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	icon = 'icons/obj/item/drills.dmi'
	icon_state = "jackhammer"
	item_state = "jackhammer"
	contained_sprite = TRUE
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	drill_verb = "hammering"
	autodrill = TRUE
	drill_sound = 'sound/weapons/sonic_jackhammer.ogg'
	digspeed = 5
	digspeed_unwielded = 10
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = FALSE
	force = 31

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
	icon = 'icons/obj/item/drills.dmi'
	icon_state = "diamonddrill"
	item_state = "diamonddrill"
	contained_sprite = TRUE
	digspeed = 3 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	excavation_amount = 100

	can_wield = 0
	force = 25
	digspeed_unwielded = 3
	force_unwielded = 20.0

	action_button_name = null

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon = 'icons/obj/item/drills.dmi'
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	contained_sprite = TRUE
	digspeed = 10
	digspeed_unwielded = 10
	force_unwielded = 25.0
	desc = ""
	drill_verb = "drilling"
	autodrill = TRUE
	drill_sound = 'sound/weapons/drill.ogg'
	can_wield = FALSE
	force = 22
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
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	force = 18
	throwforce = 4.0
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = FALSE
	edge = TRUE
	drop_sound = 'sound/items/drop/shovel.ogg'
	pickup_sound = 'sound/items/pickup/shovel.ogg'
	usesound = /singleton/sound_category/shovel_sound

/obj/item/shovel/is_shovel()
	return TRUE

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	icon_state = "spade"
	item_state = "spade"
	force = 11
	throwforce = 7.0
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/gadpathur
	name = "trench shovel"
	desc = "A standard-issue Gadpathurian entrenching tool. Sharpened edges make this tool/weapon equally adept at breaking earth and collarbones."
	icon_state = "gadpathur_shovel"
	item_state = "gadpathur_shovel"
	force = 15
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1, TECH_COMBAT = 2)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked", "slashed", "cut")
	sharp = TRUE

/obj/item/shovel/gadpathur/iscrowbar()
	return TRUE

// Flags.

/obj/item/stack/flag
	name = "beacons"
	desc = "A stack of light emitting beacons."
	singular_name = "flag"
	amount = 25
	max_amount = 25
	w_class = WEIGHT_CLASS_SMALL
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
	. = ..()
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

/obj/item/stack/flag/attackby(obj/item/attacking_item, mob/user)
	if(upright && istype(attacking_item, src.type))
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

/obj/item/stack/flag/purple/borg
	name = "stationbound beacon deployer"
	desc = "A stationbound-mounted beacon deployer, deploys standard purple beacons in accordance with the mining colour scheme. Uses a metal synthesizer to produce more."
	charge_costs = list(1500)
	uses_charge = TRUE
	stacktype = /obj/item/stack/flag/purple

/**********************Miner Carts***********************/

// RRF refactored into RFD-M, found in RFD.dm

/obj/structure/track
	name = "mine track"
	desc = "Just like your grandpappy used to lay 'em in 1862."
	icon = 'icons/obj/smoothtrack.dmi'
	icon_state = "track15"
	density = FALSE
	anchored = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	layer = 2.44

/obj/structure/track/Initialize()
	. = ..()
	var/obj/structure/track/track = locate() in get_turf(src)
	if(track && track != src)
		qdel(src)
		return
	updateOverlays()
	for(var/dir in GLOB.cardinals)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()

/obj/structure/track/Destroy()
	for(var/dir in GLOB.cardinals)
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

/obj/structure/track/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(attacking_item, user)
		return
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.use(0, user))
			to_chat(user, SPAN_NOTICE("You slice apart the track."))
			new /obj/item/stack/rods(get_turf(src))
			qdel(src)
	return

/obj/structure/track/proc/updateOverlays()
	set waitfor = FALSE
	overlays = list()

	var/dir_sum = 0

	for(var/direction in GLOB.cardinals)
		if(locate(/obj/structure/track, get_step(src, direction)))
			dir_sum += direction

	icon_state = "track[dir_sum]"
	return

/obj/vehicle/train/cargo/engine/mining
	name = "mine cart engine"
	desc = "A ridable electric minecart designed for pulling other mine carts."
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
	key = new /obj/item/key/minecarts(src)
	var/image/I = new(icon = 'icons/obj/vehicles.dmi', icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	AddOverlays(I)
	turn_off()

/obj/vehicle/train/cargo/engine/mining/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/key/minecarts))
		if(!key)
			user.drop_from_inventory(attacking_item, src)
			key = attacking_item
		return
	..()

/obj/vehicle/train/cargo/engine/mining/Move(var/turf/destination)
	if((locate(/obj/structure/track) in destination))
		move_delay = initial(move_delay)
	else if(!(locate(/obj/structure/track) in loc) && on) // Allow minecarts to off-track move, albeit slowly and only if not on a track already
		if(move_delay == initial(move_delay))
			move_delay = 10
			visible_message(SPAN_WARNING("\The [src]'s rollers struggle to move without a track to follow!"), SPAN_WARNING("You hear a horrible grinding noise!"))
			playsound(loc, 'sound/mecha/tanktread.ogg', 50, 1)
		else if(prob(50))
			playsound(loc, 'sound/mecha/tanktread.ogg', 50, 1)
	else
		return FALSE

	. = ..()

/obj/vehicle/train/cargo/engine/mining/update_car(var/train_length, var/active_engines)
	return

/obj/vehicle/train/cargo/trolley/mining
	name = "mine-cart"
	desc = "A modern day twist to an ancient classic."
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

/obj/item/key/minecarts
	name = "key"
	desc = "A keyring with a small steel key, and a pickaxe shaped fob."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mine_keys"
	w_class = WEIGHT_CLASS_TINY

/**********************Pinpointer**********************/

/obj/item/ore_radar
	name = "scanner pad"
	desc = "An antiquated device that can detect ore in a wide radius around the user."
	icon = 'icons/obj/item/pinpointer.dmi'
	icon_state = "pinoff"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
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
	w_class = WEIGHT_CLASS_SMALL
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

	for(var/obj/item/device/radio/beacon/B in GLOB.teleportbeacons)
		var/turf/T = get_turf(B)
		if(is_station_level(T.z))
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
	var/obj/effect/portal/wormhole/jaunt_tunnel/J = new /obj/effect/portal/wormhole/jaunt_tunnel(get_turf(src), chosen_beacon, null, 100)
	J.set_target(chosen_beacon)
	playsound(src,'sound/effects/sparks4.ogg', 50, 1)
	qdel(src)

/obj/item/device/wormhole_jaunter/emp_act(severity)
	. = ..()

	var/triggered = FALSE

	switch(severity)
		if(EMP_HEAVY)
			triggered = TRUE
		if(EMP_LIGHT)
			if(prob(50))
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
					addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon/human, vomit), 20))

/**********************Lazarus Injector**********************/

/obj/item/lazarus_injector
	name = "lazarus injector"
	desc = "An injector with a secret patented cocktail of nanomachines and chemicals, this device can seemingly raise animals from the dead. If no effect in 3 days please call customer support."
	icon = 'icons/obj/item/reagent_containers/syringe.dmi'
	icon_state = "lazarus_loaded"
	item_state = "lazarus_loaded"
	contained_sprite = TRUE
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	var/loaded = TRUE
	var/mask_color = null
	var/emagged = FALSE
	var/malfunctioning = FALSE
	var/revive_type = TYPE_ORGANIC //So you can't revive boss monsters or robots with it
	origin_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4)

/obj/item/lazarus_injector/Initialize()
	. = ..()
	if(!mask_color)
		mask_color = pick(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_PINK)
		update_icon()

/obj/item/lazarus_injector/update_icon()
	ClearOverlays()
	if(loaded)
		var/mutable_appearance/filling = mutable_appearance(icon, "lazarus_filling")
		filling.color = mask_color
		AddOverlays(filling)
		if(malfunctioning || emagged)
			var/mutable_appearance/static_fill = mutable_appearance(icon, "lazarus_static")
			static_fill.color = mask_color
			AddOverlays(static_fill)
	icon_state = "lazarus_[loaded ? "loaded" : "spent"]"
	item_state = icon_state
	update_held_icon()

/obj/item/lazarus_injector/attack(mob/living/target_mob, mob/living/user, target_zone)
	//If we're not loaded, the target is not a living mob, or we're further from 1 tile away, not our problem
	if(!loaded || !isliving(target_mob) || get_dist(target_mob, user) > 1)
		return ..()

	if(istype(target_mob, /mob/living/simple_animal))
		var/mob/living/simple_animal/M = target_mob

		if(!(M.find_type() & revive_type) || !(M.tameable))
			to_chat(user, SPAN_INFO("\The [src] does not work on this sort of creature."))
			return

		if(M.stat == DEAD)
			if(emagged)	//if emagged, will set anything revived to the user's faction. convert station pets to the traitor side!
				M.faction = user.faction
			if(malfunctioning) //when EMP'd, will set the mob faction to its initial faction, so any taming will be reverted.
				M.faction = initial(M.faction)
			M.revive()
			M.icon_state = M.icon_living
			M.desc = initial(M.desc)
			loaded = FALSE
			user.visible_message(SPAN_NOTICE("\The [user] revives \the [M] by injecting it with \the [src]."))
			feedback_add_details("lazarus_injector", "[M.type]")
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			update_icon()

		else
			to_chat(user, SPAN_INFO("\The [src] is only effective on the dead."))

	else
		to_chat(user, SPAN_INFO("\The [src] is only effective on lesser beings."))

/obj/item/lazarus_injector/emp_act()
	. = ..()

	if(!malfunctioning)
		malfunctioning = TRUE
		update_icon()

/obj/item/lazarus_injector/emag_act(mob/user)
	if(!emagged)
		to_chat(user, SPAN_WARNING("You overload \the [src]'s injection matrix."))
		emagged = TRUE
		update_icon()

/obj/item/lazarus_injector/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!loaded)
		. += SPAN_INFO("\The [src] is empty.")
	if(malfunctioning || emagged)
		. += SPAN_INFO("The display on \the [src] seems to be flickering.")

/**********************Point Transfer Card**********************/

/obj/item/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 500

/obj/item/card/mining_point_card/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/card/id))
		if(points)
			var/obj/item/card/id/C = attacking_item
			C.mining_points += points
			to_chat(user, SPAN_INFO("You transfer [points] points to \the [C]."))
			points = 0
		else
			to_chat(user, SPAN_INFO("There's no points left on \the [src]."))
	..()

/obj/item/card/mining_point_card/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("There's [points] point\s on the card.")

/**********************"Fultons"**********************/

GLOBAL_LIST_INIT_TYPED(total_extraction_beacons, /obj/structure/extraction_point, list())

/obj/item/extraction_pack
	name = "warp extraction pack"
	desc = "A complex device that warps nonliving matter to nearby locations."
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "fulton"
	w_class = WEIGHT_CLASS_NORMAL
	var/obj/structure/extraction_point/beacon
	var/list/beacon_networks = list("station")
	var/uses_left = 3
	origin_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4, TECH_ENGINEERING = 4)

/obj/item/extraction_pack/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("It has [uses_left] uses remaining.")

/obj/item/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/B in GLOB.total_extraction_beacons)
		var/obj/structure/extraction_point/EP = B
		if(EP.beacon_network in beacon_networks)
			possible_beacons += EP

	if(!length(possible_beacons))
		to_chat(user, SPAN_NOTICE("There are no extraction beacons in existence!"))
		return

	else
		var/A = tgui_input_list(user, "Select a beacon to connect to.", "Warp Extraction Pack", possible_beacons, beacon)
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
		var/turf/T = get_turf(A)
		for(var/found_inhibitor in GLOB.bluespace_inhibitors)
			var/obj/machinery/anti_bluespace/AB = found_inhibitor
			if(T.z != AB.z || get_dist(T, AB) > 8 || (AB.stat & (NOPOWER | BROKEN)))
				continue
			AB.use_power_oneoff(AB.active_power_usage)
			to_chat(user, SPAN_WARNING("A nearby bluespace inhibitor interferes with \the [src]!"))
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
	desc_info = "You can activate this item in-hand to create a static beacon, or you can click on an ore box with it to allow the ore box to be linked to warp packed mining satchels."
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
	GLOB.total_extraction_beacons += src

/obj/structure/extraction_point/Destroy()
	GLOB.total_extraction_beacons -= src
	return ..()

/**********************Resonator**********************/

/obj/item/resonator
	name = "resonator"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It can also be activated without a target to create a field at the user's location, to act as a delayed time trap. It's more effective in a vacuum."
	w_class = WEIGHT_CLASS_NORMAL
	force = 22
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
		to_chat(user, SPAN_INFO("You set the resonator's fields to detonate after 3 seconds."))
	else
		burst_time = 50
		to_chat(user, SPAN_INFO("You set the resonator's fields to detonate after 5 seconds."))

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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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

	addtimer(CALLBACK(src, PROC_REF(burst), loc), timetoburst)

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
		L.apply_damage(resonance_damage, DAMAGE_BRUTE)
	qdel(src)


/******************************Ore Magnet*******************************/
/obj/item/oremagnet
	name = "ore magnet"
	contained_sprite = TRUE
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "magneto"
	item_state = "magneto"
	desc = "A handheld device that creates a well of negative force that attracts minerals of a very specific type, size, and state to its user."
	w_class = WEIGHT_CLASS_NORMAL
	force = 15
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
	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)
	if(user)
		to_chat(user, "<span class='[(datum_flags & DF_ISPROCESSING) ? "notice" : "warning"]'>You switch [(datum_flags & DF_ISPROCESSING) ? "on" : "off"] [src].</span>")

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
	w_class = WEIGHT_CLASS_NORMAL
	force = 22
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
	desc = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"
	icon = 'icons/obj/item/drills.dmi'
	icon_state = "chisel"
	item_state = "jackhammer"
	contained_sprite = TRUE
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)

#define TRUE_QDEL 3
/obj/structure/sculpting_block
	name = "sculpting block"
	desc = "A finely chiselled sculpting block, it is ready to be your canvas."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sculpting_block"
	density = TRUE
	opacity = TRUE
	anchored = FALSE
	var/sculpted = FALSE
	var/mob/living/T
	var/times_carved = 0
	var/busy_sculpting = FALSE

/obj/structure/sculpting_block/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		visible_message("<b>[user]</b> starts to [anchored ? "un" : ""]anchor \the [src].", SPAN_NOTICE("You start to [anchored ? "un" : ""]anchor \the [src]."))
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			anchored = !anchored

	else if(istype(attacking_item, /obj/item/autochisel))
		if(sculpted)
			to_chat(user, SPAN_WARNING("\The [src] has already been sculpted!"))
			return
		if(busy_sculpting)
			to_chat(user, SPAN_WARNING("Someone's already busy sculpting \the [src]!"))
			return

		busy_sculpting = TRUE

		var/choice = tgui_input_list(user, "What would you like to sculpt?", "Sculpting Options", list("Sculpture", "Ladder"))
		if(!choice)
			busy_sculpting = FALSE
			return
		choice = lowertext(choice)
		var/result = sculpture_options(choice, user)
		if(!result)
			busy_sculpting = FALSE
			return

		user.visible_message(SPAN_NOTICE("\The [user] begins sculpting."), SPAN_NOTICE("You begin sculpting."))

		if(prob(25))
			playsound(loc, 'sound/items/Screwdriver.ogg', 20, TRUE)
		else
			playsound(loc, /singleton/sound_category/pickaxe_sound, 20, TRUE)

		var/successfully_sculpted = FALSE
		while(do_after(user, 2 SECONDS) && sculpture_process_check(choice, user))
			if(times_carved <= 9)
				times_carved++
				playsound(loc, /singleton/sound_category/pickaxe_sound, 20, TRUE)
				continue
			successfully_sculpted = TRUE
			break

		busy_sculpting = FALSE

		if(!successfully_sculpted)
			return

		user.visible_message(SPAN_NOTICE("\The [user] finishes sculpting their magnum opus!"), SPAN_NOTICE("You finish sculpting a masterpiece."))
		sculpted = finish_sculpture(choice, user)
		if(sculpted == TRUE_QDEL)
			qdel(src)

/obj/structure/sculpting_block/proc/sculpture_options(choice, mob/user)
	switch(choice)
		if("sculpture")
			var/mob/living/old_T
			if(T)
				old_T = T

			var/list/choices = list()
			for(var/mob/living/M in get_hearers_in_LOS(7, user))
				choices += M
			T = tgui_input_list(user, "Who do you wish to sculpt?", "Sculpt Options", choices)
			if(!T)
				to_chat(user, SPAN_NOTICE("You decide against sculpting for now."))
				return FALSE

			var/sculpting_coefficient = max(get_dist(user, T), 1)
			if(sculpting_coefficient >= 7)
				to_chat(user, SPAN_WARNING("You hardly remember what \the [T] really looks like! Bah!"))
				T = null
				return

			if(old_T && T != old_T)
				times_carved = 0

			return TRUE
		if("ladder")
			var/turf/T = get_turf(src)
			var/turf/above = GET_TURF_ABOVE(T)
			if(!above)
				to_chat(user, SPAN_WARNING("There is nothing above you to make a ladder towards."))
				return FALSE
			if(!isopenturf(above))
				to_chat(user, SPAN_WARNING("The tile above you isn't open and can't accomodate a ladder."))
				return FALSE
			return TRUE

/obj/structure/sculpting_block/proc/sculpture_process_check(var/choice, var/mob/user)
	switch(choice)
		if("sculpture")
			if(!QDELETED(T) && get_dist(user, T) < 8)
				return TRUE
			return FALSE
		if("ladder")
			var/turf/T = get_turf(src)
			var/turf/above = GET_TURF_ABOVE(T)
			if(!above)
				to_chat(user, SPAN_WARNING("There is nothing above you to make a ladder towards."))
				return FALSE
			if(!isopenturf(above))
				to_chat(user, SPAN_WARNING("The tile above you isn't open and can't accomodate a ladder."))
				return FALSE
			return TRUE

/obj/structure/sculpting_block/proc/finish_sculpture(choice, mob/user)
	switch(choice)
		if("sculpture")
			appearance = T
			appearance_flags = KEEP_TOGETHER
			color = list( // for anyone interested, this is called a color matrix
				0.35, 0.3, 0.25,
				0.35, 0.3, 0.25,
				0.35, 0.3, 0.25
			)
			pixel_y += 8

			var/image/pedestal_underlay = image('icons/obj/mining.dmi', icon_state = "pedestal")
			pedestal_underlay.appearance_flags = RESET_COLOR
			pedestal_underlay.pixel_y -= 8
			underlays += pedestal_underlay

			obj_flags = OBJ_FLAG_ROTATABLE

			var/title = tgui_input_text(usr, "If you would like to name your art, do so here.", "Christen Your Sculpture", multiline = FALSE)
			if(title)
				name = title
			else
				name = T.name

			var/legend = tgui_input_text(usr, "If you would like to describe your art, do so here.", "Story Your Sculpture", multiline = TRUE)
			if(legend)
				desc = legend
			else
				desc = "This is a sculpture of [T.name]. All craftsmanship is of the highest quality. It is decorated with rock and more rock. It is covered with rock. On the item is an image of a rock. The rock is [T.name]."

			T = null // null T out, we don't need the ref to them anymore

			return TRUE

		if("ladder")
			var/turf/T = get_turf(src)
			var/turf/above = GET_TURF_ABOVE(T)
			if(!above)
				to_chat(user, SPAN_WARNING("There is nothing above you to make a ladder towards."))
				return FALSE
			if(!isopenturf(above))
				to_chat(user, SPAN_WARNING("The tile above you isn't open and can't accomodate a ladder."))
				return FALSE

			new /obj/structure/ladder/up/mining(get_turf(src))
			new /obj/structure/ladder/mining(above)
			return TRUE_QDEL

/obj/structure/sculpting_block/update_icon()
	return

#undef TRUE_QDEL

/******************************Gains Boroughs*******************************/

/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Better this than the Operations Manager."
	icon = 'icons/obj/mining.dmi'
	icon_state = "punchingbag"
	anchored = TRUE
	layer = 5.1

/obj/structure/punching_bag/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	flick("[icon_state]2", src)
	playsound(get_turf(src), /singleton/sound_category/swing_hit_sound, 25, 1, -1)

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
		AddOverlays(W)
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
		CutOverlays(W)
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
	QDEL_NULL(effect_overlay)
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
						addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living/carbon/human, vomit)), 20)

		addtimer(CALLBACK(src, PROC_REF(drill), location), 2)

	qdel(src)

/obj/item/plastique/seismic/proc/drill(var/turf/drill_loc)
	for(var/turf/simulated/mineral/M in range(7,drill_loc))
		if(prob(75))
			M.GetDrilled(1)
