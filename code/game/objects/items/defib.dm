#define DEFIB_TIME_LIMIT (8 MINUTES) //past this many seconds, defib is useless. Currently 8 Minutes
#define DEFIB_TIME_LOSS  (2 MINUTES) //past this many seconds, brain damage occurs. Currently 2 minutes

//backpack item
/obj/item/defibrillator
	name = "auto-resuscitator"
	desc = "A device that delivers powerful shocks via detachable paddles to resuscitate incapacitated patients."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	contained_sprite = TRUE
	force = 11
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2)
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1500, MATERIAL_ALUMINIUM = 1000)
	action_button_name = "Toggle Paddles"

	var/obj/item/shockpaddles/linked/paddles
	var/obj/item/cell/bcell

/obj/item/defibrillator/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(bcell)
		. += "The charge meter is showing <b>[bcell.percent()]%</b> charge left."
	else
		. += "There is no cell inside."

/obj/item/defibrillator/Initialize() //starts without a cell for rnd
	. = ..()
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)

	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()

/obj/item/defibrillator/attack_self(mob/user)
	. = ..()
	toggle_paddles()

/obj/item/defibrillator/Destroy()
	. = ..()
	QDEL_NULL(paddles)
	QDEL_NULL(bcell)

/obj/item/defibrillator/loaded //starts with regular power cell for R&D to replace later in the round.
	bcell = /obj/item/cell

/obj/item/defibrillator/update_icon()
	var/list/new_overlays = list()

	if(paddles) //in case paddles got destroyed somehow.
		if(paddles.loc == src)
			new_overlays += "[initial(icon_state)]-paddles"
		if(bcell && bcell.check_charge(paddles.chargecost))
			if(!paddles.safety)
				new_overlays += "[initial(icon_state)]-emagged"
			else
				new_overlays += "[initial(icon_state)]-powered"

	if(bcell)
		var/ratio = Ceil(bcell.percent()/25) * 25
		new_overlays += "[initial(icon_state)]-charge[ratio]"
	else
		new_overlays += "[initial(icon_state)]-nocell"

	overlays = new_overlays

/obj/item/defibrillator/ui_action_click()
	toggle_paddles()

/obj/item/defibrillator/attack_hand(mob/user)
	if(loc == user)
		toggle_paddles()
	else
		..()

/obj/item/defibrillator/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!paddles)
		to_chat(user, SPAN_WARNING("The paddles are missing!"))
		return

	if(paddles.loc != src)
		reattach_paddles() //Remove from their hands and back onto the defib unit
		return

	if(!slot_check() && slot_flags)
		to_chat(user, SPAN_WARNING("You need to equip [src] before taking out [paddles]."))
	else
		if(!usr.put_in_any_hand_if_possible(paddles)) //Detach the paddles into the user's hands
			to_chat(user, SPAN_WARNING("You need a free hand to hold the paddles!"))
		update_icon() //success

/obj/item/defibrillator/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	. = ..()
	if(ismob(loc) && slot_flags)
		var/mob/M = src.loc
		if(use_check_and_message(M))
			return
		if(!M.unEquip(src))
			return
		add_fingerprint(user)
		M.put_in_active_hand(src)
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(Adjacent(H))
				if(!H.put_in_active_hand(paddles))
					to_chat(H, SPAN_WARNING("You need a free hand to take out the paddles!"))

/obj/item/defibrillator/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item == paddles)
		reattach_paddles(user)
	else if(istype(attacking_item, /obj/item/cell))
		if(bcell)
			to_chat(user, SPAN_NOTICE("\The [src] already has a cell."))
		else
			if(!user.unEquip(attacking_item))
				return
			attacking_item.forceMove(src)
			bcell = attacking_item
			to_chat(user, SPAN_NOTICE("You install a cell in \the [src]."))
			update_icon()

	else if(attacking_item.isscrewdriver())
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from \the [src]."))
			update_icon()
	else
		return ..()

/obj/item/defibrillator/emag_act(uses, mob/user)
	if(paddles)
		return paddles.emag_act(uses, user, src)
	return NO_EMAG_ACT

