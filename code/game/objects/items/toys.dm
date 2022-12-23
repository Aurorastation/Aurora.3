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
 *		Ring bell
 *		Chess Pieces
 */


/obj/item/toy
	icon = 'icons/obj/toy.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_toy.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_toy.dmi',
		)
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/*
 * Water Balloons
 */
/obj/item/toy/waterballoon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "waterballoon-e"
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/toy/waterballoon/New()
	var/datum/reagents/R = new/datum/reagents(10)
	reagents = R
	R.my_atom = src

/obj/item/toy/waterballoon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterballoon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to_obj(src, 10)
		to_chat(user, "<span class='notice'>You fill the balloon with the contents of [A].</span>")
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/waterballoon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent(/decl/reagent/acid/polyacid, 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.splash(user, reagents.total_volume)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, "<span class='notice'>You fill the balloon with the contents of [O].</span>")
					O.reagents.trans_to_obj(src, 10)
		src.update_icon()
		return TRUE

/obj/item/toy/waterballoon/throw_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message("<span class='warning'>\The [src] bursts!</span>","You hear a pop and a splash.")
		src.reagents.touch_turf(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.touch(A)
		src.icon_state = "burst"
		QDEL_IN(src, 5)
	return

/obj/item/toy/waterballoon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
	else
		icon_state = "waterballoon-e"
	item_state = icon_state

/*
 * Balloons
 */

 #define BALLOON_NORMAL	0
 #define BALLOON_BLOW	1
 #define BALLOON_BURST	2

/obj/item/toy/balloon
	name = "balloon"
	desc_info = "You can fill it up with gas using a tank."
	desc_extended = "Thanks to the joint effort of the Research and Atmospherics teams, station enviroments have been set to allow balloons to float without helium. Look, it was the end of the month and we went under budget."
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'
	w_class = ITEMSIZE_HUGE
	var/datum/gas_mixture/air_contents = null
	var/status = 0 // 0 = normal, 1 = blow, 2 = burst

/obj/item/toy/balloon/attack_self(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes [src]!</span>","<span class='notice'>You poke [src]!</span>")
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
	else if (user.a_intent == I_GRAB)
		if(prob(66))
			user.visible_message("<span class='warning'><b>\The [user]</b> attempts to pop [src]!</span>","<span class='warning'>You attempt to pop [src]!</span>")
		else
			user.visible_message("<span class='warning'><b>\The [user]</b> pops [src]!</span>","<span class='warning'>You pop [src]!</span>")
			burst()
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> lightly bats the [src].</span>","<span class='notice'>You lightly bat the [src].</span>")

/obj/item/toy/balloon/update_icon()
	switch(status)
		if(BALLOON_BURST)
			if(("[initial(icon_state)]_burst") in icon_states(icon))
				icon_state = "[initial(icon_state)]_burst"
				item_state = icon_state
			else
				qdel(src) // Just qdel it if it doesn't have a burst state.
		if(BALLOON_BLOW)
			if(("[initial(icon_state)]_blow") in icon_states(icon)) //Only give blow icon_state if it has one. For those who can't be bothered to sprite. (Also a catch to prevent invisible sprites.)
				icon_state = "[initial(icon_state)]_blow"
	update_held_icon()

/obj/item/toy/balloon/proc/blow(obj/item/tank/T)
	if(status == BALLOON_BURST)
		return
	else
		src.air_contents = T.remove_air_volume(3)
		status = BALLOON_BLOW
		update_icon()

/obj/item/toy/balloon/proc/burst()
	playsound(src, 'sound/weapons/gunshot/gunshot1.ogg', 100, 1)
	status = BALLOON_BURST
	update_icon()
	if(air_contents)
		loc.assume_air(air_contents)

/obj/item/toy/balloon/ex_act(severity)
	burst()
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)

/obj/item/toy/balloon/bullet_act()
	burst()

/obj/item/toy/balloon/fire_act(datum/gas_mixture/air, temperature, volume)
	if(temperature > T0C+100)
		burst()
	return

/obj/item/toy/balloon/attackby(obj/item/W as obj, mob/user as mob)
	if(W.can_puncture())
		burst()
		return TRUE

/obj/item/toy/balloon/latex
	desc = "Leaves a starchy taste in your mouth after blowing into it."
	icon_state = "latexballoon"
	item_state = "latexballoon"

/obj/item/toy/balloon/latex/nitrile
	desc = "I hope you aren't going to re-use these for medical purposes."
	icon_state = "nitrileballoon"
	item_state = "nitrileballoon"

/obj/item/toy/balloon/syndicate
	name = "'criminal' balloon"
	desc = "Across the balloon is printed: \"FUK CAPITALISM!11!\""
	icon_state = "syndballoon"
	item_state = "syndballoon"

/obj/item/toy/balloon/nanotrasen
	name = "'motivational' balloon"
	desc = "Across the balloon is printed: \"Man, I love corporate soooo much. I use only brand name products. You have NO idea.\""
	icon_state = "ntballoon"
	item_state = "ntballoon"

/obj/item/toy/balloon/fellowship
	name = "fellowship balloon"
	desc = "Across the balloon is printed: \"Fellowship R Friends!\""
	icon_state = "fellowshipballoon"
	item_state = "fellowshipballoon"

/obj/item/toy/balloon/fellowshiphead
	name = "fellowship head balloon"
	desc = "Across the balloon is printed: \"Follow Fellows Forwards With The Fellowship!\""
	icon_state = "fellowshipheadballoon"
	item_state = "fellowshipheadballoon"

/obj/item/toy/balloon/contender
	name = "contender balloon"
	desc = "Across the balloon is printed: \"Contenders R Cool!\""
	icon_state = "contenderballoon"
	item_state = "contenderballoon"

/obj/item/toy/balloon/contenderhead
	name = "contender head balloon"
	desc = "Across the balloon is printed: \"Converge With Comrades in the Contenders!\""
	icon_state = "contenderheadballoon"
	item_state = "contenderheadballoon"

/obj/item/toy/balloon/bat
	name = "giant bat balloon"
	desc = "A large, kitschy balloon in the shape of a spooky bat with orange eyes."
	desc_extended = "There's a tag that reads: \"Apparition Halloween LLC.\""
	icon_state = "batballoon"

/obj/item/toy/balloon/ghost
	name = "giant ghost balloon"
	desc = "Oh no, it's a ghost! Oh wait, it's just a kitschy balloon. Phew!"
	desc_extended = "There's a tag that reads: \"Apparition Halloween LLC.\""
	icon_state = "ghostballoon"

/obj/item/toy/balloon/xmastree
	name = "giant christmas tree balloon"
	desc = "Mandatory at inter-generational christmas gatherings and office parties."
	desc_extended = "There's a tag that reads: \"On behalf of employee relations, the CCIA Department wishes you a happy non-denominational holiday season.\""
	icon_state = "xmastreeballoon"

/obj/item/toy/balloon/candycane
	name = "giant candy cane balloon"
	desc = "Kris Kringle ain't got nothing on this candied confection."
	desc_extended = "There's a tag that reads: \"On behalf of employee relations, the CCIA Department wishes you a happy non-denominational holiday season.\""
	icon_state = "candycaneballoon"

/obj/item/toy/balloon/color /// To color it, VV the 'color' var with a hex color code with the # included.
	desc = "It's a plain little balloon. Comes in many colors!"
	icon_state = "colorballoon"
	item_state = "colorballoon"
	build_from_parts = TRUE
	worn_overlay = "string"
	randpixel = 5

/obj/item/toy/balloon/color/Initialize()
	. = ..()
	if(build_from_parts)
		color = pick(COLOR_BLUE, COLOR_RED, COLOR_PURPLE, COLOR_BROWN, COLOR_GREEN, COLOR_CYAN, COLOR_YELLOW)
		update_icon()
		randpixel_xy()

/obj/item/toy/balloon/color/update_icon() // Only color the balloon, not the string.
	..()
	if(status == BALLOON_BURST)
		worn_overlay = null
	cut_overlay()
	if(worn_overlay)
		add_overlay(overlay_image(icon, "[initial(icon_state)]_[worn_overlay]", flags=RESET_COLOR))

#undef BALLOON_NORMAL
#undef BALLOON_BLOW
#undef BALLOON_BURST

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
 * Comic books
 */
/obj/item/toy/comic
	name = "comic book"
	desc = "A magazine presenting a fictional story through a sequence of images. Perfect for those long, boring shifts."
	w_class = ITEMSIZE_SMALL
	icon_state = "comic"
	item_state = "comic"
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/toy/comic/inspector
	name = "inspector 404 manga"
	desc = "Inspector 404 follows the adventures of the titular I404, a shell inspector from Konyang. This issue, #67, follows the \
	404, also known as Kyung-Sun's quest to bring down the corrupt Superintendent Hayashi."
	icon_state = "comicinspector"
	item_state = "comicinspector"

/obj/item/toy/comic/stormman
	name = "stormman manga"
	desc = "Stormman, often stylized as STORMMAN! is one of Konyang's most beloved anime series, following a masked superhero named Stormman \
	who has the power to harness the weather to defend his homeworld while keeping his secret identity. Since its release, all kinds of merchandise \
	have been made, including a conversion of the show to a paperback manga."
	icon_state = "comicstormman"
	item_state = "comicstormman"

/obj/item/toy/comic/outlandish_tales
	name = "outlandish tales magazine"
	desc = "A magazine specialized in publishing Tajaran Otherworldly Literature stories. The periodical magazine features texts submitted by amateur and established writers alike. \
	Since it is printed using cheap, recycled paper, outlandish tales is sold for a couple of credits on the streets of Little Adhomai. The magazine also has a section dedicated to \
	exploring the urban legends and mysteries of Mendell City."
	desc_extended = "Influenced by recent events and the growing interest in urban legends, Little Adhomai became the birthplace of Tajaran Otherworldly Literature. This literary genre combines \
	aspects of fantasy, horror, and speculative fiction alongside Adhomian paranormal elements, frequently reimagining mythological creatures and events. Tajaran Otherworldly texts are usually \
	published in magazines or on extranet sites."
	icon_state = "comicoutlandish"
	item_state = "comicoutlandish"

/obj/item/toy/comic/azmarian
	name = "az'marian comic"
	desc = "A comic book series revolving around a superhero from Az'Mar, popular in the New Kingdom."
	icon_state = "comicazmarian"
	item_state = "comicazmarian"

/obj/item/toy/comic/azmarian/issue_1
	desc_extended = "Issue 1 - The Az'Marian Landing! - In this issue, the would-be hero departs from Az'Mar and lands in a war-torn \
	town in the outskirts of the Kingdom, witnessing the townspeople terrorised by a Zhan'Khazan maniacal terrorist. After mutilating \
	his body with alien technology and even cutting off his own arms to replace with robotic equivalents, the cybernetically enhanced \
	Corporal Khara'zan will not let his reign of terror be stopped easily. Will the visitor from Az'mar manage to stand in his way and prevail?"

/obj/item/toy/comic/azmarian/issue_2
	desc_extended = "Issue 2 - The Road Towards A Dark Future - In this issue, the Az'Marian meets the local nobility whom he had saved from \
	terror, learning that the Kingdom is threatened on all fronts. The superhero embarks on a journey through bandit-infested lands towards the \
	headquarters of evil, meeting an unlikely ally and his band of friends. However, all is not what it seems, and the superhero will soon face \
	a threat that once welcomed him with open arms. A treacherous plot, an ally destined by S'rendarr, and the darkness encroaching; the superhero \
	faces the modern threat of depraved Tajara."

/obj/item/toy/comic/azmarian/issue_3
	desc_extended = "Issue 3 - The Swamp Debacle - In this issue, the Az'Marian and his loyal but dim-witted sidekick Murr'zhul reach a poisonous \
	swamp polluted by waste-producing factories. A chemical-obsessed scientist looks to experiment and find the perfect poison for his evil deeds, \
	killing the surrounding nature and turning residents sickly. A lumbering creature hiding in the swamp caves, a mad researcher about to find the \
	perfect toxin, and the duo seeking to halt his plans. Will they find a way to shut him down?"

/obj/item/toy/comic/azmarian/issue_4
	desc_extended = "Issue 4 - The Den of Evil! - In this issue, the hero and his loyal but dim-witted sidekick Murr'zhul reach the stronghold of \
	the retreating Corporal Khara'zan. The superhero uncovers a sinister plot orchestrated by the Corporal's superior to turn all of the local living \
	beings into cyborgs. The leader, Director Shul'tyz, is not yet aware of the Az'Marian's presence, and the time is ripe. Met with a slumbering horde \
	of cybernetic ha'rrons, schlorrgos and even Tajara, the superhero encounters a threat that will truly test his mettle."

/obj/item/toy/comic/azmarian/issue_5
	desc_extended = "Issue 5 - Path to Recovery - In this issue, the hero, who has faced a successful confrontation with Director Shul'tyz, managed to \
	free the local populace of cybernetic mind control, but at a heavy price. The syringe that was shot into him started coursing through his veins, preventing \
	him from using his powers in a rapidly degrading state. His loyal sidekick Murr'zhul helps bring the hero to the capital of the ancient Kingdom to seek aid. \
	Met with internal politics, a mixed reception, sinister plots and a meeting with the King, will the hero find a way to recover from the illness that plagues him?"

/obj/item/toy/comic/azmarian/issue_6
	desc_extended = "Issue 6 - The Pilgrimage - Steppe Trouble! - In this issue, the hero and his loyal but dim-witted sidekick Murr'zhul embark on a journey \
	to a sacred shrine in the mountains built by the early Ancient Tajara. Having received a blessing to prevent his state from degrading from the local priests, \
	the hero has little time to waste before the blessing wanes. A meeting with wandering nomads, an audience with their ruler, and a perilous journey across \
	the steppes leads the Az'Marian to face many decisions and challenges as the reality of the nomads comes to light. Deprived of his powers, will he and his \
	trusted Hharar side-kick manage to reach the mountains?"

/obj/item/toy/comic/azmarian/issue_7
	desc_extended = "Issue 7 - The Pilgrimage Pt. 2 - Mountain Survival - In this issue, the hero and his loyal but dim-witted sidekick Murr'zhul reach \
	the mountains that contain the ancient shrine of the Suns, where he would be able to recover from his illness caused by Director Shul'tyz. Trailed \
	by Sham'tyrs, facing freezing winds and snow, the two will trek to reach the shrine in hope of recovery. Bandits encampments, a village in need of help, \
	a chance encounter with the S'Mara, and a shape-shifting spy amongst the Sham'tyrs, will the heroes make their way in one piece?"

/obj/item/toy/comic/azmarian/issue_8
	desc_extended = "Issue 8 - The Shrine - In this issue, the hero and his loyal but dim-witted sidekick Murr'zhul meet the Parivara at the ancient shrine. \
	Tended to by the Sun Sister with the blessing of Messa, the Az'Marian manages to recover from his affliction over the course of a week. He learns of an \
	evil plan staged by a group of Cae'rrin living in caves nearby to desecrate the shrine and eat its attendants, and the two embark on a journey to put a \
	stop to this plan. Already aware of the Az'Marian's presence from their spy, they begin to set up traps and occult rituals to prevent him from even reaching \
	the caves. Forces of Raskara, shape-shifting creatures, dastardly traps and true evil lurking within, the Az'Marian and his sidekick will have to use their \
	newly regained powers to their fullest."

//
// Toy Crossbows
//
/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A foam dart crossbow."
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	contained_sprite = TRUE
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/dart_count = 5

/obj/item/toy/crossbow/examine(mob/user)
	if(..(user, 2) && dart_count)
		to_chat(user, "<span class='notice'>\The [src] is loaded with [dart_count] foam dart\s.</span>")

/obj/item/toy/crossbow/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/toy/ammo/crossbow))
		if(dart_count <= 4)
			user.drop_from_inventory(I, src)
			qdel(I)
			dart_count++
			to_chat(user, "<span class='notice'>You load the foam dart into \the [src].</span>")
		else
			to_chat(usr, "<span class='warning'>\The [src] is already fully loaded.</span>")


