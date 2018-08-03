/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
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
		new /obj/item/weapon/storage/backpack/industrial(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/weapon/storage/bag/ore(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/weapon/ore_radar(src)
	new /obj/item/weapon/key/minecarts(src)
	new /obj/item/device/gps/mining(src)
	new /obj/item/weapon/book/manual/ka_custom(src)

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	item_state = "lantern"
	desc = "A mining lantern."
	light_power = 1
	brightness_on = 6
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/*****************************Pickaxe********************************/

/obj/item/weapon/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining implements. Surely this is a joke?"
	icon = 'icons/obj/items.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 4.0
	force = 10.0
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = 4.0
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/digspeed //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/chisel1.ogg'
	var/drill_verb = "excavating"
	var/autodrill = 0 //pickaxes must be manually swung to mine, drills can mine rocks via bump
	sharp = 1

	var/can_wield = 1

	var/excavation_amount = 30
	var/wielded = 0
	var/force_unwielded = 5.0
	var/force_wielded = 15.0
	var/digspeed_unwielded = 30
	var/digspeed_wielded = 10
	var/drilling = 0

	action_button_name = "Wield pick/drill"

/obj/item/weapon/pickaxe/proc/unwield()
	wielded = 0
	force = force_unwielded
	digspeed = digspeed_unwielded
	name = initial(name)
	update_icon()

/obj/item/weapon/pickaxe/proc/wield()
	wielded = 1
	force = force_wielded
	digspeed = digspeed_wielded
	name = "[name] (Wielded)"
	update_icon()

/obj/item/weapon/pickaxe/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(wielded)
		M << "<span class='warning'>Unwield the [initial(name)] first!</span>"
		return 0

	return ..()

/obj/item/weapon/pickaxe/dropped(mob/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/pickaxe/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return	unwield()

/obj/item/weapon/pickaxe/pickup(mob/user)
	unwield()

/obj/item/weapon/pickaxe/attack_self(mob/user as mob)

	..()

	if(!can_wield)
		return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(issmall(H))
			user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
			return
	else
		return

	if(!istype(user.get_active_hand(), src))
		user << "<span class='warning'>You need to be holding the [name] in your active hand.</span>"
		return

	if(wielded) //Trying to unwield it
		unwield()
		user << "<span class='notice'>You are now carrying the [initial(name)] with one hand.</span>"

		var/obj/item/weapon/pickaxe/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()

	else //Trying to wield it
		if(user.get_inactive_hand())
			user << "<span class='warning'>You need your other hand to be empty</span>"
			return
		wield()
		user << "<span class='notice'>You grab the [initial(name)] with both hands.</span>"

		var/obj/item/weapon/pickaxe/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]."
		user.put_in_inactive_hand(O)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	return

/obj/item/weapon/pickaxe/ui_action_click()
	if(src in usr)
		attack_self(usr)

/obj/item/weapon/pickaxe/verb/wield_pick()
	if(can_wield)
		set name = "Wield pick/drill"
		set category = "Object"
		set src in usr

		attack_self(usr)

/obj/item/weapon/pickaxe/offhand
	w_class = 5
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	item_state = null
	name = "offhand"
	simulated = FALSE

	action_button_name = null

/obj/item/weapon/pickaxe/proc/copy_stats(obj/item/weapon/pickaxe/parent)
	digspeed_wielded = parent.digspeed_wielded
	excavation_amount = parent.excavation_amount
	force = parent.force_wielded

/obj/item/weapon/pickaxe/offhand/unwield()
	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/weapon/pickaxe/offhand/wield()
	if (ismob(loc))
		var/mob/living/our_mob = loc
		our_mob.remove_from_mob(src)

	qdel(src)

/obj/item/weapon/pickaxe/hammer
	name = "sledgehammer"
	//icon_state = "sledgehammer" Waiting on sprite
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

/obj/item/weapon/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	origin_tech = list(TECH_MATERIAL = 3)
	desc = "This makes no metallurgic sense."
	excavation_amount = 30

	digspeed_unwielded = 30
	digspeed_wielded = 5

/obj/item/weapon/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"
	autodrill = 1
	drill_sound = 'sound/weapons/drill.ogg'
	digspeed = 20
	digspeed_unwielded = 30
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = 0
	force = 15.0

	action_button_name = null

/obj/item/weapon/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"
	autodrill = 1
	drill_sound = 'sound/weapons/sonic_jackhammer.ogg'
	digspeed = 15
	digspeed_unwielded = 15
	force_unwielded = 15.0
	excavation_amount = 100

	can_wield = 0
	force = 25.0

	action_button_name = null

/obj/item/weapon/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 4)
	desc = "This makes no metallurgic sense."
	excavation_amount = 50

	digspeed_unwielded = 30
	digspeed_wielded = 5

/obj/item/weapon/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head."
	excavation_amount = 30

	digspeed_unwielded = 20
	digspeed_wielded = 1
	force_wielded = 25.0

/obj/item/weapon/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	autodrill = 1
	drill_sound = 'sound/weapons/drill.ogg'
	excavation_amount = 100

	can_wield = 0
	force = 20.0
	digspeed = 5
	digspeed_unwielded = 5
	force_unwielded = 20.0

	action_button_name = null

/obj/item/weapon/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	digspeed_unwielded = 15
	force_unwielded = 25.0
	desc = ""
	drill_verb = "drilling"
	autodrill = 1
	drill_sound = 'sound/weapons/drill.ogg'
	can_wield = 0
	force = 15.0
	excavation_amount = 100

	action_button_name = null

/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = 3.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = 0
	edge = 1

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
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
	amount = 5
	max_amount = 5
	w_class = 2
	icon = 'icons/obj/mining.dmi'
	var/upright = 0
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

/obj/item/stack/flag/attackby(obj/item/W as obj, mob/user as mob)
	if(upright && istype(W,src.type))
		src.attack_hand(user)
	else
		..()

/obj/item/stack/flag/attack_hand(user as mob)
	if(upright)
		upright = 0
		icon_state = base_state
		anchored = 0
		set_light(0)
		src.visible_message("<b>[user]</b> turns [src] off.")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user as mob)

	var/obj/item/stack/flag/F = locate() in get_turf(src)

	var/turf/T = get_turf(src)
	if(!T || !istype(T, /turf/simulated/floor/asteroid))
		user << "The beacon won't stand up in this terrain."
		return

	if(F && F.upright)
		user << "There is already a beacon here."
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = 1
	newflag.anchored = 1
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
	newflag.set_light(2)
	src.use(1)

