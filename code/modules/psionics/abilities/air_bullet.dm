/singleton/psionic_power/air_bullet
	name = "Air Bullet"
	desc = "Wrap air in a psionic bubble, compress it, then send it flying at your enemies. Activate the spell in hand to create up to six air bullets, then \
			fire them by clicking something."
	icon_state = "tech_frostaura"
	point_cost = 3
	spell_path = /obj/item/spell/projectile/air_bullet

/obj/item/spell/projectile/air_bullet
	name = "air bullet"
	desc = "Not really a big bang attack, but it's actually pretty close."
	icon_state = "force_missile"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_PSIONIC
	spell_projectile = /obj/item/projectile/air_bullet
	fire_sound = 'sound/weapons/wave.ogg'
	cooldown = 5
	psi_cost = 3
	var/bullets = 0
	var/max_bullets = 6

/obj/item/spell/projectile/air_bullet/on_use_cast(mob/user)
	. = ..()
	if(bullets < max_bullets)
		if(do_after(user, 0.5 SECONDS))
			to_chat(user, SPAN_NOTICE("You compress some air bullets between your fingers."))
			bullets = min(bullets + 2, 6)
			maptext = SMALL_FONTS(7, bullets)
			playsound(user, 'sound/weapons/unjam.ogg', 25)
			if(bullets >= 6)
				to_chat(user, SPAN_NOTICE("You finish compressing all the bullets you can hold."))
				return
			on_use_cast(user)

/obj/item/spell/projectile/air_bullet/on_ranged_cast(atom/hit_atom, mob/living/user, atom/pb_target)
	if(!bullets)
		to_chat(user, SPAN_WARNING("You flick your fingers, but find that you don't have any air bullets left!"))
		return
	. = ..(hit_atom, user, pb_target)
	if(.)
		bullets--
		maptext = SMALL_FONTS(7, bullets)

/obj/item/projectile/air_bullet
	name = "air bullet"
	icon_state = "plasma_bolt"
	damage = 30
	armor_penetration = 10
	damage_type = DAMAGE_BRUTE