/obj/item/toy/crossbow/afterattack(atom/target, mob/user, flag)
	if(!isturf(target.loc) || target == user)
		return

	if(flag)
		return

	if(locate(/obj/structure/table) in get_turf(src))
		return

	else if(dart_count)
		var/turf/trg = get_turf(target)
		var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
		dart_count--
		D.icon_state = "foamdart"
		D.name = "foam dart"
		playsound(src, 'sound/items/syringeproj.ogg', 50, TRUE)

		for(var/i = 0, i < 6, i++)
			if (D)
				if(D.loc == trg) break
				step_towards(D, trg)

				for(var/mob/living/M in D.loc)
					if(!istype(M, /mob/living))
						continue

					if(M == user)
						continue

					for(var/mob/O in viewers(world.view, D))
						O.show_message(text("<span class='warning'>\The [] was hit by the foam dart!</span>", M), 1)
					new /obj/item/toy/ammo/crossbow(M.loc)
					qdel(D)
					return

				for(var/atom/A in D.loc)
					if(A == user)
						continue

					if(A.density)
						new /obj/item/toy/ammo/crossbow(A.loc)
						qdel(D)

			sleep(1)

		spawn(10)
			if(D)
				new /obj/item/toy/ammo/crossbow(D.loc)
				qdel(D)

		return

