/obj/item/organ/augment
	name = "aug"
	icon = 'icons/obj/surgery.dmi'
	var/action_icon = "ams"

	robotic = 2

	emp_coeff = 1

	var/online = 0
	var/list/install_locations = list()

/obj/item/organ/augment/proc/installation_instructions(var/obj/item/organ/external/E)
	return 1

/obj/item/organ/augment/refresh_action_button()
	. = ..()
	if(.)
		if(!online)
			return
		action.button_icon_state = action_icon
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!online)
			return

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

/obj/item/organ/augment/process()
	..()
	if(!online)
		return

/////////////////
/////////////////
/////////////////
/obj/item/organ/augment/timepiece
	name = "integrated timepiece"
	action_icon = "time"

/obj/item/organ/augment/timepiece/attack_self(var/mob/user)
	. = ..()
	user << "Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day."
	if (emergency_shuttle.get_status_panel_eta())
		user << "<span class='warning'>Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()].</span>"

/obj/item/organ/augment/pda
	name = "integrated PDA"
	action_icon = "pda"
	var/obj/item/device/pda/P

/obj/item/organ/augment/pda/Initialize()
	. = ..()
	if(!P)
		P = new /obj/item/device/pda (src)
		P.canremove = 0

/obj/item/organ/augment/pda/timepiece/attack_self(var/mob/user)
	. = ..()
	if(P)
		if(!P.owner)
			var/obj/item/weapon/card/id/idcard = owner.get_active_hand()
			if(istype(idcard))
				P.owner = idcard.registered_name
				P.ownjob = idcard.assignment
				P.ownrank = idcard.rank
				P.name = "Integrated PDA-[P.owner] ([P.ownjob])"
				user << "<span class='notice'>Card scanned.</span>"
				P.try_sort_pda_list()
			else
				user << "<span class='notice'>No ID data loaded. Please hold your ID to be scanned.</span>"
				return

		P.attack_self(user)
	return


/////////////////
//TOOL AUGMENTS// - they spawn a tool when they operate
/////////////////

/obj/item/organ/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	action_icon = "combitool"
	var/augment_type
	var/obj/item/augment
	var/deployed = 0
	var/cooldown = 100
	install_locations = list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)

/obj/item/organ/augment/tool/Initialize()
	. = ..()
	if(augment_type)
		augment = new augment_type(src)
		augment.canremove = 0

/obj/item/organ/augment/tool/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "digitool"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(!deployed)
			if(owner.get_active_hand())
				to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
				return

			owner.last_special = world.time + cooldown
			owner.put_in_active_hand(augment)
			owner.visible_message("<span class='notice'>\The [augment] slides out of \the [owner]'s [src].</span>","<span class='notice'>You deploy \the [augment]!</span>")
			deployed = 1
		else
			owner.last_special = world.time + cooldown
			augment.forceMove(src)
			owner.visible_message("<span class='notice'>\The [augment] slides into \the [owner]'s [src].</span>","<span class='notice'>You retract \the [augment]!</span>")
			deployed = 0

/obj/item/organ/augment/tool/combitool
	name = "retractable combitool"
	action_button_name = "Deploy Combitool"
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/augment/tool/combipen
	name = "retractable combipen"
	action_button_name = "Deploy Combipen"
	action_icon = "pen"
	augment_type = /obj/item/weapon/pen/multi
	cooldown = 10

/obj/item/organ/augment/tool/healthanalyzer
	name = "retractable health analyzer"
	action_button_name = "Deploy Health Analyzer"
	action_icon = "health"
	augment_type = /obj/item/device/healthanalyzer
	cooldown = 50