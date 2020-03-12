var/global/list/global_eggs = list()

/obj/item/caretaker_egg
	name = "mysterious egg"
	desc = "A mysterious egg of unknown origin."
	w_class = ITEMSIZE_LARGE
	icon = 'icons/obj/grenade.dmi' // placeholder
	icon_state = "grenade"
	item_state = "grenade"
	throw_range = 3
	slot_flags = SLOT_BELT
	contained_sprite = TRUE
	var/mob/living/egg/player // The player who will ultimately gain control of the hatchling
	var/mob_type = /mob/living/carbon/human/stok // The mob to be spawned when the hatch time is reached
	var/hatch_time = 1500 // 2.5 minutes
	var/jittering = FALSE

/obj/item/caretaker_egg/Initialize()
	. = ..()
	global_eggs += src

	addtimer(CALLBACK(src, .proc/jitter_process), (hatch_time - 300)) // start jittering thirty seconds before hatching
	addtimer(CALLBACK(src, .proc/hatch), hatch_time)

/obj/item/caretaker_egg/Destroy()
	player?.ghostize(TRUE)
	jittering = FALSE
	global_eggs -= src
	return ..()

// this process won't end because we end it when hatching
/obj/item/caretaker_egg/proc/jitter_process()
	var/old_x = pixel_x
	var/old_y = pixel_y
	jittering = TRUE

	visible_message(SPAN_WARNING("\The [src] is starting to hatch!"))

	while(jittering)
		var/jitter_value = rand(1, 3)
		pixel_x = old_x + rand(-jitter_value, jitter_value)
		pixel_y = old_y + rand(-jitter_value, jitter_value)
		sleep(1)

/obj/item/caretaker_egg/proc/hatch()
	visible_message(SPAN_WARNING("\The [src] hatches!"))
	var/mob/hatched_mob = new mob_type(get_turf(src))
	if(player)
		hatched_mob.ckey = player.ckey
		for(var/language in player.languages)
			hatched_mob.add_language(language)
		hatched_mob.name = player.name
		hatched_mob.real_name = hatched_mob.name
		player = null // so it doesn't get ghosted when deleted
	qdel(src)