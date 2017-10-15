/* 
The reverse engineering deive.
Made up of several parts and is able to anaylze a specimen using various deconstrutive and analytical proccesses.
Going through the machine causes the specimen to be destroyed, but something is given for it.
There is also a non-destrutive option, but... It's not as fun.
*/
//Scan types
#define SCAN_IDLE 0
#define SCAN_DESTROY 1
#define SCAN_CONVERT_ORIGIN 2
#define SCAN_NODESTROY 3
#define SCAN_DNA_SAMPLE 4
#define SCAN_CLONE 5
//Sample Things
#define SAMPLE_CLONE 6
#define SAMPLE_DEEPANALYZE 7

/obj/machinery/red
	name = "reverse engineering device"
	desc = "A biological and engineering feat. Used to analyze various specimens."
	icon = 'icons/obj/machines/gravity_generator.dmi'
	anchored = 1
	density = 1
	use_power = 0
	unacidable = 1
	//Part 1 = Very left entrance part
	//Part 2 = fluff part to the right of the leftmost part
	//Part 3 = central computer/part
	//Part 4 = fluff part to the left of the rightmost part
	//Part 5 = Very right exit part
	var/part_number = 0
	//Status 0 = Not processing something
	//Status 1 = Processing something
	//Status 2 = Broken
	//Status 3 = No power
	var/status = 0 //Used for icon
	var/processing_status = 0 // 100 is completed
	var/mob/mobinside = null // whats inside
	var/obj/machinery/red/main/mainpart = null // the main part (part 3)

/obj/machinery/red/Initialize()
	. = ..()
	update_icon()
	machinery_processing = FALSE

/obj/machinery/red/update_icon()
	..()
	//icon_state = "red_[part_number]_[get_status()]"
	icon_state = "on_8"

/obj/machinery/red/proc/get_status()
	if(machinery_processing)
		return 1
	return 0

/obj/machinery/red/machinery_process()
	if(mobinside)
		if(mainpart)
			if(processing_status == 100)
				var/obj/machinery/red/T = null
				for(var/A in mainpart.parts)
					if(T.part_number == part_number - 1)
						break
					T = A
				if(T)
					machinery_processing = FALSE
					processing_status = 0
					transfer_mob(mobinside, T)
					T.machinery_processing = TRUE
				else if(part_number == 5)
					machinery_processing = FALSE
					complete_mob_analysis()
			else
				machinery_processing = FALSE
				spawn(0)
					runevent()
	else
		processing_status = 0
		mobinside = null
	return

/obj/machinery/red/proc/transfer_mob(var/mob/T, var/obj/machinery/red/A)
	mobinside = null
	status = 0
	T.forceMove(A)
	A.status = 1
	A.mobinside = T

