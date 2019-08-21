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
 *		Firing pin boxes - Testing and Normal. one for sec, one for science.
 */

/obj/item/weapon/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	var/foldable = /obj/item/stack/material/cardboard	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	var/maxHealth = 20	//health is already defined
	use_sound = 'sound/items/storage/box.ogg'
	drop_sound = 'sound/items/drop/box.ogg'
	var/chewable = TRUE

/obj/item/weapon/storage/box/Initialize()
	. = ..()
	health = maxHealth

/obj/item/weapon/storage/box/proc/damage(var/severity)
	health -= severity
	check_health()

/obj/item/weapon/storage/box/proc/check_health()
	if (health <= 0)
		qdel(src)

/obj/item/weapon/storage/box/attack_generic(var/mob/user)
	if(!chewable)
		return
	if (istype(user, /mob/living))
		var/mob/living/L = user

		if (istype(L, /mob/living/carbon/alien/diona) || istype(L, /mob/living/simple_animal) || istype(L, /mob/living/carbon/human))//Monkey-like things do attack_generic, not crew
			if(contents.len && !locate(/obj/item/weapon/reagent_containers/food) in src) // you can tear open empty boxes for nesting material, or for food
				to_chat(user, span("warning", "There's no food in that box!"))
				return
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

/obj/item/weapon/storage/box/examine(var/mob/user)
	..()
	if (health < maxHealth)
		if (health >= (maxHealth * 0.5))
			to_chat(user, span("warning", "It is slightly torn."))
		else
			to_chat(user, span("danger", "It is full of tears and holes."))

// BubbleWrap - A box can be folded up to make card
/obj/item/weapon/storage/box/attack_self(mob/user as mob)
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
	to_chat(user, "<span class='notice'>You fold [src] flat.</span>")
	playsound(src.loc, 'sound/items/storage/boxfold.ogg', 30, 1)
	new src.foldable(get_turf(src))
	qdel(src)

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	..()

/obj/item/weapon/storage/box/survival
	autodrobe_no_remove = 1
	starts_with = list(/obj/item/clothing/mask/breath = 1, /obj/item/weapon/tank/emergency_oxygen = 1)

/obj/item/weapon/storage/box/survival/fill()
	..()
	for(var/obj/item/thing in contents)
		thing.autodrobe_no_remove = 1

/obj/item/weapon/storage/box/vox
	starts_with = list(/obj/item/clothing/mask/breath = 1, /obj/item/weapon/tank/emergency_nitrogen = 1)

/obj/item/weapon/storage/box/engineer
	autodrobe_no_remove = 1
	starts_with = list(/obj/item/clothing/mask/breath = 1, /obj/item/weapon/tank/emergency_oxygen/engi = 1)

/obj/item/weapon/storage/box/engineer/fill()
	..()
	for(var/obj/item/thing in contents)
		thing.autodrobe_no_remove = 1

/obj/item/weapon/storage/box/vaurca
	autodrobe_no_remove = 1
	starts_with = list(/obj/item/clothing/mask/breath = 1, /obj/item/weapon/reagent_containers/inhaler/phoron_special = 1)

/obj/item/weapon/storage/box/vaurca/fill()
	..()
	for(var/obj/item/thing in contents)
		thing.autodrobe_no_remove = 1

/obj/item/weapon/storage/box/gloves
	name = "box of sterile gloves"
	desc = "Contains sterile gloves."
	icon_state = "latex"
	starts_with = list(/obj/item/clothing/gloves/latex = 4, /obj/item/clothing/gloves/latex/nitrile = 3)

/obj/item/weapon/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"
	starts_with = list(/obj/item/clothing/mask/surgical = 7)

/obj/item/weapon/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"
	starts_with = list(/obj/item/weapon/reagent_containers/syringe = 20)

/obj/item/weapon/storage/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	icon_state = "syringe"
	starts_with = list(/obj/item/weapon/syringe_cartridge = 7)

