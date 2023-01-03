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
	hitsound = /decl/sound_category/bottle_hit_intact_sound
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	matter = list(MATERIAL_GLASS = 800)

	var/obj/item/reagent_containers/glass/rag/rag = null
	var/rag_underlay = "rag"
	drink_flags = IS_GLASS

/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
	rag = null
	return ..()

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, var/speed)
	..()

	var/mob/M = thrower
	if((drink_flags & IS_GLASS) && istype(M) && M.a_intent == I_HURT)
		var/throw_dist = get_dist(throw_source, loc)
		if(speed >= throw_speed && smash_check(throw_dist)) //not as reliable as smashing directly
			if(reagents)
				hit_atom.visible_message("<span class='notice'>The contents of \the [src] splash all over [hit_atom]!</span>")
				reagents.splash(hit_atom, reagents.total_volume)
			src.smash(loc, hit_atom)

/obj/item/reagent_containers/food/drinks/bottle/proc/smash_check(var/distance)
	if(!(drink_flags & IS_GLASS) || !smash_duration)
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
	B.icon_state = initial(icon_state)

	var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src, /decl/sound_category/glass_break_sound, 70, 1)
	src.transfer_fingerprints_to(B)

	qdel(src)
	return B

/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/W, mob/user)
	if(!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if(rag && W.isFlameSource())
		rag.attackby(W, user)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user)
	if(rag)
		remove_rag(user)
	else
		..()

