/obj/structure/barricade/liquid
	name = "liquid-bag barricade"
	desc = "An advanced version of sandbags, used in conflict since their inception in the late 2300s. These barricades are made of bags that contain non-newtonian liquid that hardens in response to projectile impacts. Easy to set up as well!"
	icon_state = "sandbag1"
	force_level_absorption = 15
	health = BARRICADE_LIQUIDBAG_TRESHOLD_1
	maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_1
	stack_type = /obj/item/stack/liquidbags
	barricade_hitsound = 'sound/weapons/Genhit.ogg'
	barricade_type = "sandbag"
	can_wire = TRUE
	stack_amount = 1
	var/build_stage = BARRICADE_LIQUIDBAG_1

/obj/structure/barricade/liquid/Initialize(mapload, mob/user, var/direction, var/amount)
	if(direction)
		set_dir(direction)

	if(dir == SOUTH)
		pixel_y = -7
	else if(dir == NORTH)
		pixel_y = 7

	for(var/i = 1 to amount-1)
		increment_build_stage()
	. = ..(loc, user)

/obj/structure/barricade/liquid/update_icon()
	..()
	icon_state = "sandbag[build_stage]"

/obj/structure/barricade/liquid/update_damage_state()
	var/changed = FALSE
	if(health <= BARRICADE_LIQUIDBAG_TRESHOLD_4 && build_stage != BARRICADE_LIQUIDBAG_4)
		changed = TRUE
		build_stage = BARRICADE_LIQUIDBAG_4
		maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_4
		stack_amount = 4
	if(health <= BARRICADE_LIQUIDBAG_TRESHOLD_3 && build_stage != BARRICADE_LIQUIDBAG_3)
		changed = TRUE
		build_stage = BARRICADE_LIQUIDBAG_3
		maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_3
		stack_amount = 3
	if(health <= BARRICADE_LIQUIDBAG_TRESHOLD_2 && build_stage != BARRICADE_LIQUIDBAG_2)
		changed = TRUE
		build_stage = BARRICADE_LIQUIDBAG_2
		maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_2
		stack_amount = 2
	if(health <= BARRICADE_LIQUIDBAG_TRESHOLD_1 && build_stage != BARRICADE_LIQUIDBAG_1)
		changed = TRUE
		build_stage = BARRICADE_LIQUIDBAG_1
		maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_1
		stack_amount = 1
	if(changed && is_wired)
		maxhealth += 50

/obj/structure/barricade/liquid/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/crowbar) && user.a_intent != I_HURT)
		var/obj/item/crowbar/ET = W
		user.visible_message(SPAN_NOTICE("[user] starts disassembling [src]."), \
		SPAN_NOTICE("You start disassembling [src]."))
		if(ET.use_tool(src, user, 4 SECONDS))
			user.visible_message(SPAN_NOTICE("[user] disassembles [src]."),
			SPAN_NOTICE("You disassemble [src]."))
			barricade_deconstruct(TRUE)
		return TRUE

	if(istype(W, stack_type))
		var/obj/item/stack/liquidbags/SB = W
		if(build_stage == BARRICADE_LIQUIDBAG_5)
			to_chat(user, SPAN_WARNING("You can't stack more on [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] starts adding more [SB] to [src]."), \
			SPAN_NOTICE("You start adding liquid bags to [src]."))
		for(var/i = build_stage to BARRICADE_LIQUIDBAG_5)
			if(build_stage >= BARRICADE_LIQUIDBAG_5 || !do_after(user, 5, act_target = src) || build_stage >= BARRICADE_LIQUIDBAG_5)
				break
			SB.use(1)
			increment_build_stage()
			update_icon()
		user.visible_message(SPAN_NOTICE("[user] finishes stacking [SB] onto [src]."), \
			SPAN_NOTICE("You stack [SB] onto [src]."))
		return
	else
		. = ..()

/obj/structure/barricade/liquid/barricade_deconstruct(deconstruct)
	if(deconstruct && is_wired)
		new /obj/item/stack/barbed_wire(loc)
	if(stack_type && health > 0)
		new stack_type(loc, stack_amount)
	qdel(src)

/obj/structure/barricade/liquid/proc/increment_build_stage()
	switch(build_stage)
		if(BARRICADE_LIQUIDBAG_1)
			health = BARRICADE_LIQUIDBAG_TRESHOLD_2
			maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_2
			stack_amount = 2
		if(BARRICADE_LIQUIDBAG_2)
			health = BARRICADE_LIQUIDBAG_TRESHOLD_3
			maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_3
			stack_amount = 3
		if(BARRICADE_LIQUIDBAG_3)
			health = BARRICADE_LIQUIDBAG_TRESHOLD_4
			maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_4
			stack_amount = 4
		if(BARRICADE_LIQUIDBAG_4)
			health = BARRICADE_LIQUIDBAG_TRESHOLD_5
			maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_5
			stack_amount = 5
	if(is_wired)
		maxhealth += 50
		health += 50
	build_stage++

/obj/structure/barricade/liquid/wired/Initialize(mapload, mob/user, var/direction, var/amount)
	. = ..()
	health = BARRICADE_LIQUIDBAG_TRESHOLD_5
	maxhealth = BARRICADE_LIQUIDBAG_TRESHOLD_5
	maxhealth += 50
	update_health(-50)
	stack_amount = 5
	can_wire = FALSE
	is_wired = TRUE
	build_stage = BARRICADE_LIQUIDBAG_5
	update_icon()
	climbable = FALSE