/obj/item/weapon/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"
	starts_with = list(/obj/item/weapon/reagent_containers/glass/beaker = 7)

/obj/item/weapon/storage/box/injectors
	name = "box of DNA injectors"
	desc = "This box contains injectors it seems."
	starts_with = list(/obj/item/weapon/dnainjector/h2m = 3, /obj/item/weapon/dnainjector/m2h = 3)

/obj/item/weapon/storage/box/blanks
	name = "box of blank shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front."
	icon_state = "blankshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/blank = 8)

/obj/item/weapon/storage/box/beanbags
	name = "box of beanbag shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "beanshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/beanbag = 8)

/obj/item/weapon/storage/box/shotgunammo
	name = "box of shotgun slugs"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "lethalslug_box"
	starts_with = list(/obj/item/ammo_casing/shotgun = 8)

/obj/item/weapon/storage/box/shotgunshells
	name = "box of shotgun shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "lethalshell_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/pellet = 8)

/obj/item/weapon/storage/box/flashshells
	name = "box of illumination shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "illumshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/flash = 8)

/obj/item/weapon/storage/box/stunshells
	name = "box of stun shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "stunshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/stunshell = 8)

/obj/item/weapon/storage/box/practiceshells
	name = "box of practice shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "blankshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/practice = 8)

/obj/item/weapon/storage/box/haywireshells
	name = "box of haywire shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "empshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/emp = 8)

/obj/item/weapon/storage/box/incendiaryshells
	name = "box of incendiary shells"
	desc = "It has a picture of a shotgun shell and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "incendiaryshot_box"
	starts_with = list(/obj/item/ammo_casing/shotgun/incendiary = 8)

/obj/item/weapon/storage/box/sniperammo
	name = "box of 14.5mm shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	starts_with = list(/obj/item/ammo_casing/a145 = 7)

/obj/item/weapon/storage/box/ammo10mm
	name = "box of 10mm shells"
	desc = "It has a picture of a gun and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	starts_with = list(/obj/item/ammo_casing/c10mm = 10)

/obj/item/weapon/storage/box/flashbangs
	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/flashbang = 7)

/obj/item/weapon/storage/box/firingpins
	name = "box of firing pins"
	desc = "A box of NT brand Firearm authentication pins; Needed to operate most weapons."
	starts_with = list(/obj/item/device/firing_pin = 7)

/obj/item/weapon/storage/box/testpins
	name = "box of firing pins"
	desc = "A box of NT brand Testing Authentication pins; allows guns to fire in designated firing ranges."
	starts_with = list(/obj/item/device/firing_pin/test_range = 7)

/obj/item/weapon/storage/box/loyaltypins
	name = "box of firing pins"
	desc = "A box of specialised \"loyalty\" authentication pins produced by Nanotrasen; these check to see if the user of the gun it's installed in has been implanted with a loyalty implant. Often used in ERTs."
	starts_with = list(/obj/item/device/firing_pin/implant/loyalty = 7)

/obj/item/weapon/storage/box/loyaltypins/fill()
	..()
	new /obj/item/device/firing_pin/implant/loyalty(src)
	new /obj/item/device/firing_pin/implant/loyalty(src)
	new /obj/item/device/firing_pin/implant/loyalty(src)
	new /obj/item/device/firing_pin/implant/loyalty(src)

/obj/item/weapon/storage/box/firingpinsRD
	name = "box of assorted firing pins"
	desc = "A box of varied assortment of firing pins. Appears to have R&D stickers on all sides of the box. Also seems to have a smiley face sticker on the top of it."
	starts_with = list(/obj/item/device/firing_pin = 2, /obj/item/device/firing_pin/access = 2, /obj/item/device/firing_pin/implant/loyalty = 2, /obj/item/device/firing_pin/clown = 1, /obj/item/device/firing_pin/dna = 1)

/obj/item/weapon/storage/box/teargas
	name = "box of pepperspray grenades"
	desc = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/chem_grenade/teargas = 6)

