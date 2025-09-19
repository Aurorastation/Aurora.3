/obj/item/device/dociler
	name = "dociler"
	desc = "A complex single use recharging injector that spreads a complex neurological serum that makes animals docile and friendly. Somewhat."
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"
	force = 0
	var/loaded = 1
	var/mode = "completely"

/obj/item/device/dociler/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += SPAN_NOTICE("It is currently set to [mode] docile mode.")

/obj/item/device/dociler/attack_self(var/mob/user)
	if(mode == "somewhat")
		mode = "completely"
	else
		mode = "somewhat"

	to_chat(user, "You set \the [src] to [mode] docile mode.")

/obj/item/device/dociler/afterattack(var/mob/living/L, var/mob/user, proximity)
	if(!proximity) return

	if(!istype(L, /mob/living/simple_animal))
		to_chat(user, SPAN_WARNING("\The [src] has no effect on \the [L]."))
		return

	if(!loaded)
		to_chat(user, SPAN_WARNING("\The [src] isn't loaded!"))
		return

	user.visible_message("\The [user] thrusts \the [src] deep into \the [L]'s head, injecting something!")

	if(mode == "somewhat")
		L.faction = user.faction
	else
		L.faction = null
	if(istype(L,/mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = L
		if(!H.tameable)
			to_chat(user, SPAN_WARNING("\The [src] has no effect on \the [L]."))
			return
		else
			H.LoseTarget()
			H.attack_same = 0
			H.friends += user
			H.hostile_nameable = TRUE

	L.desc += "<br><span class='notice'>It looks especially docile.</span>"
	var/name = input(user, "Would you like to rename \the [L]?", "Dociler", L.name) as text
	if(length(name))
		L.real_name = name
		L.name = name

	loaded = 0
	icon_state = "decloner0"
	addtimer(CALLBACK(src, PROC_REF(do_recharge)), 5 MINUTES)


/obj/item/device/dociler/proc/do_recharge()
	loaded = 1
	icon_state = "decloner"
	src.visible_message("\The [src] beeps, refilling itself.")
