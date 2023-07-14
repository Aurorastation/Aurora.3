/obj/structure/automobile
	name = "generic automotive"
	desc = "A newer model of automotive."
	icon = 'icons/obj/structure/urban/cars.dmi'
	icon_state = "car"
	anchored = TRUE
	density = TRUE
	layer = 7

/obj/structure/automobile/random/Initialize(mapload)
	. = ..()
	cut_overlays()
	name = "[pick("deluxe Shibata Sport automotive","beat-up Poplar Auto Group automotive","weathered Shibata Sport automotive","beat-up Langenfeld automotive","deluxe Langenfeld automotive","weathered Langenfeld automotive")]"
	desc = "A [name] vehicle of working condition."
	icon_state = "car[rand(1, 10)]"
	return

/obj/structure/automobile/police
	name = "police cruiser"
	desc = "A police vehicle with all the bells and whistles you'd expect from a decently-funded agency."
	icon_state = "copcar"

/obj/structure/automobile_filler
	name = "vehicle"
	desc = "A piece of a larger vehicle."
	icon = 'icons/obj/structure/urban/cars.dmi'
	icon_state = "blank"
	anchored = TRUE
	density = TRUE

/obj/structure/road_sign
	name = "stop sign"
	desc = "A stop sign to direct traffic. Sometimes a demand."
	icon = 'icons/obj/structure/urban/road_signs.dmi'
	icon_state = "stop"
	layer = 9
	anchored = TRUE

/obj/structure/road_sign/yield
	name = "yield sign"
	desc = "A yield sign which tells you to slow down, rather politely. Let's hope you listen."
	icon_state = "yield"

/obj/structure/road_sign/pedestrian
	name = "pedestrian passing sign"
	desc = "A yellow sign which alerts you of bonus points ahead."
	icon_state = "pedestrian"

/obj/structure/road_sign/turn
	name = "turn ahead sign"
	desc = "A sign which warns of an approaching turn to the right. Is it the right choice?"
	icon_state = "right"

/obj/structure/road_sign/turn/left
	desc = "A sign which warns of an approaching turn to the left. Is anything left?"
	icon_state = "left"

/obj/structure/road_sign/street
	name = "street sign"
	desc = "A green, wide street sign with words telling you that you are indeed on a street."
	icon_state = "street_big"

	var/street_name = null

/obj/structure/road_sign/street/Initialize(mapload)
	. = ..()
	name = "[street_name]"
	desc = "This sign indicates this crossing street is called [street_name]."

/obj/structure/stairs/urban
	icon = 'icons/obj/structure/urban/ledges.dmi'
	icon_state = "stairs-single"
	layer = 2.01
	opacity = 1

/obj/structure/stairs/urban/road_ramp
	name = "inclined asphalt ramp"
	desc = "A solid asphalt ramp to allow your vehicle to traverse inclines with ease."
	icon_state = "road-ramp-center"
	layer = 2.02

/obj/structure/stairs/urban/road_ramp/right
	icon_state = "road-ramp-right"

/obj/structure/stairs/urban/road_ramp/left
	icon_state = "road-ramp-left"

/obj/structure/closet/crate/bin/urban
	name = "tall garbage can"
	desc = "Garbage day!"
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "bin"

/obj/structure/closet/crate/bin/urban/compact
	name = "discrete garbage can"
	icon_state = "city-bin"
	anchored = TRUE

/obj/structure/closet/crate/bin/urban/dumpster
	name = "extra-wide hefty dumpster"
	desc = "This trunk carries a lot of junk."
	icon_state = "dumpster"
	anchored = TRUE

/obj/structure/manhole
	name = "sewer access manhole"
	desc = "Probably a bad idea to open this."
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "manhole_closed"
	var/open = 0