/obj/item/toy/crossbow/attack(mob/M, mob/user)
	src.add_fingerprint(user)

	if (src.dart_count > 0 && M.lying) // Check
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(text("<span class='notice'>\The [] casually lines up a shot with []'s head and pulls the trigger.</span>", user, M), 1)
				O.show_message(text("<span class='warning'>\The [] was hit in the head by the foam dart!</span>", M), 1)

		playsound(src, 'sound/items/syringeproj.ogg', 50, TRUE)
		new /obj/item/toy/ammo/crossbow(M.loc)
		src.dart_count--
	return

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "A foam dart."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/effect/foam_dart_dummy
	name = null
	desc = null
	icon = 'icons/obj/toy.dmi'
	icon_state = null
	anchored = TRUE
	density = FALSE

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of a blue energy sword. Realistic sounds and colors! Ages 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_energy.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_energy.dmi',
		)
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	var/active = 0.0
	var/colorvar = "blue"
	var/last_active = 0
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")

/obj/item/toy/sword/attack_self(mob/user as mob)
	if(last_active <= world.time - 20)
		last_active = world.time
		src.active = !( src.active )
		if(src.active)
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
	contained_sprite = TRUE
	icon = 'icons/obj/sword.dmi'
	icon_state = "katana"
	item_state = "katana"
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = /decl/sound_category/sword_pickup_sound
	equip_sound = /decl/sound_category/sword_equip_sound
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
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/toy/snappop/attack_self(mob/user)
	user.drop_from_inventory(src)
	user.visible_message(SPAN_WARNING("\The [user] throws \the [src] at their feet!"), SPAN_NOTICE("You throw \the [src] at your feet."))
	do_pop()

