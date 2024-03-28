/obj/structure/hadii_statue
	name = "president Hadii statue"
	desc = "A statue of the current president of the People's Republic of Adhomai, Njadrasanukii Hadii."
	icon = 'icons/obj/hadii_statue.dmi'
	icon_state = "bronze"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	var/toppled = FALSE
	var/outside = FALSE
	var/already_toppled = FALSE
	var/toppling_sound = 'sound/effects/metalhit.ogg'
	var/health = 100

/obj/structure/hadii_statue/stone
	icon_state = "stone"
	toppling_sound = 'sound/effects/meteorimpact.ogg'

/obj/structure/hadii_statue/Initialize()
	. = ..()
	if(already_toppled)
		topple()

/obj/structure/hadii_statue/update_icon()
	cut_overlays()
	if(toppled)
		icon_state = "[initial(icon_state)]_toppled"
		return
	if(outside)
		add_overlay("snow")

/obj/structure/hadii_statue/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		else
			topple()

/obj/structure/hadii_statue/proc/topple()
	if(toppled)
		return
	visible_message(SPAN_WARNING("\The [src] topples down!"))
	playsound(src, toppling_sound, 75, 1)
	toppled = TRUE
	update_icon()

/obj/structure/hadii_statue/attackby(obj/item/attacking_item, mob/user)
	if(toppled)
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	if(attacking_item.force <= 15)
		visible_message(SPAN_WARNING("\The [attacking_item] bounces off \the [src]!"))
		return
	visible_message(SPAN_WARNING("\The [user] strikes \the [src] with \the [attacking_item]!"))
	do_integrity_check(attacking_item.force)

/obj/structure/hadii_statue/proc/do_integrity_check(damage)
	if(toppled)
		return
	if(damage)
		health -= damage
	if(health <= 0)
		topple()

/obj/structure/hadii_statue/bullet_act(var/obj/item/projectile/Proj)
	if(toppled)
		return
	if(!Proj)
		return
	if(!Proj.damage)
		visible_message(SPAN_WARNING("\The [Proj] bounces off \the [src]!"))
		return
	visible_message(SPAN_WARNING("\The [Proj] hits \the [src]!"))
	do_integrity_check(Proj.damage)
