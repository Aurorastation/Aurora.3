
/obj/machinery/artifact
	name = "alien artifact"
	desc = "A large alien device."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano00"
	var/icon_num = 0
	density = 1
	var/datum/artifact_effect/my_effect
	var/datum/artifact_effect/secondary_effect
	var/being_used = 0

/obj/machinery/artifact/Initialize()
	. = ..()

	//setup primary effect - these are the main ones (mixed)
	var/effecttype = pick(subtypesof(/datum/artifact_effect))
	my_effect = new effecttype(src)

	//75% chance to have a secondary stealthy (and mostly bad) effect
	if(prob(75))
		effecttype = pick(subtypesof(/datum/artifact_effect))
		secondary_effect = new effecttype(src)
		if(prob(75))
			secondary_effect.ToggleActivate(0)

	icon_num = rand(0,13)
	icon_state = "ano[icon_num]0"
	if(icon_num == 7 || icon_num == 8)
		name = "large alien crystal"
		desc = pick("It shines faintly as it catches the light.",\
		"It appears to have a faint inner glow.",\
		"It seems to draw you inward as you look it at.",\
		"Something twinkles faintly as you look at it.",\
		"It's mesmerizing to behold.")
		if(prob(75))
			my_effect.trigger = TRIGGER_ENERGY
	else if(icon_num == 1 || icon_num == 6)
		desc = "There appears to be some kind of environmental scanner on it."
		if(prob(75))
			my_effect.trigger = rand(5,8)
	else if(icon_num == 9 || icon_num == 11 || icon_num == 13)
		name = "alien computer"
		if(prob(75))
			my_effect.trigger = TRIGGER_TOUCH
	else if(icon_num == 2 || icon_num == 3 || icon_num == 4)
		desc = "A large alien device, there appear to be vents in the side."
		if(prob(75))
			my_effect.trigger = rand(7,12)
	else if(icon_num == 10 || icon_num == 12)
		name = "sealed alien pod"
		if(prob(75))
			my_effect.trigger = rand(1,4)

/obj/machinery/artifact/Destroy()
	QDEL_NULL(my_effect)
	QDEL_NULL(secondary_effect)

	. = ..()

/obj/machinery/artifact/process()

	var/turf/L = loc
	if(isnull(L) || !istype(L)) 	// We're inside a container or on null turf, either way stop processing effects
		return

	if(my_effect)
		my_effect.process()
	if(secondary_effect)
		secondary_effect.process()

	if(pulledby)
		CollidedWith(pulledby)

	//if either of our effects rely on environmental factors, work that out
	var/trigger_cold = 0
	var/trigger_hot = 0
	var/trigger_phoron = 0
	var/trigger_oxy = 0
	var/trigger_co2 = 0
	var/trigger_nitro = 0
	if( (my_effect.trigger >= TRIGGER_HEAT && my_effect.trigger <= TRIGGER_NITRO) || (my_effect.trigger >= TRIGGER_HEAT && my_effect.trigger <= TRIGGER_NITRO) )
		var/turf/T = get_turf(src)
		if(!istype(T)) return
		var/datum/gas_mixture/env = T.return_air()
		if(env)
			if(env.temperature < 225)
				trigger_cold = 1
			else if(env.temperature > 375)
				trigger_hot = 1

			if(env.gas[GAS_PHORON] >= 10)
				trigger_phoron = 1
			if(env.gas[GAS_OXYGEN] >= 10)
				trigger_oxy = 1
			if(env.gas[GAS_CO2] >= 10)
				trigger_co2 = 1
			if(env.gas[GAS_NITROGEN] >= 10)
				trigger_nitro = 1

	//COLD ACTIVATION
	if(trigger_cold)
		if(my_effect.trigger == TRIGGER_COLD && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_COLD && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_COLD && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_COLD && secondary_effect.activated)
			secondary_effect.ToggleActivate()

	//HEAT ACTIVATION
	if(trigger_hot)
		if(my_effect.trigger == TRIGGER_HEAT && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_HEAT && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_HEAT && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_HEAT && secondary_effect.activated)
			secondary_effect.ToggleActivate()

	//PHORON GAS ACTIVATION
	if(trigger_phoron)
		if(my_effect.trigger == TRIGGER_PHORON && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_PHORON && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_PHORON && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_PHORON && secondary_effect.activated)
			secondary_effect.ToggleActivate()

	//OXYGEN GAS ACTIVATION
	if(trigger_oxy)
		if(my_effect.trigger == TRIGGER_OXY && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_OXY && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_OXY && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_OXY && secondary_effect.activated)
			secondary_effect.ToggleActivate()

	//CO2 GAS ACTIVATION
	if(trigger_co2)
		if(my_effect.trigger == TRIGGER_CO2 && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_CO2 && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_CO2 && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_CO2 && secondary_effect.activated)
			secondary_effect.ToggleActivate()

	//NITROGEN GAS ACTIVATION
	if(trigger_nitro)
		if(my_effect.trigger == TRIGGER_NITRO && !my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_NITRO && !secondary_effect.activated)
			secondary_effect.ToggleActivate()
	else
		if(my_effect.trigger == TRIGGER_NITRO && my_effect.activated)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_NITRO && secondary_effect.activated)
			secondary_effect.ToggleActivate()