/obj/item/reagent_containers/food/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R, mob/user)
	if(!(drink_flags & IS_GLASS) || rag)
		return
	if(user.unEquip(R))
		to_chat(user, "<span class='notice'>You stuff [R] into [src].</span>")
		rag = R
		rag.forceMove(src)
		flags &= ~OPENCONTAINER
		update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag)
		return
	user.put_in_hands(rag)
	rag = null
	flags |= (initial(flags) & OPENCONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/delete_rag()
	if(!rag)
		return
	QDEL_NULL(rag)
	flags |= (initial(flags) & OPENCONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	set_light(0)
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		if(rag.on_fire)
			set_light(2, l_color = LIGHT_COLOR_FIRE)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack(mob/living/target, mob/living/user, var/hit_zone)
	var/blocked = ..()

	if(user.a_intent != I_HURT)
		return
	if(target == user)  //A check so you don't accidentally smash your brains out while trying to get your drink on.
		var/confirm = alert("Do you want to smash the bottle on yourself?","Hit yourself?","No", "Yeah!", "Splash Reagents")
		if(confirm == "No")
			return 1 //prevents standard_splash_mob on return
		if(confirm == "Splash Reagents")
			return //standard_splash_mob will still play on return, in case we want to douse ourselves in reagents.
	if(!smash_check(1))
		return //won't always break on the first hit

	// You are going to knock someone out for longer if they are not wearing a helmet.
	var/weaken_duration = 0
	if(blocked < 100)
		weaken_duration = smash_duration + min(0, force - target.get_blocked_ratio(hit_zone, BRUTE) * 100 + 10)

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
	sharp = TRUE
	edge = FALSE
	hitsound = /decl/sound_category/bottle_hit_broken
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")
	w_class = ITEMSIZE_SMALL

#define DRINK_FLUFF_GETMORE  "This drink is made by Getmore Corporation, a subsidiary of NanoTrasen. It mostly specializes in fast food and consumer food products, \
							   but also makes average quality alcohol. Many can find Getmore products in grocery stores, vending machines, \
							   and fast food restaurants all under the Getmore brand."

#define DRINK_FLUFF_ZENGHU    "This drink is made by Zeng-Hu Pharmaceuticals, a trans-stellar medical research and pharmaceutical conglomerate that has heavy ties with Skrell. \
							   With a big genetics and xenobiology division, it has also revolutionized the production of some old Terran alcohol."

#define DRINK_FLUFF_SILVERPORT "This drink is made by Silverport Quality Brand, an Idris subsidiary that focuses on production of expensive, extremely high-quality drinks. \
								Its facilities can be found on both Silversun and Venus, but the Cytherean part of Venus are its main consumers. \
								Still, Silverport has excellent reputation all across the Orion Spur."


/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Borovicka gin"
	desc = "A bottle of good quality gin. Previously a mainstay in bars throughout the spur, it has become scarcer since \
			the Solarian collapse, only remaining in stock thanks to Idris ownership of the Visegradi facilities that produce it."
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/gin = 100)

/obj/item/reagent_containers/food/drinks/bottle/victorygin
	name = "Victory gin"
	desc = "Pour one out for Al'mari. His gun was on stun, bless his heart."
	icon_state = "victorygin"
	center_of_mass = list("x"=16, "y"=4)
	desc_extended = "Considered the official drink of the People's Republic of Adhomai, Victory Gin was created to celebrate the end of the revolution. It is commonly found in NanoTrasen's \
	facilities, due to a contract that allows the government to supply the corporation, and in the Tajaran communities of Tau Ceti. The destruction of Victory Gin's bottles and reserves \
	was widespread when Republican positions and cities were taken by the opposition as the drink is deemed by many as a symbol of the Hadiist regime."
	reagents_to_add = list(/decl/reagent/alcohol/victorygin = 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Mu Cephei Special Reserve"
	desc = "An okayish single-malt whiskey. This one is produced mainly in New Valletta on Callisto and is fairly famous among Cythereans, too. It's great to get you \
	in the right mindset for your tenth night out clubbing in a row!"
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/whiskey = 100)

/obj/item/reagent_containers/food/drinks/bottle/fireball
	name = "Delta Cephei Cinnamon Fireball"
	desc = "An okayish single-malt whiskey, infused with cinnamon and hot pepper that used to be mainly produced on Mars, but the production line was since moved to Earth for geopolitical reasons. \
	It is sometimes claimed that particularly desperate Eridanian dregs came up with the current recipe for this drink."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/fireball = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Martian 50% Premium"
	desc = "Only potatoes grown in real imported Martian soil may be used for this premium vodka (imports of Martian soil may have stopped). Made by Silverport, drunk by Zavodskoi."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/vodka = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom
	name = "Inverkeithing Import mushroom vodka"
	desc = "A mushroom-based vodka imported from the breweries of Inverkeithing on Himeo. Drinking too much of this will result in a personal permanent revolution."
	desc_extended = "Vodka made from mushrooms is a local favourite on Himeo, due to the ease with which mushrooms can be grown under the planet's surface. This bottle is \
	from the Schwarzer Drache Breweries Syndicate in Inverkeithing, arguably the most famous brewery on Himeo due to its historical reputation. It is also the most famous brand \
	of mushroom vodka among non-Himeans because of Inverkeithing's developing tourism industry. Drinkers of the world (and beyond), unite!"
	icon_state = "mushroomvodkabottle"
	reagents_to_add = list(/decl/reagent/alcohol/vodka/mushroom = 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Nathan's Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients! This particular line of tequila has Nathan Trasen's signature on the label and his approval, \
	as can be commonly seen and heard in Getmore's many advertisements for this line. Astute observers may however note the absolute lack of emotion on Trasen's face while reciting his love for Getmore tequila on television."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "tequilabottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/tequila = 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "bottle of nothing"
	desc = "A bottle filled with nothing."
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/decl/reagent/drink/nothing = 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Nojosuru Aromatic Bitters"
	desc = "Only the finest and highest quality herbs find their way into our cocktail bitters, both human <i>and</i> skrellian."
	desc_extended = "This drink is made by Nojosuru Foods, a subsidiary of Zeng-Hu Pharmaceuticals, founded on Earth in 2252. \
				  They are known for their surprisingly affordable and incredible quality foods, as well as growing many crops used in pharmaceuticals and luxury items."
	icon_state = "bitters"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/decl/reagent/alcohol/bitters = 40)

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Silverport's Bubbliest champagne"
	desc = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades. This champagne is an absolute mainstay on Venus, used everywhere from appetizers to celebrations to \
	cocktail creation, where it shines the most. If you haven't got a bottle of Silverport's Bubbliest in your fridge, are you <i>really</i> a Cytherean? The advertisements for this line say no!"
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "champagnebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/champagne = 100)

/obj/item/reagent_containers/food/drinks/bottle/mintsyrup
	name = "Getmore's Bold Peppermint"
	desc = "Minty fresh. Contains dyn (and just a little peppermint)."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "mint_syrup"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/decl/reagent/drink/mintsyrup = 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Cytherea Artiste patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy. It's among some of the most expensive Silverport Quality Brand products, \
	perhaps due to demand rather than the actual cost of production."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/decl/reagent/alcohol/patron = 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Undirstader Broeckhouser rum"
	desc = "If Getmore gets any alcohol right, it's certainly rum, according to (most) New Gibsoners (only Ovanstaders were polled)! This is <b>real</b>, <i><b>GENUINE</b></i> Undirstader rum, made using <b>OLD WORLD</b> recipes! The most authentic \
	Undirstader drink in Getmore's wide arsenal! Or so the advertisements say. Undirstader critics often point to this rum as a corporate mockery of their culture, yet it remains the most \
	popular Getmore product in New Gibson's Ovanstads by far, and most people simply know it as a famous Undirstader drink produced by Getmore."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/rum = 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = list("x"=17, "y"=10)
	drink_flags = NO_EMPTY_ICON
	reagents_to_add = list(/decl/reagent/water/holywater = 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Xinghua vermouth"
	desc = "Sweet, sweet dryness. Some alcohol critics say that the addition of dyn to the recipe ruins the drink, \
	but the average consumer doesn't really notice the difference, and it's cheaper to manufacture."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/vermouth = 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Nixiqi's Happy Accident coffee liqueur"
	desc = "A particularly genius Skrell came up with the recipe by accident in a hydroponics lab by spilling coffee in their herbal concoction, or so the story goes."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "kahluabottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/decl/reagent/alcohol/coffee/kahlua = 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "Uptown Cytherean goldschlager"
	desc = "Not as sophisticated as Cytherea Artiste, but I guess if you <i>really</i> want to have pure gold in your drink..."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/goldschlager = 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Cytherea Golden Sweetness cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Savor this, and feel the real high life."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/cognac = 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Silverport Quality Brand red wine"
	desc = "Some consider this to be Silversun's main cultural export."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/wine = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time. Particularly artistic Cythereans drink this Silverport product to get inspired."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/decl/reagent/alcohol/absinthe = 100)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine melon liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor, made from a Silversun-grown variety of melon. Sweet and light, and surprisingly cheap considering the manufacturer."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "alco-green"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = IS_GLASS | UNIQUE_EMPTY_ICON
	empty_icon_state = "alco-blue_empty"
	reagents_to_add = list(/decl/reagent/alcohol/melonliquor = 100)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Xuaousha curacao"
	desc = "A fruity, exceptionally azure drink. Thanks to weird Skrellian genetic experiments, oranges used for this are, in fact, really blue."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "alco-blue"
	empty_icon_state = "alco-clear"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/decl/reagent/alcohol/bluecuracao = 100)

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Getmore's Tangy grenadine syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "grenadinebottle"
	drink_flags = IS_GLASS | NO_EMPTY_ICON
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/decl/reagent/drink/grenadine = 100)

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "comet cola"
	desc = "Getmore's most popular line of soda. A generic cola, otherwise."
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/decl/reagent/drink/space_cola = 100)
	shatter_material = MATERIAL_PLASTIC
	fragile = 0

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Vacuum Fizz"
	desc = "Tastes like a hull breach in your mouth."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/decl/reagent/drink/spaceup = 100)
	shatter_material = MATERIAL_PLASTIC
	fragile = 0

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Stellar Jolt"
	desc = "For those who have a need for caffeine stronger than would be sensible."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/decl/reagent/drink/spacemountainwind = 100)
	shatter_material = MATERIAL_PLASTIC
	fragile = 0

