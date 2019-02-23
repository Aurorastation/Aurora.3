#define RAT_MAYOR_LEVEL 1
#define RAT_BARON_LEVEL 3
#define RAT_DUKE_LEVEL 5
#define RAT_KING_LEVEL 10
#define RAT_EMPEROR_LEVEL 20
#define RAT_SAVIOR_LEVEL 30
#define RAT_GOD_LEVEL 50


/proc/announceToRodents(var/message)
	for(var/R in SSmob.all_mice)
		to_chat(R, message)

/mob/living/simple_animal/mouse/king
	attacktext = "bitten"
	a_intent = "harm"

	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	var/swarm_name = "peasentry"
	var/announce_name = "Request"
	var/list/rats = list()

/mob/living/simple_animal/mouse/king/Initialize()
	. = ..()

	update()

	icon_state = initial(icon_state)
	icon_living = initial(icon_living)
	icon_dead = initial(icon_dead)
	body_color = "gray"

	say_dead_direct("An heir to the rat throne has risen, all rejoice and celebrate.")
	announceToRodents("<span class='notice'>The rat king has risen! Go at once and join his kingdom, long live the king!</span>")

/mob/living/simple_animal/mouse/king/death()
	while(rats.len)
		eject(rats[1], 1)

	..()

/mob/living/simple_animal/mouse/king/Move()
	..()

	for(var/image/I in overlays)
		I.dir = src.dir

/mob/living/simple_animal/mouse/king/update_icon()
	..()

	cut_overlays()

	for(var/mob/living/simple_animal/mouse/R in rats)
		var/image/rat_overlay = image('icons/mob/animal.dmi', "[R.icon_state]")
		rat_overlay.dir = src.dir
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		rat_overlay.transform = M
		add_overlay(rat_overlay)

/mob/living/simple_animal/mouse/king/proc/update()
	if( rats.len >= RAT_GOD_LEVEL)
		name = "rat god"
		swarm_name = "creation"
		announce_name = "commandment"
		desc = "A titanic swarm of rats."
		attacktext = "swarmed"
		melee_damage_lower = 15
		melee_damage_upper = 20
		maxHealth = 260
		health = 260
		mob_size = 10
		universal_speak = 1
	else if(rats.len >= RAT_SAVIOR_LEVEL)
		name = "rat savior"
		swarm_name = "flock"
		announce_name = "pronouncement"
		desc = "A massive swarm of rats."
		attacktext = "swarmed"
		melee_damage_lower = 10
		melee_damage_upper = 10
		maxHealth = 160
		health = 160
		mob_size = 9
	else if(rats.len >= RAT_EMPEROR_LEVEL)
		name = "rat emperor"
		swarm_name = "empire"
		announce_name = "command"
		desc = "A large swarm of rats."
		attacktext = "swarmed"
		melee_damage_lower = 7
		melee_damage_upper = 5
		maxHealth = 110
		health = 110
		mob_size = 8
	else if(rats.len >= RAT_KING_LEVEL)
		name = "rat king"
		swarm_name = "kingdom"
		announce_name = "decree"
		desc = "A big swarm of rats."
		attacktext = "swarmed"
		melee_damage_lower = 5
		melee_damage_upper = 5
		maxHealth = 60
		health = 60
		mob_size = 7
	else if(rats.len >= RAT_DUKE_LEVEL)
		name = "rat duke"
		swarm_name = "duchy"
		announce_name = "decree"
		desc = "A swarm of rats."
		attacktext = "bitten"
		maxHealth = 35
		health = 35
		mob_size = 6
	else if(rats.len >= RAT_BARON_LEVEL)
		name = "rat baron"
		swarm_name = "barony"
		announce_name = "decree"
		desc = "A group of rats."
		attacktext = "bitten"
		maxHealth = 25
		health = 25
		mob_size = 4
	else if(rats.len >= RAT_MAYOR_LEVEL)
		name = "rat mayor"
		swarm_name = "hamlet"
		announce_name = "decree"
		desc = "A couple of rats."
		attacktext = "bitten"
		maxHealth = 15
		health = 15
		mob_size = 3
	else
		name = "rat peasant"
		swarm_name = "peasentry"
		announce_name = "request"
		desc = "A single rat. This one seems special."
		attacktext = "scratched"
		maxHealth = 10
		health = 10
		mob_size = 2

	desc += " There are [rats.len] rats in his [swarm_name]."
	real_name = name

	update_icon()