/obj/item/weapon/storage/box/smokebombs
	name = "box of smoke grenades"
	desc = "A box full of smoke grenades, used by special law enforcement teams and military organisations. Provides cover, confusion, and distraction."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/smokebomb = 7)

/obj/item/weapon/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/empgrenade = 5)

/obj/item/weapon/storage/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/smokebomb = 5)

/obj/item/weapon/storage/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/anti_photon = 5)

/obj/item/weapon/storage/box/frags
	name = "box of frag grenades"
	desc = "A box containing 5 military grade fragmentation grenades.<br> WARNING: Live explosives. Misuse may result in serious injury or death."
	icon_state = "flashbang"
	starts_with = list(/obj/item/weapon/grenade/frag = 5)

/obj/item/weapon/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
	starts_with = list(/obj/item/weapon/implantcase/tracking = 4, /obj/item/weapon/implanter = 1, /obj/item/weapon/implantpad = 1, /obj/item/weapon/locator = 1)


/obj/item/weapon/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
	starts_with = list(/obj/item/weapon/implantcase/chem = 4, /obj/item/weapon/implanter = 1, /obj/item/weapon/implantpad = 1)

/obj/item/weapon/storage/box/chemimp/fill()
	..()
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implantcase/chem(src)
	new /obj/item/weapon/implanter(src)
	new /obj/item/weapon/implantpad(src)

/obj/item/weapon/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	starts_with = list(/obj/item/clothing/glasses/regular = 7)

/obj/item/weapon/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."
	starts_with = list(/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 6)

/obj/item/weapon/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"
	starts_with = list(/obj/item/weapon/implanter = 1, /obj/item/weapon/implantcase/death_alarm = 6)

/obj/item/weapon/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	starts_with = list(/obj/item/weapon/reagent_containers/food/condiment = 6)

/obj/item/weapon/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
	starts_with = list(/obj/item/weapon/reagent_containers/food/drinks/sillycup = 7)

/obj/item/weapon/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket = 6)

/obj/item/weapon/storage/box/sinpockets
	name = "box of sin-pockets"
	desc = "<B>Instructions:</B> <I>Crush bottom of package to initiate chemical heating. Wait for 20 seconds before consumption. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket = 6)

/obj/item/weapon/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube)
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped = 5)


/obj/item/weapon/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Adhomai. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 5)

/obj/item/weapon/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube = 5)

/obj/item/weapon/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube = 5)

/obj/item/weapon/storage/box/monkeycubes/vkrexicubes
	name = "vkrexi cube box"
	desc = "Drymate brand vkrexi cubes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/vkrexicube = 5)

/obj/item/weapon/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	starts_with = list(/obj/item/weapon/card/id = 7)

/obj/item/weapon/storage/box/seccarts
	name = "box of spare R.O.B.U.S.T. Cartridges"
	desc = "A box full of R.O.B.U.S.T. Cartridges, used by Security."
	icon_state = "pda"
	starts_with = list(/obj/item/weapon/cartridge/security = 7)

/obj/item/weapon/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	starts_with = list(/obj/item/weapon/handcuffs = 7)

/obj/item/weapon/storage/box/zipties
	name = "box of zipties"
	desc = "A box full of zipties."
	icon_state = "handcuff"
	starts_with = list(/obj/item/weapon/handcuffs/ziptie = 7)

/obj/item/weapon/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"
	starts_with = list(/obj/item/device/assembly/mousetrap = 6)

/obj/item/weapon/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	icon_state = "pillbox"
	starts_with = list(/obj/item/weapon/storage/pill_bottle = 7)

/obj/item/weapon/storage/box/spraybottles
	name = "box of spray bottles"
	desc = "It has pictures of spray bottles on its front."
	starts_with = list(/obj/item/weapon/reagent_containers/spray = 7)

/obj/item/weapon/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)
	starts_with = list(/obj/item/toy/snappop = 8)

/obj/item/weapon/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = 1
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/weapon/flame/match)
	starts_with = list(/obj/item/weapon/flame/match = 10)

