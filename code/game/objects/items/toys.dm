/* Toys!
 * Contains:
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Toy bosun's whistle
 *      Toy mechs
 *		Snap pops
 *		Water flower
 *      Therapy dolls
 *      Toddler doll
 *      Inflatable duck
 *		Action figures
 *		Plushies
 *		Toy cult sword
 */


/obj/item/toy
	icon = 'icons/obj/toy.dmi'
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	drop_sound = 'sound/items/drop/gloves.ogg'

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"
	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/toy/balloon/New()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src

/obj/item/toy/balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, 10)
		to_chat(user, "<span class='notice'>You fill the balloon with the contents of [A].</span>")
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, "<span class='notice'>You fill the balloon with the contents of [O].</span>")
					O.reagents.trans_to_obj(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/throw_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message("<span class='warning'>\The [src] bursts!</span>","You hear a pop and a splash.")
		src.reagents.touch_turf(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.touch(A)
		src.icon_state = "burst"
		QDEL_IN(src, 5)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "criminal balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	icon_state = "syndballoon"
	item_state = "syndballoon"
	drop_sound = 'sound/items/drop/rubber.ogg'
	w_class = ITEMSIZE_LARGE

/obj/item/toy/nanotrasenballoon
	name = "nanotrasen balloon"
	desc = "Across the balloon the following is printed: \"Man, I love NanoTrasen soooo much. I use only NT products. You have NO idea.\""
	icon_state = "ntballoon"
	item_state = "ntballoon"
	w_class = ITEMSIZE_LARGE
	drop_sound = 'sound/items/drop/rubber.ogg'

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	drop_sound = 'sound/items/drop/gun.ogg'
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 5

	examine(mob/user)
		if(..(user, 2) && bullets)
			to_chat(user, "<span class='notice'>It is loaded with [bullets] foam darts!</span>")

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/toy/ammo/crossbow))
			if(bullets <= 4)
				user.drop_from_inventory(I,src)
				qdel(I)
				bullets++
				to_chat(user, "<span class='notice'>You load the foam dart into the crossbow.</span>")
			else
				to_chat(usr, "<span class='warning'>It's already fully loaded.</span>")


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if(!isturf(target.loc) || target == user) return
		if(flag) return

		if (locate (/obj/structure/table, src.loc))
			return
		else if (bullets)
			var/turf/trg = get_turf(target)
			var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
			bullets--
			D.icon_state = "foamdart"
			D.name = "foam dart"
			playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

			for(var/i=0, i<6, i++)
				if (D)
					if(D.loc == trg) break
					step_towards(D,trg)

					for(var/mob/living/M in D.loc)
						if(!istype(M,/mob/living)) continue
						if(M == user) continue
						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("<span class='warning'>\The [] was hit by the foam dart!</span>", M), 1)
						new /obj/item/toy/ammo/crossbow(M.loc)
						qdel(D)
						return

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							new /obj/item/toy/ammo/crossbow(A.loc)
							qdel(D)

				sleep(1)

			spawn(10)
				if(D)
					new /obj/item/toy/ammo/crossbow(D.loc)
					qdel(D)

			return
		else if (bullets == 0)
			user.Weaken(5)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("<span class='warning'>\The [] realized they were out of ammo and starting scrounging for some!</span>", user), 1)


	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

