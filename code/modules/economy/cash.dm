/obj/item/weapon/spacecash
	name = "0 credit chip"
	desc = "It's worth 0 credits."
	gender = PLURAL
	icon = 'icons/obj/cash.dmi'
	icon_state = "1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = 2.0
	var/access = list()
	access = access_crate_cash
	var/worth = 0

	var/list/possible_values = list(100,50,20,10,5,2,1)

/obj/item/weapon/spacecash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		if(istype(W, /obj/item/weapon/spacecash/ewallet)) return 0

		var/obj/item/weapon/spacecash/bundle/bundle
		if(!istype(W, /obj/item/weapon/spacecash/bundle))
			var/obj/item/weapon/spacecash/cash = W
			bundle = new(src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			//TODO: Find out a better way to do this
			h_user.drop_from_inventory(src)
			h_user.drop_from_inventory(bundle)
			h_user.put_in_hands(bundle)
		user << "<span class='notice'>You add [src.worth] credits worth of money to the bundles.<br>It holds [bundle.worth] credits now.</span>"
		qdel(src)

/obj/item/weapon/spacecash/bundle
	name = "credit chips"
	icon_state = ""
	gender = PLURAL
	desc = "They are worth 0 credits."
	worth = 0

/obj/item/weapon/spacecash/bundle/update_icon()
	cut_overlays()
	var/list/ovr = list()
	var/sum = src.worth
	var/num = 0
	for(var/i in possible_values)
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image(icon, "[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			ovr += banknote
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		var/image/banknote = image(icon, "[possible_values[possible_values.len]]")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		ovr += banknote

	add_overlay(ovr)
	compile_overlays()	// The delay looks weird, so we force an update immediately.
	src.desc = "They are worth [worth] credits."

/obj/item/weapon/spacecash/bundle/attack_self()
	var/amount = input(usr, "How many credits do you want to take? (0 to [src.worth])", "Take Money", 20) as num
	amount = round(Clamp(amount, 0, src.worth))
	if(amount==0) return 0

	src.worth -= amount
	src.update_icon()
	if(!worth)
		usr.drop_from_inventory(src)

	if(amount in possible_values)
		var/cashtype = text2path("/obj/item/weapon/spacecash/c[amount]")
		var/obj/cash = new cashtype (usr.loc)
		usr.put_in_hands(cash)
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (usr.loc)
		bundle.worth = amount
		bundle.update_icon()
		usr.put_in_hands(bundle)

	if(!worth)
		qdel(src)

/obj/item/weapon/spacecash/c1
	name = "1 credit chip"
	icon_state = "1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/weapon/spacecash/c2
	name = "2 credit chip"
	icon_state = "2"
	desc = "It's worth 2 credits."
	worth = 2

/obj/item/weapon/spacecash/c5
	name = "5 credit chip"
	icon_state = "5"
	desc = "It's worth 5 credits."
	worth = 5

/obj/item/weapon/spacecash/c10
	name = "10 credit chip"
	icon_state = "10"
	desc = "It's worth 10 credits."
	worth = 10

/obj/item/weapon/spacecash/c20
	name = "20 credit chip"
	icon_state = "20"
	desc = "It's worth 20 credits."
	worth = 20

/obj/item/weapon/spacecash/c50
	name = "50 credit chip"
	icon_state = "50"
	desc = "It's worth 50 credits."
	worth = 50

/obj/item/weapon/spacecash/c100
	name = "100 credit chip"
	icon_state = "100"
	desc = "It's worth 100 credits."
	worth = 100

/obj/item/weapon/spacecash/bundle/coins_only
	name = "coins"
	icon_state = "2"
	desc = "A bundle of coins."
	worth = 3
	possible_values = list(2,1)

/obj/item/weapon/spacecash/bundle/coins_only/update_icon()
	. = ..()
	var/coint_coint = worth/2
	throwforce = min(10,coint_coint/5) //A stack of 50+ coins will do 10 brute damage. For referece, a toolbox does 10 when thrown and a simple punch does 5.
	force = throwforce / 2

proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(100,50,20,10,5,2,1))
		var/cash_type = text2path("/obj/item/weapon/spacecash/c[sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/weapon/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/weapon/spacecash/ewallet
	name = "Charge card"
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	..(user)
	if (!(user in view(2)) && user!=src.loc) return
	user << "<span class='notice'>Charge card's owner: [src.owner_name]. Credit chips remaining: [src.worth].</span>"

/obj/item/weapon/spacecash/ewallet/lotto
	name = "space lottery card"
	desc = "A virtual scratch-action charge card that contains a variable amount of money."
	worth = 0
	var/scratches_remaining = 3
	var/next_scratch = 0

/obj/item/weapon/spacecash/ewallet/lotto/attack_self(mob/user)

	if(scratches_remaining <= 0)
		user << "<span class='warning'>The card flashes: \"No scratches remaining!\"</span>"
		return

	if(next_scratch > world.time)
		user << "<span class='warning'>The card flashes: \"Please wait!\"</span>"
		return

	next_scratch = world.time + 6 SECONDS

	user << "<span class='notice'>You initiate the simulated scratch action process on the [src]...</span>"
	playsound(src.loc, 'sound/items/drumroll.ogg', 50, 0, -4)
	if(do_after(user,4.5 SECONDS))
		var/won = 0
		var/result = rand(1,10000)
		if(result <= 4000) // 40% chance to not earn anything at all.
			won = 0
			speak("You've won: [won] CREDITS. Better luck next time!")
		else if (result <= 8000) // 40% chance
			won = 50
			speak("You've won: [won] CREDITS. Partial winner!")
		else if (result <= 9000) // 10% chance
			won = 100
			speak("You've won: [won] CREDITS. Winner!")
		else if (result <= 9500) // 5% chance
			won = 200
			speak("You've won: [won] CREDITS. SUPER WINNER! You're lucky!")
		else if (result <= 9750) // 2.5% chance
			won = 500
			speak("You've won: [won] CREDITS. MEGA WINNER! You're super lucky!")
		else if (result <= 9900) // 1.5% chance
			won = 1000
			speak("You've won: [won] CREDITS. ULTRA WINNER! You're mega lucky!")
		else if (result <= 9950) // 0.5% chance
			won = 2500
			speak("You've won: [won] CREDITS. ULTIMATE WINNER! You're ultra lucky!")
		else if (result <= 9975) // 0.25% chance
			won = 5000
			speak("You've won: [won] CREDITS. ULTIMATE WINNER! You're ultra lucky!")
		else if (result <= 9999) // 0.24% chance
			won = 10000
			speak("You've won: [won] CREDITS. ULTIMATE WINNER! You're ultra lucky!")
		else ///0.01% chance
			won = 25000
			speak("You've won: [won] CREDITS. JACKPOT WINNER! You're JACKPOT lucky!")

		scratches_remaining -= 1
		worth += won
		sleep(1 SECONDS)
		if(scratches_remaining > 0)
			user << "<span class='notice'>The card flashes: You have: [scratches_remaining] SCRATCHES remaining! Scratch again!</span>"
		else
			user << "<span class='notice'>The card flashes: You have: [scratches_remaining] SCRATCHES remaining! You won a total of: [worth] CREDITS. Thanks for playing the space lottery!</span>"

		owner_name = user.name

/obj/item/weapon/spacecash/ewallet/lotto/proc/speak(var/message = "Hello!")
	for(var/mob/O in hearers(src.loc, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> pings, \"[message]\"</span>",2)
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0, -4)
