/obj/structure/tank_wall
	name = "mixed gas tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains mixed gasses."
	density = TRUE
	anchored = TRUE
	opacity = TRUE
	icon = 'icons/turf/placeholder_tanks.dmi'
	icon_state = "m-1"

	atmos_canpass = CANPASS_DENSITY
	var/health = 1000

/obj/structure/tank_wall/Initialize(mapload)
	. = ..()
	if(!mapload)
		update_nearby_tiles()

/obj/structure/tank_wall/ex_act(severity)
	if(severity == 1.0)
		qdel(src)

/obj/structure/tank_wall/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/tank_wall/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] falls apart!"))
		qdel(src)

/obj/structure/tank_wall/phoron
	name = "phoron gas tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains phoron."
	icon_state = "ph1"

/obj/structure/tank_wall/oxygen
	name = "oxygen tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains oxygen."
	icon_state = "o2-1"

/obj/structure/tank_wall/hydrogen
	name = "hydrogen tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains hydrogen."
	icon_state = "h1"

/obj/structure/tank_wall/carbon_dioxide
	name = "carbon dioxide tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains carbon dioxide."
	icon_state = "co2-1"

/obj/structure/tank_wall/nitrogen
	name = "nitrogen tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains nitrogen."
	icon_state = "n1"

/obj/structure/tank_wall/air
	name = "air tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains air."
	icon_state = "air1"

/obj/structure/tank_wall/nitrous_oxide
	name = "nitrous oxide tank"
	desc = "An impact resistant tank to safely contain highly pressurised gasses. This one contains nitrous oxide."
	icon_state = "h1"