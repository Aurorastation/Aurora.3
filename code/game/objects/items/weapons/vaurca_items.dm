//Weapons and items used exclusively by the Vaurcae, typically only for event shenanigans, and possibly random finds in the future. All items here should have
//"Vaurca" in the item path at some point, so they can be easily spawned in-game.

/obj/item/clothing/mask/breath/vaurca
	desc = "A Vaurcae mandible garment with an attached gas filter and air-tube."
	name = "mandible garment"
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "m_garment"
	item_state = "m_garment"
	contained_sprite = 1

/obj/item/clothing/mask/breath/vaurca/adjust_mask(mob/user)
	to_chat(user, "This mask is too tight to adjust.")
	return

/obj/item/clothing/mask/breath/vaurca/filter
	desc = "A basic screw on filter attached beneath the mouthparts of the common Vaurca."
	name = "filter port"
	icon_state = "filterport"
	species_restricted = list("Vaurca", "Vaurca Breeder")
	item_state = 0

/obj/item/clothing/head/shaper
	name = "shaper helmet"
	desc = "A mirrored helm commonly worn by Preimminents. The helm masks the visage of its wearer, symbolically and literally blinding them to all but the path set in front of them."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "shaper_helmet"
	item_state = "shaper_helmet"
	contained_sprite = TRUE
	species_restricted = list("Vaurca")
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/expression
	name = "human expression mask"
	desc = "A mask that allows emotively challenged aliens to convey facial expressions. This one depicts a human."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "human_helmet"
	item_state = "human_helmet"
	contained_sprite = TRUE

/obj/item/clothing/head/expression/skrell
	name = "skrell expression mask"
	desc = "A mask that allows emotively challenged aliens to convey facial expressions. This one depicts a skrell."
	icon_state = "skrell_helmet"
	item_state = "skrell_helmet"

/obj/item/clothing/head/shroud
	name = "vaurcan shroud"
	desc = "This relatively new design is meant to cover the head of a Vaurca, to both protect against sunlight, and to cover their mandibles. This one is blue."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "vacshroudblue"
	item_state = "vacshroudblue"
	body_parts_covered = HEAD|FACE|EYES
	contained_sprite = TRUE

/obj/item/clothing/head/shroud/red
	desc = "This relatively new design is meant to cover the head of a Vaurca, to both protect against sunlight, and to cover their mandibles. This one is red."
	icon_state = "vacshroudred"
	item_state = "vacshroudred"

/obj/item/clothing/head/shroud/green
	desc = "This relatively new design is meant to cover the head of a Vaurca, to both protect against sunlight, and to cover their mandibles. This one is green."
	icon_state = "vacshroudgreen"
	item_state = "vacshroudgreen"

/obj/item/clothing/head/shroud/purple
	desc = "This relatively new design is meant to cover the head of a Vaurca, to both protect against sunlight, and to cover their mandibles. This one is purple."
	icon_state = "vacshroudpurple"
	item_state = "vacshroudpurple"

/obj/item/clothing/head/shroud/brown
	desc = "This relatively new design is meant to cover the head of a Vaurca, to both protect against sunlight, and to cover their mandibles. This one is brown."
	icon_state = "vacshroudbrown"
	item_state = "vacshroudbrown"

/obj/item/melee/energy/vaurca
	name = "thermal knife"
	desc = "A Vaurcae-designed combat knife with a thermal energy blade designed for close-quarter encounters."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "eknife0"
	item_state = "eknife0"
	active_force = 20
	active_throwforce = 20
	active_w_class = 5
	force = 5
	throwforce = 5
	throw_speed = 5
	throw_range = 10
	w_class = 1
	flags = CONDUCT | NOBLOODY
	attack_verb = list("stabbed", "chopped", "sliced", "cleaved", "slashed", "cut")
	sharp = 1
	edge = 1
	contained_sprite = 1


/obj/item/melee/energy/vaurca/activate(mob/living/user)
	..()
	icon_state = "eknife1"
	item_state = icon_state
	damtype = "fire"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/melee/energy/vaurca/deactivate(mob/living/user)
	..()
	icon_state = "eknife0"
	item_state = icon_state
	damtype = "brute"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	to_chat(user, "<span class='notice'>\The [src] is de-energised.</span>")