/obj/item/reagent_containers/food/drinks/bottle/hrozamal_soda
	name = "Hro'zamal Soda"
	desc = "A bottle of Hro'zamal Soda. Made with Hro'zamal Ras'Nifs powder and bottled in the People's Republic of Adhomai."
	desc_extended = "Hro'zamal Soda is a soft drink made from the seed's powder of a plant native to Hro'zamal, the sole Hadiist colony. While initially consumed as a herbal tea by the \
	colonists, it was introduced to Adhomai by the Army Expeditionary Force and transformed into a carbonated drink. The beverage is popular with factory workers and university \
	students because of its stimulant effect."
	icon_state = "hrozamal_soda_bottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/decl/reagent/drink/hrozamal_soda = 100)
	fragile = FALSE

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Chip Getmore's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/pwine = 100)

//Small bottles
/obj/item/reagent_containers/food/drinks/bottle/small
	name = "small bottle"
	desc = "A small bottle."
	icon_state = "beer"
	volume = 50
	smash_duration = 1
	flags = 0 //starts closed
	rag_underlay = "rag_small"

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "Virklunder beer"
	desc = "Contains only water, malt and hops. Not really as high-quality as the label says, but it's still popular. This particular line of beer is made by Getmore on New Gibson, specifically in the Ovanstad of \
	Virklund in a massive beer brewery complex. It quickly became the most consumed kind of beer across the Republic of Biesel and has since been in stock in practically every bar across the nation."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/decl/reagent/alcohol/beer = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Burszi-ale"
	desc = "Manufactured in Virklund on New Gibson by Getmore, this is a true Burszian's drink of choice. That is, if you're not an IPC. You wouldn't be able to buy this ale then. Or think of buying it. Or afford it."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/decl/reagent/alcohol/ale = 30)

