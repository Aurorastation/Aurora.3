///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/food/drinks/bottle
	name = "empty bottle"
	desc = "A sad empty bottle."
	icon_state = "alco-clear"
	center_of_mass = list("x" = 16,"y" = 6)
	amount_per_transfer_from_this = 5//Smaller sip size for more BaRP and less guzzling a litre of vodka before you realise it
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	force = 5
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it
	matter = list("glass" = 800)

	var/obj/item/reagent_containers/glass/rag/rag = null
	var/rag_underlay = "rag"

/obj/item/reagent_containers/food/drinks/bottle/Initialize()
	. = ..()
	if(isGlass)
		unacidable = 1
		drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
	rag = null
	return ..()

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, var/speed)
	..()

	var/mob/M = thrower
	if(isGlass && istype(M) && M.a_intent == I_HURT)
		var/throw_dist = get_dist(throw_source, loc)
		if(speed >= throw_speed && smash_check(throw_dist)) //not as reliable as smashing directly
			if(reagents)
				hit_atom.visible_message("<span class='notice'>The contents of \the [src] splash all over [hit_atom]!</span>")
				reagents.splash(hit_atom, reagents.total_volume)
			src.smash(loc, hit_atom)

/obj/item/reagent_containers/food/drinks/bottle/proc/smash_check(var/distance)
	if(!isGlass || !smash_duration)
		return 0

	var/list/chance_table = list(90, 90, 85, 85, 60, 35, 15) //starting from distance 0
	var/idx = max(distance + 1, 1) //since list indices start at 1
	if(idx > chance_table.len)
		return 0
	return prob(chance_table[idx])

/obj/item/reagent_containers/food/drinks/bottle/proc/smash(var/newloc, atom/against = null)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	var/obj/item/broken_bottle/B = new /obj/item/broken_bottle(newloc)
	if(prob(33))
		new/obj/item/material/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = src.icon_state

	var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src, "shatter", 70, 1)
	src.transfer_fingerprints_to(B)

	qdel(src)
	return B

/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/W, mob/user)
	if(!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if(rag && istype(W, /obj/item/flame))
		rag.attackby(W, user)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user)
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/reagent_containers/food/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R, mob/user)
	if(!isGlass || rag) return
	if(user.unEquip(R))
		to_chat(user, "<span class='notice'>You stuff [R] into [src].</span>")
		rag = R
		rag.forceMove(src)
		flags &= ~OPENCONTAINER
		update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag) return
	user.put_in_hands(rag)
	rag = null
	flags |= (initial(flags) & OPENCONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag) return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image

/obj/item/reagent_containers/food/drinks/bottle/attack(mob/living/target, mob/living/user, var/hit_zone)
	var/blocked = ..()

	if(user.a_intent != I_HURT)
		return
	if(!smash_check(1))
		return //won't always break on the first hit

	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/weaken_duration = 0
	if(blocked < 100)
		weaken_duration = smash_duration + min(0, force - target.getarmor(hit_zone, "melee") + 10)

	var/mob/living/carbon/human/H = target
	if(istype(H) && H.headcheck(hit_zone))
		var/obj/item/organ/affecting = H.get_organ(hit_zone) //headcheck should ensure that affecting is not null
		user.visible_message("<span class='danger'>[user] smashes [src] into [H]'s [affecting.name]!</span>")
		if(weaken_duration)
			target.apply_effect(min(weaken_duration, 5), WEAKEN, blocked) // Never weaken more than a flash!
	else
		user.visible_message("<span class='danger'>\The [user] smashes [src] into [target]!</span>")

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	if(reagents)
		user.visible_message("<span class='notice'>The contents of \the [src] splash all over [target]!</span>")
		reagents.splash(target, reagents.total_volume)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/broken_bottle/B = smash(target.loc, target)
	user.put_in_active_hand(B)

	return blocked

/obj/item/reagent_containers/food/drinks/bottle/bullet_act()
	smash(loc)

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle

	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = 1
	edge = 0
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")
	w_class = 2

/obj/item/broken_bottle/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob, var/target_zone)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()


/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("gin", 100)

