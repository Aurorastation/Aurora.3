/// This is 2011 code. Treat warily.
/obj/structure/machinery/mineral/mint
	name = "coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"
	density = TRUE
	anchored = TRUE
	var/amt_silver = 0
	var/amt_gold = 0
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_phoron = 0
	var/amt_uranium = 0
	/// How many coins the machine made in its last load.
	var/newCoins = 0
	var/processing = 0
	/// Which material will be used to make coins.
	var/chosen = MATERIAL_STEEL
	var/coinsToProduce = 10

/obj/structure/machinery/mineral/mint/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	setup_io()

/obj/structure/machinery/mineral/mint/process()
	if(input_turf)
		var/obj/item/stack/material/O
		O = locate(/obj/item/stack/material, get_turf(input_turf))
		if(O)
			var/processed = TRUE
			var/singleton/material/stack_material = O.get_material()
			switch(stack_material?.type)
				if(MATERIAL_GOLD)
					amt_gold += 100 * O.get_amount()
				if(MATERIAL_SILVER)
					amt_silver += 100 * O.get_amount()
				if(MATERIAL_DIAMOND)
					amt_diamond += 100 * O.get_amount()
				if(MATERIAL_PHORON)
					amt_phoron += 100 * O.get_amount()
				if(MATERIAL_URANIUM)
					amt_uranium += 100 * O.get_amount()
				if(MATERIAL_STEEL)
					amt_iron += 100 * O.get_amount()
				else
					processed = FALSE
			if(processed)
				qdel(O)

/obj/structure/machinery/mineral/mint/attack_hand(user)
	var/dat = "<b>Coin Press</b><br>"

	if(!input_turf)
		dat += "input connection status: "
		dat += "<b><span class='warning'>NOT CONNECTED</span></b><br>"
	if(!output_turf)
		dat += "<br>output_turf connection status: "
		dat += "<b><span class='warning'>NOT CONNECTED</span></b><br>"

	dat += "<br><font color='#ffcc00'><b>Gold inserted: </b>[amt_gold]</font> "
	if(chosen == MATERIAL_GOLD)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=gold'>Choose</A>"
	dat += "<br><font color='#888888'><b>Silver inserted: </b>[amt_silver]</font> "
	if(chosen == MATERIAL_SILVER)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=silver'>Choose</A>"
	dat += "<br><font color='#555555'><b>Iron inserted: </b>[amt_iron]</font> "
	if(chosen == MATERIAL_STEEL)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=metal'>Choose</A>"
	dat += "<br><font color='#8888FF'><b>Diamond inserted: </b>[amt_diamond]</font> "
	if(chosen == MATERIAL_DIAMOND)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=diamond'>Choose</A>"
	dat += "<br><font color='#FF8800'><b>Phoron inserted: </b>[amt_phoron]</font> "
	if(chosen == MATERIAL_PHORON)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=phoron'>Choose</A>"
	dat += "<br><font color='#008800'><b>Uranium inserted: </b>[amt_uranium]</font> "
	if(chosen == MATERIAL_URANIUM)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=[REF(src)];choose=uranium'>Choose</A>"

	dat += "<br><br>Will produce [coinsToProduce] [lowertext(SSmaterials.material_display_name(chosen))] coins if enough materials are available.<br>"
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=-10'>-10</A> "
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=-5'>-5</A> "
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=-1'>-1</A> "
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=1'>+1</A> "
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=5'>+5</A> "
	dat += "<A href='byond://?src=[REF(src)];chooseAmt=10'>+10</A> "

	dat += "<br><br>In total this machine produced <font color='green'><b>[newCoins]</b></font> coins."
	dat += "<br><A href='byond://?src=[REF(src)];makeCoins=[1]'>Make coins</A>"
	user << browse(HTML_SKELETON(dat), "window=mint")

/obj/structure/machinery/mineral/mint/Topic(href, href_list)
	if(..())
		return TRUE
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(processing)
		to_chat(usr, SPAN_WARNING("The machine is busy processing."))
		return
	if(href_list["choose"])
		switch(href_list["choose"])
			if("gold")
				chosen = MATERIAL_GOLD
			if("silver")
				chosen = MATERIAL_SILVER
			if("steel")
				chosen = MATERIAL_STEEL
			if("diamond")
				chosen = MATERIAL_DIAMOND
			if("phoron")
				chosen = MATERIAL_PHORON
			if("uranium")
				chosen = MATERIAL_URANIUM
	if(href_list["chooseAmt"])
		coinsToProduce = between(0, coinsToProduce + text2num(href_list["chooseAmt"]), 1000)
	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		if(output_turf)
			processing = TRUE
			icon_state = "coinpress1"
			var/obj/item/storage/bag/money/M
			switch(chosen)
				if(MATERIAL_STEEL)
					while(amt_iron && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new/obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/iron(M)
						amt_iron -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if(MATERIAL_GOLD)
					while(amt_gold && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new/obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/gold(M)
						amt_gold -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if(MATERIAL_SILVER)
					while(amt_silver && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new/obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/silver(M)
						amt_silver -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if(MATERIAL_DIAMOND)
					while(amt_diamond && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new/obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/diamond(M)
						amt_diamond -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if(MATERIAL_PHORON)
					while(amt_phoron && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new/obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/phoron(M)
						amt_phoron -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
				if(MATERIAL_URANIUM)
					while(amt_uranium && coinsToProduce)
						if(locate(/obj/item/storage/bag/money, get_turf(output_turf)))
							M = locate(/obj/item/storage/bag/money, get_turf(output_turf))
						else
							M = new /obj/item/storage/bag/money(get_turf(output_turf))
						new /obj/item/coin/uranium(M)
						amt_uranium -= 20
						coinsToProduce--
						newCoins++
						src.updateUsrDialog()
						sleep(5)
			icon_state = "coinpress0"
			processing = FALSE
			coinsToProduce = temp_coins
	src.updateUsrDialog()
	return
