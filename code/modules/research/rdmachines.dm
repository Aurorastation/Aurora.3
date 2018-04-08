//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/rnd
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/obj/machinery/computer/rdconsole/linked_console
	var/obj/item/loaded_item = null
	var/requires_console = 1
	var/disabled = 0

/obj/machinery/rnd/attack_hand(mob/user as mob)
	return

/obj/machinery/rnd/proc/getMaterialType(var/name)
	switch(name)
		if(DEFAULT_WALL_MATERIAL)
			return /obj/item/stack/material/steel
		if("glass")
			return /obj/item/stack/material/glass
		if("gold")
			return /obj/item/stack/material/gold
		if("silver")
			return /obj/item/stack/material/silver
		if("phoron")
			return /obj/item/stack/material/phoron
		if("uranium")
			return /obj/item/stack/material/uranium
		if("diamond")
			return /obj/item/stack/material/diamond
	return null

/obj/machinery/rnd/proc/getMaterialName(var/type)
	switch(type)
		if(/obj/item/stack/material/steel)
			return DEFAULT_WALL_MATERIAL
		if(/obj/item/stack/material/glass)
			return "glass"
		if(/obj/item/stack/material/gold)
			return "gold"
		if(/obj/item/stack/material/silver)
			return "silver"
		if(/obj/item/stack/material/phoron)
			return "phoron"
		if(/obj/item/stack/material/uranium)
			return "uranium"
		if(/obj/item/stack/material/diamond)
			return "diamond"

/obj/machinery/rnd/proc/pulse_radiation(var/amount = 20)
	for(var/mob/living/L in view(7, src))
		L.apply_effect(amount, IRRADIATE, blocked = L.getarmor(null, "rad"))

/obj/machinery/rnd/proc/Insert_Item(obj/item/I, mob/user)
	return

/obj/machinery/rnd/proc/is_insertion_ready(mob/user)
	if(panel_open)
		to_chat(user, "<span class='warning'>You can't load [src] while it's opened!</span>")
		return FALSE
	if(disabled)
		return FALSE
	if(requires_console && !linked_console)
		to_chat(user, "<span class='warning'>[src] must be linked to an R&D console first!</span>")
		return FALSE
	if(busy)
		to_chat(user, "<span class='warning'>[src] is busy right now.</span>")
		return FALSE
	if(stat & BROKEN)
		to_chat(user, "<span class='warning'>[src] is broken.</span>")
		return FALSE
	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>[src] has no power.</span>")
		return FALSE
	if(loaded_item)
		to_chat(user, "<span class='warning'>[src] is already loaded.</span>")
		return FALSE
	return TRUE