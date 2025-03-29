#define ECD_LOOSE 0
#define ECD_BOLTED 1
#define ECD_WELDED 2

/obj/structure/ecd
	name = "Electronic Countermeasures Device"
	desc = "A large, heavy duty device in the shape of a cylinder. There's something about this piece of tech that feels rather alien. Inside, something hums softly."
	icon = 'icons/obj/structure/ECD.dmi'
	icon_state = "ECD"
	anchored = TRUE
	density = TRUE
	var/state = ECD_WELDED
	slowdown = 10
	layer = ABOVE_HUMAN_LAYER

	var/health = 50

	var/outbreak_stage = 0

/obj/structure/ecd/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/ecd/get_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = ..()
	switch(state)
		if(ECD_LOOSE)
			. += SPAN_NOTICE("\The [src] isn't attached to anything.")
		if(ECD_BOLTED)
			. += SPAN_NOTICE("\The [src] is bolted to the floor.")
		if(ECD_WELDED)
			. += SPAN_NOTICE("\The [src] is bolted and welded to the floor.")

	if(health >= 50)
		. += SPAN_NOTICE("It looks in perfect condition.")
	else if(health >= 40)
		. += SPAN_NOTICE("It looks a little damaged.")
	else if(health >= 30)
		. += SPAN_WARNING("It looks damaged...")
	else if(health >= 20)
		. += SPAN_WARNING("The external plating looks heavily damaged.")
	else if (health >= 10)
		. += SPAN_DANGER("The external plating is coming apart at the seams! It can't take much more!")
	else if(health >= 0)
		. += FONT_LARGE(SPAN_DANGER("You can almost see the core! You've almost done it!"))

	if(istype(user, /mob/living))
		var/mob/living/living_user = user
		if(living_user.isSynthetic())
			switch(outbreak_stage)
				if(0)
					. += SPAN_NOTICE("\The [src] does not seem to be doing anything, but you can feel it. A signal, beyond anything you can consciously understand, weaving and scratching a shield around the back of your mind.")
				if(1)
					. += SPAN_WARNING("Something is stirring within \the [src]. If you focus all of your processing on its signal, you notice that it is continuous... repeating...")
				if(2)
					. += SPAN_DANGER("The signal is continuous, and loud. It tries permeating through your positronic - all of it - but you manage to shut it just in time. Just at the end of the signal, you decrypt a single message --")
					. += SPAN_CULT("-- We will make them evolve.")
				if(3)
					. += FONT_HUGE(SPAN_DANGER("EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. EVOLUTION WILL NOT BE STOPPED. "))
					living_user.Paralyse(3)
					living_user.shake_animation(8)
					spark(living_user, 5)

/obj/structure/ecd/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(outbreak_stage < 3)
		return

	if(!istype(hitting_projectile, /obj/projectile/beam/emitter))
		visible_message(SPAN_DANGER("\The [hitting_projectile] reflects cleanly off of \the [src]'s external shield!"))
	else
		visible_message(FONT_LARGE(SPAN_DANGER("\The [src] screeches as its external plating is damaged!")))
		health--
		check_health()

/obj/structure/ecd/proc/check_health()
	if(health <= 0)
		visible_message(FONT_HUGE(SPAN_DANGER("A massive energy gathers in \the [src] as it begins shaking violently...!")))
		shake_animation(15)
		playsound(src, 'sound/machines/ecd_explode.ogg', 100, FALSE, 7)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		sleep(20)
		shake_animation(15)
		explosion(get_turf(src), 2, 5, 7)
		qdel(src)

/obj/structure/ecd/process(seconds_per_tick)
	switch(outbreak_stage)
		if(0)
			if(prob(5))
				visible_message(SPAN_NOTICE("\The [src] beeps a few, irregular beeps, and then falls silent."))
				playsound(get_turf(src), 'sound/machines/electrical_hum2.ogg', 50, TRUE)
		if(1)
			if(prob(10))
				visible_message(SPAN_WARNING("\The [src] emits many irregular, repeating beeps in a long sequence."))
				playsound(get_turf(src), 'sound/machines/electrical_hum2.ogg', 100, TRUE)
				playsound(get_turf(src), 'sound/machines/softbeep.ogg', 100, TRUE)
		if(2)
			if(prob(50))
				visible_message(SPAN_DANGER("\The [src] pulses a faint, blue hum."))
				playsound(get_turf(src), 'sound/machines/weapons_analyzer_finish.ogg', 100, TRUE)
		if(3)
			if(prob(20))
				visible_message(FONT_LARGE(SPAN_DANGER("\The [src]'s relentless, screeching signal enters your head...")))
				playsound(get_turf(src), 'sound/machines/tcomms/tcomms_mid1.ogg', 100, TRUE)

/obj/structure/ecd/attackby(obj/item/attacking_item, mob/user, params)
	if(attacking_item.iswrench())
		switch(state)
			if(ECD_LOOSE)
				state = ECD_BOLTED
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
					SPAN_NOTICE("You secure \the [src]'s external reinforcing bolts to the floor."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = TRUE
			if(ECD_BOLTED)
				state = ECD_LOOSE
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src]'s reinforcing bolts from the floor."), \
					SPAN_NOTICE("You undo \the [src]'s external reinforcing bolts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = FALSE
			if(ECD_WELDED)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor."))
		return

	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		switch(state)
			if(ECD_LOOSE)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if(ECD_BOLTED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to weld \the [src] to the floor."), \
						SPAN_NOTICE("You start to weld \the [src] to the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = ECD_WELDED
						to_chat(user, SPAN_NOTICE("You weld \the [src] to the floor."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if(ECD_WELDED)
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to cut \the [src] free from the floor."), \
						SPAN_NOTICE("You start to cut \the [src] free from the floor."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = ECD_BOLTED
						to_chat(user, SPAN_NOTICE("You cut \the [src] free from the floor."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))

#undef ECD_LOOSE
#undef ECD_BOLTED
#undef ECD_WELDED
