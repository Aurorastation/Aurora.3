/datum/technomancer/spell/reflect
	name = "Reflect"
	desc = "Emits a protective shield fron your hand in front of you, which will reflect one attack back at the attacker."
	cost = 100
	obj_path = /obj/item/spell/reflect
	ability_icon_state = "tech_reflect"
	category = DEFENSIVE_SPELLS

/obj/item/spell/reflect
	name = "\proper reflect shield"
	icon_state = "reflect"
	desc = "A very protective combat shield that'll reflect the next attack at the unfortunate person who tried to shoot you."
	aspect = ASPECT_FORCE
	toggled = 1
	var/reflecting = 0
	var/damage_to_energy_multiplier = 60.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 1200 energy cost

/obj/item/spell/reflect/Initialize()
	. = ..()
	set_light(3, 2, l_color = "#006AFF")
	to_chat(owner, "<span class='notice'>Your shield will expire in 5 seconds!</span>")
	QDEL_IN(src, 5 SECONDS)

/obj/item/spell/reflect/Destroy()
	if(owner)
		to_chat(owner, "<span class='danger'>Your shield expires!</span>")
	return ..()

/obj/item/spell/reflect/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return FALSE

	var/damage_to_energy_cost = (damage_to_energy_multiplier * damage)

	if(!pay_energy(damage_to_energy_cost))
		to_chat(owner, "<span class='danger'>Your shield fades due to lack of energy!</span>")
		qdel(src)
		return FALSE

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source

			if(P.starting && !P.reflected)
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(P.starting.x, P.starting.y, curloc, user)
				P.reflected = 1
				if(check_for_scepter())
					P.damage = P.damage * 1.5

				spark(src, 5, 0)
				playsound(src, 'sound/weapons/blade.ogg', 50, 1)
				// now send a log so that admins don't think they're shooting themselves on purpose.
				log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

				if(!reflecting)
					reflecting = 1
					spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
						to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
						qdel(src)

				return PROJECTILE_CONTINUE // complete projectile permutation

		else if(istype(damage_source, /obj/item))
			var/obj/item/W = damage_source
			if(attacker)
				W.attack(attacker)
				to_chat(attacker, "<span class='danger'>Your [damage_source.name] goes through \the [src] in one location, comes out \
				on the same side, and hits you!</span>")

				spark(src, 5, cardinal)
				playsound(src, 'sound/weapons/blade.ogg', 50, 1)

				log_and_message_admins("[user] reflected [attacker]'s attack back at them.")

				if(!reflecting)
					reflecting = 1
					spawn(2 SECONDS) //To ensure that most or all of a burst fire cycle is reflected.
						to_chat(owner, "<span class='danger'>Your shield fades due being used up!</span>")
						qdel(src)
		return PROJECTILE_STOPPED
	return FALSE