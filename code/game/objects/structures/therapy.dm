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

/obj/structure/bed/chair/e_chair/Destroy()
	if (part)
		part.master = null
		part = null

	. = ..()

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
	usr << "<span class='notice'>You switch [on ? "on" : "off"] [src].</span>"

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
	var/datum/weakref/thrall = null
	var/time_counter = 0

/obj/item/weapon/mesmetron/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	thrall = null
	. = ..()

/obj/item/weapon/mesmetron/process()
	if (!thrall)
		STOP_PROCESSING(SSfast_process, src)
		return

	var/mob/living/carbon/human/H = thrall.resolve()
	if(!H)
		thrall = null
		STOP_PROCESSING(SSfast_process, src)
		return

	if (time_counter > 20)
		time_counter += 0.5
		var/thrall_response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "No")
			H.sleeping = max(H.sleeping - 40, 0)
			H.drowsyness = max(H.drowsyness - 60, 0)
			thrall = null
			STOP_PROCESSING(SSfast_process, src)
		else
			H.sleeping = max(H.sleeping, 40)
			H.drowsyness = max(H.drowsyness, 60)
	else
		STOP_PROCESSING(SSfast_process, src)

/obj/item/weapon/mesmetron/attack_self(mob/user as mob)
	if(!thrall || !thrall.resolve())
		thrall = null
		user << "You decipher the watch's mesmerizing face, discerning the time to be: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'."
		return

	var/mob/living/carbon/human/H = thrall.resolve()

	var/response = alert(user, "Would you like to make a suggestion to [thrall], or release them?", "Mesmetron", "Suggestion", "Release")

	if (response == "Release")
		thrall = null
		STOP_PROCESSING(SSfast_process, src)
	else
		if(get_dist(user, H) > 1)
			user << "You must stand in whisper range of [H]."
			return

		text = input("What would you like to suggest?", "Hypnotic suggestion", null, null)
		text = sanitize(text)
		if(!text)
			return

		var/thrall_response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")
		if(thrall_response == "Yes")
			H << "<span class='notice'><i>... [text] ...</i></span>"
		else
			thrall = null

/obj/item/weapon/mesmetron/afterattack(mob/living/carbon/human/H, mob/user, proximity)
	if(!proximity)
		return

	if(!istype(H))
		return

	user.visible_message("<span class='warning'>[user] begins to mesmerizingly wave [src] like a pendulum before [H]'s very eyes!</span>")

	if(!do_mob(user, H, 10 SECONDS))
		return

	if(!(user in view(1, loc)))
		return

	var/response = alert(H, "Do you believe in hypnosis?", "Willpower", "Yes", "No")

	if(response == "Yes")
		H.visible_message("<span class='warning'>[H] falls into a deep slumber!</span>", "<span class ='danger'>You fall into a deep slumber!</span>")

		H.sleeping = max(H.sleeping, 40)
		H.drowsyness = max(H.drowsyness, 60)
		thrall = WEAKREF(H)
		START_PROCESSING(SSfast_process, src)

/obj/machinery/chakrapod
	name = "Hallucinatory Therapy Pod"
	desc = "An even more state-of-the-art therapy pod. Designed to utilize control doses of hallucinogenic drugs and memetic pulse rays to cure mental traumas. Proven to be 100% effective 33.3% of the time!"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_0"
	density = 1
	anchored = 1

	use_power = 1
	idle_power_usage = 60
	active_power_usage = 10000

	var/datum/weakref/occupant = null
	var/locked
	var/obj/machinery/chakraconsole/connected

/obj/machinery/chakrapod/Initialize()
	. = ..()
	create_reagents(60)

/obj/machinery/chakrapod/Destroy()
	if (connected)
		connected.connected = null
		connected = null

	occupant = null

	return ..()

/obj/machinery/chakrapod/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/chakrapod/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Hallucinatory Therapy Pod"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/chakrapod/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Hallucinatory Therapy Pod"

	if (usr.stat != 0 || locked)
		return
	if(occupant)
		if (occupant.resolve())
			usr << "<span class='warning'>The pod is already occupied!</span>"
			return
	if (usr.abiotic())
		usr << "<span class='warning'>The subject cannot have abiotic items on.</span>"
		return
	if(locked)
		usr << "<span class='warning'>The pod is currently locked!</span>"
		return
	if(!ishuman(usr))
		usr << "<span class='warning'>The subject does not fit!</span>"
		return
	usr.pulling = null
	usr.client.perspective = EYE_PERSPECTIVE
	usr.client.eye = src
	usr.forceMove(src)
	src.occupant = WEAKREF(usr)
	update_use_power(2)
	src.icon_state = "syndipod_1"
	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	src.add_fingerprint(usr)
	return

