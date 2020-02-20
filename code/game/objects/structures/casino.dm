/obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_r"
	density = 1
	anchored = 1
	var/busy=0

/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"<span class='notice'>You cannot spin now! \The [src] is already spinning.</span> ")
		return
	visible_message("<span class='notice'>[user] spins the roulette and throws inside little ball.</span>")
	busy = 1
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	spawn(5 SECONDS)
		visible_message("<span class='notice'>\The [src] stops spinning, the ball landing on [n], [color].</span>")
		busy=0

/obj/structure/casino/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets! "
	icon = 'icons/obj/casino.dmi'
	icon_state = "roulette_l"
	density = 1
	anchored = 1

/obj/structure/casino/attackby(obj/item/W as obj, mob/user as mob, var/click_parameters)
	if (!W) return

	if(user.unEquip(W, 0, src.loc))
		user.make_item_drop_sound(W)
		return 1