// Checks that the base unit is in the correct slot to be used, or next to us.
/obj/item/defibrillator/proc/slot_check()
	if(ismob(loc))
		var/mob/M = loc
		if(!istype(M))
			return FALSE //not equipped
		if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
			return TRUE
		if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
			return TRUE
	return FALSE

/obj/item/defibrillator/dropped(mob/user)
	..()
	if(slot_flags)
		//Paddles attached to an equippable base unit should never exist outside of their base unit or the mob equipping the base unit.
		reattach_paddles()

/obj/item/defibrillator/proc/reattach_paddles()
	if(!paddles)
		return

	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		if(M.drop_from_inventory(paddles, src))
			to_chat(M, SPAN_NOTICE("\The [paddles] snap back into the main unit."))
	else
		paddles.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/defibrillator/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)

/obj/item/defibrillator/compact/loaded
	bcell = /obj/item/cell/high

/obj/item/defibrillator/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/shockpaddles/linked/combat

/obj/item/defibrillator/compact/combat/loaded
	bcell = /obj/item/cell/high

/obj/item/shockpaddles/linked/combat
	combat = TRUE
	safety = FALSE
	chargetime = (1 SECONDS)

//paddles

/obj/item/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	contained_sprite = TRUE
	gender = PLURAL
	force = 2
	throwforce = 6
	w_class = WEIGHT_CLASS_BULKY

	var/safety = TRUE //if you can zap people with the paddles on harm mode
	var/combat = FALSE //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 100 //units of charge
	var/burn_damage_amt = 5

	var/wielded = FALSE
	var/cooldown = 0
	var/busy = FALSE

/obj/item/shockpaddles/attack_self(mob/user)
	. = ..()
	if(!wielded)
		wield()
	else
		unwield()

/obj/item/shockpaddles/proc/set_cooldown(delay)
	cooldown = 1
	update_icon()

	addtimer(CALLBACK(src, PROC_REF(recharge)), delay)

/obj/item/shockpaddles/proc/recharge()
	if(cooldown)
		cooldown = 0
		update_icon()

		make_announcement("beeps, \"Unit is re-energized.\"", "notice")
		playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/shockpaddles/proc/wield()
	var/mob/living/carbon/human/M = loc
	if(istype(M))
		var/obj/A = M.get_inactive_hand()
		if(A)
			to_chat(M, SPAN_WARNING("Your other hand is occupied!"))
			return
		if(!wielded)
			wielded = TRUE
			name = "[initial(name)] (wielded)"
			var/obj/item/offhand/O = new(M)
			O.name = "[initial(name)] - offhand"
			O.desc = "The second set of paddles."
			M.put_in_inactive_hand(O)
			update_icon()

/obj/item/shockpaddles/proc/unwield()
	wielded = FALSE
	if(ismob(loc))
		var/mob/living/M = loc
		var/obj/item/offhand/O = M.get_inactive_hand()
		if(istype(O))
			O.unwield()
	name = initial(name)
	update_icon()

/obj/item/shockpaddles/dropped(mob/user)
	..()
	if(user)
		var/obj/item/offhand/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
		return unwield()

/obj/item/shockpaddles/can_swap_hands(var/mob/user)
	if(wielded)
		return FALSE
	return TRUE

/obj/item/shockpaddles/update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return FALSE
	if(!check_charge(chargecost))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have enough charge left to do that."))
		return FALSE
	if(!wielded && !isrobot(user))
		to_chat(user, SPAN_WARNING("You need to wield the paddles with both hands before you can use them on someone!"))
		return FALSE
	if(cooldown)
		to_chat(user, SPAN_WARNING("\The [src] are re-energizing!"))
		return FALSE
	return TRUE

