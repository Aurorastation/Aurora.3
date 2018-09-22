#define DRAKE_SWOOP_HEIGHT 270 //how high up drakes go, in pixels
#define DRAKE_SWOOP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from
#define DRAKE_SWOOP_COOLDOWN 20 SECONDS

#define SWOOP_DAMAGEABLE 1
#define SWOOP_INVULNERABLE 2

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 3 SECONDS

#define ISINRANGE(VALUE,MIN,MAX) (VALUE <= MAX && VALUE >= MIN)

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake
	name = "\improper Ash Drake"
	short_name = "ash drake"
	icon = 'icons/mob/64x64megafauna.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	icon_gib = "dragon_dead"

	attack_sound = 'sound/magic/demon_attack1.ogg'

	projectilesound = 'sound/magic/Fireball.ogg'
	projectiletype = /obj/item/projectile/energy/electrode/fireball

	pixel_x = -16

	ranged = 1

	health = 1000
	maxHealth = 1000

	speed = 0.75 SECONDS
	move_to_delay = 0.75 SECONDS
	attack_delay = 0.25 SECONDS

	var/swooping = 0
	var/swoop_cooldown = 0

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/AltClickOn(atom/movable/A)
	if(!istype(A))
		return
	if(swoop_cooldown >= world.time)
		to_chat(src, "<span class='warning'>You need to wait [DRAKE_SWOOP_COOLDOWN/10] seconds between swoop attacks!</span>")
		return
	INVOKE_ASYNC(src,.proc/swoop_attack_multi,A)

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/CtrlClickOn(atom/movable/A)
	if(!istype(A))
		return
	if(swoop_cooldown >= world.time)
		to_chat(src, "<span class='warning'>You need to wait [ (DRAKE_SWOOP_COOLDOWN/10) * 3] seconds between swoop attacks!</span>")
		return
	INVOKE_ASYNC(src,.proc/swoop_attack,A)
	swoop_cooldown = world.time + DRAKE_SWOOP_COOLDOWN*3

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/AttackingTarget()
	if(swooping)
		return

	if(!Adjacent(target_mob) && prob(25))
		ranged = 1
		return

	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/visible_message()
	if(swooping & SWOOP_INVULNERABLE) //to suppress attack messages without overriding every single proc that could send a message saying we got hit
		return
	return ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/DestroySurroundings()
	if(swooping)
		return
	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/follow_target()
	if(swooping)
		return
	..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/MoveToTarget()
	if(swooping)
		return
	. = ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/proc/swoop_attack_multi(atom/movable/manual_target, swoop_duration = 40)
	swoop_attack(manual_target,swoop_duration)
	swoop_attack(manual_target,swoop_duration)
	swoop_attack(manual_target,swoop_duration)

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/OpenFire(target_mob)

	if(swooping)
		return

	face_atom(target_mob)

	stop_automated_movement = TRUE

	if(prob(40) && !ckey && swoop_cooldown <= world.time)
		if(prob(10))
			INVOKE_ASYNC(src, .proc/swoop_attack_multi,target_mob)
		else
			INVOKE_ASYNC(src, .proc/swoop_attack,target_mob)
	else
		. = ..()

