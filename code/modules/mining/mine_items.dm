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

/obj/structure/closet/secure_closet/miner/New()
	..()
	sleep(2)
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
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/weapon/shovel(src)
	new /obj/item/weapon/pickaxe(src)

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_on = 4			// luminosity when on
	light_power = 0.75
	light_wedge = LIGHT_OMNI
	light_color = LIGHT_COLOR_FIRE

/*****************************Pickaxe********************************/

/obj/item/weapon/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining implements. Surely this is a joke?"
	icon = 'icons/obj/items.dmi'
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15.0
	throwforce = 4.0
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = 4.0
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "drilling"
	var/autodrill = 0 //pickaxes must be manually swung to mine, drills can mine rocks via bump
	sharp = 1

	var/excavation_amount = 100

/obj/item/weapon/pickaxe/hammer
	name = "sledgehammer"
	//icon_state = "sledgehammer" Waiting on sprite
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

/obj/item/weapon/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30
	origin_tech = list(TECH_MATERIAL = 3)
	desc = "This makes no metallurgic sense."

/obj/item/weapon/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 40
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"
	autodrill = 1

/obj/item/weapon/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"
	autodrill = 1

/obj/item/weapon/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20
	origin_tech = list(TECH_MATERIAL = 4)
	desc = "This makes no metallurgic sense."
	drill_verb = "picking"

/obj/item/weapon/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10
	origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head."
	drill_verb = "picking"

/obj/item/weapon/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"
	autodrill = 1

/obj/item/weapon/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"
	autodrill = 1

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
	name = "flags"
	desc = "Some colourful flags."
	singular_name = "flag"
	amount = 5
	max_amount = 5
	icon = 'icons/obj/mining.dmi'
	var/upright = 0
	var/base_state

/obj/item/stack/flag/New()
	..()
	base_state = icon_state

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"

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
		src.visible_message("<b>[user]</b> knocks down [src].")
	else
		..()

/obj/item/stack/flag/attack_self(mob/user as mob)

	var/obj/item/stack/flag/F = locate() in get_turf(src)

	var/turf/T = get_turf(src)
	if(!T || !istype(T,/turf/simulated/floor/asteroid))
		user << "The flag won't stand up in this terrain."
		return

	if(F && F.upright)
		user << "There is already a flag here."
		return

	var/obj/item/stack/flag/newflag = new src.type(T)
	newflag.amount = 1
	newflag.upright = 1
	anchored = 1
	newflag.name = newflag.singular_name
	newflag.icon_state = "[newflag.base_state]_open"
	newflag.visible_message("<b>[user]</b> plants [newflag] firmly in the ground.")
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
	var/obj/product

	product = new /obj/structure/track()
	used_energy = 10

	user << "Dispensing track..."
	product.loc = get_turf(A)

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

/obj/structure/track/initialize()
	..()
	for(var/obj/structure/track/T in src.loc)
		if(T != src)
			qdel(T)
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
	..()

/obj/structure/track/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/track/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user)
		return
	if (istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>Slicing apart connectors ...</span>"
		getFromPool(/obj/item/stack/rods, src.loc)
		qdel(src)

	return

/obj/structure/track/proc/updateOverlays()
	spawn(1)
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

/obj/vehicle/train/cargo/engine/mining/New()
	..()
	cell = new /obj/item/weapon/cell/high(src)
	key = null
	var/image/I = new(icon = 'icons/obj/cart.dmi', icon_state = "[icon_state]_overlay", layer = src.layer + 0.2) //over mobs
	overlays += I
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/key/minecarts))
		if(!key)
			user.drop_item()
			W.forceMove(src)
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

/obj/vehicle/train/cargo/trolley/mining/Move(var/turf/destination)
	return ((locate(/obj/structure/track) in destination)) ? ..() : FALSE

/obj/item/weapon/key/minecarts
	name = "key"
	desc = "A keyring with a small steel key, and a pickaxe shaped fob."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "mine_keys"
	w_class = 1

/**********************Jaunter**********************/

/obj/item/device/wormhole_jaunter
	name = "wormhole jaunter"
	desc = "A single use device harnessing outdated warp technology. The wormholes it creates are unpleasant to travel through, to say the least."
	contained_sprite = 1
	icon = 'icons/obj/mining_contained.dmi'
	icon_state = "jaunter"
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
		if(T.z in config.station_levels)
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
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	desc = "A stable hole in the universe made by a wormhole jaunter. Turbulent doesn't even begin to describe how rough passage through one of these is, but at least it will always get you somewhere near a beacon."

/obj/effect/portal/jaunt_tunnel/teleport(atom/movable/M)
	if(M.anchored || istype(M, /obj/effect))
		return

	if(istype(M, /atom/movable))
		if(do_teleport(M, target, 6))
			playsound(M,'sound/weapons/resonator_blast.ogg',50,1)
			if(iscarbon(M))
				var/mob/living/carbon/L = M
				L.Weaken(3)
				if(ishuman(L))
					shake_camera(L, 20, 1)
					spawn(20)
						L.vomit()

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
					M.faction = list("neutral")
				M.revive(full_heal = 1, admin_revive = 1)
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
	icon_state = "jaunter"
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

		A = input("Select a beacon to connect to", "Balloon Extraction Pack", A) in possible_beacons

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
		if(do_after(user,50,target=A))
			user << "<span class='notice'>You attach the pack to [A] and activate it.</span>"
			uses_left--
			if(uses_left <= 0)
				user.drop_item(src)
				loc = A
			var/list/flooring_near_beacon = list()
			for(var/turf/simulated/floor/floor in orange(1, beacon))
				flooring_near_beacon += floor
			A.loc = pick(flooring_near_beacon)
			if(uses_left <= 0)
				qdel(src)


/obj/item/warp_core
	name = "warp extraction beacon signaller"
	desc = "Emits a signal which Warp-Item recovery devices can lock onto. Activate in hand to create a beacon."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"
	origin_tech = list(TECH_BLUESPACE = 1, TECH_PHORON = 1, TECH_ENGINEERING = 2)

/obj/item/fulton_core/attack_self(mob/user)
	if(do_after(user,15,target = user))
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
	icon_state = "resonator_u"
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4, TECH_POWER = 2, TECH_ENGINEERING = 3)
	fieldlimit = 6
	quick_burst_mod = 1

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
	CreateResonance(target, user)

/obj/effect/resonance
	name = "resonance field"
	desc = "A resonating field that significantly damages anything inside of it when the field eventually ruptures."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
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
	spawn(timetoburst)
		burst(proj_turf)

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