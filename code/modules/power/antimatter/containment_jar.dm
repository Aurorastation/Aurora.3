/obj/item/am_containment
	name = "antimatter containment jar"
	desc = "Holds antimatter. Warranty void if exposed to matter."
	desc_antag = "Antimatter is extremely volatile, and containment jars are not particularly strong. Weak explosions will reduce the container's integrity, and larger ones will cause it to explode immediately."
	icon = 'icons/obj/machinery/antimatter.dmi'
	icon_state = "jar"
	force = 8
	throwforce = 10
	throw_speed = 1
	throw_range = 2

	var/fuel = 1000
	var/stability = 100 //TODO: add all the stability things to this so its not very safe if you keep hitting in on things
	var/exploded = FALSE

/obj/item/am_containment/proc/boom()
	var/percent = 0
	if(fuel)
		percent = (fuel / initial(fuel)) * 100
	if(!exploded && percent >= 10)
		explosion(get_turf(src), 1, 2, 3, 5)//Should likely be larger but this works fine for now I guess
		exploded = TRUE
	if(src)
		qdel(src)

/obj/item/am_containment/ex_act(severity)
	switch(severity)
		if(1.0)
			boom()
		if(2.0)
			if(prob((fuel / 10) - stability))
				boom()
			stability -= 40
		if(3.0)
			stability -= 20
	check_stability()

/obj/item/am_containment/proc/check_stability()
	if(stability <= 0)
		boom()

/obj/item/am_containment/proc/usefuel(var/wanted)
	if(fuel < wanted)
		wanted = fuel
	fuel -= wanted
	return wanted
