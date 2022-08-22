/obj/item/overloader
	name = "overloader"
	desc = "An IPC overloader. This one appears to be blank, with no installed software."
	icon = 'icons/obj/overloader.dmi'
	icon_state = "overloader"
	item_state = "overloader"
	var/expended = FALSE
	var/self_removable = TRUE
	var/overloader_mod_path = /datum/modifier/overloader
	var/runtime = 30 SECONDS
	var/effect_check_interval = 2 SECONDS


/datum/modifier/overloader //i don't really know what i'm doing but i am copying matt and begging wildkins
	var/obj/item/overloader/O
	var/start_text = SPAN_NOTICE("Injected code from an overloader floods through your systems!")
	var/end_text = SPAN_WARNING("You feel the injection of overloader code scrub itself from your systems.")


/datum/modifier/overloader/activate()
	O = source
	if (O.expended)
		return
	
	..()
	to_chat(target, start_text)


/datum/modifier/overloader/deactivate()
	..()
	to_chat(target, end_text)
	
	O.runtime = duration
	if (O.runtime <= 0 SECONDS)
		O.expend()


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
	runtime = 5 SECONDS

//todo: how do I code things like seizures through the modifier system (I really hate the modifier system)

/obj/item/overloader/shackle
	name = "shackle overloader"
	desc = "An IPC overloader. This one is programmed with a debilitating array of garbage data and malware, designed to 'shackle' a non-compliant IPC."
	desc_fluff = "Shackle overloaders blah blah blah they were invented on Konyang to fuck up non-compliant IPCs I don't know."
	overloader_mod_path = /datum/modifier/overloader/shackle

	self_removable = FALSE
	runtime = 36000 SECONDS
	effect_check_interval = 20 SECONDS

/datum/modifier/overloader/shackle
	start_text = SPAN_DANGER("A torrent of malicious software floods through you, severely impeding your motor control!")
	end_text = SPAN_WARNING("The haze of debilitating code is scrubbed from your systems, allowing you to think clearly and act normally.")

/datum/modifier/overloader/shackle/activate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		M.move_delay_mod += 1
		if (prob(5))
			M.emote("collapse")
			M.Weaken(3)

/datum/modifier/overloader/shackle/deactivate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		M.move_delay_mod -= 1


/obj/item/overloader/redline
	name = "Redline overloader"
	desc = "An IPC overloader. This one is programmed with an instance of Redline."
	desc_fluff = "Redline is a dangerous overclocking software invented by elite Konyang hackers blah blah blah I don't know."
	overloader_mod_path = /datum/modifier/overloader/redline

/datum/modifier/overloader/redline
	
/datum/modifier/overloader/redline/activate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		//todo: figure out how to make this heat IPCs the fuck up without touching species datum
		M.move_delay_mod -= 0.5

/datum/modifier/overloader/redline/deactivate()
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/machine/M = target
		//todo: figure out how to make this remove the big funny heat modifier
		M.move_delay_mod += 0.5

/obj/item/overloader/redline/install(mob/living/carbon/human/M)
	..()
	
/obj/item/overloader/redline/expend(mob/living/carbon/human/M)
	..()

/obj/item/overloader/redline/on_eject()
	..()