/obj/machinery/red/proc/runevent()
	if(processing_status == 0)
		src.visible_message("<span class='notice'>The [src] makes some loud humming noises, and starts to visibly shake very slightly...</span>")
		if(prob(50))
			playsound(src.loc, 'sound/machines/red_powerup.ogg', 75, 1)
		else
			playsound(src.loc, 'sound/machines/red_powerup_alt.ogg', 75, 1)
		processing_status = 20
		sleep(300)
		switch(part_number)
			if(1)
				ping("\The [src] pings loudly, 'Biological subject loaded. Current operational parameters: [scantype2text()]. Initating scan.'")
				processing_status = 40
			if(2)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					ping("\The [src] pings loudly, 'Initating safe scan. Biological sample will be preserved. Initating scanning procedures.'")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					ping("\The [src] pings loudly, 'Initating pre-clone procedures, preparing sample...'")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					ping("\The [src] pings loudly, 'Initating deep scan procedures, preparing sample...'")
				else
					ping("\The [src] pings loudly, 'Initiating full scan. Biological sample will be destroyed. Initating scanning procedures.'")
			if(3)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] makes a few beeping sounds, as parts inside the machine move around...</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					src.visible_message("<span class='notice'>The [src] makes a spraying sound...</span>")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] emits a heavy dronning sound as the sample is scanned...</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a loud crushing sound.</span>")
			if(4)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] whirrs loudly and makes a few beeping sounds.</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE, SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] makes a scanning sound.</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a heavy droning sound. </span>")
			if(5)
				ping("\The [src] pings loudly, 'Finilazing processes... 0 Percent.'")
		sleep(100)
		machinery_processing = TRUE
		return
	else if(processing_status == 20)
		if(prob(50))
			playsound(src.loc, 'sound/machines/red_powerup.ogg', 75, 1) // SOUND
		else
			playsound(src.loc, 'sound/machines/red_powerup_alt.ogg', 75, 1) // SOUND
		processing_status = 40
		sleep(300)
		switch(part_number)
			if(2)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					ping("\The [src] pings loudly, 'Analyzing internal structual...'")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					ping("\The [src] pings loudly, 'Reading specimen DNA...'")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					ping("\The [src] pings loudly, 'Preparing specimen DNA for reading...'")
				else
					ping("\The [src] pings loudly, 'Decontaminating biological specimen to ensure purity. Current purity: [rand(0,20)]%'")
			if(3)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] makes a few beeping sounds, as parts inside the machine move around...</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					src.visible_message("<span class='notice'>The [src] makes a spraying sound...</span>")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] emits a heavy dronning sound as the sample is scanned...</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a loud crushing sound.</span>")
			if(4)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] whirrs loudly and makes a few beeping sounds.</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE, SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] makes a scanning sound.</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a heavy droning sound. </span>")
			if(5)
				ping("\The [src] pings loudly, 'Finalizing processes... 20 Percent.'")
		sleep(100)
		machinery_processing = TRUE
		return
	else if(processing_status == 40)
		if(prob(50))
			playsound(src.loc, 'sound/machines/red_powerup.ogg', 75, 1) // SOUND
		else
			playsound(src.loc, 'sound/machines/red_powerup_alt.ogg', 75, 1) // SOUND
		processing_status = 60
		sleep(300)
		switch(part_number)
			if(1)
				ping("\The [src] pings loudly, 'Scan type: [scantype2text()] prepartions loaded. Loading maintenance procedures.'")
				processing_status = 80
			if(2)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					ping("\The [src] pings loudly, 'Interal structure loaded. Preparing DNA for scanning procedures.'")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					ping("\The [src] pings loudly, 'Loading CRISPR procedures...'")
				else
					ping("\The [src] pings loudly, 'Decontaminating biological specimen to ensure purity. Current purity: [rand(20,40)]%'")
			if(3)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] makes a few beeping sounds, as parts inside the machine move around...</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					src.visible_message("<span class='notice'>The [src] makes a spraying sound...</span>")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] emits a heavy dronning sound as the sample is scanned...</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a loud crushing sound.</span>")
			if(4)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] whirrs loudly and makes a few beeping sounds.</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE, SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] makes a scanning sound.</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a heavy droning sound. </span>")
			if(5)
				ping("\The [src] pings loudly, 'Finalizing processes... 40 Percent.'")
		sleep(100)
		machinery_processing = TRUE
		return
	else if(processing_status == 60)
		if(prob(50))
			playsound(src.loc, 'sound/machines/red_powerup.ogg', 75, 1) // SOUND
		else
			playsound(src.loc, 'sound/machines/red_powerup_alt.ogg', 75, 1) // SOUND
		processing_status = 80
		sleep(300)
		switch(part_number)
			if(2)
				if(mainpart.scan_type in list( SCAN_NODESTROY))
					ping("\The [src] pings loudly, 'Analyzing internal structual...'")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					ping("\The [src] pings loudly, 'Preparing structual DNA for CRISPR adjustments...'")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					ping("\The [src] pings loudly, 'Preparing specimen DNA for reading...'")
				else
					ping("\The [src] pings loudly, 'Decontaminating biological specimen to ensure purity. Current purity: [rand(40,80)]%'")
			if(3)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] makes a few beeping sounds, as parts inside the machine move around...</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					src.visible_message("<span class='notice'>The [src] makes a spraying sound...</span>")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] emits a heavy dronning sound as the sample is scanned...</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a loud crushing sound.</span>")
			if(4)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					src.visible_message("<span class='notice'>The [src] whirrs loudly and makes a few beeping sounds.</span>")
				else if(mainpart.scan_type in list(SCAN_CLONE, SAMPLE_DEEPANALYZE))
					src.visible_message("<span class='notice'>The [src] makes a scanning sound.</span>")
				else
					src.visible_message("<span class='notice'>The [src] emits a heavy droning sound. </span>")
			if(5)
				ping("\The [src] pings loudly, 'Finalizing processes... 40 Percent.'")
		sleep(100)
		machinery_processing = TRUE
		return
	else if(processing_status == 80)
		playsound(src.loc, 'sound/machines/signal.ogg', 75, 1)
		processing_status = 100
		sleep(300)
		switch(part_number)
			if(1)
				ping("\The [src] pings loudly, 'Scan type: [scantype2text()] preparations finished. Offloading sample to next sequence. Shutting down...'")
			if(2)
				if(mainpart.scan_type in list(SCAN_NODESTROY))
					ping("\The [src] pings loudly, 'Internal structure analyzation complete. Offloading sample to begin next sequence. Shutting down... '")
				else if(mainpart.scan_type in list(SCAN_CLONE))
					ping("\The [src] pings loudly, 'CRISPR module loaded. Offloading DNA and CRISPR procedures. Shutting down...'")
				else if(mainpart.scan_type in list(SAMPLE_DEEPANALYZE))
					ping("\The [src] pings loudly, 'Preparing specimen DNA for reading...'")
				else
					ping("\The [src] pings loudly, 'Decontaminating biological specimen to ensure purity. Current purity: [rand(80,100)]%'")
			if(3 to 4)
				src.visible_message("<span class='notice'>The [src] emits a heavy droning sound as it transfers the specimen. </span>")	
			if(5)
				ping("\The [src] pings loudly, 'Processing finialized. Ejecting final product. Exercise caution.'")
				playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 75, 1)
		sleep(100)
		machinery_processing = TRUE
		return