/**********************Miner Carts***********************/
/obj/item/weapon/rrf_ammo
	name = "compressed railway cartridge"
	desc = "Highly compressed matter for the RRF."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 15000,"glass" = 7500)

/obj/item/weapon/rrf
	name = "\improper Rapid-Railway-Fabricator"
	desc = "A device used to rapidly deploy mine tracks."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 30
	w_class = 3.0

/obj/item/weapon/rrf/examine(mob/user)
	if(..(user, 0))
		user << "It currently holds [stored_matter]/30 fabrication-units."

/obj/item/weapon/rrf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/weapon/rcd_ammo))

		if ((stored_matter + 30) > 30)
			user << "The RRF can't hold any more matter."
			return

		qdel(W)

		stored_matter += 30
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		user << "The RRF now holds [stored_matter]/30 fabrication-units."
		return

	if (istype(W, /obj/item/weapon/rrf_ammo))

		if ((stored_matter + 15) > 30)
			user << "The RRF can't hold any more matter."
			return

		qdel(W)

		stored_matter += 15
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		user << "The RRF now holds [stored_matter]/30 fabrication-units."
		return

/obj/item/weapon/rrf/afterattack(atom/A, mob/user as mob, proximity)

	if(!proximity) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			return

	if(!istype(A, /turf/simulated/floor))
		return

	if(locate(/obj/structure/track) in A)
		return

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0

	used_energy = 10

	new /obj/structure/track(get_turf(A))

	user << "Dispensing track..."

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		user << "The RRF now holds [stored_matter]/30 fabrication-units."


