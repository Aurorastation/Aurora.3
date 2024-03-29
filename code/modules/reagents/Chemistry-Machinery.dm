// Update asset_cache.dm if you change these.
#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4") //list of available bottle sprites

#define CHEMMASTER_BOTTLE_SOUND playsound(src, 'sound/items/pickup/bottle.ogg', 75, 1)
#define CHEMMASTER_DISPENSE_SOUND playsound(src, 'sound/machines/reagent_dispense.ogg', 75, 1)
#define CHEMMASTER_CHANGESETTINGS_SOUND playsound(src, 'sound/machines/slide_change.ogg', 75, 1)
#define CHEMMASTER_SWITCH_SOUND playsound(src, 'sound/machines/switch1.ogg', 75, 1)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = POWER_USE_IDLE
	idle_power_usage = 20
	layer = 2.9
	clicksound = /singleton/sound_category/button_sound

	var/obj/item/reagent_containers/glass/beaker = null
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = TRUE
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle-1" //yes, strings
	var/pillsprite = "pill1"
	var/max_pill_count = 20
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/datum/asset/spritesheet/chem_master/chem_asset
	var/list/forbidden_containers = list(/obj/item/reagent_containers/glass/bucket) //For containers we don't want people to shove into the chem machine. Like big-ass buckets.
	var/datum/tgui/ui = null
	var/list/analysis = list()

/obj/machinery/chem_master/Initialize()
	. = ..()
	create_reagents(300)

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/proc/eject()
	if(beaker && usr)
		if(!use_check_and_message(usr))
			usr.put_in_hands(beaker, TRUE)
		else
			beaker.loc = get_turf(src)
		beaker = null
		reagents.clear_reagents()
		icon_state = "mixer0"
		return TRUE

/obj/machinery/chem_master/AltClick()
	if(!use_check_and_message(usr))
		eject()

/obj/machinery/chem_master/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/reagent_containers/glass))

		if(src.beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		if(is_type_in_list(attacking_item, forbidden_containers))
			to_chat(user, SPAN_WARNING("There's no way to fit [attacking_item] into \the [src]!"))
			return
		src.beaker = attacking_item
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"
		CHEMMASTER_BOTTLE_SOUND

	else if(istype(attacking_item, /obj/item/storage/pill_bottle))
		if(condi)
			return
		if(src.loaded_pill_bottle)
			to_chat(user, "A pill bottle is already loaded into the machine.")
			return

		src.loaded_pill_bottle = attacking_item
		user.drop_from_inventory(attacking_item, src)
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()
	else if(attacking_item.iswrench())
		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] the [src] [anchored ? "to" : "from"] the ground")
		attacking_item.play_tool_sound(get_turf(src), 75)

	if(ui?.user)
		ui = SStgui.try_update_ui(user, src, ui)


/obj/machinery/chem_master/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster")
		ui.open()

/obj/machinery/chem_master/ui_data(mob/user)
	var/list/data = list()

	var/list/reagents_in_internal_storage = list()
	var/list/reagents_in_beaker = list()

	data["mode"] = src.mode
	data["loaded_beaker"] = !isnull(src.beaker)
	data["loaded_pill_bottle"] = !isnull(src.loaded_pill_bottle)
	data["current_bottle_icon"] = bottlesprite
	data["current_pill_icon"] = pillsprite
	data["analysis"] = analysis


	// Process the beaker
	if(beaker)
		var/datum/reagents/beaker_reagents = beaker:reagents
		for(var/reagent in beaker_reagents.reagent_volumes)

			var/singleton/reagent/reagent_singleton = GET_SINGLETON(reagent)
			reagents_in_beaker += list(list("name" = reagent_singleton.name, "volume" = REAGENT_VOLUME(beaker_reagents, reagent), "typepath" = reagent_singleton.type))

	data["reagents_in_beaker"] = reagents_in_beaker

	//Process the machine content
	for(var/reagent in src.reagents.reagent_volumes)
		var/singleton/reagent/reagent_singleton = GET_SINGLETON(reagent)
		reagents_in_internal_storage += list(list("name" = reagent_singleton.name, "volume" = REAGENT_VOLUME(reagents, reagent), "typepath" = reagent_singleton.type))
	data["reagents_in_internal_storage"] = reagents_in_internal_storage


	return data

/obj/machinery/chem_master/LateInitialize()
	if(!chem_asset)
		chem_asset = get_asset_datum(/datum/asset/spritesheet/chem_master)

