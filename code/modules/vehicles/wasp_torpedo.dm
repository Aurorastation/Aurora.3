/obj/vehicle/bike/wasp_torpedo
	name = "wasp torpedo"
	desc = "A manned torpedo used by the Al'mariist space forces."
	icon = 'icons/obj/wasp_torpedo.dmi'
	icon_state = "torpedo_off"

	desc_info = "Click-drag yourself onto the torpedo to climb onto it.<br>\
		- CTRL-click the torpedo to toggle the engine.<br>\
		- ALT-click to toggle the kickstand which prevents movement by driving and dragging.<br>\
		- Click the resist button or type \"resist\" in the command bar at the bottom of your screen to get off the torpedo.<br>\
		- CTRL-SHIFT-click to cause it to charge and detonate on impact."

	health = 300
	maxhealth = 300

	fire_dam_coeff = 0.5
	brute_dam_coeff = 0.4

	mob_offset_y = 1

	bike_icon = "torpedo"
	dir = EAST

	land_speed = 3
	space_speed = 5

	storage_type = null

	pixel_y = -16
	pixel_x = -16

	ion_type = /datum/effect_system/ion_trail/explosion

	var/primmed = FALSE

/obj/item/mesmetron/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	. = ..()

/obj/vehicle/bike/wasp_torpedo/collide_act(var/atom/movable/AM)
	if(!AM.density)
		return
	if(!primmed)
		return

	torpedo_explosion()

/obj/vehicle/bike/wasp_torpedo/proc/torpedo_explosion()
	STOP_PROCESSING(SSfast_process, src)
	primmed = FALSE
	if(prob(25) && buckled) //has a chance of being thrown off when it explodes
		if(ishuman(buckled))
			var/mob/living/carbon/human/C = buckled
			C.visible_message(SPAN_DANGER ("\The [C] is thrown off from \the [src]!"))
			unload(C)
			C.throw_at(get_edge_target_turf(loc, loc.dir), 5, 1)
			C.apply_effect(2, WEAKEN)
	if(buckled)
		unload(buckled)
		if(ishuman(buckled))
			var/mob/living/carbon/human/V = buckled
			V.apply_effect(2, WEAKEN)
	explosion(loc, 1, 2, 4, 8)
	visible_message(SPAN_DANGER ("\The [src] detonates!"))
	qdel(src)

/obj/vehicle/bike/wasp_torpedo/proc/prime(var/mob/user)
	if(primmed)
		if(user)
			to_chat(src, SPAN_WARNING("The priming button is jammed. There is no turning back now."))
		return
	if(!on)
		turn_on()
	kickstand = FALSE
	visible_message(SPAN_DANGER ("\The [src] begins to beep omnisouly before charging!"))
	playsound(get_turf(src), 'sound/items/countdown.ogg', 75, 1, -3)
	primmed = TRUE
	land_speed = 10
	space_speed = 10
	START_PROCESSING(SSprocessing, src)

/obj/vehicle/bike/wasp_torpedo/CtrlShiftClick(var/mob/user)
	prime(user)

/obj/vehicle/bike/wasp_torpedo/process()
	if(!primmed)
		return
	Move(get_step(src, dir))

/obj/vehicle/bike/wasp_torpedo/turn_off()
	if(primmed)
		return
	..()

/obj/vehicle/bike/wasp_torpedo/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(prob(10))
			torpedo_explosion()
	..()

/obj/vehicle/bike/wasp_torpedo/ex_act(severity)
	switch(severity)
		if(1.0)
			torpedo_explosion()
			return
		if(2.0)
			if(prob(50))
				torpedo_explosion()
	..()