/obj/item/melee/energy/wizard
	name = "rune sword"
	desc = "A large sword engraved with arcane markings, it seems to reverberate with unearthly powers."
	icon = 'icons/obj/sword.dmi'
	icon_state = "runesword0"
	item_state = "runesword0"
	contained_sprite = 1
	active_force = 40
	active_throwforce = 40
	active_w_class = 5
	force = 20
	throwforce = 30
	throw_speed = 5
	throw_range = 10
	w_class = 5
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 8)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharp = 1
	edge = 1
	base_reflectchance = 60
	base_block_chance = 60
	can_block_bullets = 1
	shield_power = 150

/obj/item/melee/energy/wizard/activate(mob/living/user)
	..()
	icon_state = "runesword1"
	item_state = "runesword1"
	to_chat(user, "<span class='notice'>\The [src] surges to life!.</span>")

/obj/item/melee/energy/wizard/deactivate(mob/living/user)
	..()
	icon_state = "runesword0"
	item_state = "runesword0"
	to_chat(user, "<span class='notice'>\The [src] slowly dies out.</span>")

/obj/item/melee/energy/wizard/attack(mob/living/M, mob/living/user, var/target_zone)
	if(user.is_wizard())
		return ..()

	var/zone = (user.hand ? BP_L_ARM:BP_R_ARM)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, "<span class='danger'>The sword refuses you as its true wielder, slashing your [affecting.name] instead!</span>")

	user.apply_damage(active_force, BRUTE, zone, 0, sharp=1, edge=1)

	user.drop_from_inventory(src)

	return 1