/obj/machinery/chem_master/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/chem_master)
	)

/obj/machinery/chem_master/ui_static_data(mob/user)
	. = ..()
	var/list/data = list()

	var/list/bottle_icons = list()
	var/list/pill_icons = list()

	if(!chem_asset)
		chem_asset = get_asset_datum(/datum/asset/spritesheet/chem_master)

	for(var/sprite in BOTTLE_SPRITES)
		bottle_icons += chem_asset.icon_tag(sprite, FALSE)

	for(var/i = 1 to MAX_PILL_SPRITE)
		var/pillicon = "pill[i]"
		pill_icons += chem_asset.icon_tag(pillicon, FALSE)

	data["bottle_icons"] = bottle_icons
	data["pill_icons"] = pill_icons
	data["machine_name"] = name
	data["is_condimaster"] = condi


	return data


/obj/machinery/chem_master/ui_act(action, params)
	. = ..()

	if(.)
		return

	playsound(src, 'sound/machines/button3.ogg', 75, 1) //Buttons clicky

	if(action == "ejectp")
		if(loaded_pill_bottle)
			if(Adjacent(usr))
				usr.put_in_hands(loaded_pill_bottle)
			else
				loaded_pill_bottle.forceMove(get_turf(src))
			loaded_pill_bottle = null
		return TRUE

	else if(action == "close")
		ui.ui_close()
		return TRUE

	// These actions makes sense only if there's a beaker in
	if(beaker)
		if(action == "analyze")
			var/datum/reagents/R = beaker:reagents
			if(!condi)
				if(params["name"] == "Blood")
					var/singleton/reagent/blood/G = GET_SINGLETON(/singleton/reagent/blood)
					var/Gdata = REAGENT_DATA(R, /singleton/reagent/blood)
					analysis["name"] = G.name
					analysis["type"] = Gdata["blood_type"]
					analysis["DNA"] = Gdata["blood_DNA"]
				else if(params["name"] == "Close")
					analysis = list()
			CHEMMASTER_SWITCH_SOUND
			return TRUE

		else if(action == "add")
			if(params["amount"])
				var/rtype = text2path(params["add"])
				var/amount = Clamp((text2num(params["amount"])), 0, 200)
				beaker.reagents.trans_type_to(src, rtype, amount)
			return TRUE

		else if (action == "remove")
			if(params["amount"])
				var/rtype = text2path(params["remove"])
				var/amount = Clamp((text2num(params["amount"])), 0, 200)
				if(mode)
					reagents.trans_type_to(beaker, rtype, amount)
				else
					reagents.remove_reagent(rtype, amount)
			return TRUE

		else if (action == "eject")
			if(eject())
				return TRUE

	if (action == "toggle")
		mode = !mode
		CHEMMASTER_CHANGESETTINGS_SOUND
		return TRUE

	else if(action == "createbottle")
		if(!condi)
			var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_primary_reagent_name()), MAX_NAME_LEN)
			var/obj/item/reagent_containers/glass/bottle/P = new/obj/item/reagent_containers/glass/bottle(get_turf(src))
			if(!name) name = reagents.get_primary_reagent_name()
			P.name = "[name] bottle"
			P.pixel_x = rand(-7, 7) //random position
			P.pixel_y = rand(-7, 7)
			P.icon_state = bottlesprite
			reagents.trans_to_obj(P,60)
			P.update_icon()
		else
			var/obj/item/reagent_containers/food/condiment/P = new/obj/item/reagent_containers/food/condiment(get_turf(src))
			reagents.trans_to_obj(P,50)
		CHEMMASTER_BOTTLE_SOUND
		return TRUE

	else if (action == "createpill" || action == "createpill_multiple")
		var/count = 1

		if(reagents.total_volume/count < 1) //Sanity checking.
			return TRUE

		if (action == "createpill_multiple")
			count = tgui_input_number(usr, "Select the number of pills to make.", src.name, pillamount, max_pill_count, 1)
			count = Clamp(count, 1, max_pill_count)

		if(reagents.total_volume/count < 1) //Sanity checking.
			return TRUE

		var/amount_per_pill = reagents.total_volume/count
		if (amount_per_pill > 60) amount_per_pill = 60

		var/name = tgui_input_text(usr, "Name your pill.", src.name, "[reagents.get_primary_reagent_name()] ([amount_per_pill] units)", MAX_NAME_LEN)

		if(reagents.total_volume/count < 1) //Sanity checking.
			return TRUE
		while (count-- && count >= 0)
			var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(get_turf(src))
			if(!name) name = reagents.get_primary_reagent_name()
			P.name = "[name] pill"
			P.pixel_x = rand(-7, 7) //random position
			P.pixel_y = rand(-7, 7)
			P.icon_state = pillsprite
			reagents.trans_to_obj(P,amount_per_pill)
			if(src.loaded_pill_bottle)
				loaded_pill_bottle.insert_into_storage(P)
		CHEMMASTER_DISPENSE_SOUND
		return TRUE

	else if(action == "pill_sprite")
		pillsprite = sanitizeSafe(params["pill_sprite"])
		CHEMMASTER_CHANGESETTINGS_SOUND
		return TRUE

	else if(action == "bottle_sprite")
		bottlesprite = sanitizeSafe(params["bottle_sprite"])
		CHEMMASTER_CHANGESETTINGS_SOUND
		return TRUE
	return TRUE



