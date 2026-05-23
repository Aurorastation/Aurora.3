/obj/structure/machinery/supermatter_growth_tray
	name = "supermatter growth tray"
	icon = 'icons/obj/diona.dmi'
	icon_state = "smtray"
	anchored = FALSE
	density = TRUE
	var/radioactivity = RAD_LEVEL_MODERATE

/obj/structure/machinery/supermatter_growth_tray/Initialize()
	. = ..()
	if(radioactivity)
		START_PROCESSING(SSprocessing, src)

/obj/structure/machinery/supermatter_growth_tray/process()
	SSradiation.radiate(src, radioactivity)
