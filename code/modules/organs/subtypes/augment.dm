/obj/item/organ/internal/augment
	name = "augment"
	icon_state = "innards-prosthetic"
	parent_organ = BP_GROIN
	organ_tag = "augment"
	robotic = 2
	emp_coeff = 2
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
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use your \the [src] in your current state!</span>")
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
	parent_organ = BP_HEAD
	action_button_name = "Actuvate Integrated Timepiece"
	activable = TRUE
	action_button_icon = "timepiece"

/obj/item/organ/internal/augment/timepiece/attack_self(var/mob/user)
	. = ..()

	if(.)
		to_chat(owner, "Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day.")
		if (emergency_shuttle.get_status_panel_eta())
			to_chat(owner, "<span class='warning'>Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()].</span>")

/obj/item/organ/internal/augment/pda
	name = "integrated pda"
	parent_organ = BP_HEAD
	action_button_name = "Actuvate Integrated PDA"
	activable = TRUE
	action_button_icon = "pdapiece"
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
				to_chat(owner, "<span class='notice'>Card scanned.</span>")
				P.try_sort_pda_list()
			else
				to_chat(owner, "<span class='notice'>No ID data loaded. Please hold your ID to be scanned.</span>")
				return

		P.attack_self(user)
	return

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
		augment.canremove = 0

/obj/item/organ/internal/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(!deployed)
			if(!deployment_location)
				if(owner.get_active_hand())
					to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
					return

				owner.last_special = world.time + cooldown
				owner.put_in_active_hand(augment)
				owner.visible_message("<span class='notice'>\The [augment] slides out of \the [owner]'s [src.loc].</span>","<span class='notice'>You deploy \the [augment]!</span>")
				deployed = 1

			else
				if(!owner.equip_to_slot_if_possible(augment, deployment_location))
					to_chat(owner, "<span class='danger'>You must remove your [deployment_string] before enabling your [src]!</span>")
					return

				owner.last_special = world.time + cooldown
				owner.visible_message("<span class='notice'>\The [augment] slides out of \the [owner]'s [src.loc].</span>","<span class='notice'>You deploy \the [augment]!</span>")
				deployed = 1

		else
			owner.last_special = world.time + cooldown
			augment.forceMove(src)
			owner.visible_message("<span class='notice'>\The [augment] slides into \the [owner]'s [src.loc].</span>","<span class='notice'>You retract \the [augment]!</span>")
			deployed = 0

/obj/item/organ/internal/augment/tool/combitool
	name = "retractable combitool"
	action_button_name = "Deploy Combitool"
	augment_type = /obj/item/combitool/robotic
