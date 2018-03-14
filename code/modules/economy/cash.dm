/obj/item/weapon/spacecash
	name = "0 credit chip"
	desc = "It's worth 0 credits."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"
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

/obj/item/weapon/spacecash/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/spacecash))
		if(istype(W, /obj/item/weapon/spacecash/ewallet)) return 0

		var/obj/item/weapon/spacecash/bundle/bundle
		if(!istype(W, /obj/item/weapon/spacecash/bundle))
			var/obj/item/weapon/spacecash/cash = W
			user.drop_from_inventory(cash)
			bundle = new (src.loc)
			bundle.worth += cash.worth
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
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
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			ovr += banknote
	if(num == 0) // Less than one credit, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items.dmi', "spacecash1")
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
	if(amount in list(1000,500,200,100,50,20,1))
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
	icon_state = "spacecash1"
	desc = "It's worth 1 credit."
	worth = 1

/obj/item/weapon/spacecash/c10
	name = "10 credit chip"
	icon_state = "spacecash10"
	desc = "It's worth 10 credits."
	worth = 10

/obj/item/weapon/spacecash/c20
	name = "20 credit chip"
	icon_state = "spacecash20"
	desc = "It's worth 20 credits."
	worth = 20

/obj/item/weapon/spacecash/c50
	name = "50 credit chip"
	icon_state = "spacecash50"
	desc = "It's worth 50 credits."
	worth = 50

/obj/item/weapon/spacecash/c100
	name = "100 credit chip"
	icon_state = "spacecash100"
	desc = "It's worth 100 credits."
	worth = 100

/obj/item/weapon/spacecash/c200
	name = "200 credit chip"
	icon_state = "spacecash200"
	desc = "It's worth 200 credits."
	worth = 200

/obj/item/weapon/spacecash/c500
	name = "500 credit chip"
	icon_state = "spacecash500"
	desc = "It's worth 500 credits."
	worth = 500

/obj/item/weapon/spacecash/c1000
	name = "1000 credit chip"
	icon_state = "spacecash1000"
	desc = "It's worth 1000 credits."
	worth = 1000

proc/spawn_money(var/sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(1000,500,200,100,50,20,10,1))
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
	name = "lottery card"
	desc = "A scratch-action charge card that contains a variable amount of money."
	worth = 0
	var/scratched = 0

/obj/item/weapon/spacecash/ewallet/lotto/attack_self(mob/user)
	if(!scratched)
		user << "<span class='notice'>You initiate the simulated scratch action process on the charge card...</span>"
		if(do_after(user,5))
			var/result = rand(1,10000)
			if(result <= 5000) // 50% chance to not earn anything at all.
				worth = 0
				user << "<span class='notice'>The card reads [worth]. Not your lucky day!</span>"
			else if (result <= 8000) // 30% chance to break even.
				worth = 200
				user << "<span class='notice'>The card reads [worth]. At least you broke even...</span>"
			else if (result <= 9000) // 10% chance to earn 500 credits
				worth = 500
				user << "<span class='notice'>The card reads [worth]. You doubled your money!</span>"
			else if (result <= 9500) // 5% chance to earn 1000 credits.
				worth = 1000
				user << "<span class='notice'>The card reads [worth]. Wow, you're lucky!</span>"
			else if (result <= 9750) // 2.5% chance to earn 2500 credits.
				worth = 2500
				user << "<span class='notice'>The card reads [worth]. Wow, your luck is running high!</span>"
			else if (result <= 9900) // 1.5% chance to earn 5000 credits.
				worth = 5000
				user << "<span class='notice'>The card reads [worth]. Wow, you're rich!</span>"
			else if (result <= 9950) // 0.5% chance to earn 10000 credits
				worth = 10000
				user << "<span class='notice'>The card reads [worth]. Wow, your're super rich!</span>"
			else if (result <= 9975) // 0.25% chance to earn 50000 credits.
				worth = 25000
				user << "<span class='notice'>The card reads [worth]. Wow, your're super rich!</span>"
			else // 0.25% chance to earn 100000 credits.
				user << "<span class='notice'>The card reads [worth]. YOU HIT THE JACKPOT!</span>"
				worth = 50000

			scratched = 1
			owner_name = user.name
