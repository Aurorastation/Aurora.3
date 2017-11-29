//////////////////////Scrying orb//////////////////////

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/living/user as mob)
	if(!user.is_wizard())
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/E = H.get_eyes(no_synthetic = TRUE)
			if (!E)
				user << "<span class='notice'>You stare deep into the abyss... and nothing happens. What a letdown.</span>"
				return

			user << "<span class='warning'>You stare deep into the abyss... and the abyss stares back.</span>"
			sleep(10)
			user << "<span class='warning'>Your [E.name] fill with painful light, and you feel a sharp burning sensation in your head!</span>"
			user.custom_emote(2, "screams in horror!")
			playsound(user, 'sound/hallucinations/far_noise.ogg', 40, 1)
			user.drop_item()
			user.visible_message("<span class='danger'>Ashes pour out of [user]'s eye sockets!</span>")
			new /obj/effect/decal/cleanable/ash(get_turf(user))
			E.removed(user)
			qdel(E)
			H.adjustBrainLoss(50)
			H.hallucination += 20
			return
	else
		user << "<span class='info'>You can see... everything!</span>"
		visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")

		user.teleop = user.ghostize(1)
		announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
		return

/obj/item/weapon/melee/energy/wizard
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

/obj/item/weapon/melee/energy/wizard/activate(mob/living/user)
	..()
	icon_state = "runesword1"
	item_state = "runesword1"
	user << "<span class='notice'>\The [src] surges to life!.</span>"

/obj/item/weapon/melee/energy/wizard/deactivate(mob/living/user)
	..()
	icon_state = "runesword0"
	item_state = "runesword0"
	user << "<span class='notice'>\The [src] slowly dies out.</span>"

/obj/item/weapon/melee/energy/wizard/attack(mob/living/M, mob/living/user, var/target_zone)
	if(user.is_wizard())
		return ..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		user << "<span class='danger'>The sword refuses you as its true wielder, slashing your [affecting.name] instead!</span>"

	user.apply_damage(active_force, BRUTE, zone, 0, sharp=1, edge=1)

	user.drop_from_inventory(src)

	return 1

//skeleton weapons and armor

/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A rudimentary armor made of bones of several creatures."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "bonearmor"
	item_state = "bonearmor"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/bone
	name = "bone helmet"
	desc = "A rudimentary helmet made of some dead creature."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "skull"
	item_state = "skull"
	contained_sprite = 1
	species_restricted = list("Skeleton")
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/weapon/material/twohanded/spear/bone
	desc = "A spear crafted with bones of some long forgotten creature."
	default_material = "cursed bone"

//lich phylactery

/obj/item/phylactery
	name = "phylactery"
	desc = "A twisted mummified heart."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cursedheart-off"
	origin_tech = list(TECH_BLUESPACE = 8, TECH_MATERIAL = 8, TECH_BIO = 8)
	w_class = 5
	light_color = "#6633CC"
	light_power = 3
	light_range = 4
	
	var/lich = null

/obj/item/phylactery/Initialize()
	. = ..()
	world_phylactery += src
	create_reagents(30)
	reagents.add_reagent("undead_ichor", 30)

/obj/item/phylactery/Destroy()
	lich << "<span class='danger'>Your phylactery was destroyed, your soul is cast into the abyss as your immortality vanishes away!</span>"
	world_phylactery -= src
	lich = null
	return ..()
	
/obj/item/phylactery/examine(mob/user)
	..(user)
	if(!lich)
		user << "The heart is inert."
	else
		user << "The heart is pulsing slowly."
	
/obj/item/phylactery/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/nullrod))
		src.visible_message("\The [src] twists violently and explodes!")
		gibs(src.loc)
		qdel(src)
		return