// ******* Check

		if (src.bullets > 0 && M.lying)

			for(var/mob/O in viewers(M, null))
				if(O.client)
					O.show_message(text("<span class='danger'>\The [] casually lines up a shot with []'s head and pulls the trigger!</span>", user, M), 1, "<span class='warning'>You hear the sound of foam against skull</span>", 2)
					O.show_message(text("<span class='warning'>\The [] was hit in the head by the foam dart!</span>", M), 1)

			playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)
			new /obj/item/toy/ammo/crossbow(M.loc)
			src.bullets--
		else if (M.lying && src.bullets == 0)
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message(text("<span class='danger'>\The [] casually lines up a shot with []'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!</span>", user, M), 1, "<span class='warning'>You hear someone fall</span>", 2)
			user.Weaken(5)
		return

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	drop_sound = 'sound/items/drop/food.ogg'

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = null
	anchored = 1
	density = 0


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of a blue energy sword. Realistic sounds and colors! Ages 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	drop_sound = 'sound/items/drop/gun.ogg'
	var/active = 0.0
	var/colorvar = "blue"
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	attack_self(mob/user as mob)
		src.active = !( src.active )
		if (src.active)
			to_chat(user, "<span class='notice'>You extend the plastic blade with a quick flick of your wrist.</span>")
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			src.icon_state = "sword[colorvar]"
			src.item_state = "sword[colorvar]"
			src.w_class = ITEMSIZE_LARGE
		else
			to_chat(user, "<span class='notice'>You push the plastic blade back down into the handle.</span>")
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
			src.icon_state = "sword0"
			src.item_state = "sword0"
			src.w_class = ITEMSIZE_SMALL

		if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			H.update_inv_l_hand()
			H.update_inv_r_hand()

		src.add_fingerprint(user)
		return

/obj/item/toy/sword/Initialize()
	. = ..()
	colorvar = pick("red","blue","green","purple")
	desc = "A cheap, plastic replica of a [colorvar] energy sword. Realistic sounds and colors! Ages 8 and up."

/obj/item/toy/katana
	name = "replica katana"
	desc = "A cheap plastic katana that luckily isn't sharp enough to accidentally cut your floor length braid. Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	drop_sound = 'sound/items/drop/gun.ogg'
	hitsound = "swing_hit"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/food.ogg'

	throw_impact(atom/hit_atom)
		..()
		spark(src, 3, alldirs)
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message("<span class='warning'>The [src.name] explodes!</span>","<span class='warning'>You hear a snap!</span>")
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == "run")
			to_chat(M, "<span class='warning'>You step on the snap pop!</span>")

			spark(src, 2)
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message("<span class='warning'>The [src.name] explodes!</span>","<span class='warning'>You hear a snap!</span>")
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/toy.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	drop_sound = 'sound/items/drop/herb.ogg'
	var/empty = 0
	flags

/obj/item/toy/waterflower/New()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src
	R.add_reagent("water", 10)

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterflower/afterattack(atom/A as mob|obj, mob/user as mob)

	if (istype(A, /obj/item/storage/backpack ))
		return

	else if (locate (/obj/structure/table, src.loc))
		return

	else if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, "<span class='notice'>You refill your flower!</span>")
		return

	else if (src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, "<span class='notice'>Your flower has run dry!</span>")
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(get_turf(src))
		D.name = "water"
		D.icon = 'icons/obj/chemical.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to_obj(D, 1)
		playsound(src.loc, 'sound/effects/spray3.ogg', 50, 1, -6)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.reagents.touch_turf(get_turf(D))
				for(var/atom/T in get_turf(D))
					D.reagents.touch(T)
					if(ismob(T) && T:client)
						to_chat(T:client, "<span class='warning'>\The [user] has sprayed you with water!</span>")
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/examine(mob/user)
	if(..(user, 0))
		to_chat(user, text("\icon[] [] units of water left!", src, src.reagents.total_volume))

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A genuine Admiral Krush Bosun's Whistle, for the aspiring ship's captain! Suitable for ages 8 and up, do not swallow."
	icon_state = "bosunwhistle"
	drop_sound = 'sound/items/drop/card.ogg'
	var/cooldown = 0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS

/obj/item/toy/bosunwhistle/attack_self(mob/user as mob)
	if(cooldown < world.time - 35)
		to_chat(user, "<span class='notice'>You blow on [src], creating an ear-splitting noise!</span>")
		playsound(user, 'sound/misc/boatswain.ogg', 20, 1)
		cooldown = world.time

