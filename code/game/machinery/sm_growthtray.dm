/obj/machinery/supermatter_growth_tray
	name = "supermatter growth tray"
	icon = 'icons/obj/diona.dmi'
	icon_state = "smtray"
	anchored = FALSE
	density = TRUE
	var/radioactivity = 25

/obj/machinery/supermatter_growth_tray/Initialize()
	. = ..()
	if(radioactivity)
		START_PROCESSING(SSprocessing, src)

/obj/machinery/supermatter_growth_tray/process()
	SSradiation.radiate(src, radioactivity)
