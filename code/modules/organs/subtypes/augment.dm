/obj/item/organ/internal/augment
	name = "augment"
	icon_state = "augment"
	parent_organ = BP_CHEST
	organ_tag = "augment"
	robotic = 2
	emp_coeff = 2
	is_augment = TRUE
	species_restricted = list("Human","Off-Worlder Human",
							"Tajara", "Zhan-Khazan Tajara", "M'sai Tajara",
							"Unathi", "Aut'akh Unathi", "Skrell",
							"Baseline Frame", "Hephaestus G1 Industrial Frame",
							"Hephaestus G2 Industrial Frame", "Xion Industrial Frame",
							"Zeng-Hu Mobility Frame", "Bishop Accessory Frame")
	var/cooldown = 150
	var/action_button_icon = "augment"
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
			to_chat(owner, SPAN_WARNING("\The [src] is still recharging!"))
			return FALSE

		if(use_check_and_message(owner))
			return FALSE

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
	action_button_name = "Activate Integrated Timepiece"
	activable = TRUE
	organ_tag = BP_AUG_TIMEPIECE
	action_button_icon = "augment-clock"

/obj/item/organ/internal/augment/timepiece/attack_self(var/mob/user)
	. = ..()

	if(.)
		to_chat(owner, SPAN_NOTICE("Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day."))
		if (emergency_shuttle.get_status_panel_eta())
			to_chat(owner, SPAN_WARNING("Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()]."))

/obj/item/organ/internal/augment/pda
	name = "integrated PDA"
	icon_state = "augment-pda"
	parent_organ = BP_HEAD
	action_button_name = "Activate Integrated PDA"
	activable = TRUE
	organ_tag = BP_AUG_PDA
	action_button_icon = "augment-pda"
	cooldown = 5
	var/obj/item/device/pda/P

/obj/item/organ/internal/augment/pda/Initialize()
	. = ..()
	if(!P)
		P = new /obj/item/device/pda(src)
		P.canremove = FALSE

/obj/item/organ/internal/augment/pda/attack_self(mob/user)
	. = ..()
	if(.)
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
					to_chat(owner, SPAN_WARNING("No ID data loaded. Please hold your ID to be scanned."))
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
				to_chat(owner, FONT_LARGE(SPAN_DANGER("You feel something burn inside your head!")))
				var/obj/item/organ/external/O = owner.get_organ(BP_HEAD)
				if(O)
					O.add_pain(30)

/obj/item/organ/internal/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	cooldown = 10
	activable = TRUE
	var/augment_type
	var/obj/item/augment
	var/deployed = FALSE
	var/deployment_location
	var/deployment_string

/obj/item/organ/internal/augment/tool/Initialize()
	. = ..()
	if(augment_type)
		augment = new augment_type(src)

/obj/item/organ/internal/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(!deployed)
			if(!deployment_location)
				if(owner.get_active_hand())
					to_chat(owner, SPAN_WARNING("You must empty your active hand before enabling your [src]!"))
					return

				owner.last_special = world.time + cooldown
				owner.put_in_active_hand(augment)
				augment.canremove = FALSE
				owner.visible_message(SPAN_NOTICE("\The [augment] slides out of \the [owner]'s [src.loc]."), SPAN_NOTICE("You deploy \the [augment]!"))
				deployed = TRUE

			else
				if(!owner.equip_to_slot_if_possible(augment, deployment_location))
					to_chat(owner, SPAN_WARNING("You must remove your [deployment_string] before enabling your [src]!"))
					return

		else
			augment.canremove = TRUE
			owner.drop_from_inventory(augment, src)
			owner.visible_message(SPAN_NOTICE("\The [augment] slides into \the [owner]'s [src.loc]."), SPAN_NOTICE("You retract \the [augment]!"))
			deployed = FALSE

/obj/item/organ/internal/augment/tool/combitool
	name = "retractable combitool"
	icon_state = "augment-tool"
	action_button_name = "Deploy Combitool"
	action_button_icon = "augment-tool"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_TOOL
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/internal/augment/tool/combitool/left
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/tool/pen
	name = "retractable combipen"
	action_button_name = "Deploy Combipen"
	action_button_icon = "combipen"
	organ_tag = BP_AUG_PEN
	augment_type = /obj/item/pen/multi
	cooldown = 10
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/tool/pen/left
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/tool/lighter
	name = "retractable lighter"
	action_button_name = "Deploy lighter"
	action_button_icon = "lighter"
	organ_tag = BP_AUG_LIGHTER
	augment_type = /obj/item/flame/lighter/zippo
	cooldown = 10
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/tool/lighter/left
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/health_scanner
	name = "integrated health scanner"
	action_button_icon = "health"
	organ_tag = BP_AUG_HEALTHSCAN
	cooldown = 8

/obj/item/organ/internal/augment/health_scanner/attack_self(var/mob/user)
	. = ..()

	if(.)
		health_scan_mob(owner, owner)

