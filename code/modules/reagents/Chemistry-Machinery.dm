// Update asset_cache.dm if you change these.
#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4") //list of available bottle sprites


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	layer = 2.9
	clicksound = "button"
	
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

/obj/machinery/chem_master/attackby(var/obj/item/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/reagent_containers/glass))

		if(src.beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return
		src.beaker = B
		user.drop_from_inventory(B,src)
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(B, /obj/item/storage/pill_bottle))

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
			loaded_pill_bottle.forceMove(src.loc)
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
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					var/A = G.name
					var/B = G.data["blood_type"]
					var/C = G.data["blood_DNA"]
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[A]<BR><BR>Description:<BR>Blood Type: [B]<br>DNA: [C]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if (href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				R.trans_id_to(src, id, amount)

		else if (href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if (href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)


		else if (href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = Clamp(useramount, 0, 200)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
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

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill] units)"), MAX_NAME_LEN)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count-- && count >= 0)
				var/obj/item/reagent_containers/pill/P = new/obj/item/reagent_containers/pill(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to_obj(P,amount_per_pill)
				if(src.loaded_pill_bottle)
					loaded_pill_bottle.insert_into_storage(P)

		else if (href_list["createbottle"])
			if(!condi)
				var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()), MAX_NAME_LEN)
				var/obj/item/reagent_containers/glass/bottle/P = new/obj/item/reagent_containers/glass/bottle(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = bottlesprite
				reagents.trans_to_obj(P,60)
				P.update_icon()
			else
				var/obj/item/reagent_containers/food/condiment/P = new/obj/item/reagent_containers/food/condiment(src.loc)
				reagents.trans_to_obj(P,50)
		else if(href_list["change_pill"])
			var/dat = "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/sprite in BOTTLE_SPRITES)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[sprite]\"><img src=\"[sprite].png\" /></a></td></tr>"
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
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)

	var/datum/asset/pill_icons = get_asset_datum(/datum/asset/chem_master)
	pill_icons.send(user.client)

	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "[G.name] , [G.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=[G.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];addcustom=[G.id]'>(Custom)</A><BR>"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name] , [N.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=[N.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];removecustom=[N.id]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
			dat += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"[bottlesprite].png\" /></A>"
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

/obj/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/circuitboard/pandemic
	//use_power = 1
	//idle_power_usage = 20		//defaults make more sense.
	var/temphtml = ""
	var/wait = null
	var/obj/item/reagent_containers/glass/beaker = null


/obj/machinery/computer/pandemic/set_broken()
	icon_state = (src.beaker?"mixer1_b":"mixer0_b")
	stat |= BROKEN


/obj/machinery/computer/pandemic/power_change()
	..()
	if(stat & BROKEN)
		icon_state = (src.beaker?"mixer1_b":"mixer0_b")

	else if(!(stat & NOPOWER))
		icon_state = (src.beaker?"mixer1":"mixer0")

	else
		spawn(rand(0, 15))
			src.icon_state = (src.beaker?"mixer1_nopower":"mixer0_nopower")


/obj/machinery/computer/pandemic/Topic(href, href_list)
	if(..())
		return 1
	if(!beaker) return

	if (href_list["create_vaccine"])
		if(!src.wait)
			var/obj/item/reagent_containers/glass/bottle/B = new/obj/item/reagent_containers/glass/bottle(src.loc)
			if(B)
				var/path = href_list["create_vaccine"]
				var/vaccine_type = text2path(path)
				var/datum/disease/D = null

				if(!vaccine_type)
					D = archive_diseases[path]
					vaccine_type = path
				else
					if(vaccine_type in diseases)
						D = new vaccine_type(0, null)

				if(D)
					B.name = "[D.name] vaccine bottle"
					B.reagents.add_reagent("vaccine",15,vaccine_type)
					wait = 1
					var/datum/reagents/R = beaker.reagents
					var/datum/reagent/blood/Blood = null
					for(var/datum/reagent/blood/L in R.reagent_list)
						if(L)
							Blood = L
							break
					var/list/res = Blood.data["resistances"]
					spawn(res.len*200)
						src.wait = null
		else
			src.temphtml = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["create_virus_culture"])
		if(!wait)
			var/obj/item/reagent_containers/glass/bottle/B = new/obj/item/reagent_containers/glass/bottle(src.loc)
			B.icon_state = "bottle-1"
			var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
			var/datum/disease/D = null
			if(!type)
				var/datum/disease/advance/A = archive_diseases[href_list["create_virus_culture"]]
				if(A)
					D = new A.type(0, A)
			else
				if(type in diseases) // Make sure this is a disease
					D = new type(0, null)
			var/list/data = list("viruses"=list(D))
			var/name = sanitizeSafe(input(usr,"Name:","Name the culture",D.name), MAX_NAME_LEN)
			if(!name || name == " ") name = D.name
			B.name = "[name] culture bottle"
			B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
			B.reagents.add_reagent("blood",20,data)
			B.update_icon()
			src.updateUsrDialog()
			wait = 1
			spawn(1000)
				src.wait = null
		else
			src.temphtml = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["empty_beaker"])
		beaker.reagents.clear_reagents()
		src.updateUsrDialog()
		return
	else if (href_list["eject"])
		beaker:loc = src.loc
		beaker = null
		icon_state = "mixer0"
		src.updateUsrDialog()
		return
	else if(href_list["clear"])
		src.temphtml = ""
		src.updateUsrDialog()
		return
	else if(href_list["name_disease"])
		var/new_name = sanitizeSafe(input(usr, "Name the Disease", "New Name", ""), MAX_NAME_LEN)
		if(stat & (NOPOWER|BROKEN)) return
		if(usr.stat || usr.restrained()) return
		if(!in_range(src, usr)) return
		var/id = href_list["name_disease"]
		if(archive_diseases[id])
			var/datum/disease/advance/A = archive_diseases[id]
			A.AssignName(new_name)
			for(var/datum/disease/advance/AD in SSdisease.processing)
				AD.Refresh()
		src.updateUsrDialog()


	else
		usr << browse(null, "window=pandemic")
		src.updateUsrDialog()
		return

	src.add_fingerprint(usr)
	return

