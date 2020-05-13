/obj/item/device/dociler
	name = "dociler"
	desc = "A complex single use recharging injector that spreads a complex neurological serum that makes animals docile and friendly. Somewhat."
	w_class = 3
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	// To-do track down where the hell this sprite went?
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = "decloner"
	item_state = "decloner"
	contained_sprite = TRUE
	force = 0
	var/loaded = 1
	var/mode = "completely"

/obj/item/device/dociler/examine(var/mob/user)
	. = ..(user)
	to_chat(user, "<span class='notice'>It is currently set to [mode] docile mode.</span>")

/obj/item/device/dociler/attack_self(var/mob/user)
	if(mode == "somewhat")
		mode = "completely"
	else
		mode = "somewhat"

	to_chat(user, "You set \the [src] to [mode] docile mode.")

/obj/item/device/dociler/afterattack(var/mob/living/L, var/mob/user, proximity)
	if(!proximity) return

	if(!istype(L, /mob/living/simple_animal))
		to_chat(user, "<span class='warning'>\The [src] has no effect on \the [L].</span>")
		return

	if(!loaded)
		to_chat(user, "<span class='warning'>\The [src] isn't loaded!</span>")
		return

	user.visible_message("\The [user] thrusts \the [src] deep into \the [L]'s head, injecting something!")

	if(mode == "somewhat")
		L.faction = user.faction
	else
		L.faction = null
	if(istype(L,/mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = L
		if(!H.tameable)
			to_chat(user, "<span class='warning'>\The [src] has no effect on \the [L].</span>")
			return
		else
			H.LoseTarget()
			H.attack_same = 0
			H.friends += user

	L.desc += "<br><span class='notice'>It looks especially docile.</span>"
	var/name = input(user, "Would you like to rename \the [L]?", "Dociler", L.name) as text
	if(length(name))
		L.real_name = name
		L.name = name

	loaded = 0
	icon_state = "animal_tagger0"
	addtimer(CALLBACK(src, .proc/do_recharge), 5 MINUTES)


/obj/item/device/dociler/proc/do_recharge()
	loaded = 1
	icon_state = "animal_tagger1"
	src.visible_message("\The [src] beeps, refilling itself.")