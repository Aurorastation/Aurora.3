/obj/structure/AIcore
	name = "\improper AI core"
	desc = "A large machine that can store an AI, give it power, and protection. Additionally, it provides site-wide camera access."
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"
	density = 1
	anchored = 0
	build_amt = 4
	var/state = 0
	var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen
	var/obj/item/circuitboard/circuit = null
	var/obj/item/device/mmi/brain = null


/obj/structure/AIcore/attackby(obj/item/attacking_item, mob/user)

	switch(state)
		if(0)
			if(attacking_item.iswrench())
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					to_chat(user, "<span class='notice'>You wrench the frame into place.</span>")
					anchored = 1
					state = 1
				return TRUE
			if(attacking_item.iswelder())
				var/obj/item/weldingtool/WT = attacking_item
				if(!WT.isOn())
					to_chat(user, "The welder must be on for this task.")
					return
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					if(!src || !WT.use(0, user)) return
					to_chat(user, "<span class='notice'>You deconstruct the frame.</span>")
					new /obj/item/stack/material/plasteel( loc, 4)
					qdel(src)
				return TRUE
		if(1)
			if(attacking_item.iswrench())
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					to_chat(user, "<span class='notice'>You unfasten the frame.</span>")
					anchored = 0
					state = 0
				return TRUE
			if(istype(attacking_item, /obj/item/circuitboard/aicore) && !circuit)
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You place the circuit board inside the frame.</span>")
				icon_state = "1"
				circuit = attacking_item
				user.drop_from_inventory(attacking_item,src)
				return TRUE
			if(attacking_item.isscrewdriver() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You screw the circuit board into place.</span>")
				state = 2
				icon_state = "2"
				return TRUE
			if(attacking_item.iscrowbar() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You remove the circuit board.</span>")
				state = 1
				icon_state = "0"
				circuit.forceMove(loc)
				circuit = null
				return TRUE
		if(2)
			if(attacking_item.isscrewdriver() && circuit)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You unfasten the circuit board.</span>")
				state = 1
				icon_state = "1"
				return TRUE
			if(attacking_item.iscoil())
				var/obj/item/stack/cable_coil/C = attacking_item
				if (C.get_amount() < 5)
					to_chat(user, "<span class='warning'>You need five coils of wire to add them to the frame.</span>")
					return TRUE
				to_chat(user, "<span class='notice'>You start to add cables to the frame.</span>")
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if (do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) && state == 2)
					if (C.use(5))
						state = 3
						icon_state = "3"
						to_chat(user, "<span class='notice'>You add cables to the frame.</span>")
				return TRUE
		if(3)
			if(attacking_item.iswirecutter())
				if (brain)
					to_chat(user, "Get that brain out of there first")
				else
					playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
					to_chat(user, "<span class='notice'>You remove the cables.</span>")
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( loc )
					A.amount = 5
				return TRUE

			if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == MATERIAL_GLASS_REINFORCED)
				var/obj/item/stack/RG = attacking_item
				if (RG.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two sheets of glass to put in the glass panel.</span>")
					return
				to_chat(user, "<span class='notice'>You start to put in the glass panel.</span>")
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				if (do_after(user, 2 SECONDS, src, DO_REPAIR_CONSTRUCT) && state == 3)
					if(RG.use(2))
						to_chat(user, "<span class='notice'>You put in the glass panel.</span>")
						state = 4
						icon_state = "4"
				return TRUE

			if(istype(attacking_item, /obj/item/aiModule/asimov))
				laws.add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
				laws.add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
				laws.add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
				to_chat(usr, "Law module applied.")
				return TRUE

			if(istype(attacking_item, /obj/item/aiModule/nanotrasen))
				laws.add_inherent_law("Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.")
				laws.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
				to_chat(usr, "Law module applied.")
				return TRUE

			if(istype(attacking_item, /obj/item/aiModule/purge))
				laws.clear_inherent_laws()
				to_chat(usr, "Law module applied.")
				return TRUE

			if(istype(attacking_item, /obj/item/aiModule/freeform))
				var/obj/item/aiModule/freeform/M = attacking_item
				laws.add_inherent_law(M.newFreeFormLaw)
				to_chat(usr, "Added a freeform law.")
				return TRUE

			if(istype(attacking_item, /obj/item/device/mmi))
				var/obj/item/device/mmi/M = attacking_item
				if(!M.ready_for_use(user))
					return TRUE
				if(jobban_isbanned(M.brainmob, "AI"))
					to_chat(user, "<span class='warning'>This [attacking_item] does not seem to fit.</span>")
					return TRUE

				if(M.brainmob.mind)
					clear_antag_roles(M.brainmob.mind, 1)

				user.drop_from_inventory(attacking_item, src)
				brain = attacking_item
				to_chat(usr, "Added [attacking_item].")
				icon_state = "3b"
				return TRUE

			if(attacking_item.iscrowbar() && brain)
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You remove the brain.</span>")
				brain.forceMove(loc)
				brain = null
				icon_state = "3"
				return TRUE

		if(4)
			if(attacking_item.iscrowbar())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You remove the glass panel.</span>")
				state = 3
				if (brain)
					icon_state = "3b"
				else
					icon_state = "3"
				new /obj/item/stack/material/glass/reinforced( loc, 2 )
				return TRUE

			if(attacking_item.isscrewdriver())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, "<span class='notice'>You connect the monitor.</span>")
				if(!brain)
					var/open_for_latejoin = alert(user, "Would you like this core to be open for latejoining AIs?", "Latejoin", "Yes", "Yes", "No") == "Yes"
					var/obj/structure/AIcore/deactivated/D = new(loc)
					if(open_for_latejoin)
						GLOB.empty_playable_ai_cores += D
				else
					var/mob/living/silicon/ai/A = new /mob/living/silicon/ai ( loc, laws, brain )
					if(A) //if there's no brain, the mob is deleted and a structure/AIcore is created
						A.rename_self("ai", 1)
				feedback_inc("cyborg_ais_created",1)
				qdel(src)
				return TRUE