/obj/item/organ/internal/augment/tesla
	name = "tesla spine"
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	species_restricted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	var/max_charges = 1
	var/actual_charges = 0
	var/recharge_time = 5 //this is in minutes

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
		to_chat(owner, SPAN_DANGER("You feel your [src.name] surge with energy!"))
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
	if(is_broken())
		visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
		playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
		tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/tesla/advanced
	name = "advanced tesla spine"
	max_charges = 15
	cooldown = 50
	emp_coeff = 1
	action_button_icon = "tesla_spine"
	action_button_name = "Activate Tesla Coil"
	activable = TRUE

/obj/item/organ/internal/augment/tesla/advanced/attack_self(var/mob/user)
	. = ..()

	if(.)
		visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
		playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
		tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/eye_sensors
	name = "integrated eye sensors"
	icon_state = "augment_eyes"
	cooldown = 25
	organ_tag = BP_AUG_EYE_SENSORS
	action_button_name = "Toggle Eyes Sensors"

	var/static/list/hud_types = list(
		"Disabled",
		"Security",
		"Medical")

	var/selected_hud = "Disabled"

/obj/item/organ/internal/augment/eye_sensors/attack_self(var/mob/user)
	. = ..()

	if(.)

		var/choice = input("Select the Sensor Type.", "Bionic Eyes Sensors") as null|anything in hud_types

		selected_hud = choice

/obj/item/organ/internal/augment/eye_sensors/process()
	..()

	if(!owner)
		return

	switch(selected_hud)

		if("Security")
			req_access = list(access_security)
			if(allowed(owner))
				process_sec_hud(owner, 1)

		if("Medical")
			req_access = list(access_medical)
			if(allowed(owner))
				process_med_hud(owner, 1)

/obj/item/organ/internal/augment/eye_sensors/emp_act(severity)
	..()
	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return
	E.take_damage(5)

/obj/item/organ/internal/augment/cyber_hair
	name = "synthetic hair extensions"
	cooldown = 20
	action_button_icon = "cyber_hair"
	organ_tag = BP_AUG_HAIR
	activable = TRUE
	action_button_name = "Activate Synthetic Hair Extensions"

/obj/item/organ/internal/augment/cyber_hair/attack_self(var/mob/user)
	. = ..()

	if(.)
		owner.visible_message(SPAN_NOTICE("\The [owner]'s hair begins to rapidly shift in shape and length."))
		owner.change_appearance(APPEARANCE_ALL_HAIR, owner.loc, owner, check_species_whitelist = 1)

/obj/item/organ/internal/augment/suspension
	name = "calf suspension"
	icon_state = "suspension"
	organ_tag = BP_AUG_SUSPENSION
	parent_organ = BP_GROIN
	min_broken_damage = 20
	max_damage = 20
	var/suspension_mod = 0.8

/obj/item/organ/internal/augment/suspension/advanced
	name = "advanced calf suspension"
	min_broken_damage = 50
	max_damage = 50
	suspension_mod = 0

/obj/item/organ/internal/augment/taste_booster
	name = "taste booster"
	organ_tag = BP_AUG_TASTE_BOOSTER
	parent_organ = BP_HEAD
	var/new_taste = TASTE_SENSITIVE //this will replace the species' taste var

/obj/item/organ/internal/augment/taste_booster/dull
	name = "taste duller"
	new_taste = TASTE_DULL

/obj/item/organ/internal/augment/radio
	name = "integrated radio"
	organ_tag = BP_AUG_RADIO
	parent_organ = BP_HEAD
	action_button_icon = "radio"
	activable = TRUE
	cooldown = 15
	action_button_name = "Activate Integrated Radio"
	var/obj/item/device/radio/off/P

/obj/item/organ/internal/augment/radio/Initialize()
	. = ..()
	if(!P)
		P = new /obj/item/device/radio/off(src)
		P.canremove = FALSE

/obj/item/organ/internal/augment/radio/attack_self(mob/user)
	. = ..()
	if(.)
		if(P)
			P.attack_self(user)
	return

/obj/item/organ/internal/augment/radio/emp_act(severity)
	..()
	if(P)
		P = null
		qdel(P)
		if(owner)
			if(owner.can_feel_pain())
				to_chat(owner, FONT_LARGE(SPAN_DANGER("You feel something burn inside your head!")))
				var/obj/item/organ/external/O = owner.get_organ(BP_HEAD)
				if(O)
					O.add_pain(30)

/obj/item/organ/internal/augment/fuel_cell
	name = "integrated fuel cell"
	organ_tag = BP_AUG_FUEL_CELL
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/air_analyzer
	name = "integrated air analyzer"
	organ_tag = BP_AUG_AIR_ANALYZER
	parent_organ = BP_HEAD
	action_button_icon = "atmos"
	action_button_name = "Activate Air Analyzer"

/obj/item/organ/internal/augment/air_analyzer/attack_self(var/mob/user)
	. = ..()
	if(.)
		analyze_gases(src, user)