/obj/machinery/computer/pandemic/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/pandemic/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	user.set_machine(src)
	var/dat = ""
	if(src.temphtml)
		dat = "[src.temphtml]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
	else if(!beaker)
		dat += "Please insert beaker.<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
	else
		var/datum/reagents/R = beaker.reagents
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		if(!R.total_volume||!R.reagent_list.len)
			dat += "The beaker is empty<BR>"
		else if(!Blood)
			dat += "No blood sample found in beaker"
		else if(!Blood.data)
			dat += "No blood data found in beaker."
		else
			dat += "<h3>Blood sample data:</h3>"
			dat += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
			dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"


			if(Blood.data["viruses"])
				var/list/vir = Blood.data["viruses"]
				if(vir.len)
					for(var/datum/disease/D in Blood.data["viruses"])
						if(!D.hidden[PANDEMIC])


							var/disease_creation = D.type
							if(istype(D, /datum/disease/advance))

								var/datum/disease/advance/A = D
								D = archive_diseases[A.GetDiseaseID()]
								disease_creation = A.GetDiseaseID()
								if(D.name == "Unknown")
									dat += "<b><a href='?src=\ref[src];name_disease=[A.GetDiseaseID()]'>Name Disease</a></b><BR>"

							if(!D)
								CRASH("We weren't able to get the advance disease from the archive.")

							dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[disease_creation]'>Create virus culture bottle</A>":"none"]<BR>"
							dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
							dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
							dat += "<b>Spread:</b> [(D.spread||"none")]<BR>"
							dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR><BR>"

							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/A = D
								dat += "<b>Symptoms:</b> "
								var/english_symptoms = list()
								for(var/datum/symptom/S in A.symptoms)
									english_symptoms += S.name
								dat += english_list(english_symptoms)


			dat += "<BR><b>Contains antibodies to:</b> "
			if(Blood.data["resistances"])
				var/list/res = Blood.data["resistances"]
				if(res.len)
					dat += "<ul>"
					for(var/type in Blood.data["resistances"])
						var/disease_name = "Unknown"

						if(!ispath(type))
							var/datum/disease/advance/A = archive_diseases[type]
							if(A)
								disease_name = A.name
						else
							var/datum/disease/D = new type(0, null)
							disease_name = D.name

						dat += "<li>[disease_name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((R.total_volume&&R.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

	user << browse("<TITLE>[src.name]</TITLE><BR>[dat]", "window=pandemic;size=575x400")
	onclose(user, "pandemic")
	return


/obj/machinery/computer/pandemic/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(stat & (NOPOWER|BROKEN)) return
		if(src.beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return

		src.beaker =  I
		user.drop_from_inventory(I,src)
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else
		..()
	return
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list( //have a number of reagents which is a factor of REAGENTS_PER_SHEET (default 20) unless you like decimals
		/obj/item/stack/material/iron = list("iron"),
		/obj/item/stack/material/uranium = list("uranium"),
		/obj/item/stack/material/phoron = list("phoron"),
		/obj/item/stack/material/gold = list("gold"),
		/obj/item/stack/material/silver = list("silver"),
		/obj/item/stack/material/platinum = list("platinum"),
		/obj/item/stack/material/mhydrogen = list("hydrazine"), // i guess
		/obj/item/stack/material/steel = list("iron", "carbon"),
		/obj/item/stack/material/plasteel = list("iron", "iron", "carbon", "carbon", "platinum"), //8 iron, 8 carbon, 4 platinum,
		/obj/item/stack/material/sandstone = list("silicon", "acetone"),
		/obj/item/stack/material/glass = list("silicate"),
		/obj/item/stack/material/glass/phoronglass = list("platinum", "silicate", "silicate", "silicate"), //5 platinum, 15 silicate,
		)

/obj/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/reagent_containers/glass/beaker/large(src)

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/reagent_containers/glass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/drinkingglass) || \
		istype(O,/obj/item/reagent_containers/food/drinks/shaker))
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

	do_hair_pull(user)

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
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
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
	user << browse("<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return 1

	switch(href_list["action"])
		if ("grind")
			grind()
		if("eject")
			eject()
		if ("detach")
			detach()
	src.updateUsrDialog()
	return 1

/obj/machinery/reagentgrinder/proc/detach()

	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.forceMove(src.loc)
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(src.loc)
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind()

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		src.updateUsrDialog()

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

/obj/machinery/reagentgrinder/MouseDrop_T(mob/living/carbon/human/target as mob, mob/user as mob)
	if (!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || istype(user, /mob/living/silicon/ai))
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
			target.apply_damage(30, BRUTE, BP_HEAD)
			target.apply_damage(25, PAIN)
			target.say("*scream")

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has fed [target.name]'s ([target.ckey]) hair into a [src].</font>")
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
			target.apply_damage(25, BRUTE, BP_HEAD)
			target.apply_damage(10, PAIN)
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