/obj/machinery/chem_master/Topic(href, href_list)
	if(..())
		return 1
	return

/obj/machinery/chem_master/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/machinery/cooking_machines.dmi'
	icon_state = "juicer1"
	layer = 2.99
	density = 0
	anchored = 0
	use_power = POWER_USE_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list( //have a number of reagents which is a factor of REAGENTS_PER_SHEET (default 20) unless you like decimals
		/obj/item/stack/material/iron = list(/singleton/reagent/iron),
		/obj/item/stack/material/uranium = list(/singleton/reagent/uranium),
		/obj/item/stack/material/phoron = list(/singleton/reagent/toxin/phoron),
		/obj/item/stack/material/gold = list(/singleton/reagent/gold),
		/obj/item/stack/material/silver = list(/singleton/reagent/silver),
		/obj/item/stack/material/platinum = list(/singleton/reagent/platinum),
		/obj/item/stack/material/mhydrogen = list(/singleton/reagent/hydrazine), // i guess
		/obj/item/stack/material/steel = list(/singleton/reagent/iron, /singleton/reagent/carbon),
		/obj/item/stack/material/plasteel = list(/singleton/reagent/iron, /singleton/reagent/iron, /singleton/reagent/carbon, /singleton/reagent/carbon, /singleton/reagent/platinum), //8 iron, 8 carbon, 4 platinum,
		/obj/item/stack/material/sandstone = list(/singleton/reagent/silicon, /singleton/reagent/acetone),
		/obj/item/stack/material/glass = list(/singleton/reagent/silicate),
		/obj/item/stack/material/glass/phoronglass = list(/singleton/reagent/platinum, /singleton/reagent/silicate, /singleton/reagent/silicate, /singleton/reagent/silicate), //5 platinum, 15 silicate,
		)
	var/list/beaker_types = list( // also can't be ground
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/food/drinks/drinkingglass,
		/obj/item/reagent_containers/food/drinks/shaker,
		/obj/item/reagent_containers/cooking_container
	)