/obj/item/weapon/storage/box/matches/attackby(obj/item/weapon/flame/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		if(prob(25))
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_lit.ogg', 25, 0, -1)
			user.visible_message("<span class='notice'>[user] manages to light the match on the matchbox.</span>")
			W.lit = 1
			W.damtype = "burn"
			W.icon_state = "match_lit"
			START_PROCESSING(SSprocessing, W)
		else
			playsound(src.loc, 'sound/items/cigs_lighters/matchstick_hit.ogg', 25, 0, -1)
	W.update_icon()
	return


/obj/item/weapon/storage/box/autoinjectors
	name = "box of empty injectors"
	desc = "Contains empty autoinjectors."
	icon_state = "syringe"
	starts_with = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector = 7)

/obj/item/weapon/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/weapon/storage/box/lights/Initialize()	// TODO-STORAGE: Initialize()?
	. = ..()
	make_exact_fit()

/obj/item/weapon/storage/box/lights/bulbs
	starts_with = list(/obj/item/weapon/light/bulb = 21)

/obj/item/weapon/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	starts_with = list(/obj/item/weapon/light/tube = 21)

/obj/item/weapon/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube = 14, /obj/item/weapon/light/bulb = 7)

/obj/item/weapon/storage/box/lights/coloredmixed
	name = "box of colored lights"
	icon_state = "lightmixed"

/obj/item/weapon/storage/box/lights/coloredmixed/fill() // too lazy for this one
	..()
	var/static/list/tube_colors = list(
		/obj/item/weapon/light/tube/colored/red,
		/obj/item/weapon/light/tube/colored/green,
		/obj/item/weapon/light/tube/colored/blue,
		/obj/item/weapon/light/tube/colored/magenta,
		/obj/item/weapon/light/tube/colored/yellow,
		/obj/item/weapon/light/tube/colored/cyan
	)
	var/static/list/bulbs_colors = list(
		/obj/item/weapon/light/bulb/colored/red,
		/obj/item/weapon/light/bulb/colored/green,
		/obj/item/weapon/light/bulb/colored/blue,
		/obj/item/weapon/light/bulb/colored/magenta,
		/obj/item/weapon/light/bulb/colored/yellow,
		/obj/item/weapon/light/bulb/colored/cyan
	)
	for(var/i = 0, i < 14, i++)
		var/type = pick(tube_colors)
		new type(src)
	for(var/i = 0, i < 7, i++)
		var/type = pick(bulbs_colors)
		new type(src)

/obj/item/weapon/storage/box/lights/colored/red
	name = "box of red lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/red = 14, /obj/item/weapon/light/bulb/colored/red = 7)

/obj/item/weapon/storage/box/lights/colored/green
	name = "box of green lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/green = 14, /obj/item/weapon/light/bulb/colored/green = 7)

/obj/item/weapon/storage/box/lights/colored/blue
	name = "box of blue lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/blue = 14, /obj/item/weapon/light/bulb/colored/blue = 7)

/obj/item/weapon/storage/box/lights/colored/cyan
	name = "box of cyan lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/cyan = 14, /obj/item/weapon/light/bulb/colored/cyan = 7)

/obj/item/weapon/storage/box/lights/colored/yellow
	name = "box of yellow lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/yellow = 14, /obj/item/weapon/light/bulb/colored/yellow = 7)

/obj/item/weapon/storage/box/lights/colored/magenta
	name = "box of magenta lights"
	icon_state = "lightmixed"
	starts_with = list(/obj/item/weapon/light/tube/colored/magenta = 14, /obj/item/weapon/light/bulb/colored/magenta = 7)

/obj/item/weapon/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	max_w_class = 3
	can_hold = list(/obj/item/organ, /obj/item/weapon/reagent_containers/food, /obj/item/weapon/reagent_containers/glass)
	max_storage_space = 21
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try
	chewable = FALSE

