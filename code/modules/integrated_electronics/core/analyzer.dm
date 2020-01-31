/obj/item/device/integrated_electronics/analyzer
	name = "circuit analyzer"
	desc = "This tool can scan an assembly and generate code necessary to recreate it in a circuit printer."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "analyzer"
	flags = CONDUCT
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 20)

/obj/item/device/integrated_electronics/analyzer/afterattack(var/atom/A, var/mob/living/user)
	. = ..()
	if(istype(A, /obj/item/device/electronic_assembly) || istype(A, /obj/item/clothing) || istype(A, /obj/item/implant/integrated_circuit))
		if(istype(A, /obj/item/clothing))
			var/obj/item/clothing/cloth = A
			A = cloth.IC
		else if (istype(A, /obj/item/implant/integrated_circuit))
			var/obj/item/implant/integrated_circuit/implant = A
			A = implant.IC
		var/saved = "[A.name] analyzed! On circuit printers with cloning enabled, you may use the code below to clone the circuit:<br><br><code>[SSelectronics.save_electronic_assembly(A)]</code>"
		if(saved)
			to_chat(user, "<span class='notice'>You scan \the [A].</span>")
			show_browser(user, saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
		else
			to_chat(user, "<span class='warning'>\the [A] is not complete enough to be encoded!</span>")