/obj/item/reagent_containers/food/drinks/bottle/victorygin
	name = "Victory gin"
	desc = "Pour one out for Al'mari. His gun was on stun, bless his heart."
	icon_state = "victorygin"
	center_of_mass = list("x"=16, "y"=4)
	description_fluff = "Adhomian beverages are commonly made with fermented grains or vegetables, if alcoholic, or juices mixed with sugar or honey. Victory gin is the most \
	widespread alcoholic drink in Adhomai, the result of the fermentation of honey extracted from Messa's tears, but its production and consumption is slowly declining due to the \
	People's Republic situation in the current conflict."
	Initialize()
		. = ..()
		reagents.add_reagent("victorygin", 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("whiskey", 100)

/obj/item/reagent_containers/food/drinks/bottle/fireball
	name = "Uncle Git's Cinnamon Fireball"
	desc = "A premium single-malt whiskey, infused with cinnamon and hot pepper inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "fireballbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("fireball", 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Russians worldwide."
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("vodka", 100)

/obj/item/reagent_containers/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("tequilla", 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "bottle of nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=16, "y"=5)
	Initialize()
		. = ..()
		reagents.add_reagent("nothing", 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Angstra Aromatic Bitters"
	desc = "Only the finest and highest quality herbs find their way into our cocktail bitters."
	icon_state = "bitters"
	center_of_mass = list("x"=16, "y"=9)
	Initialize()
		. = ..()
		reagents.add_reagent("bitters",40)

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Tailfeather's Bubbliest champagne"
	desc = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades."
	icon_state = "champagnebottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("champagne",100)

/obj/item/reagent_containers/food/drinks/bottle/mintsyrup
	name = "Wintergreen Mint Syrup"
	desc = "Minty fresh. NOTE: Do not use as a replacement for breath fresheners."
	icon_state = "mint_syrup"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("mintsyrup", 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste patron"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=7)
	Initialize()
		. = ..()
		reagents.add_reagent("patron", 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("rum", 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = list("x"=17, "y"=10)
	Initialize()
		. = ..()
		reagents.add_reagent("holywater", 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("vermouth", 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's coffee liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	center_of_mass = list("x"=16, "y"=5)
	Initialize()
		. = ..()
		reagents.add_reagent("kahlua", 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("goldschlager", 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("cognac", 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Red Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("wine", 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=7)
	Initialize()
		. = ..()
		reagents.add_reagent("absinthe", 100)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine melon liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("melonliquor", 100)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Miss blue curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("bluecuracao", 100)

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Briar Rose grenadine syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("grenadine", 100)

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "space cola"
	desc = "Cola. in space"
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("cola", 100)

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		..()
		reagents.add_reagent("space_up", 100)

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("spacemountainwind", 100)

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("pwine", 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=6)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("orangejuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=6)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("cream", 100)

/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=6)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("tomatojuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=4)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("limejuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/lemonjuice
	name = "lemon juice"
	desc = "This juice is VERY sour."
	icon_state = "lemoncarton"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=6)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("lemonjuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/dynjuice
	name = "dyn juice"
	desc = "Juice from a Skrell medicinal herb. It's supposed to be diluted."
	icon_state = "dyncarton"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=6)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("dynjuice", 100)

/obj/item/reagent_containers/food/drinks/bottle/applejuice
	name = "apple juice"
	desc = "Juice from an apple. Yes."
	icon_state = "applejuice"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=4)
	isGlass = 0
	Initialize()
		. = ..()
		reagents.add_reagent("applejuice", 100)

//Small bottles
/obj/item/reagent_containers/food/drinks/bottle/small
	name = "empty small bottle"
	desc = "A sad empty bottle."
	icon_state = "beer"
	volume = 50
	smash_duration = 1
	flags = 0 //starts closed
	rag_underlay = "rag_small"

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=8)
	Initialize()
		. = ..()
		reagents.add_reagent("beer", 30)

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Magm-ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=8)
	Initialize()
		. = ..()
		reagents.add_reagent("ale", 30)

//aurora's drinks

/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen
	name = "green chartreuse"
	desc = "A green, strong liqueur."
	icon_state = "chartreusegreenbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	Initialize()
		. = ..()
		reagents.add_reagent("chartreusegreen", 100)

/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow
	name = "yellow chartreuse"
	desc = "A yellow, strong liqueur."
	icon_state = "chartreuseyellowbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	Initialize()
		. = ..()
		reagents.add_reagent("chartreuseyellow", 100)

/obj/item/reagent_containers/food/drinks/bottle/cremewhite
	name = "white creme de menthe"
	desc = "Mint-flavoured alcohol, in a bottle."
	icon_state = "whitecremebottle"
	center_of_mass = list("x" = 16,"y" = 5)
	Initialize()
		. = ..()
		reagents.add_reagent("cremewhite", 100)

/obj/item/reagent_containers/food/drinks/bottle/cremeyvette
	name = "Creme de Yvette"
	desc = "Berry-flavoured alcohol, in a bottle."
	icon_state = "cremedeyvettebottle"
	center_of_mass = list("x" = 16,"y" = 6)
	Initialize()
		. = ..()
		reagents.add_reagent("cremeyvette", 100)

/obj/item/reagent_containers/food/drinks/bottle/brandy
	name = "brandy"
	desc = "Cheap knock off for cognac."
	icon_state = "brandybottle"
	center_of_mass = list("x" = 15,"y" = 8)
	Initialize()
		. = ..()
		reagents.add_reagent("brandy", 100)

/obj/item/reagent_containers/food/drinks/bottle/guinnes
	name = "Guinness"
	desc = "A bottle of good old Guinness."
	icon_state = "guinnes_bottle"
	center_of_mass = list("x" = 15,"y" = 4)
	Initialize()
		. = ..()
		reagents.add_reagent("guinnes", 100)

/obj/item/reagent_containers/food/drinks/bottle/drambuie
	name = "Drambuie"
	desc = "A bottle of Drambuie."
	icon_state = "drambuie_bottle"
	center_of_mass = list("x" = 16,"y" = 6)
	Initialize()
		. = ..()
		reagents.add_reagent("drambuie", 100)

/obj/item/reagent_containers/food/drinks/bottle/sbiten
	name = "sbiten"
	desc = "A bottle full of sweet sbiten."
	icon_state = "sbitenbottle"
	center_of_mass = list("x" = 16,"y" = 7)
	Initialize()
		. = ..()
		reagents.add_reagent("sbiten", 100)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	name = "messa's mead"
	desc = "A bottle of Messa's mead. Bottled somewhere in the icy world of Adhomai."
	icon_state = "messa_mead"
	center_of_mass = list("x" = 16,"y" = 5)
	description_fluff = "Adhomian beverages are commonly made with fermented grains or vegetables, if alcoholic, or juices mixed with sugar or honey. Victory gin is the most \
	widespread alcoholic drink in Adhomai, the result of the fermentation of honey extracted from Messa's tears, but its production and consumption is slowly declining due to the \
	People's Republic situation in the current conflict. Messa's mead is also another more traditional alternative, made with honey and fermented Earthen-Root juice."
	Initialize()
		. = ..()
		reagents.add_reagent("messa_mead", 100)

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
	name = "Xuizi Juice"
	desc = "Blended flower buds from the Xuizi cactus. It smells faintly of vanilla. Bottled by the Arizi Guild for over 200 years."
	icon_state = "xuizibottle"
	center_of_mass = list("x"=16, "y"=8)
	Initialize()
		. = ..()
		reagents.add_reagent("xuizijuice", 30)

/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	name = "Sarezhi Wine"
	desc = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	icon_state = "sarezhibottle"
	center_of_mass = list("x" = 16,"y" = 6)
	Initialize()
		. = ..()
		reagents.add_reagent("sarezhiwine", 100)

// Synnono Meme (Bottled) Drinks
//======================================
//

/obj/item/reagent_containers/food/drinks/bottle/boukha
	name = "Boukha Boboksa Classic"
	desc = "A distillation of figs, imported from the Serene Republic of Elyra. Makes an excellent apertif or digestif."
	icon_state = "boukhabottle"
	center_of_mass = list("x"=16, "y"=6)
	Initialize()
		. = ..()
		reagents.add_reagent("boukha", 100)

/obj/item/reagent_containers/food/drinks/bottle/whitewine
	name = "Doublebeard Bearded White Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "whitewinebottle"
	center_of_mass = list("x"=16, "y"=4)
	Initialize()
		. = ..()
		reagents.add_reagent("whitewine", 100)