/obj/machinery/artifact/attack_hand(mob/user)
	if(use_check_and_message(user, USE_ALLOW_NON_ADV_TOOL_USR))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves)
			to_chat(user, "<b>You touch \the [src]</b> with your gloved hands, [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].")
			return

	src.add_fingerprint(user)

	if(my_effect.trigger == TRIGGER_TOUCH)
		to_chat(user, "<b>You touch \the [src].</b>")
		my_effect.ToggleActivate()
	else
		to_chat(user, "<b>You touch \the [src],</b> [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].")

	if(secondary_effect?.trigger == TRIGGER_TOUCH)
		to_chat(user, "<b>You touch \the [src].</b>")
		secondary_effect.ToggleActivate()

	if (my_effect.effect == EFFECT_TOUCH)
		my_effect.DoEffectTouch(user)

	if(secondary_effect?.effect == EFFECT_TOUCH && secondary_effect.activated)
		secondary_effect.DoEffectTouch(user)

/obj/machinery/artifact/attackby(obj/item/attacking_item, mob/user)

	if (istype(attacking_item, /obj/item/reagent_containers/))
		if(attacking_item.reagents.has_reagent(/singleton/reagent/hydrazine, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/water, 1))
			if(my_effect.trigger == TRIGGER_WATER)
				my_effect.ToggleActivate()
			if(secondary_effect?.trigger == TRIGGER_WATER)
				secondary_effect.ToggleActivate()
		else if(attacking_item.reagents.has_reagent(/singleton/reagent/acid, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/acid/polyacid, 1) ||\
				attacking_item.reagents.has_reagent(/singleton/reagent/diethylamine, 1))
			if(my_effect.trigger == TRIGGER_ACID)
				my_effect.ToggleActivate()
			if(secondary_effect?.trigger == TRIGGER_ACID)
				secondary_effect.ToggleActivate()
		else if(attacking_item.reagents.has_reagent(/singleton/reagent/toxin/phoron, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/thermite, 1))
			if(my_effect.trigger == TRIGGER_VOLATILE)
				my_effect.ToggleActivate()
			if(secondary_effect?.trigger == TRIGGER_VOLATILE)
				secondary_effect.ToggleActivate()
		else if(attacking_item.reagents.has_reagent(/singleton/reagent/toxin, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/toxin/cyanide, 1) ||\
				attacking_item.reagents.has_reagent(/singleton/reagent/drugs/cryptobiolin, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/drugs/impedrezene, 1) ||\
				attacking_item.reagents.has_reagent(/singleton/reagent/toxin/amatoxin, 1) || attacking_item.reagents.has_reagent(/singleton/reagent/alcohol/neurotoxin, 1))
			if(my_effect.trigger == TRIGGER_TOXIN)
				my_effect.ToggleActivate()
			if(secondary_effect?.trigger == TRIGGER_TOXIN)
				secondary_effect.ToggleActivate()
	else if(istype(attacking_item,/obj/item/melee/baton) && attacking_item:status ||\
			istype(attacking_item,/obj/item/melee/energy) ||\
			istype(attacking_item,/obj/item/melee/cultblade) ||\
			istype(attacking_item,/obj/item/card/emag) ||\
			attacking_item.ismultitool())
		if (my_effect.trigger == TRIGGER_ENERGY)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_ENERGY)
			secondary_effect.ToggleActivate()

	else if (istype(attacking_item,/obj/item/flame) && attacking_item:lit ||\
			attacking_item.iswelder() && attacking_item:welding)
		if(my_effect.trigger == TRIGGER_HEAT)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_HEAT)
			secondary_effect.ToggleActivate()
	else
		..()
		if (my_effect.trigger == TRIGGER_FORCE && attacking_item.force >= 10)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_FORCE)
			secondary_effect.ToggleActivate()

