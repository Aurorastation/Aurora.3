/obj/item/organ/internal/augment/tesla
	name = "tesla spine"
	icon = 'icons/mob/human_races/augments_external.dmi'
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	active_overlay = TRUE
	active_emissive = TRUE
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
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
		to_chat(owner, FONT_LARGE(SPAN_DANGER("You feel your [src.name] surge with energy!")))
		spark(get_turf(owner), 3)
		addtimer(CALLBACK(src, PROC_REF(disarm)), recharge_time MINUTES)
		if(is_bruised() && prob(50))
			owner.electrocute_act(40, owner)

/obj/item/organ/internal/augment/tesla/proc/disarm()
	if(actual_charges <= 0)
		return
	actual_charges = min(actual_charges - 1, max_charges)
	if(actual_charges > 0)
		addtimer(CALLBACK(src, PROC_REF(disarm)), recharge_time MINUTES)
	if(is_broken())
		owner.visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
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

	if(!.)
		return FALSE

	owner.visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
	playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
	tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/tesla/massive
	name = "massive tesla spine"
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/tesla_body_augments.dmi'
	species_restricted = list(SPECIES_TAJARA_TESLA_BODY)
