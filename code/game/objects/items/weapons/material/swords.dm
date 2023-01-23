/obj/item/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	desc_antag = "As a Cultist, this item can be reforged to become a cult blade."
	icon = 'icons/obj/sword.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	can_embed = 0
	var/parry_chance = 40
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	equip_sound = /singleton/sound_category/sword_equip_sound

/obj/item/material/sword/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/parry_bonus = 1

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/has_parry_bonus = H.check_weapon_affinity(src, TRUE)
		if(has_parry_bonus)
			parry_bonus = has_parry_bonus // proc returns the parry multiplier

	if(default_parry_check(user, attacker, damage_source) && prob(parry_chance * parry_bonus))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/bladeparry.ogg', 50, 1)
		return PROJECTILE_STOPPED
	return FALSE

/obj/item/material/sword/perform_technique(var/mob/living/carbon/human/target, var/mob/living/carbon/human/user, var/target_zone)
	var/armor_reduction = target.get_blocked_ratio(target_zone, BRUTE, DAM_EDGE|DAM_SHARP, damage = force)*100
	var/obj/item/organ/external/affecting = target.get_organ(target_zone)
	if(!affecting)
		return

	user.do_attack_animation(target)

	if(target_zone == BP_HEAD || target_zone == BP_EYES || target_zone == BP_MOUTH)
		if(prob(70 - armor_reduction))
			target.eye_blurry += 5
			target.confused += 10
			return TRUE

	if(target_zone == BP_R_ARM || target_zone == BP_L_ARM || target_zone == BP_R_HAND || target_zone == BP_L_HAND)
		if(prob(80 - armor_reduction))
			if(target_zone == BP_R_ARM || target_zone == BP_R_HAND)
				target.drop_r_hand()
			else
				target.drop_l_hand()
			return TRUE

	if(target_zone == BP_R_FOOT || target_zone == BP_R_FOOT || target_zone == BP_R_LEG || target_zone == BP_L_LEG)
		if(prob(60 - armor_reduction))
			target.Weaken(5)
			return TRUE

	return FALSE

/obj/item/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/rapier
	name = "rapier"
	desc = "A slender, fancy and sharply pointed sword."
	icon_state = "rapier"
	item_state = "rapier"
	slot_flags = SLOT_BELT
	attack_verb = list("attacked", "stabbed", "prodded", "poked", "lunged")
	sharp = 0

/obj/item/material/sword/longsword
	name = "longsword"
	desc = "A double-edged large blade."
	icon_state = "longsword"
	item_state = "longsword"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/longsword/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/obj/item/material/sword/sabre
	name = "sabre"
	desc = "A sharp curved backsword."
	icon_state = "sabre"
	item_state = "sabre"
	slot_flags = SLOT_BELT

/obj/item/material/sword/axe
	name = "battle axe"
	desc = "A one handed battle axe, still a deadly weapon."
	icon_state = "axe"
	item_state = "axe"
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	parry_chance = 10
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/material/sword/axe/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/obj/item/material/sword/khopesh
	name = "khopesh"
	desc = "An ancient sword shapped like a sickle."
	icon_state = "khopesh"
	item_state = "khopesh"
	slot_flags = SLOT_BELT

/obj/item/material/sword/dao
	name = "dao"
	desc = "A single-edged broadsword."
	icon_state = "dao"
	item_state = "dao"
	slot_flags = SLOT_BELT

/obj/item/material/sword/gladius
	name = "gladius"
	desc = "An ancient short sword, designed to stab and cut."
	icon_state = "gladius"
	item_state = "gladius"
	slot_flags = SLOT_BELT

/obj/item/material/sword/amohdan_sword
	name = "amohdan blade"
	desc = "A tajaran sword, commonly used by the swordsmen of the island of Amohda."
	icon_state = "amohdan_sword"
	item_state = "amohdan_sword"
	slot_flags = SLOT_BELT
	use_material_name = FALSE
	applies_material_colour = FALSE
	unbreakable = TRUE //amohdan steel is the finest in the spur


// improvised sword
/obj/item/material/sword/improvised_sword
	name = "selfmade sword"
	desc = "A crudely made, rough looking sword. Still appears to be quite deadly."
	icon_state = "improvsword"
	item_state = "improvsword"
	var/obj/item/material/hilt //what is the handle made of?
	force_divisor = 0.3
	slot_flags = SLOT_BELT

/obj/item/material/sword/improvised_sword/apply_hit_effect()
	. = ..()
	if(!unbreakable)
		if(hilt.material.is_brittle())
			health = 0
		else if(!prob(hilt.material.hardness))
			health--
		check_health()

/obj/item/material/sword/improvised_sword/proc/assignDescription()
	if(hilt)
		desc = "A crudely made, rough looking sword. Still appears to be quite deadly. It has a blade of [src.material], and a hilt of [hilt.material]."
	else
		desc = "A crudely made, rough looking sword. Still appears to be quite deadly. It has a blade of [src.material]."

// the things needed to create the above
/obj/item/material/sword_hilt
	name = "hilt"
	desc = "A hilt without a blade, quite useless."
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "swordhilt"
	unbreakable = TRUE
	force_divisor = 0.05
	thrown_force_divisor = 0.2

/obj/item/material/sword_hilt/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/material/sword_blade))
		var/obj/item/material/sword_blade/blade = O
		var/obj/item/material/sword/improvised_sword/new_sword = new(src.loc, blade.material.name)
		new_sword.hilt = src
		user.drop_from_inventory(src,new_sword)
		user.drop_from_inventory(blade,new_sword)
		user.put_in_hands(new_sword)
		qdel(blade)
		qdel(src)
		new_sword.assignDescription()
	else
		..()

/obj/item/material/sword_blade
	name = "blade"
	desc = "A blade without a hilt, don't cut yourself!"
	icon = 'icons/obj/weapons_build.dmi'
	icon_state = "swordblade"
	unbreakable = TRUE
	force_divisor = 0.20
	thrown_force_divisor = 0.3

/obj/item/material/sword_blade/attackby(var/obj/O, mob/user)
	if(istype(O, /obj/item/material/sword_hilt))
		var/obj/item/material/sword_hilt/hilt = O
		var/obj/item/material/sword/improvised_sword/new_sword = new(src.loc, src.material.name)
		new_sword.hilt = hilt.material
		new_sword.assignDescription()
		user.drop_from_inventory(src,new_sword)
		user.drop_from_inventory(hilt,new_sword)
		user.put_in_hands(new_sword)
		qdel(hilt)
		qdel(src)
		new_sword.assignDescription()
	else
		..()
