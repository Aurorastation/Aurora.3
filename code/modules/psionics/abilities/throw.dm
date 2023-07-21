/singleton/psionic_power/throw_item
	name = "Throw"
	desc = "Click this spell with an item to prepare it to be thrown, then use the spell to throw the item with lethal force."
	icon_state = "wiz_mm"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/projectile/throw_item

/obj/item/spell/projectile/throw_item
	name = "throw"
	desc = "Almost as cool as the Mass Effect one, but still not as cool."
	icon_state = "aspect_bolt"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	spell_projectile = /obj/item/projectile/psionic_throw
	fire_sound = 'sound/weapons/wave.ogg'
	cooldown = 20
	psi_cost = 20
	var/obj/item_to_throw

/obj/item/spell/projectile/throw_item/attackby(obj/item/W, mob/user)
	. = ..()
	if(!item_to_throw)
		owner.drop_item(W)
		W.forceMove(src)
		to_chat(user, SPAN_NOTICE("You imbue [W] with psionic energy!"))
		add_overlay("controlled")
		item_to_throw = W

/obj/item/spell/projectile/throw_item/Destroy()
	if(item_to_throw)
		item_to_throw.forceMove(loc)
		item_to_throw = null
	return ..()

/obj/item/spell/projectile/throw_item/on_use_cast(mob/user)
	. = ..(user, TRUE)
	if(item_to_throw)
		owner.put_in_hands(item_to_throw)
		item_to_throw = null
		cut_overlays()

/obj/item/spell/projectile/throw_item/on_ranged_cast(atom/hit_atom, mob/living/user, atom/pb_target)
	if(!item_to_throw)
		to_chat(user, SPAN_WARNING("You need to imbue an item with psionic energy first!"))
		return
	. = ..()
	item_to_throw = null
	cut_overlays()

/obj/item/spell/projectile/throw_item/make_projectile(obj/item/projectile/projectile_type, mob/living/user)
	var/obj/item/projectile/psionic_throw/P = ..()
	if(P && item_to_throw)
		var/base_damage = item_to_throw.force > 5 ? item_to_throw.force : 10
		/// Why is it called a fucking divisor? It's a multiplier...
		var/thrown_force_divisor = 1
		if(istype(item_to_throw, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/MT = item_to_throw
			base_damage = MT.force_wielded > MT.force ? MT.force_wielded : force
			thrown_force_divisor = MT.thrown_force_divisor
		/// There are different throwforce calculations, which means that we have to do this manually.
		if(base_damage < (item_to_throw.throwforce * thrown_force_divisor))
			base_damage = item_to_throw.throwforce * thrown_force_divisor
		var/base_armor_penetration
		if(item_to_throw.armor_penetration > 2)
			base_armor_penetration = item_to_throw.armor_penetration
		else
			base_armor_penetration = 2
		P.name = item_to_throw.name
		P.appearance = item_to_throw.appearance
		P.damage = base_damage * (item_to_throw.w_class / 2)
		P.armor_penetration = base_armor_penetration * item_to_throw.w_class
		/// We need to do this again because we're overriding the base make_projectile.
		if(owner.psi.get_rank() >= PSI_RANK_APEX)
			if(P.damage)
				P.damage *= 1.1
				P.armor_penetration *= 1.1
		P.damage_flags |= item_to_throw.damage_flags()
		P.damage_type = item_to_throw.damtype
		P.source_item = item_to_throw
	return P

/obj/item/projectile/psionic_throw
	name = "thrown projectile"
	damage_type = DAMAGE_BRUTE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	var/obj/source_item

/obj/item/projectile/psionic_throw/Destroy()
	if(source_item)
		source_item.forceMove(loc)
		source_item = null
	return ..()