/obj/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/reagent_containers/glass/beaker/large(src)

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(obj/item/attacking_item, mob/user)
	if (is_type_in_list(attacking_item, beaker_types))
		if (beaker)
			return 1
		else
			src.beaker =  attacking_item
			user.drop_from_inventory(attacking_item,src)
			update_icon()
			src.updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(usr, "The machine cannot hold anymore items.")
		return 1

	if(!istype(attacking_item))
		return

	if(istype(attacking_item,/obj/item/storage/bag/plants) || istype(attacking_item,/obj/item/storage/pill_bottle))
		var/failed = 1
		var/obj/item/storage/P = attacking_item
		for(var/obj/item/G in P.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			P.remove_from_storage(G,src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!attacking_item.contents.len)
			to_chat(user, "You empty \the [attacking_item] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [attacking_item].")

		src.updateUsrDialog()
		return 0

	if(!sheet_reagents[attacking_item.type] && (!attacking_item.reagents || !attacking_item.reagents.total_volume))
		to_chat(user, "\The [attacking_item] is not suitable for blending.")
		return 0

	user.remove_from_mob(attacking_item)
	attacking_item.forceMove(src)
	holdingitems += attacking_item
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	interact(user)

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
	if(inoperable())
		return
	user.set_machine(src)
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			if(!LAZYLEN(beaker.reagents.reagent_volumes))
				beaker_contents += "Nothing<br>"
			else
				for(var/_R in beaker.reagents.reagent_volumes)
					var/singleton/reagent/R = GET_SINGLETON(_R)
					beaker_contents += "[beaker.reagents.reagent_volumes[_R]] - [R.name]<br>"

		dat = {"
	<b>Processing Chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."

	var/datum/browser/grindr_win = new(user, "reagentgrinder", capitalize_first_letters(name))
	grindr_win.set_content(dat)
	grindr_win.open()

/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return 1

	switch(href_list["action"])
		if ("grind")
			grind(usr)
		if("eject")
			eject()
		if ("detach")
			detach(usr)
	src.updateUsrDialog()
	return 1

/obj/machinery/reagentgrinder/proc/detach(var/mob/user)
	if(!beaker)
		return

	if(use_check_and_message(user))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.put_in_active_hand(beaker))
			beaker.forceMove(get_turf(src))
	else
		beaker.forceMove(get_turf(src))
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(get_turf(src))
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind(mob/user)

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	if(ishuman(user))
		do_hair_pull(user)

	playsound(get_turf(src), 'sound/machines/blender.ogg', 50, 1)
	intent_message(MACHINE_SOUND)
	inuse = TRUE

	// Reset the machine.
	addtimer(CALLBACK(src, PROC_REF(grind_reset)), 60)

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/list/sheet_components = sheet_reagents[stack.type]
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					if(islist(sheet_components))
						amount_to_take = (amount_to_take/(sheet_components.len))
						for(var/i in sheet_components)
							beaker.reagents.add_reagent(i, (amount_to_take*REAGENTS_PER_SHEET))
					else
						beaker.reagents.add_reagent(sheet_components, (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

/obj/machinery/reagentgrinder/proc/grind_reset()
	inuse = FALSE
	updateUsrDialog()


/obj/machinery/reagentgrinder/MouseDrop_T(atom/dropping, mob/user)
	var/mob/living/carbon/human/target = dropping
	if (!istype(target) || target.buckled_to || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
		return
	if(target == user)
		if(target.h_style == "Floorlength Braid" || target.h_style == "Very Long Hair")
			user.visible_message("<span class='notice'>[user] looks like they're about to feed their own hair into the [src], but think better of it.</span>", "<span class='notice'>You grasp your hair and are about to feed it into the [src], but stop and come to your sense.</span>")
			return
	src.add_fingerprint(user)
	var/target_loc = target.loc
	if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		if(target.h_style != "Cut Hair" || target.h_style != "Short Hair" || target.h_style != "Skinhead" || target.h_style != "Buzzcut" || target.h_style != "Crewcut" || target.h_style != "Bald" || target.h_style != "Balding Hair")
			user.visible_message("<span class='warning'>[user] starts feeding [target]'s hair into the [src]!</span>", "<span class='warning'>You start feeding [target]'s hair into the [src]!</span>")
		if(!do_after(usr, 50))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message("<span class='warning'>[user] feeds the [target]'s hair into the [src] and flicks it on!</span>", "<span class='warning'>You turn the [src] on!</span>")
			target.apply_damage(30, DAMAGE_BRUTE, BP_HEAD)
			target.apply_damage(25, DAMAGE_PAIN)
			target.say("*scream")

			user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Has fed [target.name]'s ([target.ckey]) hair into a [src].</span>")
			target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their hair fed into [src] by [user.name] ([user.ckey])</font>")
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(target)] in a [src]. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))
		else
			return
		if(!do_after(usr, 35))
			return
		if(target_loc != target.loc)
			return
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			user.visible_message("<span class='warning'>[user] starts tugging on [target]'s head as the [src] keeps running!</span>", "<span class='warning'>You start tugging on [target]'s head!</span>")
			target.apply_damage(25, DAMAGE_BRUTE, BP_HEAD)
			target.apply_damage(10, DAMAGE_PAIN)
			target.say("*scream")
			spawn(10)
			user.visible_message("<span class='warning'>[user] stops the [src] and leaves [target] resting as they are.</span>", "<span class='warning'>You turn the [src] off and let go of [target].</span>")

/obj/machinery/reagentgrinder/verb/Eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject contents"

	if(use_check_and_message(usr))
		return
	usr.visible_message(
	"<span class='notice'>[usr] opens [src] and has removed [english_list(holdingitems)].</span>"
		)

	eject()
	detach()

#undef CHEMMASTER_DISPENSE_SOUND
#undef CHEMMASTER_CHANGESETTINGS_SOUND
#undef CHEMMASTER_SWITCH_SOUND
#undef CHEMMASTER_BOTTLE_SOUND