/obj/machinery/artifact/CollidedWith(atom/bumped_atom)
	..()
	if(istype(bumped_atom, /obj))
		var/obj/O = bumped_atom
		if(O.throwforce >= 10)
			if(my_effect.trigger == TRIGGER_FORCE)
				my_effect.ToggleActivate()
			if(secondary_effect?.trigger == TRIGGER_FORCE)
				secondary_effect.ToggleActivate()

	else if(ishuman(bumped_atom))

		var/mob/living/carbon/human/H = bumped_atom

		if(!istype(H.gloves, /obj/item/clothing/gloves))
			var/warn = 0

			if (my_effect.trigger == TRIGGER_TOUCH && prob(50))
				my_effect.ToggleActivate()
				warn = 1
			if(secondary_effect?.trigger == TRIGGER_TOUCH && prob(50))
				secondary_effect.ToggleActivate()
				warn = 1

			if (my_effect.effect == EFFECT_TOUCH && prob(50))
				my_effect.DoEffectTouch(H)
				warn = 1
			if(secondary_effect?.effect == EFFECT_TOUCH && prob(50))
				secondary_effect.DoEffectTouch(H)
				warn = 1

			if(warn)
				to_chat(H, "<b>You accidentally touch [src].</b>")
	..()

/obj/machinery/artifact/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(istype(hitting_projectile, /obj/projectile/bullet) || istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike))
		if(my_effect.trigger == TRIGGER_FORCE)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_FORCE)
			secondary_effect.ToggleActivate()

	else if(istype(hitting_projectile, /obj/projectile/beam) || istype(hitting_projectile, /obj/projectile/ion) || istype(hitting_projectile, /obj/projectile/energy))
		if(my_effect.trigger == TRIGGER_ENERGY)
			my_effect.ToggleActivate()
		if(secondary_effect?.trigger == TRIGGER_ENERGY)
			secondary_effect.ToggleActivate()

/obj/machinery/artifact/ex_act(severity)
	switch(severity)
		if(1.0) qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
			else
				if(my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
					my_effect.ToggleActivate()
				if(secondary_effect && (secondary_effect.trigger == TRIGGER_FORCE || secondary_effect.trigger == TRIGGER_HEAT) && prob(25))
					secondary_effect.ToggleActivate(0)
		if(3.0)
			if (my_effect.trigger == TRIGGER_FORCE || my_effect.trigger == TRIGGER_HEAT)
				my_effect.ToggleActivate()
			if(secondary_effect && (secondary_effect.trigger == TRIGGER_FORCE || secondary_effect.trigger == TRIGGER_HEAT) && prob(25))
				secondary_effect.ToggleActivate(0)
	return

/obj/machinery/artifact/Move()
	. = ..()
	if(my_effect)
		my_effect.UpdateMove()
	if(secondary_effect)
		secondary_effect.UpdateMove()

/obj/machinery/artifact/attack_ai(mob/user) //AI can't interfact with weird artifacts. Borgs can but not remotely.
	if(!isrobot(user) || !Adjacent(user))
		return
	return ..()
