/obj/item/weapon/melee/cultblade
	name = "eldritch blade"
	desc = "A sword humming with unholy energy. It glows with a dim red light."
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = 4
	force = 30
	throwforce = 10
	edge = 1
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'

	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	can_embed = 0 //can't get stuck anymore, because blood magic

/obj/item/weapon/melee/cultblade/cultify()
	return

/obj/item/weapon/melee/cultblade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(iscultist(user))
		return ..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		user << "<span class='danger'>An unexplicable force rips through your [affecting.name], tearing the sword from your grasp!</span>"
	else
		user << "<span class='danger'>An unexplicable force rips through you, tearing the sword from your grasp!</span>"

	//random amount of damage between half of the blade's force and the full force of the blade.
	user.apply_damage(rand(force/2, force), BRUTE, zone, 0, sharp=1, edge=1)
	user.Weaken(5)

	user.drop_from_inventory(src)
	throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	var/spooky = pick('sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg', 'sound/hallucinations/growl3.ogg', 'sound/hallucinations/wail.ogg')
	playsound(loc, spooky, 50, 1)

	return 1

/obj/item/weapon/melee/cultblade/pickup(mob/living/user as mob)
	if(!iscultist(user))
		user << "<span class='warning'>An overwhelming feeling of dread comes over you as you pick up \the [src]. It would be wise to be rid of this blade quickly.</span>"
		user.make_dizzy(120)

/obj/item/weapon/melee/cultblade/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/nullrod))
		to_chat(user, "<span class='notice'>You cleanse \the [src] of taint, restoring the blade to its original state.</span>")
		var/obj/item/weapon/material/sword/blade = new(get_turf(src))
		blade.force = 15
		qdel(src)

/obj/item/clothing/head/culthood
	name = "ragged hood"
	icon_state = "culthood"
	desc = "A torn, dust-caked hood."
	flags_inv = HIDEFACE|HIDEEARS|HIDEEYES
	body_parts_covered = HEAD|EYES
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/culthood/cultify()
	return

/obj/item/clothing/head/culthood/magus
	name = "magus helm"
	icon_state = "magus"
	desc = "A helm worn by the followers of Nar-Sie."
	flags_inv = HIDEFACE | BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/culthood/alt
	icon_state = "cult_hoodalt"

/obj/item/clothing/suit/cultrobes
	name = "ragged robes"
	desc = "A ragged, dusty set of robes."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade)
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 10, rad = 0)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/cultrobes/cultify()
	return

/obj/item/clothing/suit/cultrobes/alt
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar-Sie."
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/head/helmet/space/cult
	name = "eldritch helmet"
	desc = "A bulky helmet, bristling with spikes. It looks space proof."
	icon_state = "cult_helmet"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0

/obj/item/clothing/head/helmet/space/cult/cultify()
	return

/obj/item/clothing/suit/space/cult
	name = "eldritch armour"
	icon_state = "cult_armour"
	item_state = "cult_armour"
	desc = "A bulky suit of armour, bristling with spikes. It looks space proof."
	w_class = 3
	allowed = list(/obj/item/weapon/book/tome,/obj/item/weapon/melee/cultblade,/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)
	siemens_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS

/obj/item/clothing/suit/space/cult/cultify()
	return
