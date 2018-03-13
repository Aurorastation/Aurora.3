/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 0

/obj/structure/bed/chair/e_chair/update_icon()
	return

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
		part.forceMove(get_turf(src))
		part.master = null
		part = null
		qdel(src)

/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened || usr.lying || usr.restrained() || usr.buckled)
		return

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		shock()
		icon_state = "echair1"
	user << "<span class='notice'>You switch [on ? "on" : "off"] [src].</span>"

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return

	var/obj/structure/cable/C = locate(/obj/structure/cable, get_turf(src))
	var/datum/powernet/PN = C.powernet
	flick("echair1", src)
	spark(src, 12, alldirs)
	if(buckled_mob && istype(C))
		if(electrocute_mob(buckled_mob, C, src, 1.25, "head"))
			buckled_mob << "<span class='danger'>You feel a deep shock course through your body!</span>"
			sleep(1)
			if(electrocute_mob(buckled_mob, C, src, 1.25, "head"))
				buckled_mob.Stun(PN.get_electrocute_damage()*10)
	visible_message("<span class='danger'>The electric chair goes off!</span>", "<span class='danger'>You hear an electrical discharge!</span>")

	return

/obj/item/weapon/mesmetron
	name = "mesmetron pocketwatch"
	desc = "An elaborate pocketwatch, with captivating gold etching and an enchanting face. . ."
	icon = 'icons/obj/items.dmi'
	icon_state = "pocketwatch"
	matter = list("glass" = 150, "gold" = 50)
	w_class = 1
	var/mob/living/carbon/human/thrall
	var/time_counter = 0


/obj/item/weapon/mesmetron/process()
	if (thrall && time_counter > 20)
		time_counter += 0.5
		var/thrall_response = alert(thrall, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "No")
			thrall.sleeping = max(thrall.sleeping - 40, 0)
			thrall.drowsyness = max(thrall.drowsyness - 60, 0)
			thrall = null
			STOP_PROCESSING(SSfast_process, src)
		else
			thrall.sleeping = max(thrall.sleeping, 40)
			thrall.drowsyness = max(thrall.drowsyness, 60)
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/weapon/mesmetron/attack_self(mob/user as mob)
	if(!thrall)
		user << "You decipher the watch's mesmerizing face, discerning the time to be: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'."
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
				thrall.cure_all_traumas(cure_type = CURE_HYPNOSIS)
			else
				thrall = null

/obj/item/weapon/mesmetron/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(!ishuman(target))
		return

	var/mob/living/carbon/human/L = target

	user.visible_message("<span class='warning'>[user] begins to mesmerizingly wave [src] like a pendulum before [L]'s very eyes!</span>")

	if(!do_mob(user, L, 10 SECONDS))
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

/obj/structure/metronome/Initialize()
	. = ..()
	START_PROCESSING(SSslow_process, src)

/obj/structure/metronome/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			user << "<span class='notice'>You unanchor \the [src] and it destabilizes.</span>"
			STOP_PROCESSING(SSslow_process, src)
			icon_state = "metronome0"
			anchored = 0
		else
			user << "<span class='notice'>You anchor \the [src] and it restabilizes.</span>"
			START_PROCESSING(SSslow_process, src)
			icon_state = "metronome1"
			anchored = 1
	else
		..()

/obj/structure/metronome/process()
	var/counter = 0
	var/mob/living/carbon/human/H
	for(var/mob/living/L in view(3,src.loc))
		counter++
		if(ishuman(L))
			H = L
	if(counter == 1 && H)
		if(ticktock == "Tick")
			ticktock = "Tock"
		else
			ticktock = "Tick"
		H << "<span class='notice'><i>[ticktock]. . .</i></span>"
		H << 'sound/effects/singlebeat.ogg'
		if(prob(1))
			H.cure_all_traumas(cure_type = CURE_SOLITUDE)