/obj/structure/track
	name = "mine track"
	desc = "Just like your grandpappy used to lay 'em in 1862."
	icon = 'icons/obj/smoothtrack.dmi'
	icon_state = "track15"
	density = 0
	anchored = 1.0
	w_class = 3
	layer = 2.44

/obj/structure/track/Initialize()
	. = ..()
	var/obj/structure/track/track = locate() in loc
	if (track && track != src)
		qdel(src)
		return
	updateOverlays()
	for (var/dir in cardinal)
		var/obj/structure/track/R = locate(/obj/structure/track, get_step(src, dir))
		if(R)
			R.updateOverlays()

/obj/structure/track/Destroy()
	for (var/dir in cardinal)
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

/obj/structure/track/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user)
		return
	if (iswelder(C))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>Slicing apart connectors ...</span>"
		new /obj/item/stack/rods(src.loc)
		qdel(src)

	return

/obj/structure/track/proc/updateOverlays()
	set waitfor = FALSE
	overlays = list()

	var/dir_sum = 0

	for (var/direction in cardinal)
		if(locate(/obj/structure/track, get_step(src, direction)))
			dir_sum += direction

	icon_state = "track[dir_sum]"
	return

/obj/vehicle/train/cargo/engine/mining
	name = "mine cart engine"
	desc = "A ridable electric minecart designed for pulling other mine carts."
	icon = 'icons/obj/cart.dmi'
	icon_state = "mining_engine"
	on = 0
	powered = 1
	move_delay = -1

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 15
	active_engines = 1

	light_power = 1
	light_range = 6
	light_wedge = LIGHT_WIDE
	light_color = LIGHT_COLOR_FIRE

/obj/vehicle/train/cargo/engine/mining/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/high(src)
	key = null
	var/image/I = new(icon = 'icons/obj/cart.dmi', icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/mining/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/minecarts))
		if(!key)
			user.drop_from_inventory(W,src)
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
	anchored = 0
	passenger_allowed = 0
	move_delay = -1

	load_item_visible = 1
	load_offset_x = 1
	load_offset_y = 15
	mob_offset_y = 16

	light_power = 1
	light_range = 3
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/obj/vehicle/train/cargo/trolley/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/item/weapon/key/minecarts
	name = "key"
	desc = "A keyring with a small steel key, and a pickaxe shaped fob."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mine_keys"
	w_class = 1

/**********************Pinpointer**********************/

/obj/item/weapon/ore_radar
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
	var/turf/simulated/mineral/random/sonar = null
	var/active = 0


/obj/item/weapon/ore_radar/attack_self(mob/user)
	if(!active)
		active = 1
		usr << "<span class='notice'>You activate the pinpointer</span>"
		START_PROCESSING(SSfast_process, src)
	else
		active = 0
		icon_state = "pinoff"
		usr << "<span>You deactivate the pinpointer</span>"
		STOP_PROCESSING(SSfast_process, src)

/obj/item/weapon/ore_radar/process()
	if (active)
		workdisk()
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/weapon/ore_radar/proc/workdisk()
	if(!src.loc)
		active = 0

	if(!active)
		return

	var/closest = 15

	for(var/turf/simulated/mineral/random/R in orange(14,loc))
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
	contained_sprite = 1
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
	user.visible_message("<span class='notice'>[user.name] activates the [src.name]!</span>")
	feedback_add_details("jaunter", "U") // user activated
	activate(user)

/obj/item/device/wormhole_jaunter/proc/turf_check(mob/user)
	var/turf/device_turf = get_turf(user)
	if(!device_turf||device_turf.z==0)
		user << "<span class='notice'>You're having difficulties getting the [src.name] to work.</span>"
		return FALSE
	return TRUE