/obj/structure/manhole/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iscrowbar())
	playsound(src.loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
	to_chat(user, "You forcibly relocate the manhole, hopefully in the right way.")
	if(!open)
		visible_message("<span class='warning'>A horrid smell erupts from the abyss of the manhole, not one any soul should inhale. Some mistakes were made.</span>")
		icon_state = "manhole_open"
		desc = "This looks pretty dangerous, stinks horribly, and doesn't have a ladder inside. Watch out!"
		open = 1
		var/turf/turf = loc
		turf.is_hole = TRUE
		return
	if(open)
		visible_message("<span class='warning'>The manhole clunks and seals back into place, safely burying our problems underground for someone else later.</span>")
		icon_state = "manhole_closed"
		desc = "It looks recently opened and sloppily closed."
		open = 0
		var/turf/turf = loc
		turf.is_hole = FALSE
		return

/obj/structure/hydrant
	name = "water line hydrant"
	desc = "An emergency water hydrant for emergency watering of things."
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "hydrant"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/parking_meter
	name = "parking meter"
	desc = "A parking meter that seems to be turned off."
	icon = 'icons/obj/structure/urban/infrastructure.dmi'
	icon_state = "parking"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/dressing_divider
	name = "wardrobe dressing divider"
	desc = "A divider for an environment where you're probably swapping clothes, made with your privacy in mind."
	icon = 'icons/obj/structure/urban/tailoring.dmi'
	icon_state = "divider1"
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/shipping_container
	name = "freight container"
	desc = "A hulking industrial shipping container, bound for who knows where."
	icon = 'icons/obj/structure/industrial/shipping_containers.dmi'
	icon_state = "blue1"
	anchored = TRUE
	density = TRUE
	layer = 7

/obj/effect/overlay/container_logo
	name = "Hephaestus Industries emblem"
	icon = 'icons/obj/structure/industrial/shipping_containers.dmi'
	icon_state = "heph1"
	layer = 7.01

/obj/effect/overlay/container_logo/einstein
	name = "Einstein Engines emblem"
	icon_state = "ee1"

/obj/effect/overlay/container_logo/zenghu
	name = "Zeng-Hu Pharmaceuticals emblem"
	icon_state = "zeng1"

//Special railings for urban environments. These have almost no reason to be seen anywhere else so they exclude all of the complexities of normal railings
/obj/structure/rod_railing
	name = "rod railing"
	desc = "A flimsy rod railing bound together by screws and prayers."
	icon = 'icons/obj/structure/urban/blockers.dmi'
	icon_state = "rod_railing"
	density = TRUE
	throwpass = TRUE
	climbable = TRUE
	layer = 4.01
	anchored = TRUE

/obj/structure/rod_railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/rod_railing/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/dam
	name = "concrete dam"
	desc = "A hulking mass of concrete meant to hold in a large reservoir of water from passing downwards."
	icon = 'icons/obj/structure/urban/blockers.dmi'
	icon_state = "dam1"
	density = TRUE
	throwpass = TRUE
	anchored = TRUE
	layer = 4.01

/obj/structure/road_barrier
	name = "roadway barrier"
	desc = "A set of expendable plates meant to deflect the impact of vehicles, lest they intend to go into more dangerous areas off the road."
	icon = 'icons/obj/structure/urban/road_edges.dmi'
	icon_state = "guard"
	density = TRUE
	throwpass = TRUE
	climbable = TRUE
	anchored = TRUE
	layer = 4.01

//smoothing these things would suck so here you go. i have no idea why you would want these buildable. map them manually
/obj/structure/road_barrier/bot_in
	icon_state = "guard_bot_in"

/obj/structure/road_barrier/top_in
	icon_state = "guard_top_in"

/obj/structure/road_barrier/bot_end
	icon_state = "guard_bot_end"

/obj/structure/road_barrier/top_end
	icon_state = "guard_top_end"

/obj/structure/road_barrier/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/road_barrier/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/chainlink_fence
	name = "chainlink industrial fencing"
	desc = "A tall, imposing metal fence. Not to be confused with the slightly more popular Chainlink of recent years."
	icon = 'icons/obj/structure/industrial/fencing_tall.dmi'
	density = TRUE
	icon_state = "fence"
	color = null
	anchored = TRUE
	can_be_unanchored = FALSE
	layer = 3.01

/obj/structure/chainlink_fence/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/chainlink_fence/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/rope_railing
	name = "wooden rope"
	desc = "A simple rope tied off to protect against careless trespass."
	icon = 'icons/obj/structure/urban/wood.dmi'
	icon_state = "rope-railing"
	density = TRUE
	color = null
	anchored = TRUE
	can_be_unanchored = FALSE
	layer = 3.01

/obj/structure/rope_railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/rope_railing/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/rope_post
	name = "wooden rope post"
	desc = "A simple pole driven into something, for tying ropes onto."
	icon = 'icons/obj/structure/urban/wood.dmi'
	icon_state = "post"
	density = FALSE
	layer = OBJ_LAYER
	layer = 3

/obj/structure/statue
	name = "statue of Neopolymus"
	desc = "A statue of Neopolymus, an IPC brought to fame in Tau Ceti as the first to be held to trial for the murder of a Human. A heated debate continues today as to the validity and bias of the court as the positronic ultimately met a memory wipe, followed by deconstruction."
	icon = 'icons/obj/structure/urban/statues.dmi'
	icon_state = "neopolymus"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/sign/urban
	name = "building sign"
	desc = "A sign labeling the structure it finds itself on."
	icon_state = "goldenplaque"

/obj/structure/sign/urban/konyang
	name = "convenience store sign"
	desc = "A sign labeling the structure as a 24-7 MINI MART. Convenient!"
	icon = 'icons/obj/structure/urban/konyang_signs.dmi'
	icon_state = "shop_sign"

/obj/structure/sign/urban/konyang/police
	name = "police station sign"
	desc = "A sign labeling the structure as a Konyang police department building."
	icon_state = "police_sign"

/obj/structure/sign/urban/konyang/robotics
	name = "robotics clinic sign"
	desc = "A sign labeling the structure as a robotics and clinical support building."
	icon_state = "krc_sign"

/obj/structure/sign/urban/konyang/bar
	name = "club and bar sign"
	desc = "A sign labeling the structure as the Resting Tiger nightclub and bar."
	icon_state = "bar_sign"

/obj/structure/sign/urban/konyang/arcade
	name = "arcade sign"
	desc = "A sign labeling the structure as a very cool arcade."
	icon_state = "arcade_sign"

/obj/structure/sign/urban/konyang/pharmacy
	name = "pharmacy sign"
	desc = "A sign labeling the structure as a Konyang health and supply pharmacy."
	icon_state = "pharmacy_sign"

/obj/structure/window/urban
	icon = 'icons/obj/structure/urban/windows_tall.dmi'
	icon_state = "wood"
	basestate = "wood"
	maxhealth = 60

/obj/structure/window/urban/framed
	icon_state = "wood_framed"
	basestate = "wood_framed"

/obj/machinery/door/urban
	name = "wooden panel door"
	desc = "A delicate wooden door with a pristine bronze knob."
	icon = 'icons/obj/structure/urban/unique_simple_doors.dmi'
	icon_state = "wood_closed"
	pixel_x = -16
	pixel_y = -16
	var/base_icon = "wood"

/obj/machinery/door/urban/update_icon()
	if(density)
		icon_state = "[base_icon]_closed"
	else
		icon_state = "[base_icon]_open"
	return

/obj/machinery/door/urban/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("[base_icon]c0", src)
			else
				flick("[base_icon]c0", src)
		if("closing")
			if(p_open)
				flick("[base_icon]c1", src)
			else
				flick("[base_icon]c1", src)
	return
