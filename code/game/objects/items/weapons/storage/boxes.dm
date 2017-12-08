/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *		Kitchen utensil box
 * 		Random preserved snack box
 *		For syndicate call-ins see uplink_kits.dm
 */

	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	var/foldable = /obj/item/stack/material/cardboard	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	var/maxHealth = 20	//health is already defined

	. = ..()
	health = maxHealth

	health -= severity
	check_health()

	if (health <= 0)
		qdel(src)


	if (istype(user, /mob/living))
		var/mob/living/L = user

		if (istype(L, /mob/living/carbon/alien/diona) || istype(L, /mob/living/simple_animal) || istype(L, /mob/living/carbon/human))//Monkey-like things do attack_generic, not crew
			var/damage
			if (!L.mob_size)
				damage = 3//A safety incase i forgot to set a mob_size on something
			else
				damage = L.mob_size//he bigger you are, the faster it tears

			if (!damage || damage <= 0)
				return

			user.do_attack_animation(src)
			if ((health-damage) <= 0)
				L.visible_message("<span class='danger'>[L] tears open the [src], spilling its contents everywhere!</span>", "<span class='danger'>You tear open the [src], spilling its contents everywhere!</span>")
				spill()
			else
				animate_shake()
				var/toplay = pick(list('sound/effects/creatures/nibble1.ogg','sound/effects/creatures/nibble2.ogg'))
				playsound(loc, toplay, 30, 1)
			damage(damage)
	..()

	..()
	if (health < maxHealth)
		if (health >= (maxHealth * 0.5))
			user << span("warning", "It is slightly torn.")
		else
			user << span("danger", "It is full of tears and holes.")

// BubbleWrap - A box can be folded up to make card
	if(..()) return

	//try to fold it.
	if ( contents.len )
		return

	if ( !ispath(src.foldable) )
		return
	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			src.close(M)
		if ( M == user )
			found = 1
	if ( !found )	// User is too far away
		return
	// Now make the cardboard
	user << "<span class='notice'>You fold [src] flat.</span>"
	new src.foldable(get_turf(src))
	qdel(src)

	autodrobe_no_remove = 1

	..()
	new /obj/item/clothing/mask/breath( src )
	for(var/obj/item/thing in contents)
		thing.autodrobe_no_remove = 1

	..()
	new /obj/item/clothing/mask/breath( src )

	autodrobe_no_remove = 1

	..()
	new /obj/item/clothing/mask/breath( src )
	for(var/obj/item/thing in contents)
		thing.autodrobe_no_remove = 1

	name = "box of sterile gloves"
	desc = "Contains sterile gloves."
	icon_state = "latex"

	..()
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)

	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"

	..()
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)

	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"

	..()

	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	icon_state = "syringe"

	..()


	name = "box of beakers"
	icon_state = "beaker"

	..()

	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."

	..()

	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."

	..()
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)
	new /obj/item/ammo_casing/shotgun/blank(src)

	name = "box of beanbag shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)
	new /obj/item/ammo_casing/shotgun/beanbag(src)

	name = "box of shotgun slugs"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)
	new /obj/item/ammo_casing/shotgun(src)

	name = "box of shotgun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)
	new /obj/item/ammo_casing/shotgun/pellet(src)

	name = "box of illumination shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)
	new /obj/item/ammo_casing/shotgun/flash(src)

	name = "box of stun shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)
	new /obj/item/ammo_casing/shotgun/stunshell(src)

	name = "box of practice shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)
	new /obj/item/ammo_casing/shotgun/practice(src)

	name = "box of 14.5mm shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."

	..()
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)
	new /obj/item/ammo_casing/a145(src)

	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use."
	icon_state = "flashbang"

	..()

	name = "box of pepperspray grenades"
	desc = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "flashbang"

	..()

	name = "box of smoke grenades"
	desc = "A box full of smoke grenades, used by special law enforcement teams and military organisations. Provides cover, confusion, and distraction."
	icon_state = "flashbang"

	..()

	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"

	..()

	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	icon_state = "flashbang"

	..()

	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	icon_state = "flashbang"

	..()

	name = "box of frag grenades"
	desc = "A box containing 5 military grade fragmentation grenades.<br> WARNING: Live explosives. Misuse may result in serious injury or death."
	icon_state = "flashbang"

	..()

	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"

	..()

	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"

	..()

	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"

	..()
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)

	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."

	..()

	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"

	..()

	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

	..()

	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

	..()

	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

	..()

	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"

	..()

	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"

	..()
		for(var/i = 1; i <= 5; i++)

	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Adhomai. Just add water!"

	..()
	for(var/i = 1; i <= 5; i++)

	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"

	..()
	for(var/i = 1; i <= 5; i++)

	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"

	..()
	for(var/i = 1; i <= 5; i++)

	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

	..()

	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"

	..()

	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

	..()

	name = "box of zipties"
	desc = "A box full of zipties."
	icon_state = "handcuff"

	..()

	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"

	..()
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )

	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."

	..()

	name = "box of spray bottles"
	desc = "It has pictures of spray bottles on its front."

	..()

	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)

	..()
	for(var/i=1; i <= 8; i++)
		new /obj/item/toy/snappop(src)

	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	slot_flags = SLOT_BELT

	..()
	for(var/i=1; i <= 10; i++)

	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = "burn"
		W.icon_state = "match_lit"
		START_PROCESSING(SSprocessing, W)
	W.update_icon()
	return

	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

	..()
	for (var/i; i < 7; i++)

	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

	. = ..()
	make_exact_fit()

	..()
	for(var/i = 0; i < 21; i++)

	name = "box of replacement tubes"
	icon_state = "lighttube"

	..()
	for(var/i = 0; i < 21; i++)

	name = "box of replacement lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0; i < 14; i++)
	for(var/i = 0; i < 7; i++)

	name = "box of colored lights"
	icon_state = "lightmixed"

	..()
	var/static/list/tube_colors = list(
	)
	var/static/list/bulbs_colors = list(
	)
	for(var/i = 0, i < 14, i++)
		var/type = pick(tube_colors)
		new type(src)
	for(var/i = 0, i < 7, i++)
		var/type = pick(bulbs_colors)
		new type(src)

	name = "box of red lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "box of green lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "box of blue lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "box of cyan lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "box of yellow lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "box of magenta lights"
	icon_state = "lightmixed"

	..()
	for(var/i = 0, i < 14, i++)
	for(var/i = 0, i < 7, i++)

	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	max_w_class = 3
	max_storage_space = 21
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

	name = "kitchen supplies"
	desc = "Contains an assortment of utensils and containers useful in the preparation of food and drinks."


	var/list/utensils = list(
	)
	for (var/i = 0,i<6,i++)
		var/type = pick(utensils)
		new type(src)

	name = "rations box"
	desc = "Contains a random assortment of preserved foods. Guaranteed to remain edible* in room-temperature longterm storage for centuries!"

	var/list/snacks = list(
	)
	for (var/i = 0,i<7,i++)
		var/type = pick(snacks)
		new type(src)

	name = "stimpack value kit"
	desc = "A box with several stimpack medipens for the economical miner."
	icon_state = "syringe"

	for(var/i in 1 to 4)