/obj/machinery/chakrapod/proc/go_out()
	if (!src.occupant || !occupant.resolve())
		occupant = null
		return

	var/mob/living/carbon/human/H = occupant.resolve()

	if(locked)
		H << "<span class='notice'>You push against the pod door and attempt to escape. This process will take roughly two minutes.</span>"
		if(!do_after(H, 1200))
			return

	for(var/obj/O in src)
		O.forceMove(get_turf(src))
	if (H.client)
		H.client.eye = H.client.mob
		H.client.perspective = MOB_PERSPECTIVE
	H.forceMove(get_turf(src))
	occupant = null
	update_use_power(1)
	src.icon_state = "syndipod_0"
	locked = 0
	return

/obj/machinery/chakrapod/attackby(obj/item/weapon/grab/G, mob/user)
	if (!istype(G) || !ishuman(G.affecting))
		return
	if (occupant)
		user << "<span class='warning'>The pod is already occupied!</span>"
		return
	if (G.affecting.abiotic())
		user << "<span class='warning'>Subject cannot have abiotic items on.</span>"
		return
	if(locked)
		user << "<span class='warning'>The pod is locked.</span>"
		return


	var/mob/living/L = G.affecting
	visible_message("[user] starts putting [L] into the pod bed.", 3)

	if (do_mob(user, L, 30, needhand = 0))
		var/bucklestatus = L.bucklecheck(user)
		if (!bucklestatus)//incase the patient got buckled during the delay
			return
		if (bucklestatus == 2)
			var/obj/structure/LB = L.buckled
			LB.user_unbuckle_mob(user)

		if (L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
		L.forceMove(src)
		occupant = WEAKREF(L)

		update_use_power(2)
		icon_state = "syndipod_1"
		for(var/obj/O in src)
			O.forceMove(get_turf(src))

	src.add_fingerprint(user)
	qdel(G)
	return

/obj/machinery/chakrapod/MouseDrop_T(mob/living/carbon/human/H, mob/living/user)
	if(!istype(user) || !istype(H))
		return
	if (occupant)
		user << "<span class='notice'><B>The pod is already occupied!</B></span>"
		return
	if (H.abiotic())
		user << "<span class='notice'><B>Subject cannot have abiotic items on.</B></span>"
		return
	if(locked)
		user << "<span class='warning'>The pod is locked.</span>"
		return

	var/bucklestatus = H.bucklecheck(user)

	if (!bucklestatus)//We must make sure the person is unbuckled before they go in
		return

	if(H == user)
		visible_message("[user] starts climbing into the pod bed.", 3)
	else
		visible_message("[user] starts putting [H.name] into the pod bed.", 3)

	if (do_mob(user, H, 30, needhand = 0))
		if (bucklestatus == 2)
			var/obj/structure/LB = H.buckled
			LB.user_unbuckle_mob(user)
		if (H.client)
			H.client.perspective = EYE_PERSPECTIVE
			H.client.eye = src
		H.forceMove(src)
		occupant = WEAKREF(H)
		update_use_power(2)
		src.icon_state = "syndipod_1"
		for(var/obj/Obj in src)
			Obj.forceMove(get_turf(src))
	src.add_fingerprint(user)
	return

/obj/machinery/chakraconsole
	name = "Therapy Pod Console"
	desc = "A control panel for some kind of medical device."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_scannerconsole"
	density = 0
	anchored = 1
	var/obj/machinery/chakrapod/connected
	var/working = 0
	var/scan_count = 0
	var/calibrations
	flags = OPENCONTAINER

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
		connected = null

	return ..()

/obj/machinery/chakraconsole/power_change()
	..()
	if((stat & BROKEN) || (stat & NOPOWER))
		icon_state = "syndipod_scannerconsole-p"
	else
		icon_state = "syndipod_scannerconsole"

/obj/machinery/chakraconsole/Initialize()
	. = ..()
	for(var/obj/machinery/chakrapod/C in orange(1,src))
		connected = C
		break
	if(connected)
		connected.connected = src
	create_reagents(120)

/obj/machinery/chakraconsole/Destroy()
	if (connected)
		connected.connected = null
		connected = null

	. = ..()

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
	var/mob/living/carbon/human/H = connected && connected.occupant ? connected.occupant.resolve() : null
	if(!H)
		user << "<span class='notice'>The pod is currently unoccupied.</span>"
	else
		var/list/choices1 = list("Toggle Locking Mechanism", "Initiate Neural Scan", "Initiate Hallucinatory Therapy", "Purge Chemical Tray", "Calibrate Hallucinogen Control", "Cancel")
		if(emagged)
			choices1.Add("%eRr:# C:\\NT>quaid.exe")
		var/response1 = input(user,"Input Operation","Therapy Pod OS") as null|anything in choices1

		switch(response1)
			if("Toggle Locking Mechanism")
				connected.locked = !connected.locked
				visible_message("<span class='warning'>[connected]'s locking mechanism clicks.</span>", "<span class='warning'>You hear a click.</span>")
				return

			if("Initiate Neural Scan")
				visible_message("<span class='warning'>[connected] begins humming with an electrical tone.</span>", "<span class='warning'>You hear an electrical humming.</span>")
				if(H && connected.occupant.resolve() == H)
					if(do_after(user,20))
						scan_count++
						var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
						var/report = "<B>The following traumas are detected within subject #[scan_count]:</B><br>"
						var/traumas_found = 0
						var/obj/item/organ/sponge = H.internal_organs_by_name["brain"]
						for(var/X in sponge.traumas)
							var/datum/brain_trauma/organic/BT = X
							if(prob(80))
								report += "<B>[BT.name]</B> with severity of <B>[BT.trauma_severity] units.</B><br>"
							else
								report += "<B>[capitalize(BT.scan_desc)]</B> with severity of <B>[BT.trauma_severity + rand(-5,5) + rand()] units.</B><br>"
							traumas_found = 1
						if(!traumas_found)
							report = "<B>No traumas detected with subject #[scan_count].</B><br>"
						P.name = "neural scan - #[scan_count]"
						P.info = {"<center><img src = ntlogo.png></center>
					<center><b><i>NanoTrasen Psychology Report</b></i><br>
					<font size = \"1\"><font face='Courier New'>[report]</font></font><hr>
					<font size = \"1\">Subject's total brain integrity: <B>[sponge.damage] / [sponge.max_damage]</B>.</font><br>
					<center><img src = barcode[rand(0, 3)].png></center></center>"}
						P.update_icon()
						visible_message("\icon[src] <span class = 'notice'>The [usr] pings, \"[P.name] ready for review\", and happily disgorges a small printout.</span>", 2)
						playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

				else
					system_error("ERROR: Total braindeath in subject detected.")
				return

			if("Initiate Hallucinatory Therapy")
				neural_check(user, H)
				return
			if("%eRr:# C:\\NT>quaid.exe")
				total_recall(user, H)
				return
			if("Calibrate Hallucinogen Control")
				var/list/visualization_options = SStraumas.phobia_types
				var/list/duds = list("women","men","bankers","psychologists","gamblers","rocks","blood","trees","mimes","authority figures","mothers")
				visualization_options.Add(duds)
				calibrations = input(user,"Select a new trigger to generate.","Therapy Pod Calibrator.","clowns") in visualization_options
				user << "<span class='notice'>Therapy pod recalibrated to new specifications.</span>"
				visible_message("<span class='notice'>[src] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
				playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
				return
			if("Purge Chemical Tray")
				switch(alert(user,"Tray loaded with: [reagents.total_volume] units of chemical.","Please confirm purge.","Confirm","Cancel"))
					if("Confirm")
						user << "<span class='warning'>Purging chemical tray.</span>"
						playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
						if(do_after(user,100))
							connected.reagents.clear_reagents()
							reagents.clear_reagents()
							visible_message("<span class='notice'>[connected] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
							playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
				return

/obj/machinery/chakraconsole/proc/administer_dose(var/obj/item/organ/sponge, var/amount = 0)
	if(!sponge || !amount)
		system_error("ERROR: System failure. Doseage terminated.")
		return 0

	var/dose_id
	var/list/drugs_list = list("mind_breaker","psilocybin","space_drugs","serotrotium","cryptobiolin","impedrezene")
	for(var/id in drugs_list)
		if(reagents.has_reagent(id, amount))
			dose_id = id
			break
	if(!dose_id)
		reagents.trans_to_mob(sponge.owner, reagents.total_volume)
		system_error("ERROR: Chemical tray emptied.")
		return 0
	else
		reagents.trans_id_to(connected.reagents, dose_id, amount/10)
		connected.reagents.trans_to_mob(sponge.owner, connected.reagents.total_volume)
		var/probability = 0

		switch(dose_id)
			if("space_drugs")
				probability = 50
			if("serotrotium")
				probability = min(100, amount)
			if("cryptobiolin")
				probability = 33
			if("impedrezene")
				probability = 25
			if("mindbreaker")
				probability = max(0, 100 - amount*1.5)
			if("psilocybin")
				probability = min(75, 25 + amount)

		connected.occupant << "<span class='notice'>You begin to see flashing images of [calibrations] . . .</span>"
		if(prob(probability))
			return 1

	if(do_after(connected.occupant, 100))
		connected.occupant << "<span class='notice'>The flashing images of [calibrations] subside, but your traumas persist.</span>"
		system_error("ERROR: Subject failed to hallucinate.")
	return 0

/obj/machinery/chakraconsole/proc/neural_check(var/mob/user, var/mob/living/carbon/human/H)
	var/obj/item/organ/sponge = H.internal_organs_by_name["brain"]
	if(sponge.traumas.len)
		var/datum/brain_trauma/organic/BT = sponge.traumas[1]
		if(!administer_dose(sponge, BT.trauma_severity))
			return
		if(do_after(user, 100))
			if(BT.trigger_type == calibrations)
				qdel(BT)
				connected.occupant << "<span class='notice'>The flashing images of [calibrations] subside, and you begin to feel almost well again.</span>"
				visible_message("<span class='notice'>[connected] pings cheerfully.</span>", "<span class='notice'>You hear a ping.</span>")
				playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
			else
				system_error("ERROR: Hallucinatory feedback has no impact.")
	return

/obj/machinery/chakraconsole/proc/total_recall(var/mob/user, var/mob/living/carbon/human/H)
	if(H && H == connected.occupant.resolve())
		var/list/choices1 = list("Wipe Memory", "Implant Memory", "Cancel")
		var/response1 = input(user,"Input operation.","quaid.exe") as null|anything in choices1
		if(response1 == "Cancel")
			return
		if(response1 == "Wipe Memory")
			var/list/choices2 = list("5 minutes", "15 minutes", "30 minutes", "2 hours", "6 months", "Cancel")
			var/response2 = input(user,"Input timeframe.","Memory Wipe") as null|anything in choices2
			if(response2 != "Cancel")
				user << "<span class='notice'>Initiating memory wipe. Process will take approximately two minutes.</span>"
				H << "<span class='danger'>You feel a sharp pain in your brain as the therapy pod begins to hum menacingly!!</span>"
				if(do_after(user,(1200-rand(0,150))))
					if(administer_dose(H.internal_organs_by_name["brain"], 10))
						if(H && H == connected.occupant.resolve())
							var/timespan = response2
							H << "<span class='danger'>You feel a part of your past self, a portion of your memories, a piece of your very being slip away...</span>"
							H << "<b>Your memory of the past [timespan] has been wiped. Your ability to recall these past [timespan] has been removed from your brain, and you remember nothing that ever ocurred within those [timespan].</b>"
							return
			else
				return
		if(response1 == "Implant Memory")
			var/new_memory = input(user,"Input New Memory","quaid.exe")
			var/memory_implant = sanitize(new_memory)
			if(memory_implant)
				user << "<span class='notice'>Initiating memory implantation. Process will take approximately two minutes. Subject's memory of this process will also be wiped.</span>"
				H << "<span class='danger'>You feel a sharp pain in your brain as the therapy pod begins to hum menacingly!</span>"
				if(do_after(user,(1200-rand(0,150))))
					if(administer_dose(H.internal_organs_by_name["brain"], 10))
						if(H && H == connected.occupant.resolve())
							H << "<span class='danger'>You blink, and somehow between the timespan of your eyes closing and your eyes opening your perception of the world has changed in some imperceptible way...</span>"
							H << "<b>A new memory has been implanted in your mind as follows: [memory_implant] - you have no reason to suspect the memory to be fabricated, as your memory of the past two minutes has also been altered.</b>"
							return
	system_error("ERROR: Error not found!")

/obj/machinery/chakraconsole/proc/system_error(var/error)
	if(error)
		visible_message("<span class='warning'>\icon[src] [src.name] flashes a system warning: [error].</span>")
		playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)