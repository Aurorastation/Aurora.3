/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"
	var/expended = FALSE
	var/overloader_mod_path = /datum/modifier/overloader
	var/runtime = 30 SECONDS
	var/effect_check_interval = 2 SECONDS


/datum/modifier/overloader //i don't really know what i'm doing but i am copying matt and begging wildkins
	var/start_text = SPAN_NOTICE("Injected code from an overloader floods through your systems!")
	var/end_text = SPAN_WARNING("You feel the injection of overloader code scrub itself from your systems.")


/datum/modifier/overloader/activate()
	if (source.expended)
		return
	
	..()
	to_chat(target, start_text)


/datum/modifier/overloader/deactivate()
	..()
	to_chat(target, end_text)
	
	source.runtime = duration
	if (source.runtime <= 0 SECONDS)
		source.expend()


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
	M.add_modifier(overloader_mod_path, MODIFIER_TIMED, _source = src, _duration = runtime, _check_interval = effect_check_interval)

	
/obj/item/overloader/proc/expend((mob/living/carbon/human/M))
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
	overloader_mod_path = /datum/modifier/overloader/redline

/datum/modifier/overloader/redline
	
/datum/modifier/overloader/redline/activate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		M.move_delay_mod -= 0.5

/datum/modifier/overloader/redline/deactivate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		M.move_delay_mod += 0.5

/obj/item/overloader/redline/install(mob/living/carbon/human/M)
	..()
	
/obj/item/overloader/redline/expend(mob/living/carbon/human/M)
	..()

/obj/item/overloader/redline/on_eject()
	..()
