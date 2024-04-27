/singleton/psionic_power/electrocute
	name = "Electrocute"
	desc = "Administer a painful amount of psionic shock to the nervous system of a foe in melee range, causing burn and agony damage. "
	icon_state = "tech_shockaura"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/electrocute

/obj/item/spell/electrocute
	name = "electrocute"
	icon_state = "chain_lightning"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 5
	hitsound = 'sound/effects/psi/power_evoke.ogg'
	attack_verb = list("lays a palm on")

/obj/item/spell/electrocute/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!ishuman(hit_atom))
		to_chat(user, SPAN_WARNING("That won't work!"))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = hit_atom
	H.adjustHalLoss(20)
	H.adjustFireLoss(20)
	H.flash_pain(20)
	to_chat(H, SPAN_DANGER("A sharp, stinging pain enters your mind!"))