/mob/living/simple_animal/mouse/king/splat()
	src.apply_damage(5, BRUTE)

/mob/living/simple_animal/mouse/king/verb/kingDecree()
	set category = "Abilities"
	set name = "Decree"

	if( !health )
		to_chat(usr, "<span class='notice'>You are dead, you cannot use any abilities!</span>")
		return

	var/input = sanitize(input(usr, "Please enter the [lowertext( announce_name )] for your whole kingdom.", "What?", "") as message|null, extra = 0)

	if( !input )
		return

	var/full_message = {"<h2 class='alert'>[src]\'s [announce_name]</h2>
<span class='alert'>[input]</span><br>"}

	announceToRodents( "[full_message]" )

/mob/living/simple_animal/mouse/king/verb/roar()
	set category = "Abilities"
	set name = "Mighty Roar"

	if(!health)
		to_chat(usr, "<span class='notice'>You are dead, you cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		to_chat(usr, "<span class='warning'>We must wait a little while before we can use this ability again!</span>")
		return

	if(!canRoar())
		to_chat(usr, "<span class='warning'>Our [swarm_name] must grow larger before we can use this ability!</span>")
		return

	src.visible_message("<span class='warning'>[src] lets loose a mighty roar!</span>")
	for( var/obj/machinery/light/L in range( 3, src ))
		if( canRoarBreakLights() && prob(( rats.len/RAT_EMPEROR_LEVEL )*100 ))
			L.broken()
		else
			L.flicker()
	last_special = world.time + 30

/mob/living/simple_animal/mouse/king/verb/devourdead(mob/target as mob in oview())
	set category = "Abilities"
	set name = "Devour Body"

	if(!Adjacent(target))
		return

	if(!health)
		to_chat(usr, "<span class='notice'>You are dead, you cannot use any abilities!</span>")
		return

	if(!canEatCorpse())
		to_chat(usr, "<span class='warning'>Our [swarm_name] must grow larger before we can use this ability!</span>")
		return

	if(last_special > world.time)
		to_chat(usr, "<span class='warning'>We must wait a little while before we can use this ability again!</span>")
		return

	if(target.stat != DEAD)
		to_chat(usr, "<span class='warning'>We can only devour the dead!</span>")
		return

	usr.visible_message("<span class='danger'>\The [usr] swarms the body of \the [target], ripping flesh from bone!</span>" )

	if(!do_after(usr,200))
		to_chat(src, "<span class='warning'>You need to wait longer to consume the body of [target]!</span>")
		return 0

	src.visible_message("<span class='danger'>\The [usr] consumed the body of \the [target]!</span>")
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	return

/mob/living/simple_animal/mouse/king/proc/absorb(var/mob/living/simple_animal/mouse/R, var/update = 1)
	if(!(R in rats))
		R.forceMove(src)
		rats += R

	if( update )
		update()

/mob/living/simple_animal/mouse/king/proc/eject(var/mob/living/simple_animal/mouse/R, var/update = 1)
	if(R in rats)
		R.forceMove(get_turf(src))
		rats -= R

	if(update)
		update()

/mob/living/simple_animal/mouse/king/proc/kingdomMessage(var/message, var/king_message)
	for(var/R in rats)
		to_chat(R, message)

	if(king_message)
		to_chat(src, king_message)
	else
		to_chat(src, message)

/mob/living/simple_animal/mouse/king/proc/canNibbleWire()
	if(rats.len >= RAT_MAYOR_LEVEL)
		return 1
	return 0

/mob/living/simple_animal/mouse/king/proc/canRoar()
	if(rats.len >= RAT_BARON_LEVEL)
		return 1
	return 0

/mob/living/simple_animal/mouse/king/proc/canRoarBreakLights()
	if(rats.len >= RAT_EMPEROR_LEVEL)
		return 1
	return 0

/mob/living/simple_animal/mouse/king/proc/canEatCorpse()
	if(rats.len >= RAT_KING_LEVEL)
		return 1
	return 0
