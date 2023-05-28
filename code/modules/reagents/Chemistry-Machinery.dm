// Update asset_cache.dm if you change these.
#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4", "bottle-5", "bottle-6") //list of available bottle sprites


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

	var/beaker = null
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = TRUE
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle-1" //yes, strings
	var/pillsprite = "1"
	var/max_pill_count = 20
	flags = OPENCONTAINER
	var/datum/asset/spritesheet/chem_master/chem_asset
	var/list/forbidden_containers = list(/obj/item/reagent_containers/glass/bucket) //For containers we don't want people to shove into the chem machine. Like big-ass buckets.

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

/obj/machinery/chem_master/attackby(var/obj/item/B, mob/user)

	if(istype(B, /obj/item/reagent_containers/glass))

		if(src.beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		if(is_type_in_list(B, forbidden_containers))
			to_chat(user, SPAN_WARNING("There's no way to fit [B] into \the [src]!"))
			return
		src.beaker = B
		user.drop_from_inventory(B,src)
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(B, /obj/item/storage/pill_bottle))
		if(condi)
			return
		if(src.loaded_pill_bottle)
			to_chat(user, "A pill bottle is already loaded into the machine.")
			return

		src.loaded_pill_bottle = B
		user.drop_from_inventory(B,src)
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()
	else if(B.iswrench())
		anchored = !anchored
		to_chat(user, "You [anchored ? "attach" : "detach"] the [src] [anchored ? "to" : "from"] the ground")
		playsound(src.loc, B.usesound, 75, 1)


/obj/machinery/chem_master/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			if(Adjacent(usr))
				usr.put_in_hands(loaded_pill_bottle)
			else
				loaded_pill_bottle.forceMove(get_turf(src))
			loaded_pill_bottle = null
	else if(href_list["close"])
		usr << browse(null, "window=chemmaster")
		usr.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if (href_list["analyze"])
			var/dat = ""
			if(!condi)
				if(href_list["name"] == "Blood")
					var/singleton/reagent/blood/G = GET_SINGLETON(/singleton/reagent/blood)
					var/Gdata = REAGENT_DATA(R, /singleton/reagent/blood)
					var/A = G.name
					var/B = Gdata["blood_type"]
					var/C = Gdata["blood_DNA"]
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[A]<BR><BR>Description:<BR>Blood Type: [B]<br>DNA: [C]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if (href_list["add"])

			if(href_list["amount"])
				var/rtype = text2path(href_list["add"])
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				R.trans_type_to(src, rtype, amount)

		else if (href_list["addcustom"])

			var/rtype = text2path(href_list["addcustom"])
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[rtype]"))

		else if (href_list["remove"])

			if(href_list["amount"])
				var/rtype = text2path(href_list["remove"])
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				if(mode)
					reagents.trans_type_to(beaker, rtype, amount)
				else
					reagents.remove_reagent(rtype, amount)


		else if (href_list["removecustom"])

			var/rtype = text2path(href_list["removecustom"])
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[rtype]"))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			if(beaker)
				if(Adjacent(usr))
					usr.put_in_hands(beaker)
				else
					beaker:loc = get_turf(src)
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
				count = input("Select the number of pills to make.", "Max [max_pill_count]", pillamount) as num
				count = Clamp(count, 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if (amount_per_pill > 60) amount_per_pill = 60

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_primary_reagent_name()] ([amount_per_pill] units)"), MAX_NAME_LEN)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count-- && count >= 0)
				var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(get_turf(src))
				if(!name) name = reagents.get_primary_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to_obj(P,amount_per_pill)
				if(src.loaded_pill_bottle)
					loaded_pill_bottle.insert_into_storage(P)

		else if (href_list["createbottle"])
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
		else if(href_list["change_pill"])
			if(!chem_asset)
				chem_asset = get_asset_datum(/datum/asset/spritesheet/chem_master)
			var/dat = chem_asset.css_tag()
			dat += "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				var/pillicon = "pill[i]"
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\">[chem_asset.icon_tag(pillicon)]</a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["change_bottle"])
			if(!chem_asset)
				chem_asset = get_asset_datum(/datum/asset/spritesheet/chem_master)
			var/dat = chem_asset.css_tag()
			dat += "<table>"
			for(var/sprite in BOTTLE_SPRITES)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[sprite]\">[chem_asset.icon_tag(sprite)]</a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	src.updateUsrDialog()
	return

/obj/machinery/chem_master/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)

	if(!chem_asset)
		chem_asset = get_asset_datum(/datum/asset/spritesheet/chem_master)
	var/dat = chem_asset.css_tag()
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else if(!condi)
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else if(!condi)
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/_G in R.reagent_volumes)
				var/singleton/reagent/G = GET_SINGLETON(_G)
				dat += "[G.name] , [REAGENT_VOLUME(R, _G)] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=30'>(30)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=60'>(60)</A> "
				dat += "<A href='?src=\ref[src];add=[_G];amount=[REAGENT_VOLUME(R, _G)]'>(All)</A> "
				dat += "<A href='?src=\ref[src];addcustom=[_G]'>(Custom)</A><BR>"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/_N in reagents.reagent_volumes)
				var/singleton/reagent/N = GET_SINGLETON(_N)
				dat += "[N.name] , [REAGENT_VOLUME(reagents, _N)] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=30'>(30)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=60'>(60)</A> "
				dat += "<A href='?src=\ref[src];remove=[_N];amount=[REAGENT_VOLUME(reagents, _N)]'>(All)</A> "
				dat += "<A href='?src=\ref[src];removecustom=[_N]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\">[chem_asset.icon_tag("pill[pillsprite]")]</a><BR>"
			dat += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\">[chem_asset.icon_tag(bottlesprite)]</A>"
		else
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
	if(!condi)
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	else
		user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	onclose(user, "chem_master")
	return

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
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

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (is_type_in_list(O, beaker_types))
		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_from_inventory(O,src)
			update_icon()
			src.updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(usr, "The machine cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/storage/bag/plants) || istype(O,/obj/item/storage/pill_bottle))
		var/failed = 1
		var/obj/item/storage/P = O
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

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return 0

	user.remove_from_mob(O)
	O.forceMove(src)
	holdingitems += O
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


/obj/machinery/reagentgrinder/MouseDrop_T(mob/living/carbon/human/target as mob, mob/user as mob)
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
