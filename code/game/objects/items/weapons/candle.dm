/obj/item/weapon/flame/candle
	name = "red candle"
	desc = "a small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1
	light_color = "#E09D37"
	var/wax = 2000

/obj/item/weapon/flame/candle/New()
	wax = rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.
	..()

/obj/item/weapon/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"


/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
	else if(isflamesource(W))
		light()
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light()


/obj/item/weapon/flame/candle/proc/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		update_icon()
		START_PROCESSING(SSprocessing, src)

/obj/item/weapon/flame/candle/process()
	if(!lit)
		return
	update_icon()
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped()

		STOP_PROCESSING(SSprocessing, src)
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		to_chat(user, span("notice", "You snuff out the flame."))
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		update_icon()
		set_light(0)

/obj/item/clothing/head/pumpkin
	name = "jack o' lantern"
	desc = "Believed to ward off evil spirits."
	icon_state = "pumpkin_carved"
	throw_speed = 0.5
	item_state = "pumpkin_carved"
	w_class = 3
	drop_sound = 'sound/items/drop/herb.ogg'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	light_color = "#E09D37"
	var/wax = 2000
	var/lit = 0

/obj/item/clothing/head/pumpkin/New()
	wax = rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.
	..()

/obj/item/clothing/head/pumpkin/update_icon()
	icon_state = "pumpkin_carved[lit ? "_lit" : ""]"

/obj/item/clothing/head/pumpkin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
	else if(isflamesource(W))
		light()
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light()

/obj/item/clothing/head/pumpkin/proc/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		update_icon()
		START_PROCESSING(SSprocessing, src)

/obj/item/clothing/head/pumpkin/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new /obj/item/clothing/head/pumpkin (src.loc)
		if(istype(src.loc, /mob))
			src.dropped()

		STOP_PROCESSING(SSprocessing, src)
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/clothing/head/pumpkin/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		to_chat(user, span("notice", "You snuff out the flame."))
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		update_icon()
		set_light(0)

/obj/item/weapon/pumpkin_carved
	name = "carved pumpkin"
	desc = "A pumpkin with a spooky face carved in it. Now all that's missing is a candle."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "pumpkin_carved"
	drop_sound = 'sound/items/drop/herb.ogg'
	w_class = 3
	throwforce = 1

/obj/item/weapon/pumpkin_carved/attackby(var/obj/O, mob/user as mob)
	if(istype(O, /obj/item/weapon/flame/candle)) // supposed to carry over the wax, but I can't really figure that out.
		to_chat(user, "You add [O] to [src].")
		qdel(O)
		user.put_in_hands(new /obj/item/clothing/head/pumpkin)
		qdel(src)
		return
