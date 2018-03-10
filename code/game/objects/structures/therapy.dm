/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 1.0

/obj/structure/bed/chair/e_chair/Initialize()
	. = ..()
	add_overlay(image('icons/obj/furniture.dmi', src, "echair_over", MOB_LAYER + 1))
	if(!part)
		part = new /obj/item/assembly/shock_kit(src)
		part.master = src
		part.part1 = new /obj/item/clothing/head/helmet(part)
		part.part2 = new /obj/item/device/radio/electropack(part)
		part.part1.master = part
		part.part2.master = part

/obj/structure/bed/chair/e_chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W))
		var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(loc)
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		C.set_dir(dir)
		part.loc = loc
		part.master = null
		part = null
		qdel(src)

/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		shock()
		icon_state = "echair1"
	usr << "<span class='notice'>You switch [on ? "on" : "off"] [src].</span>"

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	var/obj/structure/cable/C = locate(/obj/structure/cable, get_turf(src))
	flick("echair1", src)
	spark(src, 12, alldirs)
	if(buckled_mob && istype(C))
		if(electrocute_mob(user, C, src, contact_zone = "head"))
			buckled_mob << "<span class='danger'>You feel a deep shock course through your body!</span>"
			sleep(1)
			if(electrocute_mob(user, C, src, contact_zone = "head"))
				buckled_mob.Stun(600)
	visible_message("<span class='danger'>The electric chair goes off!</span>", "<span class='danger'>You hear an electrical discharge!</span>")

	toggle()
	return

/obj/structure/bed/chair/e_chair/electroshock
	name = "electroshock therapy chair"
	desc = "The absolute state of conversion therapy in the 25th century."

/obj/structure/bed/chair/e_chair/electroshock/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	var/obj/structure/cable/C = locate(/obj/structure/cable, get_turf(src))
	var/datum/powernet/PN = C.powernet
	flick("echair1", src)
	spark(src, 12, alldirs)

	if(buckled_mob && istype(C))
		if(prob(15))
			if(electrocute_mob(user, C, src, 0.2, "head"))
				buckled_mob << "<span class='danger'>You feel a heavy shock course through your body!</span>"
				sleep(1)
				if(electrocute_mob(user, C, src, 0.2, "head"))
					buckled_mob.Stun(600)
		else if(prob(15) && ishuman(buckled_mob))
			var/mob/living/carbon/human/H = buckled_mob
			H.cure_all_traumas(cure_type = "electroshock")
		else
			buckled_mob << "<span class='danger'>You feel a painful shock course through your body!</span>"
			buckled_mob.stun_effect_act(PN.get_electrocute_damage(), PN.get_electrocute_damage(), "head")

	visible_message("<span class='danger'>The electroshock chair goes off!</span>", "<span class='danger'>You hear an electrical discharge!</span>")

	toggle()
	return

/obj/item/weapon/mesmetron
	name = "mesmetron pocketwatch"
	desc = "An elaborate pocketwatch, with captivating gold etching and an enchanting face. . ."
	icon = 'icons/obj/items.dmi'
	icon_state = "pocketwatch"
	matter = list("glass" = 150, "gold" = 50)
	w_class = 1
	var/mob/living/carbon/human/thrall
	var/last_time = 0

/obj/item/weapon/mesmetron/process()
	if (thrall && last_time + 300 > world.time)
		last_time = world.time
		var/thrall_response = alert(thrall, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "No")
			thrall = null
			STOP_PROCESSING(SSfast_process, src)
		else
			thrall.sleeping = max(thrall.sleeping, 40)
			thrall.drowsyness = max(thrall.drowsyness, 60)
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/weapon/mesmetron/attack_self(mob/user as mob)
	if(!thrall)
		user << "You deciper the watch's mesmerizing face, discerning the time to be: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'."
	else
		var/response = alert(user, "Would you like to make a suggestion to [thrall], or release them?", "Mesmetron", "Suggestion", "Release")
		if (response == "Release")
			thrall = null
			STOP_PROCESSING(SSfast_process, src)
		else
			if(get_dist(user, thrall) > 1)
				user << "You must stand in whisper range of [thrall]."
				return

			text = input("What would you like to suggest?", "Hypnotic suggestion", null, null)
			text = sanitize(text)
			if(!text)
				return

			var/thrall_response = alert(thrall, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
			if(thrall_response == "Yes")
				thrall << "<span class='notice'><i>... [text] ...</i></span>"
				thrall.cure_all_traumas(cure_type = "hypnosis")
			else
				thrall = null

/obj/item/weapon/mesmetron/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/L = target

	user.visible_message("<span class='warning'>[user] begins to mesmerizingly wave [src] like a pendulum before [L]'s very eyes!</span>")

	if(!do_mob(user, L, 30 SECONDS))
		return


	if((!user in view(1,target)))
		return

	var/response = alert(L, "Do you believe in hypnosis?", "Willpower", "Yes", "No")

	if(response == "Yes")
		L.visible_message("<span class='warning'>[L] falls into a deep slumber!</span>", "<span class ='danger'>You fall into a deep slumber!</span>")

		L.sleeping = max(L.sleeping, 40)
		L.drowsyness = max(L.drowsyness, 60)
		thrall = L
		START_PROCESSING(SSfast_process, src)

/obj/structure/metronome
	name = "metronome"
	desc = "Tick. Tock. Tick. Tock. Tick. Tock."
	icon = 'icons/obj/structures.dmi'
	icon_state = "metronome1"
	anchored = 1
	density = 0
	var/ticktock = "Tick"
	var/last_time = 0

/obj/structure/metronome/Initialize()
	. = ..()
	START_PROCESSING(SSfast_process, src)

/obj/structure/metronome/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			user << "<span class='notice'>You unanchor \the [src] and it destabilizes.</span>"
			STOP_PROCESSING(SSfast_process, src)
			icon_state = "metronome0"
		else
			user << "<span class='notice'>You anchor \the [src] and it restabilizes.</span>"
			START_PROCESSING(SSfast_process, src)
			icon_state = "metronome1"
	else
		..()

/obj/structure/metronome/process()
	if(last_time + (5 SECONDS) > world.time)
		last_time = world.time
		var/counter = 0
		var/mob/living/carbon/human/H
		for(var/mob/living/L in view(3,src))
			counter++
			if(ishuman(L))
				H = L
		if(counter == 1 && H)
			if(ticktock == "Tick")
				ticktock = "Tock"
			else
				ticktock = "Tick"
			H << "<span class='notice'><i>[ticktock]. . .</i></span>"
			if(prob(10))
				H.cure_all_traumas(cure_type = "solitude")