//aurora's drinks

/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen
	name = "Nralakk Touch green chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "chartreusegreenbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/decl/reagent/alcohol/chartreusegreen = 100)

/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow
	name = "Nralakk Touch yellow chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "chartreuseyellowbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/decl/reagent/alcohol/chartreuseyellow = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremewhite
	name = "Xinghua White Mint"
	desc = "Mint-flavoured alcohol, in a bottle."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "whitecremebottle"
	center_of_mass = list("x" = 16,"y" = 5)
	reagents_to_add = list(/decl/reagent/alcohol/cremewhite = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremeyvette
	name = "Xinghua Delicate Violet"
	desc = "Berry-flavoured alcohol, in a bottle."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "cremedeyvettebottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/decl/reagent/alcohol/cremeyvette = 100)

/obj/item/reagent_containers/food/drinks/bottle/brandy
	name = "Admiral Cindy's brandy"
	desc = "Cheap knock off for Silverport cognac; Getmore's attempt to ride off the cognac fad of the 2420s."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "brandybottle"
	center_of_mass = list("x" = 15,"y" = 8)
	reagents_to_add = list(/decl/reagent/alcohol/brandy = 100)

/obj/item/reagent_containers/food/drinks/bottle/guinness
	name = "Guinness"
	desc = "A bottle of good old Guinness. Manufactured by Getmore in a District 3 brewery in Mendell City. It is one of Getmore's most basic and least flashy lines of alcohol."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "guinness_bottle"
	center_of_mass = list("x" = 15,"y" = 4)
	reagents_to_add = list(/decl/reagent/alcohol/guinness = 100)

/obj/item/reagent_containers/food/drinks/bottle/drambuie
	name = "Xinghua Honeyed Satisfaction"
	desc = "A bottle of trendy whiskey with genetically modified barley. The exact genome is a closely-guarded secret, but it tastes sweet and slightly herbal."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "drambuie_bottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/decl/reagent/alcohol/drambuie = 100)

/obj/item/reagent_containers/food/drinks/bottle/sbiten
	name = "Getmore's Traditional Sbiten"
	desc = "A drink that died, then got revived, then died again, and became a fad <i>again</i> now thanks to Getmore having a surplus of honey."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "sbitenbottle"
	center_of_mass = list("x" = 16,"y" = 7)
	reagents_to_add = list(/decl/reagent/alcohol/sbiten = 100)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	name = "messa's mead"
	desc = "A bottle of Messa's mead. Bottled somewhere in the icy world of Adhomai."
	icon_state = "messa_mead"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A fermented alcoholic drink made from earthen-root juice and Messa's tears leaves. It has a relatively low alcohol content and characteristic honey flavor. \
	Messa's Mead is one of the most popular alcoholic drinks in Adhomai; it is consumed both during celebrations and daily meals. Any proper Adhomian bar will have at least a keg or \
	some bottles of the mead."
	reagents_to_add = list(/decl/reagent/alcohol/messa_mead = 100)

/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Shokyodo Sake"
	desc = "A rice-based alcohol produced and marketed by Nojosuru Foods. While frequently described as rice wine, its production shares more in common with beer."
	desc_extended = "Brewed in Nojosuru's facilities in Akita Prefecture, Japan, Shokyodo Sake is marketed as a premium good reflecting its lineage from Earth. \
	Despite its high level of quality and pleasing taste, it has never gained much popularity outside of Sol and the Inner Colonies owing to its high cost and Konyang-based \
	competitors."
	icon_state = "sakebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/sake = 100)

/obj/item/reagent_containers/food/drinks/bottle/soju
	name = "Boryeong '45 soju"
	desc = "A rice-based liquor commonly consumed by the non-synthetic residents of Konyang. This particular brand originates from the city of Boreyeong, on Konyang."
	desc_extended = "While most commonly associated with Konyang, soju can be found throughout the Sol Alliance thanks to the inexpensive cost of producing it and a successful \
	marketing campaign carried out during the robotics boom on Konyang. It is traditionally consumed neat, or without mixing any other liquids into it. The '45 in this brand's \
	name refers to its alcohol by volume content, and not a calendar year."
	icon_state = "sojubottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/soju = 100)

/obj/item/reagent_containers/food/drinks/bottle/makgeolli
	name = "Doctor Kyung's makgeolli"
	desc = "A rice wine imported from Konyang with a very low alcohol content, makegeolli is commonly consumed during social events on Konyang. This bottle has a smiling man \
	wearing a labcoat on its label."
	desc_extended = "Doctor Gyeong Kyung, PhD., is considered to be one of the Point Verdant Terraneus Institute of AI Research's premiere scholars, and is commonly seen at robotics \
	conferences throughout the Orion Spur. He has also proven to be a fairly successful hobbyist brewer on the side, as seen by this very successful brand. Due to its association \
	with the PVTI, Doctor Kyung's makegeolli is partially funded by Einstein Engines. This has not stopped it from becoming popular even in NanoTrasen-dominated areas, as it \
	really is just that good."
	icon_state = "makgeollibottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/decl/reagent/alcohol/makgeolli = 100)

/obj/item/reagent_containers/food/drinks/bottle/small/khlibnyz
	name = "khlibnyz"
	desc = "A bottle traditionally made khlibnyz. Likely prepared in some Hadiist communal farm."
	icon_state = "khlibnyz"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A fermented beverage produced from Adhomian bread. Herbs, fruits, and tree sap can be added for flavoring. It is considered a non-alcoholic drink by Adhomian standards \
	because of its very low alcohol content. Khlibnyz was mainly consumed by peasants during pre-contact times and is still very popular with the Hadiist rural population. Communal farms \
	will brew their own Khlibnyz and sell it to the government for distribution."
	reagents_to_add = list(/decl/reagent/alcohol/khlibnyz = 30)

/obj/item/reagent_containers/food/drinks/bottle/shyyrkirrtyr_wine
	name = "shyyr kirr'tyr wine"
	desc = "Tajaran spirit infused with some eel-like Adhomian creature. The animal floating in the liquid appears to be well preserved."
	icon_state = "shyyrkirrtyrwine"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "An alcoholic made by infusing a whole Shyyr Kirr'tyr in Dirt Berries or Earthen-Root spirit. The Water Snake Devil's poison is neutralized by ethanol, making the \
	beverage safe to consume. The wine can be deadly if improperly prepared. The drink is native to the Southeast Harr'masir wetlands, where it is as common as Messa's Mead. Other \
	Tajara consider the wine to be exotic or outright disgusting. The Shyyr Kirr'tyr is usually eaten after the beverage is imbibed."
	reagents_to_add = list(/decl/reagent/alcohol/shyyrkirrtyr_wine = 100)

/obj/item/reagent_containers/food/drinks/bottle/nmshaan_liquor
	name = "nm'shaan liquor"
	desc = "A strong Adhomian liquor reserved for special occasions. A label on the bottle recommends diluting it with icy water before drinking."
	icon_state = "nmshaanliquor"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "An alcoholic drink manufactured from the fruit of the Nm'shaan plant. It usually has a high level of alcohol by volume. Nm'shaan liquor was once reserved for the \
	consumption of the nobility; even today it is considered a decadent drink reserved for fancy occasions."
	reagents_to_add = list(/decl/reagent/alcohol/nmshaan_liquor = 100)

/obj/item/reagent_containers/food/drinks/bottle/small/midynhr_water
	name = "midynhr water"
	desc = "A soft drink made from honey and tree syrup. The label claims it is good as the tap version."
	icon_state = "midynhrwater"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A soft drink based on Yve'kha's honey and tree syrups. The drink has a creamy consistency and is served cold from the tap of traditional soda fountains. Native to \
	Das'nrra, the beverage is now widespread in the Al'mariist territories. Bottled versions exist, but they are considered to be inferior to what is served in bars and restaurants."
	reagents_to_add = list(/decl/reagent/drink/midynhr_water = 30)

/obj/item/reagent_containers/food/drinks/bottle/veterans_choice
	name = "veteran's choice"
	desc = "A home-made bottle of veteran's choice. Shake it carefully before serving."
	icon_state = "veteranschoice"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A cocktail consisting of Messa's Mead and gunpowder. Supposedly originated among the ranks of the Liberation Army as an attempt to spice up the mead, the cocktail \
	became a hit - not because of its taste - with the young Tajara. Drinking the Veteran's Choice is seen as a way to display one's bravado. ALA soldiers are known to consume the cocktail before going into battle believing that it brings luck."
	reagents_to_add = list(/decl/reagent/alcohol/veterans_choice = 100)

/obj/item/reagent_containers/food/drinks/bottle/treebark_firewater
	name = "tree-bark firewater"
	desc = "A jug full of adhomian moonshine. The bottle states dubiously that it is a handmade recipe."
	icon_state = "treebarkfirewater"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "High-content alcohol distilled from Earthen-Root or Blizzard Ears. Tree bark is commonly added to the drink to give it a distinct flavor. The firewater's origins can \
	be traced back to the pre-contact times where impoverished peasants would make alcohol out of anything they could find. Homebrewing remains a tradition in the New Kingdom's rural \
	parts. These traditional spirits are also manufactured by large breweries and sold to the urban population as handcrafted."
	reagents_to_add = list(/decl/reagent/alcohol/treebark_firewater = 100)
	drink_flags = NO_EMPTY_ICON

/obj/item/reagent_containers/food/drinks/bottle/darmadhir_brew
	name = "Darmadhir Brew"
	desc = "A fancy bottle contained sought-after Darmadhir's nm'shaan liquor. It is more of a collection piece than a beverage."
	icon_state = "darmadhirbrew"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A famous variation of the Nm'shaan Liquor; it is described as one of Adhomai's finest spirits. It is produced solely by a small family-owned brewery in Miran'mir. Its \
	recipe is a secret passed down through the generations of the Darmadhir household since immemorial times. The only living member of the family, Hazyr Darmadhir, is a 68 years old \
	Tajara. His sole heir and son died in the Second Revolution after being drafted to fight for the royal army. Alcohol collectors stipulate that the brew's price will skyrocket after Hazyr's death."
	reagents_to_add = list(/decl/reagent/alcohol/nmshaan_liquor/darmadhirbrew = 100)
	drink_flags = NO_EMPTY_ICON

/obj/item/reagent_containers/food/drinks/bottle/pulque
	name = "Don Augusto's pulque"
	desc = "A glass bottle of Mictlanian pulque. The label states that it is still produced by hand."
	desc_extended = "Don Augusto's pulqlueria is a famous saloon in Lago de Abundancia, known for its quality pulque. After Idris invested in the city, the family-owned business became part of the \
	megacorporation. Nowadays, it is bottled and sold all around the galaxy."
	icon_state = "pulquebottle"
	center_of_mass = list("x" = 16, "y" = 5)
	reagents_to_add = list(/decl/reagent/alcohol/pulque = 100)

/obj/item/reagent_containers/food/drinks/bottle/vintage_wine //can't make it a child of wine, or else reagents double-fill
	name = "Vintage Wine"
	desc = "A fine bottle of high-quality wine, produced in a small batch and aged for decades, if not centuries. It's likely that few bottles like it remain."
	icon_state = "vwinebottle"
	desc_extended = "Small-batch wines produced by local, independent wineries are highly sought-after by those who can afford them. They are considered highly-collectable items \
	due to how relatively few exist compared to more mass-produced wines. The attention to detail can be seen in the bottle, and felt in the taste. While megacorporations and their \
	subsidiaries don't produce bad products, wine afficianados across the spur agree that nothing comes close to these locally-produced treasures. They can easily be worth thousands of credits."
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/wine/vintage = 100)

