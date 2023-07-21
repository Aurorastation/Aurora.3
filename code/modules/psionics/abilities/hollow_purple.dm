/singleton/psionic_power/hollow_purple
	name = "Hollow Technique: Purple"
	desc = "This technique brings the concept of motion and reversal into reality. Purple is born from merging both infinites: Blue and Red, \
			to produce an imaginary mass that rushes forth and erases everything in its path. Rather than the attraction of Blue or the repulsion of Red, \
			Purple is an extraordinarily destructive energy wave of annihilation that rips whatever it hits from existence."
	icon_state = "hollow_purple"
	point_cost = 0
	ability_flags = PSI_FLAG_LIMITLESS
	spell_path = /obj/item/spell/projectile/hollow_purple

/obj/item/spell/projectile/hollow_purple
	name = "hollow purple"
	desc = "Throughout Heaven and Earth, I alone am the honored one!"
	icon_state = "destablize"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	spell_projectile = /obj/item/projectile/hollow_purple
	fire_sound = 'sound/magic/WandODeath.ogg'
	cooldown = 10
	psi_cost = 50
	var/stage = 0

/obj/item/spell/projectile/hollow_purple/on_ranged_cast(atom/hit_atom, mob/living/user, atom/pb_target)
	if(!isliving(user))
		return

	stage = 1
	user.visible_message(SPAN_NOTICE("<b><font size=4>[user] puts [user.get_pronoun("his")] palms together...</font></b>"))
	START_PROCESSING(SSprocessing, src)
	user.say("Cursed Technique Amplification: Blue...")
	user.set_light(7, 10, COLOR_BLUE)
	color = COLOR_BLUE
	if(do_after(user, 4 SECONDS))
		stage = 2
		color = COLOR_RED
		user.say("Cursed Technique Reversal: Red...")
		user.set_light(0)
		user.set_light(7, 10, COLOR_RED)
		if(do_after(user, 4 SECONDS))
			user.say("Hollow Technique: Purple!")
			user.set_light(0)
			user.visible_message(SPAN_CULT("<b><font size=4>[user] fires a gigantic purple sphere from [user.get_pronoun("his")] hand!</font></b>"))
			. = ..()

	STOP_PROCESSING(SSprocessing, src)
	color = initial(color)
	user.set_light(0)
	stage = 0

/obj/item/spell/projectile/hollow_purple/process()
	if(stage >= 1)
		for(var/mob/living/L in get_hearers_in_view(7, src))
			shake_camera(L, 5, 5)

/obj/item/projectile/hollow_purple
	name = "hollow purple"
	icon_state = "bfg"
	color = COLOR_PURPLE
	damage = 1000
	armor_penetration = 1000
	penetrating = 100
	range = 250
	accuracy = 100
	anti_materiel_potential = 100
	damage_type = DAMAGE_BRUTE

/obj/item/projectile/hollow_purple/Initialize()
	. = ..()
	set_light(10, 10, COLOR_PURPLE)

/obj/item/projectile/hollow_purple/on_impact(var/atom/A)
	if(ismob(A))
		var/mob/M = A
		M.gib()
	explosion(A, 5, 5, 5)
	..()

/obj/item/projectile/hollow_purple/on_hit(atom/target, blocked, def_zone)
	if(ismob(target))
		var/mob/M = target
		M.gib()
	explosion(target, 5, 5, 5)
	..()

/obj/item/projectile/hollow_purple/check_penetrate(atom/A)
	on_hit(A)
	return TRUE

/obj/item/projectile/hollow_purple/after_move()
	for(var/a in range(3, src))
		if(isliving(a) && a != firer)
			var/mob/living/M = a
			M.gib()
			playsound(src, 'sound/magic/LightningShock.ogg', 75, 1)
		else if(isturf(a) || isobj(a))
			var/atom/A = a
			if(!A.density)
				continue
			A.ex_act(3)
			playsound(src, 'sound/magic/LightningShock.ogg', 75, 1)