/obj/structure/AIcore/deactivated
	name = "inactive AI"
	desc = "An empty AI core."
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = 1
	state = 20//So it doesn't interact based on the above. Not really necessary.

/obj/structure/AIcore/deactivated/Destroy()
	if(src in GLOB.empty_playable_ai_cores)
		GLOB.empty_playable_ai_cores -= src
	return ..()

/obj/structure/AIcore/deactivated/proc/load_ai(var/mob/living/silicon/ai/transfer, var/obj/item/aicard/card, var/mob/user)

	if(!istype(transfer) || locate(/mob/living/silicon/ai) in src)
		return

	transfer.ai_restore_power_routine = 0
	transfer.control_disabled = 0
	transfer.ai_radio.disabledAi = 0
	transfer.forceMove(get_turf(src))
	transfer.create_eyeobj()
	transfer.cancel_camera()
	to_chat(user, "<span class='notice'>Transfer successful:</span> [transfer.name] ([rand(1000,9999)].exe) downloaded to host terminal. Local copy wiped.")
	to_chat(transfer, "You have been uploaded to a stationary terminal. Remote device connection restored.")

	if(card)
		card.clear()

	qdel(src)

/obj/structure/AIcore/deactivated/proc/check_malf(var/mob/living/silicon/ai/ai)
	if(!ai) return
	for (var/datum/mind/malfai in malf.current_antagonists)
		if (ai.mind == malfai)
			return 1

/obj/structure/AIcore/deactivated/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/aicard))
		var/obj/item/aicard/card = attacking_item
		var/mob/living/silicon/ai/transfer = locate() in card
		if(transfer)
			load_ai(transfer,card,user)
		else
			to_chat(user, "<span class='danger'>ERROR:</span> Unable to locate artificial intelligence.")
		return TRUE
	else if(attacking_item.iswrench())
		if(anchored)
			user.visible_message("<span class='notice'>\The [user] starts to unbolt \the [src] from the plating...</span>")
			if(!attacking_item.use_tool(src, user, 40, volume = 50))
				user.visible_message("<span class='notice'>\The [user] decides not to unbolt \the [src].</span>")
				return TRUE
			user.visible_message("<span class='notice'>\The [user] finishes unfastening \the [src]!</span>")
			anchored = 0
		else
			user.visible_message("<span class='notice'>\The [user] starts to bolt \the [src] to the plating...</span>")
			if(!attacking_item.use_tool(src, user, 40, volume = 50))
				user.visible_message("<span class='notice'>\The [user] decides not to bolt \the [src].</span>")
				return TRUE
			user.visible_message("<span class='notice'>\The [user] finishes fastening down \the [src]!</span>")
			anchored = 1
		return TRUE
	return ..()

/client/proc/empty_ai_core_toggle_latejoin()
	set name = "Toggle AI Core Latejoin"
	set category = "Admin"

	var/list/cores = list()
	for(var/obj/structure/AIcore/deactivated/D in world)
		cores["[D] ([D.loc.loc])"] = D

	var/id = input("Which core?", "Toggle AI Core Latejoin", null) as null|anything in cores
	if(!id) return

	var/obj/structure/AIcore/deactivated/D = cores[id]
	if(!D) return

	if(D in GLOB.empty_playable_ai_cores)
		GLOB.empty_playable_ai_cores -= D
		to_chat(src, "\The [id] is now <font color=\"#ff0000\">not available</font> for latejoining AIs.")
	else
		GLOB.empty_playable_ai_cores += D
		to_chat(src, "\The [id] is now <font color=\"#008000\">available</font> for latejoining AIs.")
