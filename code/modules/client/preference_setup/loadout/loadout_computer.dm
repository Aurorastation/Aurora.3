/datum/gear/computer
	display_name = "laptop computer"
	path = /obj/item/modular_computer/laptop/preset/loadout
	sort_category = "Modular Computers"
	cost = 2

/datum/gear/computer/handheld/tablet
	display_name = "tablet"
	path = /obj/item/modular_computer/handheld/preset

/datum/gear/computer/handheld/tablet/New()
	..()
	var/list/tablets = list()
	tablets["generic tablet"] = /obj/item/modular_computer/handheld/preset/generic
	tablets["janitor tablet"] = /obj/item/modular_computer/handheld/preset/civilian/janitor
	tablets["operations tablet"] = /obj/item/modular_computer/handheld/preset/supply
	tablets["engineering tablet"] = /obj/item/modular_computer/handheld/preset/engineering
	tablets["atmos tablet"] = /obj/item/modular_computer/handheld/preset/engineering/atmos
	tablets["medical tablet"] =/obj/item/modular_computer/handheld/preset/medical
	tablets["security tablet"] = /obj/item/modular_computer/handheld/preset/security
	tablets["investigation tablet"] = /obj/item/modular_computer/handheld/preset/security/detective
	tablets["research tablet"] = /obj/item/modular_computer/handheld/preset/research
	tablets["machinist tablet"] = /obj/item/modular_computer/handheld/preset/supply/machinist
	gear_tweaks += new /datum/gear_tweak/path(tablets)

/datum/gear/computer/handheld/wristbound/selection
	display_name = "wristbound computer selection"
	path = /obj/item/modular_computer/handheld/wristbound/preset

/datum/gear/computer/handheld/wristbound/selection/New()
	..()
	var/list/wristbounds = list()
	wristbounds["cheap generic wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/cheap/generic
	wristbounds["expensive generic wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/generic
	wristbounds["operations wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/cargo
	wristbounds["engineering wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/engineering
	wristbounds["medical wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/medical
	wristbounds["security wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security
	wristbounds["investigation wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/security/investigations
	wristbounds["research wristbound"] = /obj/item/modular_computer/handheld/wristbound/preset/advanced/research
	gear_tweaks += new /datum/gear_tweak/path(wristbounds)

/datum/gear/computer/handheld/wristbound/ce
	display_name = "wristbound computer (Chief Engineer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/computer/handheld/wristbound/rd
	display_name = "wristbound computer (Research Director)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/rd
	allowed_roles = list("Research Director")

/datum/gear/computer/handheld/wristbound/cmo
	display_name = "wristbound computer (Chief Medical Officer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/computer/handheld/wristbound/xo
	display_name = "wristbound computer (Executive Officer)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/xo
	allowed_roles = list("Executive Officer")

/datum/gear/computer/handheld/wristbound/hos
	display_name = "wristbound computer (Head of Security)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hos
	allowed_roles = list("Head of Security")

/datum/gear/computer/handheld/wristbound/captain
	display_name = "wristbound computer (Captain)"
	path = /obj/item/modular_computer/handheld/wristbound/preset/advanced/command/captain
	allowed_roles = list("Captain")