//Checks for various conditions to see if the mob is revivable
/obj/item/shockpaddles/proc/can_defib(mob/living/carbon/human/H) //This is checked before doing the defib operation
	if((H.species.flags & NO_SCAN) || H.isSynthetic())
		return "buzzes, \"Unrecogized physiology. Operation aborted.\""

	if(!check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

/obj/item/shockpaddles/proc/can_revive(mob/living/carbon/human/H) //This is checked right before attempting to revive
	if(H.stat == DEAD)
		return "buzzes, \"Resuscitation failed - Severe neurological decay makes recovery of patient impossible. Further attempts futile.\""

/obj/item/shockpaddles/proc/check_contact(mob/living/carbon/human/H)
	if(!combat)
		for(var/obj/item/clothing/cloth in list(H.wear_suit, H.w_uniform))
			if((cloth.body_parts_covered & UPPER_TORSO) && (cloth.item_flags & ITEM_FLAG_THICK_MATERIAL))
				return FALSE
	return TRUE

/obj/item/shockpaddles/proc/check_blood_level(mob/living/carbon/human/H)
	if(!H.should_have_organ(BP_HEART))
		return FALSE
	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
	if(!heart || H.get_blood_volume() < BLOOD_VOLUME_SURVIVE)
		return TRUE
	return FALSE

/obj/item/shockpaddles/proc/check_charge(charge_amt)
	return 0

/obj/item/shockpaddles/proc/checked_use(charge_amt)
	return 0

/obj/item/shockpaddles/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/H = target_mob
	if(!istype(H) || user.a_intent == I_HURT)
		return ..() //Do a regular attack. Harm intent shocking happens as a hit effect

	if(can_use(user, H))
		busy = TRUE
		update_icon()

		do_revive(H, user)

		busy = FALSE
		update_icon()

	return TRUE

//Since harm-intent now skips the delay for deliberate placement, you have to be able to hit them in combat in order to shock people.
/obj/item/shockpaddles/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if(ishuman(target) && can_use(user, target))
		busy = TRUE
		update_icon()

		do_electrocute(target, user, hit_zone)

		busy = FALSE
		update_icon()

		return TRUE

	return ..()

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/shockpaddles/proc/do_revive(mob/living/carbon/human/H, mob/living/user)
	if(!H.client)
		to_chat(find_dead_player(H.ckey, 1), SPAN_NOTICE("Someone is attempting to resuscitate you. Re-enter your body if you want to be revived!"))

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message(SPAN_WARNING("\The [user] begins to place [src] on [H]'s chest."), SPAN_WARNING("You begin to place [src] on [H]'s chest..."))
	if(!do_after(user, 3 SECONDS, H, DO_DEFAULT | DO_USER_UNIQUE_ACT))
		return
	user.visible_message(SPAN_NOTICE("\The [user] places [src] on [H]'s chest."), SPAN_WARNING("You place [src] on [H]'s chest."))
	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	if(check_blood_level(H))
		make_announcement("buzzes, \"Warning - Patient is in hypovolemic shock and may require a blood transfusion.\"", "warning") //also includes heart damage

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message(SPAN_WARNING("\The [H]'s body convulses a bit."))
	playsound(get_turf(src), "bodyfall", 50, 1)
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return
	H.apply_damage(burn_damage_amt, DAMAGE_BURN, BP_CHEST)

	//set oxyloss so that the patient is just barely in crit, if possible
	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(get_turf(src), 'sound/machines/defib_success.ogg', 50, 0)
	H.resuscitate()
	var/obj/item/organ/internal/cell/potato = H.internal_organs_by_name[BP_CELL]
	if(istype(potato) && potato.cell)
		var/obj/item/cell/C = potato.cell
		C.give(chargecost)
	H.AdjustSleeping(-60)
	log_and_message_admins("used \a [src] to revive [key_name(H)].")

/obj/item/shockpaddles/proc/lowskill_revive(mob/living/carbon/human/H, mob/living/user)
	if(prob(60))
		playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
		H.electrocute_act(burn_damage_amt*4, src, def_zone = BP_CHEST)
		user.visible_message(SPAN_WARNING("<i>The paddles were misaligned! \The [user] shocks [H] with \the [src]!</i>"), SPAN_WARNING("The paddles were misaligned! You shock [H] with \the [src]!"))
		return 0
	if(prob(50))
		playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
		user.electrocute_act(burn_damage_amt*2, src, def_zone = BP_L_HAND)
		user.electrocute_act(burn_damage_amt*2, src, def_zone = BP_R_HAND)
		user.visible_message(SPAN_WARNING("<i>\The [user] shocks themselves with \the [src]!</i>"), SPAN_WARNING("You forget to move your hands away and shock yourself with \the [src]!"))
		return 0
	return 1

/obj/item/shockpaddles/proc/do_electrocute(mob/living/carbon/human/H, mob/user, target_zone)
	var/obj/item/organ/external/affecting = H.get_organ(target_zone)
	if(!affecting)
		to_chat(user, SPAN_WARNING("They are missing that body part!"))
		return

	if(safety)
		to_chat(user, SPAN_WARNING("You can't do that while the safety is enabled."))
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message(SPAN_DANGER("\The [user] slaps [src] onto [H]'s [affecting.name]."), SPAN_DANGER("You overcharge [src] and slap them onto [H]'s [affecting.name]."))


	playsound(get_turf(src), 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message(SPAN_WARNING("\The [src] lets out a steadily rising hum..."))

	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(get_turf(src), 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message(SPAN_DANGER("<i>\The [user] shocks [H] with \the [src]!</i>"), SPAN_WARNING("You shock [H] with \the [src]!"))
	playsound(get_turf(src), 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(loc, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.stun_effect_act(2, 120, target_zone)
	var/burn_damage = H.electrocute_act(burn_damage_amt*2, src, def_zone = target_zone)
	if(burn_damage > 15 && H.can_feel_pain())
		H.emote("scream")
	var/obj/item/organ/internal/heart/doki = LAZYACCESS(affecting.internal_organs, BP_HEART)
	if(istype(doki) && doki.pulse && prob(10))
		to_chat(doki, SPAN_DANGER("Your [doki] has stopped!"))
		doki.pulse = PULSE_NONE

	admin_attack_log(user, H, "Electrocuted using \a [src]", "Was electrocuted with \a [src]", "used \a [src] to electrocute")

/obj/item/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	var/deadtime = world.time - M.timeofdeath

	M.switch_from_dead_to_living_mob_list()
	M.timeofdeath = 0
	M.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	M.regenerate_icons()
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

	M.emote("gasp")
	M.Weaken(rand(10,25))
	M.updatehealth()
	apply_brain_damage(M, deadtime)

/obj/item/shockpaddles/proc/apply_brain_damage(mob/living/carbon/human/H, deadtime)
	if(deadtime < DEFIB_TIME_LOSS) return

	if(!H.should_have_organ(BP_BRAIN)) return //no brain

	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
	if(!brain) return //no brain

	var/brain_damage = clamp((deadtime - DEFIB_TIME_LOSS)/(DEFIB_TIME_LIMIT - DEFIB_TIME_LOSS)*brain.max_damage, H.getBrainLoss(), brain.max_damage)
	H.setBrainLoss(brain_damage)

/obj/item/shockpaddles/proc/make_announcement(message, msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.")

/obj/item/shockpaddles/emag_act(uses, mob/user, obj/item/defibrillator/base)
	if(istype(src, /obj/item/shockpaddles/linked))
		var/obj/item/shockpaddles/linked/dfb = src
		if(dfb.base_unit)
			base = dfb.base_unit
	if(!base)
		return FALSE
	if(safety)
		safety = 0
		to_chat(user, SPAN_WARNING("You silently disable \the [src]'s safety protocols with the cryptographic sequencer."))
		burn_damage_amt *= 3
		base.update_icon()
		return TRUE
	else
		safety = 1
		to_chat(user, SPAN_NOTICE("You silently enable \the [src]'s safety protocols with the cryptographic sequencer."))
		burn_damage_amt = initial(burn_damage_amt)
		base.update_icon()
		return TRUE

/obj/item/shockpaddles/emp_act(severity)
	. = ..()

	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(get_turf(src), 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(get_turf(src), 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()

/obj/item/shockpaddles/robot
	name = "defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing."
	chargecost = 50
	combat = 1
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	cooldowntime = (3 SECONDS)

/obj/item/shockpaddles/robot/check_charge(charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.check_charge(charge_amt))

/obj/item/shockpaddles/robot/checked_use(charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.checked_use(charge_amt))

/obj/item/shockpaddles/rig
	name = "mounted defibrillator"
	desc = "If you can see this something is very wrong, report this bug."
	cooldowntime = (4 SECONDS)
	chargetime = (1 SECOND)
	chargecost = 150
	safety = FALSE
	wielded = TRUE

/obj/item/shockpaddles/rig/check_charge(charge_amt)
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		return (module.holder && module.holder.cell && module.holder.cell.check_charge(charge_amt))

/obj/item/shockpaddles/rig/checked_use(charge_amt)
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		return (module.holder && module.holder.cell && module.holder.cell.checked_use(charge_amt))

/obj/item/shockpaddles/rig/set_cooldown(delay)
	..()
	if(istype(src.loc, /obj/item/rig_module/device/defib))
		var/obj/item/rig_module/device/defib/module = src.loc
		module.next_use = world.time + delay
/*
	Shockpaddles that are linked to a base unit
*/
/obj/item/shockpaddles/linked
	w_class = WEIGHT_CLASS_BULKY
	var/obj/item/defibrillator/base_unit

/obj/item/shockpaddles/linked/Initialize(mapload, obj/item/defibrillator/defib)
	. = ..()
	base_unit = defib
	update_icon()

/obj/item/shockpaddles/linked/equipped(mob/user, slot, assisted_equip)
	. = ..()
	if(ismob(loc))
		RegisterSignal(loc, COMSIG_MOVABLE_MOVED, PROC_REF(unlatch), TRUE)

/obj/item/shockpaddles/linked/proc/unlatch()
	if(get_dist(loc, base_unit) > 1)
		if(ismob(loc))
			var/mob/M = loc
			to_chat(M, SPAN_WARNING("\The [src] automatically snap back to \the [base_unit]!"))
		base_unit.reattach_paddles()

/obj/item/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/shockpaddles/linked/dropped(mob/user)
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_paddles() //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/shockpaddles/linked/Move()
	. = ..()
	if(loc != base_unit)
		base_unit.reattach_paddles()

/obj/item/shockpaddles/linked/check_charge(charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/shockpaddles/linked/checked_use(charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/shockpaddles/linked/make_announcement(message, msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/shockpaddles/standalone
	desc = "A pair of shockpaddles powered by an experimental miniaturized reactor."
	var/fail_counter = 0

/obj/item/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/shockpaddles/standalone/check_charge(charge_amt)
	return TRUE

/obj/item/shockpaddles/standalone/checked_use(charge_amt)
	SSradiation.radiate(src, charge_amt/12) //just a little bit of radiation. It's the price you pay for being powered by magic I guess
	return TRUE

/obj/item/shockpaddles/standalone/process()
	if(fail_counter > 0)
		SSradiation.radiate(src, (fail_counter * 2))
		fail_counter--
	else
		STOP_PROCESSING(SSprocessing, src)

/obj/item/shockpaddles/standalone/emp_act(severity)
	. = ..()

	var/new_fail = 0

	switch(severity)

		if(EMP_HEAVY)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")

		if(EMP_LIGHT)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, SPAN_WARNING("\The [src] feel pleasantly warm."))

	if(new_fail && !fail_counter)
		START_PROCESSING(SSprocessing, src)
	fail_counter = new_fail

/obj/item/shockpaddles/standalone/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles powered by an experimental miniaturized reactor. It possesses both the ability to penetrate armor and to deliver powerful shocks."
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	combat = TRUE
	safety = FALSE
	chargetime = (1 SECONDS)
	burn_damage_amt = 15

/obj/item/rig_module/device/defib
	name = "mounted defibrillator"
	desc = "A complex Zeng-Hu circuit with two metal electrodes hanging from it."
	icon_state = "defib"

	interface_name = "mounted defibrillator"
	interface_desc = "A prototype defibrillator, palm-mounted for ease of use."

	use_power_cost = 0 //Already handled by defib, but it's 150 Wh, normal defib takes 100
	device = /obj/item/shockpaddles/rig

#undef DEFIB_TIME_LIMIT
#undef DEFIB_TIME_LOSS