/obj/item/weapon/storage/box/kitchen
	name = "kitchen supplies"
	desc = "Contains an assortment of utensils and containers useful in the preparation of food and drinks."

/obj/item/weapon/storage/box/kitchen/fill()
	new /obj/item/weapon/material/knife(src)//Should always have a knife

	var/list/utensils = list(
		/obj/item/weapon/material/kitchen/rollingpin,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/material/kitchen/utensil/fork,
		/obj/item/weapon/reagent_containers/food/condiment/enzyme,
		/obj/item/weapon/material/kitchen/utensil/spoon,
		/obj/item/weapon/material/kitchen/utensil/knife,
		/obj/item/weapon/reagent_containers/food/drinks/shaker
	)
	for (var/i = 0,i<6,i++)
		var/type = pick(utensils)
		new type(src)

/obj/item/weapon/storage/box/snack
	name = "rations box"
	desc = "Contains a random assortment of preserved foods. Guaranteed to remain edible* in room-temperature longterm storage for centuries!"

/obj/item/weapon/storage/box/snack/fill()
	var/list/snacks = list(
			/obj/item/weapon/reagent_containers/food/snacks/koisbar_clean,
			/obj/item/weapon/reagent_containers/food/snacks/candy,
			/obj/item/weapon/reagent_containers/food/snacks/candy_corn,
			/obj/item/weapon/reagent_containers/food/snacks/chips,
			/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
			/obj/item/weapon/reagent_containers/food/snacks/chocolateegg,
			/obj/item/weapon/reagent_containers/food/snacks/popcorn,
			/obj/item/weapon/reagent_containers/food/snacks/sosjerky,
			/obj/item/weapon/reagent_containers/food/snacks/no_raisin,
			/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,
			/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,
			/obj/item/weapon/reagent_containers/food/snacks/syndicake,
			/obj/item/weapon/reagent_containers/food/snacks/fortunecookie,
			/obj/item/weapon/reagent_containers/food/snacks/poppypretzel,
			/obj/item/weapon/reagent_containers/food/snacks/cracker,
			/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
			/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks,
			/obj/item/weapon/reagent_containers/food/snacks/tastybread,
			/obj/item/weapon/reagent_containers/food/snacks/meatsnack,
			/obj/item/weapon/reagent_containers/food/snacks/maps,
			/obj/item/weapon/reagent_containers/food/snacks/nathisnack,
			/obj/item/weapon/reagent_containers/food/snacks/adhomian_can,
			/obj/item/weapon/reagent_containers/food/snacks/tuna
	)
	for (var/i = 0,i<7,i++)
		var/type = pick(snacks)
		new type(src)

/obj/item/weapon/storage/box/stims
	name = "stimpack value kit"
	desc = "A box with several stimpack medipens for the economical miner."
	icon_state = "syringe"
	starts_with = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack = 4)

/obj/item/weapon/storage/box/inhalers
	name = "inhaler kit"
	desc = "A box filled with several inhalers and empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/weapon/personal_inhaler = 2, /obj/item/weapon/reagent_containers/personal_inhaler_cartridge = 6)

/obj/item/weapon/storage/box/inhalers_large
	name = "combat inhaler kit"
	desc = "A box filled with a combat inhaler and several large empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/weapon/personal_inhaler/combat = 1, /obj/item/weapon/reagent_containers/personal_inhaler_cartridge/large = 6)

/obj/item/weapon/storage/box/inhalers_auto
	name = "autoinhaler kit"
	desc = "A box filled with a combat inhaler and several large empty inhaler cartridges."
	icon_state = "box_inhalers"
	starts_with = list(/obj/item/weapon/reagent_containers/inhaler = 8)

/obj/item/weapon/storage/box/clams
	name = "box of Ras'val clam"
	desc = "A box filled with clams from the Ras'val sea, imported by Njadra'Akhar Enterprises."
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/clam = 5)

/obj/item/weapon/storage/box/produce
	name = "produce box"
	desc = "A large box of random, leftover produce."
	icon_state = "largebox"
	starts_with = list(/obj/random_produce = 12)

