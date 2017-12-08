/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/list/code = list()
	var/list/lastattempt = list()
	var/attempts = 10
	var/codelen = 4
	locked = 1

/obj/structure/closet/crate/secure/loot/Initialize()
	. = ..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")

	for(var/i in 1 to codelen)
		code += pick(digits)
		digits -= code[code.len]

	generate_loot()

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/loot = rand(1, 100)
	switch(loot)
		if(1 to 5) // Common things go, 5%
		if(6 to 10)
			new/obj/item/device/taperecorder(src)
			new/obj/item/clothing/suit/space(src)
			new/obj/item/clothing/head/helmet/space(src)
		if(11 to 15)
		if(16 to 20)
			for(var/i = 0, i < 10, i++)
		if(21 to 25)
			for(var/i = 0, i < 3, i++)
				new/obj/machinery/portable_atmospherics/hydroponics(src)
		if(26 to 30)
			for(var/i = 0, i < 3, i++)
		if(31 to 35)
			spawn_money(rand(300,800), src)
		if(36 to 40)
		if(41 to 45)
			new/obj/item/clothing/under/shorts/red(src)
			new/obj/item/clothing/under/shorts/blue(src)
		if(46 to 50)
			new/obj/item/clothing/under/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new/obj/item/clothing/accessory/horrible(src)
		if(51 to 52) // Uncommon, 2% each
		if(53 to 54)
			new/obj/item/latexballon(src)
		if(55 to 56)
			var/newitem = pick(typesof(/obj/item/toy/prize) - /obj/item/toy/prize)
			new newitem(src)
		if(57 to 58)
			new/obj/item/toy/syndicateballoon(src)
		if(59 to 60)
		if(61 to 62)
			for(var/i = 0, i < 12, ++i)
				new/obj/item/clothing/head/kitty(src)
		if(63 to 64)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				new newcoin(src)
		if(65 to 66)
			new/obj/item/clothing/suit/ianshirt(src)
		if(67 to 68)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				new newitem(src)
		if(69 to 70)
		if(71 to 72)
		if(73 to 74)
		if(75 to 76)
		if(77 to 78)
		if(79 to 80)
		if(81 to 82)
		if(83 to 84)
			new/obj/item/toy/katana(src)
		if(85)
			new/obj/item/seeds/random(src)
		if(86) // Rarest things, some are unobtainble otherwise, some are just robust,  1% each
			new/obj/item/weed_extract(src)
		if(87)
			new/obj/item/xenos_claw(src)
		if(88)
			new/obj/item/ammo_magazine/boltaction(src)
			new/obj/item/clothing/under/soviet(src)
			new/obj/item/clothing/head/ushanka(src)
		if(89)
			new/obj/item/organ/xenos/plasmavessel(src)
		if(90)
			new/obj/item/organ/heart(src)
		if(91)
			new/obj/item/device/soulstone(src)
		if(92)
		if(93)
		if(94) // Why the hell not
			new/obj/item/clothing/under/rank/clown(src)
			new/obj/item/clothing/shoes/clown_shoes(src)
			new/obj/item/device/pda/clown(src)
			new/obj/item/clothing/mask/gas/clown_hat(src)
			new/obj/item/toy/waterflower(src)
		if(95)
			new/obj/item/clothing/under/mime(src)
			new/obj/item/clothing/shoes/black(src)
			new/obj/item/device/pda/mime(src)
			new/obj/item/clothing/gloves/white(src)
			new/obj/item/clothing/mask/gas/mime(src)
			new/obj/item/clothing/head/beret(src)
			new/obj/item/clothing/accessory/suspenders(src)
		if(96)
		if(97)
		if(98)
		if(99)
			new/obj/item/clothing/mask/luchador(src)
		if(100)
			new/obj/item/ammo_magazine/t40(src)
			new/obj/item/ammo_magazine/t40(src)
			new/obj/item/ammo_magazine/t40/rubber(src)
			new/obj/item/clothing/under/rank/dispatch(src)
			new/obj/item/clothing/accessory/badge/old(src)
			new/obj/item/clothing/head/helmet/formalcaptain(src)

/obj/structure/closet/crate/secure/loot/togglelock(mob/user as mob)
	if(!locked)
		return

	user << "<span class='notice'>The crate is locked with a Deca-code lock.</span>"
	var/input = input(user, "Enter [codelen] digits.", "Deca-Code Lock", "") as text
	if(!Adjacent(user))
		return

	if(input == null || length(input) != codelen)
		user << "<span class='notice'>You leave the crate alone.</span>"
	else if(check_input(input))
		user << "<span class='notice'>The crate unlocks!</span>"
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		set_locked(0)
	else
		visible_message("<span class='warning'>A red light on \the [src]'s control panel flashes briefly.</span>")
		attempts--
		if (attempts == 0)
			user << "<span class='danger'>The crate's anti-tamper system activates!</span>"
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 1, 2)
			qdel(src)

/obj/structure/closet/crate/secure/loot/emag_act(var/remaining_charges, var/mob/user)
	if (locked)
		user << "<span class='notice'>The crate unlocks!</span>"
		locked = 0

/obj/structure/closet/crate/secure/loot/proc/check_input(var/input)
	if(length(input) != codelen)
		return 0

	. = 1
	lastattempt.Cut()
	for(var/i in 1 to codelen)
		var/guesschar = copytext(input, i, i+1)
		lastattempt += guesschar
		if(guesschar != code[i])
			. = 0

	if(locked)
		if (ismultitool(W)) // Greetings Urist McProfessor, how about a nice game of cows and bulls?
			user << "<span class='notice'>DECA-CODE LOCK ANALYSIS:</span>"
			if (attempts == 1)
				user << "<span class='warning'>* Anti-Tamper system will activate on the next failed access attempt.</span>"
			else
				user << "<span class='notice'>* Anti-Tamper system will activate after [src.attempts] failed access attempts.</span>"
			if(lastattempt.len)
				var/bulls = 0
				var/cows = 0

				var/list/code_contents = code.Copy()
				for(var/i in 1 to codelen)
					if(lastattempt[i] == code[i])
						++bulls
					else if(lastattempt[i] in code_contents)
						++cows
					code_contents -= lastattempt[i]
				user << "<span class='notice'>Last code attempt had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions.</span>"
			return
	..()