/obj/item/toy/snappop/throw_impact(atom/hit_atom)
	..()
	do_pop()

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/human/M = H
		if(M.shoes?.item_flags & LIGHTSTEP)
			return
		if(M.m_intent == M_RUN)
			to_chat(M, SPAN_WARNING("You step on the snap pop!"))
			do_pop()

/obj/item/toy/snappop/proc/do_pop()
	spark(src, 3, alldirs)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	visible_message(SPAN_WARNING("\The [src] explodes!"), SPAN_WARNING("You hear a snap!"))
	playsound(get_turf(src), 'sound/effects/snap.ogg', 50, TRUE)
	qdel(src)

/obj/item/toy/snappop/syndi
	desc_antag = "These snap pops have an extra compound added that will deploy a tiny smokescreen when snapped."

/obj/item/toy/snappop/syndi/do_pop()
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread
	smoke.set_up(2, 0, get_turf(src))
	smoke.attach(get_turf(src))
	smoke.start()
	..()

/*
 * Water flower
 */

 //moved to spray.dm

/*
 * Bosun's whistle
 */

/obj/item/toy/bosunwhistle
	name = "bosun's whistle"
	desc = "A genuine Admiral Krush Bosun's Whistle, for the aspiring ship's captain! Suitable for ages 8 and up, do not swallow."
	icon_state = "bosunwhistle"
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
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
	pickup_sound = 'sound/items/pickup/accessory.ogg'

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
	pickup_sound = 'sound/items/pickup/plushie.ogg'
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