/obj/item/vaurca/box
	name = "puzzle box"
	desc = "A classic Zo'rane puzzle box, a common sight in Vaurcae colonies."
	icon_state = "puzzlebox"
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'

/obj/item/vaurca/box/attack_self(mob/user as mob)

	if(isvaurca(user))
		to_chat(user, "<span class='notice'>You are familiar with the box's solution, and open it to reveal an ancient thing. How tedious.</span>")
		var/obj/item/archaeological_find/X = new /obj/item/archaeological_find
		user.remove_from_mob(src)
		user.put_in_hands(X)
		qdel(src)

	else if(isipc(user))
		to_chat(user, "<span class='notice'>You analyze the box's markings, and begin to calculate with robotic efficiency every possible combination. (You must stand still to complete the puzzle box.)</span>")
		if(do_after(user, 100))
			to_chat(user, "<span class='notice'>Calculations complete. You begin to brute-force the box with a mechanical determination.</span>")
			if(do_after(user, 600))
				to_chat(user, "<span class='notice'>After a minute of brute-force puzzle solving, the box finally opens to reveal an ancient thing.</span>")
				var/obj/item/archaeological_find/X = new /obj/item/archaeological_find
				user.remove_from_mob(src)
				user.put_in_hands(X)
				qdel(src)

	else if(isvox(user))
		to_chat(user, "<span class='notice'>You are surprised to recognize the markings of the Apex, the Masters! You know this thing... (You must stand still to complete the puzzle box.)</span>")
		if(do_after(user, 100))
			to_chat(user, "<span class='notice'>After a few seconds of remembering, you input the solution to the riddle - a lovely riddle indeed - and open the box to reveal an ancient thing.</span>")
			var/obj/item/archaeological_find/X = new /obj/item/archaeological_find
			user.remove_from_mob(src)
			user.put_in_hands(X)
			qdel(src)

	else
		to_chat(user, "<span class='notice'>You stare at the box for a few seconds, trying to even comprehend what you're looking at... (You must stand still to complete the puzzle box.)</span>")
		if(do_after(user, 60))
			to_chat(user, "<span class = 'notice'>After a few more seconds, you hesitantly turn the first piece of the puzzle box.</span>")
			if(do_after(user,30))
				to_chat(user, "<span class = 'notice'>After nothing bad happens, you dive into the puzzle with a feeling of confidence!</span>")
				if(do_after(user,200))
					to_chat(user, "<span class = 'notice'>Twenty seconds pass, and suddenly you're feeling a lot less confident. You struggle on...</span>")
					if(do_after(user,100))
						to_chat(user, "<span class='notice'>You blink, and suddenly you've lost your place, your thoughts, your mind...</span>")
						if(do_after(user,20))
							to_chat(user, "<span class='notice'>You find yourself again, and get back to turning pieces. At this point it is just randomly.</span>")
							if(do_after(user,600))
								to_chat(user, "<span class='notice'>A minute goes by, and with one final turn the box looks just like it did when you started. Fucking bugs.</span>")

/obj/item/melee/vaurca/navcomp
	name = "navcomp coordinate archive"
	desc = "A rather heavy data disk for a Vaurcae Arkship navigation drive."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "harddisk"
	force = 10
	throwforce = 5
	w_class = 3
	contained_sprite = 1

/obj/item/melee/vaurca/rock
	name = "Sedantis rock"
	desc = "A large chunk of alien earth from the distant Vaurcae world of Sedantis I. Just looking at it makes you feel funny."
	icon_state = "glowing"
	icon = 'icons/obj/vaurca_items.dmi'
	force = 15
	throwforce = 30
	w_class = 4
	contained_sprite = 1

/obj/item/grenade/spawnergrenade/vaurca
	name = "K'ois delivery pod"
	desc = "A sophisticated K'ois delivery pod, for seeding a planet from the comfort of space."
	spawner_type = /obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	deliveryamt = 7
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "beacon"
	force = 15
	throwforce = 30
	w_class = 4