/obj/item/reagent_containers/food/drinks/bottle/vintage_wine/Initialize()
	. = ..()
	name = pick("Triesto Pre-Dimming Sangiovese", "New Beirut 2340", "Vysokan Artisans Merlot", "Silver Seas Original Merlot", "Domelkos Morozian Treasure", "Belle Cote Serene Moth 2395",
			"Malta Sol Nebbiolo", "Ashkhaimi Gardens Shiraz", "Old Cairo 2375", "Artisan Empire 2354")

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
	name = "Xuizi Juice"
	desc = "Blended flower buds from the Xuizi cactus. It smells faintly of vanilla. Bottled by the Arizi Guild for over 200 years."
	icon_state = "xuizibottle"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/decl/reagent/alcohol/butanol/xuizijuice = 30)

/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	name = "Sarezhi Wine"
	desc = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	icon_state = "sarezhibottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/decl/reagent/alcohol/butanol/sarezhiwine = 100)

// Synnono Meme (Bottled) Drinks
//======================================
//

/obj/item/reagent_containers/food/drinks/bottle/boukha
	name = "Boukha Boboksa Classic"
	desc = "A distillation of figs, imported from the Serene Republic of Elyra. Makes an excellent apertif or digestif."
	icon_state = "boukhabottle"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/decl/reagent/alcohol/boukha = 100)

/obj/item/reagent_containers/food/drinks/bottle/whitewine
	name = "Pineneedle Brand white wine"
	desc = "A mediocre quality white wine, intended more for making spritzers than for drinking by itself. Produced on Visegrad by Idris."
	icon_state = "whitewinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/decl/reagent/alcohol/whitewine = 100)
