/obj/structure/gore/floor
	name = "flesh floor"
	desc = "Looks like the floor was covered by some fleshlike growth."
	icon_state = "flesh_floor"
	maxHealth = 100

/obj/structure/gore/wall
	name = "flesh wall"
	desc = "Chunks of flesh sculpted to form an impassable wall."
	icon_state = "flesh_wall"
	opacity = TRUE
	maxHealth = 200

/obj/structure/gore/wall/membrane
	name = "flesh membrane"
	desc = "Skin and muscle stretched just thin enough to let light pass through."
	icon_state = "flesh_membrane"
	opacity = FALSE
	maxHealth = 120

/obj/structure/gore/wall/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/structure/gore/wall/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	return ..()

/obj/structure/gore/resin/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, FIST_ATTACK_ANIMATION)
	if(HAS_FLAG(user.mutations, HULK))
		visible_message(SPAN_DANGER("\The [user] destroys \the [src]!"))
		health = 0
	else
		visible_message(SPAN_DANGER("\The [user] claws at \the [src]!"))
		health -= rand(5, 10)
	healthcheck()
