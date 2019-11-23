/obj/item/mecha_equipment/sleeper
	name = "\improper exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to mantain patients stabilized on their way to medical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 25
	var/obj/machinery/sleeper/mounted/sleeper = null

/obj/item/mecha_equipment/sleeper/Initialize()
	. = ..()
	sleeper = new /obj/machinery/sleeper/mounted(src)
	sleeper.forceMove(src)

/obj/item/mecha_equipment/sleeper/Destroy()
	sleeper.go_out() //If for any reason you weren't outside already.
	QDEL_NULL(sleeper)
	. = ..()

/obj/item/mecha_equipment/sleeper/uninstalled()
	. = ..()
	sleeper.go_out()

/obj/item/mecha_equipment/sleeper/attack_self(var/mob/user)
	. = ..()
	if(.)
		sleeper.ui_interact(user)

/obj/item/mecha_equipment/sleeper/attack()
	return

/obj/item/mecha_equipment/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mecha_equipment/sleeper/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(ishuman(target) && !sleeper.occupant)
			visible_message("<span class='notice'>\The [src] begins loading \the [target] into \the [src].</span>")
			sleeper.go_in(target, user)
		else
			to_chat(user, "<span class='warning'>You cannot load that in!</span>")

/obj/item/mecha_equipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "[sleeper.occupant]"

/obj/machinery/sleeper/mounted
	name = "\improper mounted sleeper"
	density = 0
	anchored = 0
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	interact_offline = TRUE

/obj/machinery/sleeper/mounted/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/ui_host()
	var/obj/item/mecha_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

/obj/machinery/sleeper/mounted/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unEquip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message("<span class='notice'>\The [user] removes \the [beaker] from \the [src].</span>", "<span class='notice'>You remove \the [beaker] from \the [src].</span>")
		beaker = I
		user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")

/obj/machinery/sleeper/mounted/go_out()

	if(!occupant)
		return

	occupant.forceMove(get_turf(src))
	occupant = null

	return