/obj/item/device/wormhole_jaunter/proc/get_destinations(mob/user)
	var/list/destinations = list()

	for(var/obj/item/device/radio/beacon/B in teleportbeacons)
		var/turf/T = get_turf(B)
		if(T.z in current_map.station_levels)
			destinations += B

	return destinations

/obj/item/device/wormhole_jaunter/proc/activate(mob/user)
	if(!turf_check(user))
		return

	var/list/L = get_destinations(user)
	if(!L.len)
		user << "<span class='notice'>The [src.name] found no beacons in the world to anchor a wormhole to.</span>"
		return
	var/chosen_beacon = pick(L)
	var/obj/effect/portal/wormhole/jaunt_tunnel/J = new /obj/effect/portal/wormhole/jaunt_tunnel(get_turf(src), chosen_beacon, lifespan=100)
	J.target = chosen_beacon
	playsound(src,'sound/effects/sparks4.ogg',50,1)
	qdel(src)

/obj/item/device/wormhole_jaunter/emp_act(power)
	var/triggered = FALSE
	if(power == 1)
		triggered = TRUE
	else if(power == 2 && prob(50))
		triggered = TRUE

	if(triggered)
		usr.visible_message("<span class='warning'>The [src] overloads and activates!</span>")
		feedback_add_details("jaunter","E") // EMP accidental activation
		activate(usr)

/obj/effect/portal/wormhole/jaunt_tunnel
	name = "jaunt tunnel"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."

/obj/effect/portal/wormhole/jaunt_tunnel/teleport(atom/movable/M)
	if(M.anchored || istype(M, /obj/effect))
		return
	single_spark(M.loc)
	if(istype(M))
		if(do_teleport(M, target, 6))
			single_spark(M.loc)
			playsound(M,'sound/weapons/resonator_blast.ogg',50,1)
			if(iscarbon(M))
				var/mob/living/carbon/L = M
				L.Weaken(3)
				if(ishuman(L))
					shake_camera(L, 20, 1)
					addtimer(CALLBACK(L, /mob/living/carbon/.proc/vomit), 20)

/**********************Lazarus Injector**********************/

/obj/item/weapon/lazarus_injector
	name = "lazarus injector"
	desc = "An injector with a cocktail of nanomachines and chemicals, this device can seemingly raise animals from the dead. If no effect in 3 days please call customer support."
	icon = 'icons/obj/syringe.dmi'
	icon_state = "borghypo"
	item_state = "hypo"
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 5
	var/loaded = 1
	var/malfunctioning = 0
	var/revive_type = TYPE_ORGANIC //So you can't revive boss monsters or robots with it
	origin_tech = list(TECH_BIO = 7, TECH_MATERIAL = 4)

/obj/item/weapon/lazarus_injector/afterattack(atom/target, mob/user, proximity_flag)
	if(!loaded)
		return
	if(isliving(target) && proximity_flag)
		if(istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/M = target
			if(!(M.find_type() & revive_type))
				user << "<span class='info'>[src] does not work on this sort of creature.</span>"
				return
			if(M.stat == DEAD)
				if(!malfunctioning)
					M.faction = "neutral"
				M.revive()
				M.icon_state = M.icon_living
				loaded = 0
				user.visible_message("<span class='notice'>[user] injects [M] with [src], reviving it.</span>")
				feedback_add_details("lazarus_injector", "[M.type]")
				playsound(src,'sound/effects/refill.ogg',50,1)
				return
			else
				user << "<span class='info'>[src] is only effective on the dead.</span>"
				return
		else
			user << "<span class='info'>[src] is only effective on lesser beings.</span>"
			return

/obj/item/weapon/lazarus_injector/emp_act()
	if(!malfunctioning)
		malfunctioning = 1

/obj/item/weapon/lazarus_injector/examine(mob/user)
	..()
	if(!loaded)
		user << "<span class='info'>[src] is empty.</span>"
	if(malfunctioning)
		user << "<span class='info'>The display on [src] seems to be flickering.</span>"

/**********************Point Transfer Card**********************/

/obj/item/weapon/card/mining_point_card
	name = "mining points card"
	desc = "A small card preloaded with mining points. Swipe your ID card over it to transfer the points, then discard."
	icon_state = "data"
	var/points = 500

/obj/item/weapon/card/mining_point_card/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/card/id))
		if(points)
			var/obj/item/weapon/card/id/C = I
			C.mining_points += points
			user << "<span class='info'>You transfer [points] points to [C].</span>"
			points = 0
		else
			user << "<span class='info'>There's no points left on [src].</span>"
	..()