/obj/item/grenade/spawnergrenade/vaurca/prime()

	if(spawner_type && deliveryamt)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(T, null))
			if(M.eyecheck(TRUE) < FLASH_PROTECTION_MODERATE)
				flick("e_flash", M.flash)

		for(var/i=1, i<=deliveryamt, i++)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/x = new spawner_type(T, new /datum/seed/koisspore())
			x.tumble(4)
	qdel(src)
	return

/obj/item/clothing/suit/space/void/vaurca
	name = "voidsuit"
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "void"
	item_state = "void"
	desc = "A lightweight Zo'rane designed Vaurcae softsuit, for extremely extended EVA operations."
	slowdown = 0

	species_restricted = list("Vaurca")

	boots = /obj/item/clothing/shoes/magboots/vox/vaurca
	helmet = /obj/item/clothing/head/helmet/space/void/vaurca

/obj/item/clothing/head/helmet/space/void/vaurca
	name = "void helmet"
	desc = "An alien looking Zo'rane softsuit helmet."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "helm_void"
	item_state = "helm_void"

	species_restricted = list("Vaurca")

	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/clothing/shoes/magboots/vox/vaurca

	desc = "A pair of heavy mag-claws designed for a Vaurca."
	name = "mag-claws"
	item_state = "boots_void"
	icon_state = "boots_void"
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'

	species_restricted = list("Vaurca","Vaurca Warform")
	sprite_sheets = list(
		"Vaurca Warform" = 'icons/mob/species/warriorform/shoes.dmi'
		)

	action_button_name = "Toggle the magclaws"

/obj/item/clothing/suit/space/void/scout
	name = "scout armor"
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "scout"
	item_state = "scout"
	desc = "Armor designed for K'laxan scouts, made of lightweight sturdy material that does not restrict movement."
	slowdown = -1

	species_restricted = list("Vaurca")
	armor = list(melee = 50, bullet = 20, laser = 50, energy = 30, bomb = 45, bio = 100, rad = 10)

/obj/item/clothing/head/helmet/space/void/scout
	name = "scout helmet"
	desc = "A helmet designed for K'laxan scouts, made of lightweight sturdy material that does not restrict movement."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "helm_scout"
	item_state = "helm_scout"

	species_restricted = list("Vaurca")
	armor = list(melee = 40, bullet = 20, laser = 40, energy = 30, bomb = 45, bio = 100, rad = 10)

	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/clothing/suit/space/void/commando
	name = "commando armor"
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "commando"
	item_state = "commando"
	desc = "A design perfected by the Zo'ra, this helmet is commonly used  by frontline warriors of a hive. Ablative design deflects lasers away from the body while providing moderate physical protection."

	species_restricted = list("Vaurca")
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 50, bomb = 45, bio = 100, rad = 10)

/obj/item/clothing/head/helmet/space/void/commando
	name = "commando helmet"
	desc = "A design perfected by the Zo'ra, this helmet is commonly used  by frontline warriors of a hive. Ablative design deflects lasers away from the body while providing moderate physical protection."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "helm_commando"
	item_state = "helm_commando"

	species_restricted = list("Vaurca")
	armor = list(melee = 30, bullet = 30, laser = 60, energy = 50, bomb = 45, bio = 100, rad = 10)

	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/clothing/mask/gas/vaurca
	name = "tactical garment"
	desc = "A tactical mandible garment with state of the art air filtration."
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | FLEXIBLEMATERIAL | THICKMATERIAL
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	gas_filter_strength = 3
	w_class = 2.0
	filtered_gases = list("nitrogen", "sleeping_agent")
	armor = list(melee = 25, bullet = 10, laser = 25, energy = 25, bomb = 0, bio = 50, rad = 15)
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "m_metalg"
	item_state = "m_metalg"
	contained_sprite = 1

/obj/item/melee/energy/vaurca_zweihander
	name = "thermal greatblade"
	desc = "An infamous execution blade of the Zo'ra, due to its size, only the largest Za were able to carry it in active combat."
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "greatblade0"
	item_state = "greatblade0"
	active_force = 30
	armor_penetration = 30
	active_throwforce = 20
	active_w_class = 5
	force = 10
	throwforce = 10
	throw_speed = 5
	throw_range = 10
	w_class = 4.0
	flags = CONDUCT | NOBLOODY
	attack_verb = list("stabbed", "chopped", "sliced", "cleaved", "slashed", "cut")
	sharp = 1
	edge = 1
	contained_sprite = 1
	base_reflectchance = 40
	base_block_chance = 60
	shield_power = 150