/obj/item/toy/plushie/pennyplush
	name = "Penny plush"
	desc = "It's a plush of the beloved company mascot cat, Penny! For the price NanoTrasen sells these things at, you probably could have bought an actual cat."
	icon_state = "pennyplushie"
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

/obj/item/toy/plushie/schlorrgo
	name = "schlorrgo plush"
	desc = "A schlorrgo plushie, ready to roll his way into your heart!"
	icon_state = "schlorrgoplushie"
	phrase = "Eough!"

/obj/item/toy/plushie/coolschlorrgo
	name = "Cool Schlorrgo plush"
	desc = "A plushie of the popular cartoon character, Cool Schlorrgo. Hadii's grace!"
	icon_state = "coolerschlorrgoplushie"
	phrase = "Eough!"

/obj/item/toy/plushie/slime
	name = "slime plush"
	desc = "A beanbag-filled slime plushie. Relaxing!"
	icon_state = "slimeplushie"
	phrase = "Rawr!"

/obj/item/toy/plushie/bee
	name = "bee plush"
	desc = "A chunky plushie bee. Your new buzz-t friend!"
	icon_state = "beeplushie"
	phrase = "Buzz!"

/obj/item/toy/plushie/shark
	name = "shark plush"
	desc = "A beloved jumbo sized shark that is sure to impress your friends."
	icon_state = "sharkplushie"
	phrase = "Gashunk!"