/obj/item/weapon/card/mining_point_card/examine(mob/user)
	..()
	user << "There's [points] point\s on the card."

/**********************"Fultons"**********************/

var/list/total_extraction_beacons = list()

/obj/item/weapon/extraction_pack
	name = "warp extraction pack"
	desc = "A complex device that warps nonliving matter to nearby locations."
	contained_sprite = 1
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "fulton"
	w_class = 3
	var/obj/structure/extraction_point/beacon
	var/list/beacon_networks = list("station")
	var/uses_left = 3
	origin_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/extraction_pack/examine()
	. = ..()
	usr.show_message("It has [uses_left] uses remaining.", 1)

/obj/item/weapon/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/B in total_extraction_beacons)
		var/obj/structure/extraction_point/EP = B
		if(EP.beacon_network in beacon_networks)
			possible_beacons += EP

	if(!possible_beacons.len)
		user << "There are no extraction beacons in existence!"
		return

	else
		var/A

		A = input("Select a beacon to connect to", "Warp Extraction Pack", A) in possible_beacons

		if(!A)
			return
		beacon = A

/obj/item/weapon/extraction_pack/afterattack(atom/movable/A, mob/living/carbon/human/user)
	if(!beacon)
		user << "[src] is not linked to a beacon, and cannot be used."
		return
	if(!istype(A))
		return
	else
		if(istype(A,/mob/living))
			user << "[src] is not safe for use with living creatures, they wouldn't survive the trip back!"
			return
		if(A.loc == user) // no extracting stuff you're holding
			return
		if(A.anchored)
			return
		user << "<span class='notice'>You start attaching the pack to [A]...</span>"
		if(do_after(user,50))
			user << "<span class='notice'>You attach the pack to [A] and activate it.</span>"
			uses_left--
			if(uses_left <= 0)
				user.drop_item(src)
				loc = A
			single_spark(A.loc)
			var/list/flooring_near_beacon = list()
			for(var/turf/simulated/floor/floor in orange(1, beacon))
				flooring_near_beacon += floor
			A.forceMove(pick(flooring_near_beacon))
			single_spark(A.loc)
			if(uses_left <= 0)
				qdel(src)


/obj/item/warp_core
	name = "warp extraction beacon signaller"
	desc = "Emits a signal which Warp-Item recovery devices can lock onto. Activate in hand to create a beacon."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"
	origin_tech = list(TECH_BLUESPACE = 1, TECH_PHORON = 1, TECH_ENGINEERING = 2)

/obj/item/warp_core/attack_self(mob/user)
	user << "<span class='notice'>You start placing down the beacon. . .</span>"
	if(do_after(user,15))
		new /obj/structure/extraction_point(get_turf(user))
		qdel(src)

/obj/structure/extraction_point
	name = "warp recovery beacon"
	desc = "A beacon for the Warp-Item recovery system. Hit a beacon with a pack to link the pack to a beacon."
	icon = 'icons/obj/mining.dmi'
	icon_state = "extraction_point"
	anchored = 1
	density = 0
	var/beacon_network = "station"

/obj/structure/extraction_point/New()
	var/area/area_name = get_area(src)
	name += " ([rand(100,999)]) ([area_name.name])"
	total_extraction_beacons += src
	..()

/obj/structure/extraction_point/Destroy()
	total_extraction_beacons -= src
	..()

/**********************Resonator**********************/