/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon_state = "ripleytoy"
	var/cooldown = 0
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/mecha/mechstep.ogg'

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	if(cooldown < world.time - 8)
		to_chat(user, "<span class='notice'>You play with [src].</span>")
		playsound(user, 'sound/mecha/mechstep.ogg', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"

/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/11."
	icon_state = "phazonprize"

/*
 * Action figures
 */

/obj/item/toy/figure
	name = "completely glitched action figure"
	desc = "A \"Space Life\" brand... wait, what the hell is this thing? It seems to be requesting the sweet release of death."
	icon_state = "glitched"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/toy/figure/cmo
	name = "chief medical officer action figure"
	desc = "A \"Space Life\" brand chief medical officer action figure."
	icon_state = "cmo"

/obj/item/toy/figure/assistant
	name = "assistant action figure"
	desc = "A \"Space Life\" brand assistant action figure."
	icon_state = "assistant"

/obj/item/toy/figure/atmos
	name = "atmospheric technician action figure"
	desc = "A \"Space Life\" brand atmospheric technician action figure."
	icon_state = "atmos"

/obj/item/toy/figure/bartender
	name = "bartender action figure"
	desc = "A \"Space Life\" brand bartender action figure."
	icon_state = "bartender"

/obj/item/toy/figure/borg
	name = "cyborg action figure"
	desc = "A \"Space Life\" brand cyborg action figure."
	icon_state = "borg"

/obj/item/toy/figure/gardener
	name = "gardener action figure"
	desc = "A \"Space Life\" brand gardener action figure."
	icon_state = "botanist"

/obj/item/toy/figure/captain
	name = "captain action figure"
	desc = "A \"Space Life\" brand captain action figure."
	icon_state = "captain"

/obj/item/toy/figure/cargotech
	name = "cargo technician action figure"
	desc = "A \"Space Life\" brand cargo technician action figure."
	icon_state = "cargotech"

/obj/item/toy/figure/ce
	name = "chief engineer action figure"
	desc = "A \"Space Life\" brand chief engineer action figure."
	icon_state = "ce"

/obj/item/toy/figure/chaplain
	name = "chaplain action figure"
	desc = "A \"Space Life\" brand chaplain action figure."
	icon_state = "chaplain"

/obj/item/toy/figure/chef
	name = "chef action figure"
	desc = "A \"Space Life\" brand chef action figure."
	icon_state = "chef"

/obj/item/toy/figure/chemist
	name = "Chemist action figure"
	desc = "A \"Space Life\" brand chemist action figure."
	icon_state = "chemist"

/obj/item/toy/figure/clown
	name = "clown action figure"
	desc = "A \"Space Life\" brand clown action figure."
	icon_state = "clown"

/obj/item/toy/figure/corgi
	name = "corgi action figure"
	desc = "A \"Space Life\" brand corgi action figure."
	icon_state = "ian"

/obj/item/toy/figure/detective
	name = "detective action figure"
	desc = "A \"Space Life\" brand detective action figure."
	icon_state = "detective"

/obj/item/toy/figure/dsquad
	name = "space commando action figure"
	desc = "A \"Space Life\" brand space commando action figure."
	icon_state = "dsquad"

/obj/item/toy/figure/engineer
	name = "engineer action figure"
	desc = "A \"Space Life\" brand engineer action figure."
	icon_state = "engineer"

/obj/item/toy/figure/geneticist
	name = "geneticist action figure"
	desc = "A \"Space Life\" brand geneticist action figure, which was recently dicontinued."
	icon_state = "geneticist"

/obj/item/toy/figure/hop
	name = "head of personel action figure"
	desc = "A \"Space Life\" brand head of personel action figure."
	icon_state = "hop"

/obj/item/toy/figure/hos
	name = "head of security action figure"
	desc = "A \"Space Life\" brand head of security action figure."
	icon_state = "hos"

/obj/item/toy/figure/qm
	name = "quartermaster action figure"
	desc = "A \"Space Life\" brand quartermaster action figure."
	icon_state = "qm"

/obj/item/toy/figure/janitor
	name = "janitor action figure"
	desc = "A \"Space Life\" brand janitor action figure."
	icon_state = "janitor"

/obj/item/toy/figure/agent
	name = "internal affairs agent action figure"
	desc = "A \"Space Life\" brand internal affairs agent action figure."
	icon_state = "agent"

/obj/item/toy/figure/librarian
	name = "librarian action figure"
	desc = "A \"Space Life\" brand librarian action figure."
	icon_state = "librarian"

/obj/item/toy/figure/journalist
	name = "journalist action figure"
	desc = "A \"Space Life\" brand librarian action figure. The word 'librarian' on the tag is scratched out with marker, and 'journalist' is written in its place."
	icon_state = "librarian"

/obj/item/toy/figure/md
	name = "physician action figure"
	desc = "A \"Space Life\" brand physician action figure."
	icon_state = "md"

/obj/item/toy/figure/mime
	name = "mime action figure"
	desc = "A \"Space Life\" brand mime action figure."
	icon_state = "mime"

/obj/item/toy/figure/miner
	name = "shaft miner action figure"
	desc = "A \"Space Life\" brand shaft miner action figure."
	icon_state = "miner"

/obj/item/toy/figure/ninja
	name = "space ninja action figure"
	desc = "A \"Space Life\" brand space ninja action figure."
	icon_state = "ninja"

/obj/item/toy/figure/wizard
	name = "wizard action figure"
	desc = "A \"Space Life\" brand wizard action figure."
	icon_state = "wizard"

/obj/item/toy/figure/rd
	name = "research director action figure"
	desc = "A \"Space Life\" brand research director action figure."
	icon_state = "rd"

/obj/item/toy/figure/roboticist
	name = "roboticist action figure"
	desc = "A \"Space Life\" brand roboticist action figure."
	icon_state = "roboticist"

/obj/item/toy/figure/scientist
	name = "scientist action figure"
	desc = "A \"Space Life\" brand scientist action figure."
	icon_state = "scientist"

/obj/item/toy/figure/syndie
	name = "doom operative action figure"
	desc = "A \"Space Life\" brand doom operative action figure."
	icon_state = "syndie"

/obj/item/toy/figure/secofficer
	name = "security officer action figure"
	desc = "A \"Space Life\" brand security officer action figure."
	icon_state = "secofficer"

/obj/item/toy/figure/warden
	name = "warden action figure"
	desc = "A \"Space Life\" brand warden action figure."
	icon_state = "warden"

/obj/item/toy/figure/psychologist
	name = "psychologist action figure"
	desc = "A \"Space Life\" brand psychologist action figure."
	icon_state = "psychologist"

/obj/item/toy/figure/paramedic
	name = "paramedic action figure"
	desc = "A \"Space Life\" brand paramedic action figure."
	icon_state = "paramedic"

/obj/item/toy/figure/ert
	name = "emergency response team commander action figure"
	desc = "A \"Space Life\" brand emergency response team commander action figure."
	icon_state = "ert"
/*
 * Therapy Dolls
 */
/obj/item/toy/plushie/therapy
	name = "therapy doll"
	desc = "A toy for therapeutic and recreational purposes. This one is in red."
	icon = 'icons/obj/toy.dmi'
	icon_state = "therapyred"
	item_state = "therapyred"
	var/active = 0.0
	var/colorvar = "red"
	w_class = ITEMSIZE_TINY

/obj/item/toy/plushie/therapy/Initialize()
	. = ..()
	colorvar = pick("red","orange","yellow","green","blue","purple")
	icon_state = "therapy[colorvar]"
	item_state = "egg_[colorvar]"
	desc = "A toy for therapeutic and recreational purposes. This one is in [colorvar]."

/*
 * Plushies
 */

/obj/item/toy/plushie
	name = "generic small plush"
	desc = "A very generic small plushie. It seems to not want to exist."
	icon_state = "nymphplushie"
	drop_sound = 'sound/items/drop/plushie.ogg'
	var/phrase = "Hewwo!"

/obj/item/toy/plushie/attack_self(mob/user as mob)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> hugs [src]!</span>","<span class='notice'>You hug [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> attempts to strangle [src]!</span>","<span class='warning'>You attempt to strangle [src]!</span>")
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes the [src].</span>","<span class='notice'>You poke the [src].</span>")
		playsound(src, 'sound/items/drop/plushie.ogg', 25, 0)
		visible_message("[src] says, \"[phrase]\"")

//Large plushies.


/obj/item/toy/plushie/ian
	name = "plush corgi"
	desc = "A plushie of an adorable corgi! Don't you just want to hug it and squeeze it and call it \"Ian\"?"
	icon_state = "ianplushie"
	phrase = "Arf!"

/obj/item/toy/plushie/drone
	name = "plush drone"
	desc = "A plushie of a happy drone! It appears to be smiling, and has a small tag which reads \"N.D.V. Icarus Gift Shop\"."
	icon_state = "droneplushie"
	phrase = "Beep boop!"

/obj/item/toy/plushie/carp
	name = "plush carp"
	desc = "A plushie of an elated carp! Straight from the wilds of the Tau Ceti frontier, now right here in your hands."
	icon_state = "carpplushie"
	phrase = "Glorf!"

/obj/item/toy/plushie/beepsky
	name = "plush Officer Sweepsky"
	desc = "A plushie of a popular industrious cleaning robot! If it could feel emotions, it would love you."
	icon_state = "beepskyplushie"
	phrase = "Ping!"

/obj/item/toy/plushie/ivancarp
	name = "plush Ivan the carp"
	desc = "A plushie in the spitting image of a russian raised carp."
	icon_state = "carpplushie_russian"
	phrase = "Blyat!"

//Small plushies.

/obj/item/toy/plushie/nymph
	name = "diona nymph plush"
	desc = "A plushie of an adorable diona nymph! While its level of self-awareness is still being debated, its level of cuteness is not."
	icon_state = "nymphplushie"
	slot_flags = SLOT_HEAD

/obj/item/toy/plushie/mouse
	name = "mouse plush"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	icon_state = "mouseplushie"

/obj/item/toy/plushie/kitten
	name = "kitten plush"
	desc = "A plushie of a cute kitten! Watch as it purrs it's way right into your heart."
	icon_state = "kittenplushie"
	slot_flags = SLOT_HEAD

/obj/item/toy/plushie/lizard
	name = "lizard plush"
	desc = "A plushie of a scaly lizard! Very controversial, after being accused as \"racist\" by some Unathi."
	icon_state = "lizardplushie"

/obj/item/toy/plushie/spider
	name = "spider plush"
	desc = "A plushie of a fuzzy spider! It has eight legs - all the better to hug you with."
	icon_state = "spiderplushie"

/obj/item/toy/plushie/farwa
	name = "farwa plush"
	desc = "A farwa plush doll. It's soft and comforting, with extra grip!"
	icon_state = "farwaplushie"
	slot_flags = SLOT_HEAD

/obj/item/toy/plushie/bear
	name = "bear plush"
	desc = "A bear plushie. You should hug it, quickly!"
	icon_state = "bearplushie"

/obj/item/toy/plushie/bearfire
	name = "firefighter bear plush"
	desc = "A bear plushie. Only you can stop phoron fires!"
	icon_state = "bearplushie_fire"

//Squid Plushies

/obj/item/toy/plushie/squid
	name = "squid plushie"
	desc = "A small, cute and loveable squid friend. This one is pink coloured."
	icon = 'icons/obj/toy.dmi'
	icon_state = "pinksquid"
	item_state = "pinksquid"
	var/active = 0.0
	var/colorvar = "pink"
	slot_flags = SLOT_HEAD

/obj/item/toy/plushie/squid/Initialize()
	. = ..()
	colorvar = pick("pink","blue","mint","green","yellow","orange")
	icon_state = "[colorvar]squid"
	item_state = "[colorvar]squid"
	desc = "A small, cute and loveable squid friend. This one is in [colorvar]."

//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon wielded by the followers of the hit Saturday morning cartoon \"King Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = ITEMSIZE_LARGE
	attack_verb = list("attacked", "slashed", "stabbed", "poked")

/* NYET.
/obj/item/toddler
	icon_state = "toddler"
	name = "toddler"
	desc = "This baby looks almost real. Wait, did it just burp?"
	force = 5
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
*/

//This should really be somewhere else but I don't know where. w/e

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/clothing/belts.dmi'
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/rubber.ogg'


/obj/item/toy/xmastree
	name = "miniature Christmas tree"
	desc = "Now with 99% less pine needles."
	icon_state = "tinyxmastree"
	w_class = ITEMSIZE_TINY
	force = 1
	throwforce = 1
	drop_sound = 'sound/items/drop/box.ogg'