/obj/item/melee/energy/vaurca_zweihander/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	user.setClickCooldown(16)
	..()

/obj/item/melee/energy/vaurca_zweihander/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/obj/item/melee/energy/vaurca_zweihander/activate(mob/living/user)
	..()
	icon_state = "greatblade1"
	item_state = icon_state
	damtype = "fire"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/melee/energy/vaurca_zweihander/deactivate(mob/living/user)
	..()
	icon_state = "greatblade0"
	item_state = icon_state
	damtype = "brute"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	to_chat(user, "<span class='notice'>\The [src] is de-energised.</span>")

/obj/item/gun/launcher/crossbow/vaurca
	name = "gauss rifle"
	desc = "An unwieldy, heavy weapon that propels metal projectiles with magnetic coils that run its length."
	contained_sprite = 1
	icon = 'icons/obj/vaurca_items.dmi'
	icon_state = "gaussrifle"
	item_state = "gaussrifle"
	fire_sound = 'sound/effects/Explosion2.ogg'
	fire_sound_text = "a subdued boom"
	fire_delay = 12
	slot_flags = SLOT_BACK
	needspin = TRUE
	recoil = 6

	is_wieldable = TRUE

	release_speed = 5
	var/list/belt = new/list()
	var/belt_size = 12 //holds this + one in the chamber
	recoil_wielded = 2
	accuracy_wielded = -1
	fire_delay_wielded = 1

/obj/item/gun/launcher/crossbow/vaurca/update_icon()
	if(wielded)
		item_state = "gaussrifle-wielded"
	else
		item_state = "gaussrifle"
	update_held_icon()

/obj/item/gun/launcher/crossbow/vaurca/consume_next_projectile(mob/user=null)
	return bolt

/obj/item/gun/launcher/crossbow/vaurca/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 1
	..()

/obj/item/gun/launcher/crossbow/vaurca/attack_self(mob/living/user as mob)
	pump(user)

/obj/item/gun/launcher/crossbow/vaurca/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(bolt)
		if(tension < max_tension)
			if(do_after(M, 5 * tension))
				to_chat(M, "<span class='warning'>You pump [src], charging the magnetic coils.</span>")
				tension++
		else
			to_chat(M, "<span class='notice'>\The [src]'s magnetic coils are at maximum charge.</span>")
		return
	var/obj/item/next
	if(belt.len)
		next = belt[1]
	if(do_after(M, 10))
		if(next)
			belt -= next //Remove grenade from loaded list.
			bolt = next
			to_chat(M, "<span class='warning'>You pump [src], loading \a [next] into the chamber.</span>")
		else
			to_chat(M, "<span class='warning'>You pump [src], but the magazine is empty.</span>")

/obj/item/gun/launcher/crossbow/vaurca/proc/load(obj/item/W, mob/user)
	if(belt.len >= belt_size)
		to_chat(user, "<span class='warning'>[src] is full.</span>")
		return
	user.remove_from_mob(W)
	W.forceMove(src)
	belt.Insert(1, W) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("[user] inserts \a [W] into [src].", "<span class='notice'>You insert \a [W] into [src].</span>")

/obj/item/gun/launcher/crossbow/vaurca/proc/unload(mob/user)
	if(belt.len)
		var/obj/item/arrow/rod/R = belt[belt.len]
		belt.len--
		user.put_in_hands(R)
		user.visible_message("[user] removes \a [R] from [src].", "<span class='notice'>You remove \a [R] from [src].</span>")
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")

/obj/item/gun/launcher/crossbow/vaurca/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/arrow))
		load(I, user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/arrow/rod/ROD = new /obj/item/arrow/rod(src)
			load(ROD, user)
	else
		..()

/obj/item/gun/launcher/crossbow/vaurca/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/crossbow/vaurca/superheat_rod(mob/user)
	if(!user || !bolt) return
	if(bolt.throwforce >= 25) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	bolt.throwforce = 25
	bolt.icon_state = "metal-rod-superheated"

/obj/item/gun/launcher/crossbow/vaurca/update_icon()
	return