/obj/machinery/chakrapod
	name = "Crystal Therapy Pod"
	desc = "A state-of-the-art crystal therapy pod. Designed to utilize phoron enhanced quartz crystals to remove mental trauma from the body. Proven to be 100% effective 30% of the time!"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000

	var/mob/living/carbon/occupant
	var/locked
	var/obj/machinery/body_scanconsole/connected

/obj/machinery/chakrapod/Destroy()
	if (connected)
		connected.connected = null
	return ..()

/obj/machinery/chakrapod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/chakrapod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Crystal Therapy Pod"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/chakrapod/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Crystal Therapy Pod"

	if (usr.stat != 0 || locked)
		return
	if (src.occupant)
		usr << "<span class='warning'>The pod is already occupied!</span>"
		return
	if (usr.abiotic())
		usr << "<span class='warning'>The subject cannot have abiotic items on.</span>"
		return
	if(locked)
		user << "<span class='warning'>The pod is currently locked!</span>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	src.occupant = usr
	update_use_power(2)
	src.icon_state = "syndipod_1"
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	src.add_fingerprint(usr)
	return

/obj/machinery/chakrapod/proc/go_out()
	if (!src.occupant)
		return

	if(locked)
		visible_message("<span class='notice'>Emergency release trigger activated. Releasing subject. ETA: 2 minutes.</span>")
		sleep(1200)

	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(get_turf(src))
	src.occupant = null
	update_use_power(1)
	src.icon_state = "syndipod_0"
	return

