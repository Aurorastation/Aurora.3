/singleton/psionic_power/air_bullet
	name = "Air Bullet"
	desc = "Wrap air in a psionic bubble, compress it, then send it flying at your enemies. Activate the spell in hand to create up to six air bullets, then \
			fire them by clicking something."
	icon_state = "tech_frostaura"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
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
	psi_cost = 0
	var/bullets = 0
	var/max_bullets = 6

/obj/item/spell/projectile/air_bullet/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	if(bullets < max_bullets)
		if(do_after(L, 0.5 SECONDS))
			to_chat(L, SPAN_NOTICE("You compress some air bullets between your fingers."))
			bullets = min(bullets + 2, 6)
			maptext = SMALL_FONTS(7, bullets)
			playsound(L, 'sound/weapons/unjam.ogg', 25)
			L.psi.spend_power(3)
			if(bullets >= 6)
				to_chat(L, SPAN_NOTICE("You finish compressing all the bullets you can hold."))
				return
			on_use_cast(L)

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
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	damage_flags = DAMAGE_FLAG_BULLET
	damage_type = DAMAGE_BRUTE