/obj/item/toy/plushie/greimorian
	name = "greimorian plushie"
	desc = "A lovable plushie of a fierce greimorian! This one takes a few liberties."
	icon_state = "greimorianplushie"
	phrase = "Gort!"

/obj/item/toy/plushie/axic
	name = "Axic plushie"
	desc = "Plushie designed after the main characters of the hit show, Swimstars! This one is Axic. "
	icon_state = "axicplushie"
	phrase = "Warble!"

/obj/item/toy/plushie/qill
	name = "Qill plushie"
	desc = "Plushie designed after the main characters of the hit show, Swimstars! This one is Qill. "
	icon_state = "qillplushie"
	phrase = "Warble!"

/obj/item/toy/plushie/xana
	name = "Xana plushie"
	desc = "Plushie designed after the main characters of the hit show, Swimstars! This one is Xana. "
	icon_state = "xanaplushie"
	phrase = "Warble!"

/obj/item/toy/plushie/ipc
	name = "Aphy plushie"
	desc = "A plushie of an old Hephaestus mascot, Aphy."
	desc_extended = "Aphy, a play on the name Aphrodite, was Hephaestus Industries' first baseline prototype. While the original Aphy is on display in Hephaestus' Mars headquarters, the unit has become a cutesy mascot in recent years."
	icon_state = "ipcplushie"
	phrase = "Bwoop!"

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

//Fox Plushies
/obj/item/toy/plushie/fox
	name = "fox plushie"
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is red."
	icon = 'icons/obj/toy.dmi'
	icon_state = "redfox"
	item_state = "redfox"
	phrase = "Kekekeke!"
/obj/item/toy/plushie/fox/black
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is black."
	icon_state = "blackfox"
	item_state = "blackfox"
/obj/item/toy/plushie/fox/marble
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is white."
	icon_state = "marblefox"
	item_state = "marblefox"
/obj/item/toy/plushie/fox/blue
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is blue."
	icon_state = "bluefox"
	item_state = "bluefox"
/obj/item/toy/plushie/fox/orange
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is the classic orange."
	icon_state = "orangefox"
	item_state = "orangefox"
/obj/item/toy/plushie/fox/coffee
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is coffee-cream coloured."
	icon_state = "coffeefox"
	item_state = "coffeefox"
/obj/item/toy/plushie/fox/pink
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is pink."
	icon_state = "pinkfox"
	item_state = "pinkfox"
/obj/item/toy/plushie/fox/purple
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is purple."
	icon_state = "purplefox"
	item_state = "purplefox"