/obj/machinery/chakrapod/attackby(obj/item/weapon/grab/G as obj, user as mob)
	if ((!( istype(G, /obj/item/weapon/grab) ) || !( ismob(G.affecting) )))
		return
	if (src.occupant)
		user << "<span class='warning'>The pod is already occupied!</span>"
		return
	if (G.affecting.abiotic())
		user << "<span class='warning'>Subject cannot have abiotic items on.</span>"
		return
	if(locked)
		user << "<span class='warning'>The pod is locked.</span>"
		return

	if(istype(G, /obj/item/weapon/grab))

		var/mob/living/L = G:affecting
		visible_message("[user] starts putting [G:affecting] into the pod bed.", 3)

		if (do_mob(user, G:affecting, 30, needhand = 0))
			var/bucklestatus = L.bucklecheck(user)
			if (!bucklestatus)//incase the patient got buckled during the delay
				return
			if (bucklestatus == 2)
				var/obj/structure/LB = L.buckled
				LB.user_unbuckle_mob(user)
			var/mob/M = G.affecting
			if (istype(M) && M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.forceMove(src)
			src.occupant = M
			update_use_power(2)
			src.icon_state = "syndipod_1"
			for(var/obj/O in src)
				O.forceMove(get_turf(src))
	src.add_fingerprint(user)
	qdel(G)
	return

/obj/machinery/chakrapod/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!istype(user))
		return
	if(!ismob(O))
		return
	var/mob/living/M = O
	if (src.occupant)
		user << "<span class='notice'><B>The pod is already occupied!</B></span>"
		return
	if (M.abiotic())
		user << "<span class='notice'><B>Subject cannot have abiotic items on.</B></span>"
		return
	if(locked)
		user << "<span class='warning'>The pod is locked.</span>"
		return

	var/mob/living/L = O
	var/bucklestatus = L.bucklecheck(user)

	if (!bucklestatus)//We must make sure the person is unbuckled before they go in
		return

	if(L == user)
		visible_message("[user] starts climbing into the pod bed.", 3)
	else
		visible_message("[user] starts putting [L.name] into the pod bed.", 3)

	if (do_mob(user, L, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled
			LB.user_unbuckle_mob(user)
		if (M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		src.occupant = M
		update_use_power(2)
		src.icon_state = "syndipod_1"
		for(var/obj/Obj in src)
			Obj.forceMove(get_turf(src))
	src.add_fingerprint(user)
	return

/obj/machinery/chakrapod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(get_turf(src))
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(get_turf(src))
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(get_turf(src))
					ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/chakraconsole
	name = "Therapy Pod Console"
	desc = "A control panel for some kind of medical device."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_scannerconsole"
	density = 0
	anchored = 1
	var/obj/machinery/bodyscanner/connected
	var/crystal = 0
	var/working = 0

/obj/machinery/chakraconsole/ex_act(severity)

	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		else
	return

/obj/machinery/chakraconsole/Destroy()
	if (connected)
		connected.connected = null
	return ..()

/obj/machinery/chakraconsole/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "syndipod_scannerconsole-p"
	else
		if (stat & NOPOWER)
			spawn(rand(0, 15))
				src.icon_state = "syndipod_scannerconsole-p"
		else
			icon_state = initial(icon_state)

/obj/machinery/chakraconsole/Initialize()
	. = ..()
	for(var/obj/machinery/chakrapod/C in orange(1,src))
		connected = C
		break
	connected.connected = src

/obj/machinery/chakraconsole/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/chakraconsole/attack_hand(user as mob)
	if(..())
		return

	button_prompt(user)

/obj/machinery/chakraconsole/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		user << "<span class='warning'>You short out [src]'s safety measurements.</span>"
		visible_message("[src] hums oddly...")
		emagged = 1
		return 1

/obj/machinery/chakraconsole/proc/button_prompt(user as mob)
	var/mob/living/carbon/human/H = connected.occupant
	if(!H)
		user << "<span class='notice>The pod is currently unoccupied</span>."
	else
		var/list/choices1 = list("Input operation.", "Therapy Pod", "Toggle Locking Mechanism", "Initiate Neural Scan", "Initiate Crystal Therapy", "Eject Crystal", "Cancel")
		if(emagged)
			choices1.Add("%eRr:# C:\\NT>quaid.exe")
		var/response1 = input(user,"Input New Memory","quaid.exe") as null|anything in choices1

		switch(response1)
			if("Toggle Locking Mechanism")
				connected.locked = !connected.locked
				visible_message("<span class='warning'>[connected]'s locking mechanism clicks.</span>", "<span class='warning'>You hear a click.</span>")
				return
			if("Initiate Neural Scan")
				visible_message("<span class='warning'>[connected] begins humming with an electrical tone.</span>", "<span class='warning'>You hear an electrical humming.</span>")
				if(H && connected.occupant == H)
					var/obj/item/organ/brain/sponge = H.internal_organs_by_name["brain"]
					var/retardation = H.getBrainLoss()
					if(sponge && istype(sponge))
						if(!sponge.lobotomized)
							user << "<span class='notice'>Scans indicate [retardation] distinct abnormalities present in subject.</span>"
							return
						else
							user << "<span class='notice'>Scans indicate [retardation+rand(-20,20)] distinct abnormalities present in subject.</span>"
							return

				user << "<span class='warning'>Scans indicate total brain failure in subject.</span>"
				return
			if("Initiate Crystal Therapy")
				if(!crystal)
					neural_check(user, H)
					return
				user << "<span class='danger'>Error: Crystal depleted. Terminating operation..</span>"
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
				visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")
			if("%eRr:# C:\\NT>quaid.exe")
				if(!crystal)
					total_recall(user, H)
					return
				user << "<span class='danger'>Error: Crystal depleted. Terminating operation..</span>"
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
				visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")
			if("Recycle Crystal")
				if(crystal)
					user << "<span class='warning'>Eliminating depleted crystal.</span>"
					playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
					sleep(100)
					crystal = 0
					visible_message("<span class='notice'>[connected] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
					playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
					return
				user << "<span class='danger'>Error: Crystal depletion not detected. Terminating operation..</span>"
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
				visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")

/obj/machinery/chakraconsole/proc/neural_check(var/mob/user, var/mob/living/carbon/human/H)
	var/response = input(user,"Input number of rotations","Therapy Pod","0")
	var/alert = text2num(sanitize(response))
	if(alert)

		for(var/i=0;i<=alert;i++)
			var/electroshock_trauma = 0
			if(H && H == connected.occupant)
				var/obj/item/organ/brain/sponge = H.internal_organs_by_name["brain"]
				if(sponge && istype(sponge))
					if(sponge.traumas.len)
						for(var/X in sponge.traumas)
							var/datum/brain_trauma/trauma = X
							if(trauma.cure_type == CURE_CRYSTAL)
								if(!trauma.permanent)
									qdel(trauma)
									electroshock_trauma = 1
									break
					if(electroshock_trauma)
						visible_message("<span class='notice'>[connected] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
						playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
					else
						if(get_dist(user,src) <= 1)
							user << "<span class='danger'>Error: Brain abnormality not recognized. Subject contamination detected.</span>"
						playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
						visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")
						H.apply_radiation(max(10,i*10))
				else
					if(get_dist(user,src) <= 1)
						user << "<span class='danger'>Error: Subject not recognized. Terminating operation.</span>"
					playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
					visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")
					break
			else
				if(get_dist(user,src) <= 1)
					user << "<span class='danger'>Error: Subject not recognized. Terminating operation.</span>"
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
				visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")
				break
			crystal = 1
			sleep(100)
	else
		user << "<span class='warning'>Error. Invalid input.</span>"

/obj/machinery/chakraconsole/proc/total_recall(var/mob/user, var/mob/living/carbon/human/H)
	if(H && H == connected.occupant)
		var/list/choices1 = list("Input operation.", "quaid.exe", "Wipe Memory", "Implant Memory", "Cancel")
		var/response1 = input(user,"Input New Memory","quaid.exe") as null|anything in choices1
		if(response1 == "Cancel")
			return
		if(response1 == "Wipe Memory")
			var/list/choices2 = list("Input timeframe.", "Memory Wipe", "5 minutes", "15 minutes", "30 minutes", "2 hours", "6 months", "Cancel")
			var/response2 = input(user,"Input New Memory","quaid.exe") as null|anything in choices2
			if(response2 != "Cancel")
				user << "<span class='notice'>Initiating memory wipe. Process will take approximately two minutes.</span>"
				H << "<span class='danger'>You feel a sharp pain in your brain as the therapy pod begins to hum menacingly!!</span>"
				sleep(1200-rand(0,150))
				if(H && H == connected.occupant)
					var/timespan = response2
					H << "<span class='danger'>You feel a part of your past self, a portion of your memories, a piece of your very being slip away...</span>"
					H << "<b>Your memory of the past [timespan] has been wiped. Your ability to recall these past [timespan] has been removed from your brain, you remember nothing that ever ocurred within those [timespan].</b>"
					return
			else
				return
		if(response1 == "Implant Memory")
			var/new_memory = input(user,"Input New Memory","quaid.exe")
			var/memory_implant = sanitize(new_memory)
			if(memory_implant)
				user << "<span class='notice'>Initiating memory implantation. Process will take approximately two minutes. Subject's memory of this process will also be wiped.</span>"
				H << "<span class='danger'>You feel a sharp pain in your brain as the therapy pod begins to hum menacingly!</span>"
				sleep(1200-rand(0,150))
				if(H && H == connected.occupant)
					H << "<span class='danger'>You blink, and somehow between the timespan of your eyes closing and your eyes opening your perception of the world has changed in some imperceptible way...</span>"
					H << "<b>A new memory has been implanted in your mind as follows: [memory_implant] - you have no reason to suspect the memory to be fabricated, as your memory of the past two minutes has also been altered.</b>"
					return
	if(get_dist(user,src) <= 1)
		user << "<span class='danger'>Error: Operation failed. Terminating operation.</span>"
	playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
	visible_message("<span class='warning'>[connected] buzzes harshly.</span>", "<span class='warning'>You hear a sharp buzz.</span>")