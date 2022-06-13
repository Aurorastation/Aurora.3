/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"
	var/runtime = 30
	var/expended = FALSE
	var/mob/living/carbon/human/affected

/obj/item/overloader/attack(mob/living/carbon/human/M, mob/user, def_zone)
	if(!istype(M))
		return
	
	var/obj/item/organ/internal/dataport/D = M.internal_organs_by_name[BP_DATAPORT]

	if (D && M.isSynthetic())
		if (length(D.contents))
			to_chat(user, SPAN_WARNING("[M]'s dataport already has something in it!"))
			return

		user.visible_message(SPAN_WARNING("[user] slots \the [src.name] into [M]'s dataport."))
		user.drop_from_inventory(src, D)
		install(M)
		D.installed = src

/obj/item/overloader/proc/install(mob/living/carbon/human/M)
	affected = M

/obj/item/overloader/proc/do_overloader_effects(mob/living/carbon/human/M)
	if (runtime > 0 || expended)
		return
	expend()
	
/obj/item/overloader/proc/expend()
	expended = TRUE

/obj/item/overloader/proc/on_eject()
	return

/obj/item/overloader/seizure
	name = "seizure overloader"
	desc = "An IPC overloader. This one appears to cause seizures, since it's a placeholder overloader for testing purposes."
	runtime = 1

/obj/item/overloader/seizure/do_overloader_effects(mob/living/carbon/human/M)
	if (runtime > 0)
		M.seizure()
	..()

/obj/item/overloader/redline
	name = "Redline overloader"
	desc = "An IPC overloader. This one is programmed with an instance of Redline."
	desc_fluff = "Redline is a dangerous overclocking whatever blah blah blah Konyang."
	var/initial_heat
	var/initial_speed
	var/overheat = 100
	var/speedup = 0.5

/obj/item/overloader/redline/install(mob/living/carbon/human/M)
	..()
	initial_heat = affected.passive_temp_gain
	initial_speed = affected.slowdown

/obj/item/overloader/redline/do_overloader_effects(mob/living/carbon/human/M)
	if (runtime > 0)
		M.passive_temp_gain = overheat
		M.slowdown -= speedup
	..()

/obj/item/overloader/redline/expend()
	..()
	affected.slowdown = initial_speed
	affected.passive_temp_gain = initial_heat

/obj/item/overloader/redline/on_eject()
	affected.slowdown = initial_speed
	affected.passive_temp_gain = initial_heat