/obj/item/weapon/resonator
	name = "resonator"
	contained_sprite = 1
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "resonator"
	item_state = "resonator"
	desc = "A handheld device that creates small fields of energy that resonate until they detonate, crushing rock. It can also be activated without a target to create a field at the user's location, to act as a delayed time trap. It's more effective in a vacuum."
	w_class = 3
	force = 15
	throwforce = 10
	var/burst_time = 30
	var/fieldlimit = 4
	var/list/fields = list()
	var/quick_burst_mod = 0.8
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/weapon/resonator/upgraded
	name = "upgraded resonator"
	desc = "An upgraded version of the resonator that can produce more fields at once."
	icon_state = "resonatoru"
	item_state = "resonatoru"
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_POWER = 2, TECH_ENGINEERING = 3)
	fieldlimit = 8
	quick_burst_mod = 1
	burst_time = 15

/obj/item/weapon/resonator/proc/CreateResonance(target, creator)
	var/turf/T = get_turf(target)
	var/obj/effect/resonance/R = locate(/obj/effect/resonance) in T
	if(R)
		R.resonance_damage *= quick_burst_mod
		R.burst(T)
		return
	if(fields.len < fieldlimit)
		playsound(src,'sound/weapons/resonator_fire.ogg',50,1)
		var/obj/effect/resonance/RE = new /obj/effect/resonance(T, creator, burst_time, src)
		fields += RE

/obj/item/weapon/resonator/attack_self(mob/user)
	if(burst_time == 50)
		burst_time = 30
		user << "<span class='info'>You set the resonator's fields to detonate after 3 seconds.</span>"
	else
		burst_time = 50
		user << "<span class='info'>You set the resonator's fields to detonate after 5 seconds.</span>"

/obj/item/weapon/resonator/afterattack(atom/target, mob/user, proximity_flag)
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
	var/obj/item/weapon/resonator/res

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
		L << "<span class='danger'>The [src.name] ruptured with you in it!</span>"
		L.apply_damage(resonance_damage, BRUTE)
	qdel(src)


/******************************Ore Magnet*******************************/
/obj/item/weapon/oremagnet
	name = "ore magnet"
	contained_sprite = 1
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "magneto"
	item_state = "magneto"
	desc = "A handheld device that creates a well of negative force that attracts minerals of a very specific type, size, and state to its user."
	w_class = 3
	force = 10
	throwforce = 5
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 3)

/obj/item/weapon/oremagnet/attack_self(mob/user)
	if (use_check(user))
		return

	toggle_on(user)

/obj/item/weapon/oremagnet/process()
	for(var/obj/item/weapon/ore/O in oview(7, loc))
		if(prob(80))
			step_to(O, src.loc, 0)

		if (TICK_CHECK)
			return

/obj/item/weapon/oremagnet/proc/toggle_on(mob/user)
	if (!isprocessing)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)

	if (user)
		to_chat(user, "<span class='[isprocessing ? "notice" : "warning"]'>You switch [isprocessing ? "on" : "off"] [src].</span>")

/obj/item/weapon/oremagnet/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/******************************Ore Summoner*******************************/

/obj/item/weapon/oreportal
	name = "ore summoner"
	contained_sprite = 1
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "supermagneto"
	item_state = "jaunter"
	desc = "A handheld device that creates a well of warp energy that teleports minerals of a very specific type, size, and state to its user."
	w_class = 3
	force = 15
	throwforce = 5
	origin_tech = list(TECH_BLUESPACE = 4, TECH_ENGINEERING = 3)

/obj/item/weapon/oreportal/attack_self(mob/user)
	user << "<span class='info'>You pulse the ore summoner.</span>"
	var/limit = 10
	for(var/obj/item/weapon/ore/O in orange(7,user))
		if(limit <= 0)
			break
		single_spark(O.loc)
		do_teleport(O, user, 0)
		limit -= 1
		CHECK_TICK

/******************************Sculpting*******************************/
/obj/item/weapon/autochisel
	name = "auto-chisel"
	icon = 'icons/obj/items.dmi'
	icon_state = "jackhammer"
	item_state = "jackhammer"
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "With an integrated AI chip and hair-trigger precision, this baby makes sculpting almost automatic!"

