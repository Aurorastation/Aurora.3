/obj/item/flame/candle
	name = "red candle"
	desc = "a small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = 1
	light_color = "#E09D37"
	var/wax = 2000

/obj/item/flame/candle/New()
	wax = rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.
	..()

/obj/item/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"


/obj/item/flame/candle/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("<span class='notice'>\The [user] casually lights the [name] with [W].</span>")
	else if(isflamesource(W))
		light()
	else if(istype(W, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = W
		if(C.lit)
			light()


/obj/item/flame/candle/proc/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [name].</span>")
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		START_PROCESSING(SSprocessing, src)

/obj/item/flame/candle/process()
	if(!lit)
		return
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

/obj/item/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
