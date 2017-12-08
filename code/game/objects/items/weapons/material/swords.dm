	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	force_divisor = 0.7 // 42 when wielded with hardnes 60 (steel)
	thrown_force_divisor = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	can_embed = 0


	if(default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		return 1
	return 0

	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

	name = "rapier"
	desc = "A slender, fancy and sharply pointed sword."
	icon = 'icons/obj/sword.dmi'
	icon_state = "rapier"
	item_state = "rapier"
	contained_sprite = 1
	slot_flags = SLOT_BELT
	attack_verb = list("attacked", "stabbed", "prodded", "poked", "lunged")

	name = "longsword"
	desc = "A double-edged large blade."
	icon_state = "longsword"
	item_state = "claymore"
	slot_flags = SLOT_BELT | SLOT_BACK

	name = "trench knife"
	desc = "A military knife used to slash and stab enemies in close quarters."
	force_divisor = 0.4
	icon_state = "trench"
	item_state = "knife"
	w_class = 3
	slot_flags = SLOT_BELT

	return 0

	name = "sabre"
	desc = "A sharp curved backsword."
	icon = 'icons/obj/sword.dmi'
	icon_state = "sabre"
	item_state = "sabre"
	contained_sprite = 1
	slot_flags = SLOT_BELT

	name = "battle axe"
	icon = 'icons/obj/sword.dmi'
	icon_state = "axe"
	item_state = "axe"
	contained_sprite = 1
	slot_flags = SLOT_BACK
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0

	name = "khopesh"
	desc = "An ancient sword shapped like a sickle."
	icon = 'icons/obj/sword.dmi'
	icon_state = "khopesh"
	item_state = "khopesh"
	contained_sprite = 1
	slot_flags = SLOT_BELT

	name = "dao"
	desc = "A single-edged broadsword."
	icon = 'icons/obj/sword.dmi'
	icon_state = "dao"
	item_state = "dao"
	contained_sprite = 1
	slot_flags = SLOT_BELT

	name = "gladius"
	desc = "An ancient short sword, designed to stab and cut."
	icon = 'icons/obj/sword.dmi'
	icon_state = "gladius"
	item_state = "gladius"
	contained_sprite = 1
	slot_flags = SLOT_BELT