/obj/structure/sculpting_block
	name = "sculpting block"
	desc = "A finely chiselled sculpting block, it is ready to be your canvas."
	icon = 'icons/obj/mining.dmi'
	icon_state = "sculpting_block"
	density = 1
	opacity = 1
	anchored = 0
	var/sculpted = 0
	var/mob/living/T
	var/times_carved = 0
	var/last_struck = 0

/obj/structure/sculpting_block/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		usr << "It is fastened to the floor!"
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/structure/sculpting_block/attackby(obj/item/C as obj, mob/user as mob)

	if (iswrench(C))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		user << "<span class='notice'>You [anchored ? "un" : ""]anchor the [name].</span>"
		anchored = !anchored

	if (istype(C, /obj/item/weapon/autochisel))
		if(!sculpted)
			if(last_struck)
				return

			if(!T)
				var/list/choices = list()
				for(var/mob/living/M in view(7,user))
					choices += M
				T = input(user,"Who do you wish to sculpt?") as null|anything in choices
				user.visible_message("<span class='notice'>[user] begins sculpting.</span>",
					"<span class='notice'>You begin sculpting.</span>")

			var/sculpting_coefficient = get_dist(user,T)
			if(sculpting_coefficient <= 0)
				sculpting_coefficient = 1

			if(sculpting_coefficient >= 7)
				user << "<span class='warning'>You hardly remember what [T] really looks like! Bah!</span>"
				T = null

			user.visible_message("<span class='notice'>[user] carves away at the sculpting block!</span>",
				"<span class='notice'>You continue sculpting.</span>")

			if(prob(25))
				playsound(user, 'sound/items/Screwdriver.ogg', 20, 1)
			else
				playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)
				spawn(3)
					playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)
					spawn(3)
						playsound(user, "sound/weapons/chisel[rand(1,2)].ogg", 20, 1)

			last_struck = 1
			if(do_after(user,(20)))
				last_struck = 0
				if(times_carved <= 9)
					times_carved += 1
					if(times_carved < 1)
						user << "<span class='notice'>You review your work and see there is more to do.</span>"
					return
				else
					sculpted = 1
					user.visible_message("<span class='notice'>[user] finishes sculpting their magnum opus!</span>",
						"<span class='notice'>You finish sculpting a masterpiece.</span>")
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
	anchored = 1
	layer = 5.1
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/punching_bag/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	flick("[icon_state]2", src)
	playsound(src.loc, pick(src.hit_sounds), 25, 1, -1)

/obj/structure/weightlifter
	name = "Weight Machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/mining.dmi'
	icon_state = "fitnessweight"
	density = 1
	anchored = 1

/obj/structure/weightlifter/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(in_use)
		user << "It's already in use - wait a bit."
		return
	else
		in_use = 1
		icon_state = "fitnessweight-c"
		user.dir = SOUTH
		user.Stun(4)
		user.forceMove(src.loc)
		var/image/W = image('icons/obj/mining.dmi',"fitnessweight-w")
		W.layer = 5.1
		add_overlay(W)
		var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
		user.visible_message("<B>[user] is [bragmessage]!</B>")
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
		user << "[finishmessage]"
		user.nutrition = user.nutrition - 10

/******************************Seismic Charge*******************************/

/obj/item/weapon/plastique/seismic
	name = "seismic charge"
	desc = "A complex mining device that utilizes a seismic detonation to eliminate weak asteroid turf in a wide radius."
	origin_tech = list(TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_PHORON = 2)
	timer = 15

/obj/item/weapon/plastique/seismic/explode(var/turf/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
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
					if(ishuman(L))
						shake_camera(L, 20, 1)
						addtimer(CALLBACK(L, /mob/living/carbon/.proc/vomit), 20)

		spawn(2)
			for(var/turf/simulated/mineral/M in range(7,location))
				if(prob(75))
					M.GetDrilled(1)

	if(target)
		target.overlays -= image_overlay
	qdel(src)