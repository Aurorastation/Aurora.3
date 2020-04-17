/obj/item/organ/internal/augment
	name = "augment"
	icon_state = "augment"
	parent_organ = BP_CHEST
	organ_tag = "augment"
	robotic = 2
	emp_coeff = 2
	is_augment = TRUE
	var/cooldown = 150
	var/action_button_icon = "innards-prosthetic"
	var/activable = FALSE

/obj/item/organ/internal/augment/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/augment/refresh_action_button()
	. = ..()
	if(.)
		if(activable)
			action.button_icon_state = action_button_icon
			if(action.button)
				action.button.UpdateIcon()

/obj/item/organ/internal/augment/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_DANGER("\The [src] is still recharging!"))
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, SPAN_DANGER("You can not use your \the [src] in your current state!"))
			return

		if(is_bruised())
			if(do_bruised_act())
				return FALSE

		if(is_broken())
			if(do_broken_act())
				return FALSE

		owner.last_special = world.time + cooldown


/obj/item/organ/internal/augment/proc/do_broken_act()
	spark(get_turf(owner), 3)
	return TRUE

/obj/item/organ/internal/augment/proc/do_bruised_act()
	spark(get_turf(owner), 3)
	return FALSE

/obj/item/organ/internal/augment/timepiece
	name = "integrated timepiece"
	icon_state = "augment-clock"
	parent_organ = BP_HEAD
	action_button_name = "Actuvate Integrated Timepiece"
	activable = TRUE
	organ_tag = BP_AUG_TIMEPIECE
	action_button_icon = "timepiece"

/obj/item/organ/internal/augment/timepiece/attack_self(var/mob/user)
	. = ..()

	if(.)
		to_chat(owner, "Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day.")
		if (emergency_shuttle.get_status_panel_eta())
			to_chat(owner, SPAN_WARNING("Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()]."))

/obj/item/organ/internal/augment/pda
	name = "integrated pda"
	icon_state = "augment-pda"
	parent_organ = BP_HEAD
	action_button_name = "Activate Integrated PDA"
	activable = TRUE
	organ_tag = BP_AUG_PDA
	action_button_icon = "pdapiece"
	cooldown = 5
	var/obj/item/device/pda/P

/obj/item/organ/internal/augment/pda/Initialize()
	. = ..()
	if(!P)
		P = new /obj/item/device/pda (src)
		P.canremove = 0

/obj/item/organ/internal/augment/pda/attack_self(var/mob/user)
	. = ..()
	if(P)
		if(!P.owner)
			var/obj/item/card/id/idcard = owner.get_active_hand()
			if(istype(idcard))
				P.owner = idcard.registered_name
				P.ownjob = idcard.assignment
				P.ownrank = idcard.rank
				P.name = "Integrated PDA-[P.owner] ([P.ownjob])"
				to_chat(owner, SPAN_NOTICE("Card scanned."))
				P.try_sort_pda_list()
			else
				to_chat(owner, SPAN_NOTICE("No ID data loaded. Please hold your ID to be scanned."))
				return

		P.attack_self(user)
	return

/obj/item/organ/internal/augment/pda/emp_act(severity)
	..()
	if(P)
		P = null
		qdel(P)
		if(owner)
			if(owner.can_feel_pain())
				to_chat(owner, SPAN_DANGER("You feel something burn inside your head!"))


/obj/item/organ/internal/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	action_button_icon = "combitool"
	cooldown = 250
	var/augment_type
	var/obj/item/augment
	var/deployed = FALSE
	var/deployment_location
	var/deployment_string

/obj/item/organ/internal/augment/tool/Initialize()
	. = ..()
	if(augment_type)
		augment = new augment_type(src)
		augment.canremove = FALSE

/obj/item/organ/internal/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(!deployed)
			if(!deployment_location)
				if(owner.get_active_hand())
					to_chat(owner, SPAN_DANGER("You must empty your active hand before enabling your [src]!"))
					return

				owner.last_special = world.time + cooldown
				owner.put_in_active_hand(augment)
				owner.visible_message(SPAN_NOTICE("\The [augment] slides out of \the [owner]'s [src.loc]."), SPAN_NOTICE("You deploy \the [augment]!"))
				deployed = TRUE

			else
				if(!owner.equip_to_slot_if_possible(augment, deployment_location))
					to_chat(owner, SPAN_DANGER("You must remove your [deployment_string] before enabling your [src]!"))
					return

				owner.last_special = world.time + cooldown
				owner.visible_message(SPAN_NOTICE("\The [augment] slides out of \the [owner]'s [src.loc]."), SPAN_NOTICE("You deploy \the [augment]!"))
				deployed = TRUE

		else
			owner.last_special = world.time + cooldown
			augment.forceMove(src)
			owner.visible_message(SPAN_NOTICE("\The [augment] slides into \the [owner]'s [src.loc]."), SPAN_NOTICE("You retract \the [augment]!"))
			deployed = FALSE

/obj/item/organ/internal/augment/tool/combitool
	name = "retractable combitool"
	action_button_name = "Deploy Combitool"
	parent_organ = BP_CHEST
	organ_tag = BP_AUG_TOOL
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/internal/augment/health_scanner
	name = "integrated health scanner"
	organ_tag = BP_AUG_HEALTHSCAN

/obj/item/organ/internal/augment/health_scanner/attack_self(var/mob/user)
	. = ..()

	if(.)
		health_scan_mob(owner, owner)

/obj/item/organ/internal/augment/tesla
	name = "tesla spine"
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	var/max_charges = 1
	var/actual_charges = 0
	var/recharge_time = 2 //this is in minutes

/obj/item/organ/internal/augment/tesla/proc/check_shock()
	if(is_broken())
		return FALSE
	if(is_bruised())
		if(prob(50))
			return FALSE
	if(actual_charges >= max_charges)
		return FALSE
	else
		do_tesla_act()
		return TRUE

/obj/item/organ/internal/augment/tesla/proc/do_tesla_act()
	if(owner)
		to_chat(owner, SPAN_DANGER("You feel your \the [src] surge with energy!"))
		spark(get_turf(owner), 3)
		addtimer(CALLBACK(src, .proc/disarm), recharge_time MINUTES)
		if(is_bruised())
			if(prob(50))
				owner.electrocute_act(40, owner)

/obj/item/organ/internal/augment/tesla/proc/disarm()
	if(actual_charges <= 0)
		return
	actual_charges = min(actual_charges-1,max_charges)
	if(actual_charges > 0)
		addtimer(CALLBACK(src, .proc/disarm), recharge_time MINUTES)