/obj/item/weapon/storage/box/produce/fill()
	. = ..()
	make_exact_fit()


/obj/item/weapon/storage/box/candy
	name = "candy box"
	desc = "A large box of assorted small candy."
	icon_state = "largebox"

/obj/item/weapon/storage/box/candy/fill()
	var/list/assorted_list = list(
		/obj/item/weapon/reagent_containers/food/snacks/cb01 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb02 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb03 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb04 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb05 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb06 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb07 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb08 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb09 = 1,
		/obj/item/weapon/reagent_containers/food/snacks/cb10 = 1
	)

	for(var/i in 1 to 24)
		var/chosen_candy = pickweight(assorted_list)
		new chosen_candy(src)

	make_exact_fit()


/obj/item/weapon/storage/box/crabmeat
	name = "box of crab legs"
	desc = "A box filled with high-quality crab legs. Shipped to Aurora by popular demand!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/crabmeat = 5)

/obj/item/weapon/storage/box/tranquilizer
	name = "box of tranquilizer darts"
	desc = "It has a picture of a tranquilizer dart and several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	icon_state = "incendiaryshot_box"
	starts_with = list(/obj/item/ammo_casing/tranq = 8)

/obj/item/weapon/storage/box/toothpaste
	can_hold = list(/obj/item/weapon/reagent_containers/toothpaste,
					/obj/item/weapon/reagent_containers/toothbrush)

	starts_with = list(/obj/item/weapon/reagent_containers/toothpaste = 1,
					/obj/item/weapon/reagent_containers/toothbrush = 1)

/obj/item/weapon/storage/box/toothpaste/green
	starts_with = list(/obj/item/weapon/reagent_containers/toothpaste = 1,
					/obj/item/weapon/reagent_containers/toothbrush/green = 1)

/obj/item/weapon/storage/box/toothpaste/red
	starts_with = list(/obj/item/weapon/reagent_containers/toothpaste = 1,
				/obj/item/weapon/reagent_containers/toothbrush/red = 1)

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	starts_with = list(/obj/item/clothing/accessory/badge/holo = 4,
				/obj/item/clothing/accessory/badge/holo/cord = 2)

/obj/item/weapon/storage/box/sol_visa
	name = "Sol Alliance visa recommendations box"
	desc = "A box full of Sol Aliance visa recommendation slips."
	starts_with = list(/obj/item/clothing/accessory/badge/sol_visa = 6)

/obj/item/weapon/storage/box/ceti_visa
	name = "TCFL recruitment papers box"
	desc = "A box full of papers that signify one as a recruit of the Tau Ceti Foreign Legion."
	starts_with = list(/obj/item/clothing/accessory/badge/tcfl_papers = 6)

/obj/item/weapon/storage/box/hadii_card
	name = "honorary party member card box"
	desc = "A box full of Hadiist party member cards."
	starts_with = list(/obj/item/clothing/accessory/badge/hadii_card = 6)

/obj/item/weapon/storage/box/hadii_manifesto
	name = "hadiist manifesto card box"
	desc = "A box full of hadiist manifesto books."
	starts_with = list(/obj/item/weapon/book/manual/pra_manifesto = 6)

/obj/item/weapon/storage/box/dominia_honor
	name = "dominian honor codex box"
	desc = "A box full of dominian honor codex "
	starts_with = list(/obj/item/weapon/book/manual/dominia_honor = 6)

/obj/item/weapon/storage/box/tcfl_pamphlet
	name = "tau ceti foreign legion pamphlets box"
	desc = "A box full of tau ceti foreign legion pamphlets."
	starts_with = list(/obj/item/weapon/book/manual/tcfl_pamphlet = 6)

/obj/item/weapon/storage/box/sharps
	name = "sharps disposal box"
	desc = "A plastic box for disposal of used needles and other sharp, potentially-contaminated tools. There is a large biohazard sign on the front."
	icon_state = "sharpsbox"
	chewable = FALSE