/obj/item/toy/plushie/fox/crimson
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is crimson."
	icon_state = "crimsonfox"
	item_state = "crimsonfox"
/obj/item/toy/plushie/fox/random
	icon_state = "redfox"
	item_state = "redfox"
	var/colorvar = "red"

/obj/item/toy/plushie/fox/random/Initialize()
	. = ..()
	desc = "A small, very soft and handsome fox, ready to receive your cuddles. This one is in [colorvar]."
	icon_state = "[colorvar]fox"
	item_state = "[colorvar]fox"
	colorvar = pick("red", "black", "marble", "blue", "orange", "coffee", "pink", "purple", "crimson")

// Squid Plushie Random
/obj/item/toy/plushie/squidcolour
	name = "squid plushie"
	desc = "A small, cute, and loveable squid friend. This one comes in a wide variety of colours."
	icon_state = "squidplushie_colour"
	// slot_flags = SLOT_HEAD - head sprite may come someday, but not today.
	phrase = "Blub!"

//Toy cult sword
/obj/item/toy/cultsword
	name = "foam sword"
	desc = "An arcane weapon wielded by the followers of the hit Saturday morning cartoon \"King Nursee and the Acolytes of Heroism\"."
	icon = 'icons/obj/sword.dmi'
	icon_state = "cultblade"
	item_state = "cultblade"
	w_class = ITEMSIZE_LARGE
	attack_verb = list("attacked", "slashed", "stabbed", "poked")
	contained_sprite = TRUE

/obj/item/inflatable_duck
	name = "inflatable duck"
	desc = "No bother to sink or swim when you can just float!"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/clothing/belts.dmi'
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

/obj/item/toy/xmastree
	name = "miniature Christmas tree"
	desc = "Now with 99% less pine needles."
	icon_state = "tinyxmastree"
	w_class = ITEMSIZE_TINY
	force = 1
	throwforce = 1
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/toy/aurora
	name = "aurora miniature"
	desc = "A miniature of a space station, built into an asteroid. A tiny suspension field keeps it afloat. A small plaque on the front reads: NSS Aurora, Tau Ceti, Romanovich Cloud, 2464. Onward to new horizons."
	desc_info = "This miniature was given out on the 9th of April 2464 to all former crew members of the Aurora as a memento, before setting off to their new mission on the SCCV Horizon."
	icon_state = "aurora"

/obj/item/toy/ringbell
	name = "ringside bell"
	desc = "A bell used to signal the beginning and end of various ring sports."
	desc_info = "Use help intent on the bell to signal the start of a contest\ndisarm intent to signal the end of a contest and\nharm intent to signal a disqualification."
	icon_state = "ringbell"
	anchored = TRUE

/obj/item/toy/ringbell/attack_hand(mob/user)
	switch(user.a_intent)
		if (I_HELP)
			user.visible_message(FONT_LARGE(SPAN_NOTICE("[user] rings \the [src], signalling the beginning of the contest.")), SPAN_NOTICE("You ring \the [src] to signal the beginning of the contest!"))
			playsound(user.loc, 'sound/items/oneding.ogg', 60, 1)
		if (I_DISARM)
			user.visible_message(FONT_LARGE(SPAN_NOTICE("[user] rings \the [src] three times, signalling the end of the contest!")), SPAN_NOTICE("You ring \the [src] to signal the end of the contest!"))
			playsound(user.loc, 'sound/items/threedings.ogg', 60, 1)
		if (I_HURT)
			user.visible_message(FONT_LARGE(SPAN_WARNING("[user] rings \the [src] repeatedly, signalling a disqualification!")), SPAN_WARNING("You ring \the [src] to signal a disqualification!"))
			playsound(user.loc, 'sound/items/manydings.ogg', 60, 1)

//baystation desk toys

/obj/item/toy/desk
	var/on = FALSE
	var/activation_sound = /decl/sound_category/switch_sound

/obj/item/toy/desk/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)

/obj/item/toy/desk/attack_self(mob/user)
	activate(user)

/obj/item/toy/desk/AltClick(mob/user)
	activate(user)

/obj/item/toy/desk/proc/activate(mob/user)
	on = !on
	playsound(src.loc, activation_sound, 75, 1)
	update_icon()
	return 1

