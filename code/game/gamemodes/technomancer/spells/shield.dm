/datum/technomancer/spell/shield
	name = "Shield"
	desc = "Emits a protective shield fron your hand in front of you, which will protect you from almost anything able to harm \
	you, so long as you can power it.  Stronger attacks blocked cost more energy to sustain.  \
	Note that holding two shields will make blocking more energy efficent."
	enhancement_desc = "Blocking is twice as efficent in terms of energy cost per hit."
	cost = 100
	obj_path = /obj/item/spell/shield
	ability_icon_state = "tech_shield"
	category = DEFENSIVE_SPELLS

/obj/item/spell/shield
	name = "\proper energy shield"
	icon_state = "shield"
	desc = "A very protective combat shield that'll stop almost anything from hitting you, at least from the front."
	aspect = ASPECT_FORCE
	toggled = 1
	var/damage_to_energy_multiplier = 30.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 600 energy cost

/obj/item/spell/shield/Initialize()
	. = ..()
	set_light(3, 2, l_color = "#006AFF")

/obj/item/spell/shield/update_icon()
	var/mob/living/carbon/human/H = owner
	if(istype(owner) && istype(H.species, /datum/species/golem/technomancer))
		item_state = "shield_golem"
	return ..()

/obj/item/spell/shield/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return FALSE

	var/damage_to_energy_cost = damage_to_energy_multiplier * damage

	if(issmall(user)) // Smaller shields are more efficent.
		damage_to_energy_cost *= 0.75

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(istype(H.get_other_hand(src), src.type)) // Two shields in both hands.
			damage_to_energy_cost *= 0.75

	else if(check_for_scepter())
		damage_to_energy_cost *= 0.50

	if(!pay_energy(damage_to_energy_cost))
		to_chat(owner, "<span class='danger'>Your shield fades due to lack of energy!</span>")
		qdel(src)
		return FALSE

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		user.visible_message("<span class='danger'>\The [user]'s [src] blocks [attack_text]!</span>")
		spark(src, 3, cardinal)
		playsound(src, 'sound/weapons/blade.ogg', 50, 1)
		adjust_instability(2)
		return PROJECTILE_STOPPED
	return FALSE