/obj/machinery/red/proc/scantype2text()
	return
		
/obj/machinery/red/proc/complete_mob_analysis()
	if(part_number != 5 && processing_status != 100)
		return
	var/human = 0
	var/mob/living/T = mobinside

	if(ishuman(mobinside))
		human = 1
	print_lore()
	switch(mainpart.scan_type)
		if(SCAN_CLONE)
			var/mob/B
			B = new T
			B.loc = src
		if(SCAN_CONVERT_ORIGIN)
			if(human)
				T.monkeyize() // this will make them into their origin species.
				spitmob()
		if(SCAN_DESTROY)
			produce_sample(T, SCAN_DESTROY)
			if(human)
				if(T.stat == DEAD)
					spitmob()
					T.gib()
				else
					T << "<span class ='danger'>You feel a horrible pain as the machine rips you apart!</span>"
			else
				qdel(T)
		if(SCAN_NODESTROY)
			produce_sample(T, SCAN_NODESTROY)
			spitmob()
		if(SAMPLE_CLONE)
			return
		if(SAMPLE_DEEPANALYZE)
			produce_sample(T, SAMPLE_DEEPANALYZE)
			return
	mainpart.scan_type = SCAN_IDLE
	return

/obj/machinery/red/proc/print_lore(var/special) // ew
	var/obj/item/weapon/paper/REDresult/T = new(src)
	T.changeinfo(mobinside, mainpart.scan_type)

/obj/machinery/red/proc/spitmob()
	mobinside.loc = src.loc
	mobinside = null
	status = 0

/obj/machinery/red/proc/produce_sample(var/mob/T, var/details)
	var/obj/item/red_sample/B = new /obj/item/red_sample
	B.mobDNA = T
	B.set_origin()

/obj/machinery/red/main
	icon_state = "red_3_0"
	name = "reverse engineering device interface"
	desc = "A highly advanced computer used to control the RED."
	idle_power_usage = 0
	active_power_usage = 6000
	power_channel = ENVIRON
	part_number = 3
	status = 0
	use_power = 1
	interact_offline = 1
	var/on = 1
	var/scan_type = SCAN_IDLE
	var/list/parts = list()

/obj/machinery/red/main/Initialize()
	. = ..()
	spawn_parts()
	parts += src
	
/obj/machinery/red/main/proc/spawn_parts()
	var/turf/our_turf = get_turf(src)
	var/list/spawn_turfs = block(locate(our_turf.x - 2, our_turf.y, our_turf.z), locate(our_turf.x + 2, our_turf.y, our_turf.z))
	var/count = 1
	for(var/turf/T in spawn_turfs)
		if(T == our_turf) // Skip our turf.
			count++
			continue
		var/obj/machinery/red/part/newpart = new(T)
		newpart.status = 0
		newpart.part_number = count
		newpart.update_icon()
		newpart.mainpart = src
		parts += newpart
		count++

/obj/machinery/red/main/attack_ai(mob/user)
	add_hiddenprint(user)	
	ui_interact(user)

/obj/machinery/red/main/attack_hand(mob/user as mob)
	add_fingerprint(user)
	//if(stat & (BROKEN|NOPOWER))
	//	return
	ui_interact(user)

/obj/machinery/red/part
	icon_state = "red_0_0"
	idle_power_usage = 0
	power_channel = ENVIRON
	part_number = 0
	status = 0
	use_power = 0
	interact_offline = 1
	var/sealed = 0

/obj/machinery/red/part/MouseDrop_T(atom/movable/O as mob|obj, mob/living/user as mob)
	if(!ismob(O))
		user << "The machine smartly refuses to accept the non-living item."
		return
	if(ishuman(O) && !emagged  && !islesserform(user))
		user << "The machines saftey mechanisms refuse to accept the [O]"
		return
	if(part_number == 1)
		if(!mobinside)
			src.visible_message("<span class='warning'>[user] starts loading [O] into the [src]!</span>")
			if(do_after(user,40))
				load_mob(O)
			else
				user << "You must remain still to load [O]"
		else
			user << "The machine is already full."
			return

/obj/machinery/red/part/proc/load_mob(var/mob/T)
	if(!ismob(T))
		return 0
	for(var/mob/living/carbon/slime/M in range(1,usr))
		if(M.Victim == usr)
			return 0
	if(mobinside)
		return 0
	transfer_mob(T, src)
	processing_status = 0
	status = 1
	runevent()