/obj/item/toy/desk/newtoncradle
	name = "\improper Newton's cradle"
	desc = "A ancient 21th century super-weapon model demonstrating that Sir Isaac Newton is the deadliest sonuvabitch in space."
	desc_extended = "Aside from car radios, Eridanian Dregs are reportedly notorious for stealing these things. It is often theorized that the very same ball bearings are used in black-market cybernetics."
	icon_state = "newtoncradle"

/obj/item/toy/desk/fan
	name = "office fan"
	desc = "Your greatest fan."
	desc_extended = "For weeks, the atmospherics department faced a conundrum on how to lower temperatures in a localized area through complicated pipe channels and ventilation systems. The problem was promptly solved by ordering several desk fans."
	icon_state = "fan"

/obj/item/toy/desk/officetoy
	name = "office toy"
	desc = "A generic microfusion powered office desk toy. Only generates magnetism and ennui."
	desc_extended = "The mechanism inside is a Hephasteus trade secret. No peeking!"
	icon_state = "desktoy"

/obj/item/toy/desk/dippingbird
	name = "dipping bird toy"
	desc = "Engineers marvel at this scale model of a primitive thermal engine. It's highly debated why the majority of owners were in low-level bureaucratic jobs."
	desc_extended = "One of the key essentials for every Eridanian suit - it's practically a rite of passage to own one of these things."
	icon_state = "dippybird"

/obj/item/toy/partypopper
	name = "party popper"
	desc = "Instructions : Aim away from face. Wait for appropriate timing. Pull cord, enjoy confetti."
	icon_state = "partypopper"
	w_class = ITEMSIZE_TINY
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/toy/partypopper/attack_self(mob/user)
	if(icon_state == "partypopper")
		spark(src, 1, user.dir)
		user.visible_message(SPAN_NOTICE("[user] pulls on the string, releasing a burst of confetti!"), SPAN_NOTICE("You pull on the string, releasing a burst of confetti!"))
		playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
		icon_state = "partypopper_e"
		var/turf/T = get_step(src, user.dir)
		if(!turf_clear(T))
			T = get_turf(src)
		new /obj/effect/decal/cleanable/confetti(T)
	else
		to_chat(user, SPAN_NOTICE("The [src] is already spent!"))

/obj/item/chess_piece
	name = "white pawn"
	desc = "A %NAME% chess piece, this one is worth %POINT% points."
	icon = 'icons/obj/item/chess.dmi'
	icon_state = "white_pawn"
	w_class = ITEMSIZE_HUGE // hugh mungus
	var/piece_worth = 1

/obj/item/chess_piece/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag && isturf(target))
		user.drop_from_inventory(src, target)
		pixel_y = initial(pixel_y)
		pixel_x = initial(pixel_x)

/obj/item/chess_piece/Initialize()
	. = ..()
	desc = "A [name] chess piece, this one is worth [piece_worth] point\s."

/obj/item/chess_piece/black
	name = "black pawn"
	icon_state = "black_pawn"

/obj/item/chess_piece/rook
	name = "white rook"
	icon_state = "white_rook"
	piece_worth = 5

/obj/item/chess_piece/rook/black
	name = "black rook"
	icon_state = "black_rook"

/obj/item/chess_piece/knight
	name = "white knight"
	icon_state = "white_knight"
	piece_worth = 3

/obj/item/chess_piece/knight/black
	name = "black knight"
	icon_state = "black_knight"

/obj/item/chess_piece/bishop
	name = "white bishop"
	icon_state = "white_bishop"
	piece_worth = 3

/obj/item/chess_piece/bishop/black
	name = "black bishop"
	icon_state = "black_bishop"

/obj/item/chess_piece/king
	name = "white king"
	icon_state = "white_king"
	piece_worth = 10 // not really, but i coded myself into a corner here

/obj/item/chess_piece/king/black
	name = "black king"
	icon_state = "black_king"

/obj/item/chess_piece/queen
	name = "white queen"
	icon_state = "white_queen"
	piece_worth = 9

/obj/item/chess_piece/queen/black
	name = "black queen"
	icon_state = "black_queen"