/mob/living/simple_animal/hostile/commanded/battlemonster/ash_drake/proc/swoop_attack(atom/movable/manual_target, swoop_duration = 40)
	if(stat || swooping)
		return
	if(manual_target)
		target_mob = manual_target
	if(!target_mob)
		return
	swoop_cooldown = world.time + DRAKE_SWOOP_COOLDOWN
	stop_automated_movement = TRUE
	swooping |= SWOOP_DAMAGEABLE
	density = FALSE
	icon_state = "shadow"
	visible_message("<span class='danger'>[src] swoops up high!</span>")
	playsound(src, 'sound/effects/ghost2.ogg', 100, 1)

	var/negative
	var/initial_x = x
	if(target_mob.x < initial_x) //if the target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(target_mob.x > initial_x)
		negative = FALSE
	else if(target_mob.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)
	var/obj/effect/temp_visual/dragon_flight/F = new /obj/effect/temp_visual/dragon_flight(loc, negative)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = transform
	alpha = 255
	animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1)
		if(QDELETED(src) || stat == DEAD) //we got hit and died, rip us
			qdel(F)
			if(stat == DEAD)
				swooping &= ~SWOOP_DAMAGEABLE
				animate(src, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
	swooping |= SWOOP_INVULNERABLE
	mouse_opacity = 0
	sleep(7)
	while(swoop_duration > 0)
		if(!target_mob && !FindTarget())
			break //we lost our target while chasing it down and couldn't get a new one
		if(loc == get_turf(target_mob))
			if(isliving(target_mob))
				var/mob/living/L = target_mob
				if(L.stat == DEAD)
					break //target is dead and we're on em, slam they
		forceMove(get_step(src, get_dir(src, target_mob)))
		if(loc == get_turf(target_mob))
			if(isliving(target_mob))
				var/mob/living/L = target_mob
				if(L.stat == DEAD)
					break
		var/swoop_speed = 1.5
		swoop_duration -= swoop_speed
		sleep(swoop_speed)

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(x, initial_x + 1, initial_x + DRAKE_SWOOP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(x, initial_x - DRAKE_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE
	new /obj/effect/temp_visual/dragon_flight/end(loc, negative)
	new /obj/effect/temp_visual/dragon_swoop(loc)
	animate(src, alpha = 255, transform = oldtransform, time = 5)
	sleep(5)
	swooping &= ~SWOOP_INVULNERABLE
	mouse_opacity = initial(mouse_opacity)
	icon_state = "dragon"
	playsound(loc, 'sound/effects/meteorimpact.ogg', 200, 1)
	for(var/mob/living/L in orange(1, src))
		L.adjustHalLoss(rand(melee_damage_lower,melee_damage_upper)*2)

	for(var/mob/M in range(7, src))
		shake_camera(M, 15, 1)

	density = TRUE
	sleep(1)
	swooping = 0
	setClickCooldown(MEGAFAUNA_DEFAULT_RECOVERY_TIME)
	if(!ckey)
		ranged = prob(50)

/obj/effect/temp_visual/dragon_swoop
	name = "certain death"
	desc = "Don't just stand there, move!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "landing"
	layer = BELOW_MOB_LAYER
	pixel_x = -32
	pixel_y = -32
	color = "#FF0000"
	duration = 5

/obj/effect/temp_visual/dragon_flight
	icon = 'icons/mob/64x64megafauna.dmi'
	icon_state = "dragon"
	pixel_x = -16
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/dragon_flight/Initialize(mapload, negative)
	. = ..()
	INVOKE_ASYNC(src, .proc/flight, negative)

/obj/effect/temp_visual/dragon_flight/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(3)
	icon_state = "swoop"
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)

/obj/effect/temp_visual/dragon_flight/end
	pixel_x = DRAKE_SWOOP_HEIGHT
	pixel_z = DRAKE_SWOOP_HEIGHT
	duration = 5

/obj/effect/temp_visual/dragon_flight/end/flight(negative)
	if(negative)
		pixel_x = -DRAKE_SWOOP_HEIGHT
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)

#undef DRAKE_SWOOP_HEIGHT
#undef DRAKE_SWOOP_DIRECTION_CHANGE_RANGE

#undef SWOOP_DAMAGEABLE
#undef SWOOP_INVULNERABLE

/obj/effect/temp_visual/dragon_fire
	name = "holofire"
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	duration = 4 SECONDS
	randomdir = TRUE
	color = "#F08C00"
	alpha = 200

/obj/effect/temp_visual/dragon_fire/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

	if(prob(50))
		var/turf/T = get_step(get_turf(src),pick(NORTH,EAST,SOUTH,WEST))
		if(!locate(/obj/effect/temp_visual/dragon_fire) in T)
			CHECK_TICK
			new/obj/effect/temp_visual/dragon_fire(T.loc)

/obj/effect/temp_visual/Crossed(var/mob/living/L as mob)
	if(istype(L))
		L.adjustHalLoss(10)

