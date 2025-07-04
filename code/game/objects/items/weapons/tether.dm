GLOBAL_LIST_INIT_TYPED(all_tethers, /obj/item/tethering_device, list())

/obj/item/tethering_device
	name = "tethering device"
	desc = "A device used by explorers to keep track of partners by way of electro-tether."
	desc_info = "Use in-hand to activate, must be on the same level and within fifteen tiles of another device to latch. Tethers are colour coded by distance."
	icon = 'icons/obj/item/device/gps.dmi'
	icon_state = "gps"
	item_state = "radio"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	force = 1
	var/active = FALSE
	var/list/linked_tethers = list()
	var/tether_range = 15
	var/list/active_beams = list()

/obj/item/tethering_device/Initialize(mapload, ...)
	. = ..()
	GLOB.all_tethers += src

/obj/item/tethering_device/update_icon()
	ClearOverlays()
	if(active)
		AddOverlays("gps_on")

/obj/item/tethering_device/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	deactivate()
	GLOB.all_tethers -= src
	return ..()

/obj/item/tethering_device/attack_self(mob/user)
	active = !active
	update_icon()
	var/msg = "You [active ? "activate" : "deactivate"] \the [src]."
	to_chat(user, SPAN_NOTICE(msg))
	if(active)
		activate()
	else
		deactivate()


/obj/item/tethering_device/process()
	var/turf/our_turf = get_turf(src)
	for(var/tether in GLOB.all_tethers - src)
		var/obj/item/tethering_device/TD = tether
		if(!TD.active)
			continue
		var/turf/target_turf = get_turf(TD)
		if(our_turf == target_turf)
			continue
		if(target_turf.z != our_turf.z)
			continue
		if(get_dist(target_turf, our_turf) > tether_range)
			continue
		if(TD in linked_tethers)
			continue
		if(src in TD.linked_tethers)
			continue
		tether(TD)

/obj/item/tethering_device/emp_act(severity)
	. = ..()
	AddOverlays("gps_emp")
	deactivate()

/obj/item/tethering_device/proc/activate()
	START_PROCESSING(SSprocessing, src)

/obj/item/tethering_device/proc/deactivate()
	STOP_PROCESSING(SSprocessing, src)
	for(var/beam in active_beams)
		var/datum/beam/exploration/B = active_beams[beam]
		B.End()
	for(var/tether in GLOB.all_tethers)
		var/obj/item/tethering_device/TD = tether
		TD.untether(src)

/obj/item/tethering_device/proc/tether(var/obj/item/tethering_device/TD)
	linked_tethers |= TD
	var/datum/beam/exploration/B = new(src, TD, beam_icon_state = "explore_beam", time = -1, maxdistance = tether_range)
	if(istype(B) && !QDELING(B))
		B.owner = src
		B.Start()
		active_beams[TD] = B

// untethering logic is primarily dictated by the beam itself, who will end if the max distance is reached, and call this proc
/obj/item/tethering_device/proc/untether(var/obj/item/tethering_device/TD, var/destroy_beam = TRUE)
	linked_tethers -= TD
	if(!destroy_beam)
		return
	var/datum/beam/exploration/B = active_beams[TD]
	if(B)
		B.End()
