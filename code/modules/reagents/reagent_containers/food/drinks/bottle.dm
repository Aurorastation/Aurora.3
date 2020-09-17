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
	shatter = TRUE
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
	if(!rag) return
	user.put_in_hands(rag)
	rag = null
	flags |= (initial(flags) & OPENCONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	if(rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		set_light(2)
	else
		set_light(0)
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
	name = "Alderamin gin"
	desc = "A bottle of average quality gin, produced on NanoTrasen Space Station Cepheus."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "ginbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/gin = 100)

/obj/item/reagent_containers/food/drinks/bottle/victorygin
	name = "Victory gin"
	desc = "Pour one out for Al'mari. His gun was on stun, bless his heart."
	icon_state = "victorygin"
	center_of_mass = list("x"=16, "y"=4)
	desc_fluff = "Adhomian beverages are commonly made with fermented grains or vegetables, if alcoholic, or juices mixed with sugar or honey. Victory gin is the most \
	widespread alcoholic drink in Adhomai, the result of the fermentation of honey extracted from Messa's tears, but its production and consumption is slowly declining due to the \
	People's Republic situation in the current conflict."
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/victorygin = 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Mu Cephei Special Reserve"
	desc = "An okayish single-malt whiskey, gently matured inside the maintenance tunnels of NSS Cepheus. TUNNEL WHISKEY RULES."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/whiskey/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/alcohol/ethanol/whiskey, 100)

/obj/item/reagent_containers/food/drinks/bottle/fireball
	name = "Delta Cephei Cinnamon Fireball"
	desc = "An okayish single-malt whiskey, infused with cinnamon and hot pepper inside the maintenance tunnels of NSS Cepheus. \
			It is sometimes claimed that Tunnel Runners came up with the current recipe for this drink."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/fireball = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Martian 50% Premium"
	desc = "Only potatoes grown in real imported Martian soil may be used for this premium vodka. Made by Silverport, drunk by Zavodskoi."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/vodka = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom
	name = "Magnitogorsk Import mushroom vodka"
	desc = "A mushroom-based vodka imported from the breweries of Himeo. Drinking too much of this will result in a personal permanent revolution."
	desc_fluff = "Vodka made from mushrooms is a local favourite on Himeo, due to the ease with which mushrooms can be grown under the planet's surface. This bottle is \
	from the Vodnik Breweries Syndicate in Magnitogorsk, arguably the most famous brewery on Himeo (though fans of the Coal Canary Syndicated Brewery in Highland City \
	would disagree). Drinkers of the world, unite!"
	icon_state = "mushroomvodkabottle"
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/vodka/mushroom = 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Chip’s Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "tequilabottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/tequila = 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "bottle of nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/datum/reagent/drink/nothing = 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Nojosuru Aromatic Bitters"
	desc = "Only the finest and highest quality herbs find their way into our cocktail bitters, both human <i>and</i> skrellian."
	desc_fluff = "This drink is made by Nojosuru Foods, a subsidiary of Zeng-Hu Pharmaceuticals, founded on Earth in 2252. \
				  They are known for their surprisingly affordable and incredible quality foods, as well as growing many crops used in pharmaceuticals and luxury items."
	icon_state = "bitters"
	center_of_mass = list("x"=16, "y"=9)

/obj/item/reagent_containers/food/drinks/bottle/bitters/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/alcohol/ethanol/bitters,40)

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Silverport’s Bubbliest champagne"
	desc = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "champagnebottle"
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/drinks/bottle/champagne/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/alcohol/ethanol/champagne,100)

/obj/item/reagent_containers/food/drinks/bottle/mintsyrup
	name = "Getmore’s Bold Peppermint"
	desc = "Minty fresh. Contains dyn (and just a little peppermint)."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "mint_syrup"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/datum/reagent/drink/mintsyrup = 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Cytherea Artiste patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy. It’s among some of the most expensive Silverport Quality Brand products, \
			perhaps due to demand rather than the actual cost of production."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/patron = 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Melinda's Cuban Spiced rum"
	desc = "If Getmore gets any alcohol right, it’s certainly rum. It’s practically GRIFF in a bottle."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/rum = 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = list("x"=17, "y"=10)
	drink_flags = NO_EMPTY_ICON
	reagents_to_add = list(/datum/reagent/water/holywater = 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Xinghua vermouth"
	desc = "Sweet, sweet dryness. Some alcohol critics say that the addition of dyn to the recipe ruins the drink, \
			but the average consumer doesn’t really notice the difference, and it’s cheaper to manufacture."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/vermouth = 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Nixiqi’s Happy Accident coffee liqueur"
	desc = "A particularly genius Skrell came up with the recipe by accident in a hydroponics lab by spilling coffee in their herbal concoction, or so the story goes."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "kahluabottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/coffee/kahlua = 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "Uptown Cytherean goldschlager"
	desc = "Not as sophisticated as Cytherea Artiste, but I guess if you <i>really</i> want to have pure gold in your drink..."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/goldschlager = 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Cytherea Golden Sweetness cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Savor this, and feel the real high life."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/cognac = 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Silverport Quality Brand red wine"
	desc = "Some consider this to be Silversun’s main cultural export."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/wine = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you’re gonna have a good time. Particularly artistic Cythereans drink this Silverport product to get inspired."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/absinthe = 100)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine melon liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor, made from a Silversun-grown variety of melon. Sweet and light, and surprisingly cheap considering the manufacturer."
	desc_fluff = DRINK_FLUFF_SILVERPORT
	icon_state = "alco-green"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = IS_GLASS | UNIQUE_EMPTY_ICON
	empty_icon_state = "alco-blue_empty"
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/melonliquor = 100)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Xuaousha curacao"
	desc = "A fruity, exceptionally azure drink. Thanks to weird Skrellian genetic experiments, oranges used for this are, in fact, really blue."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "alco-blue"
	empty_icon_state = "alco-clear"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/bluecuracao = 100)

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Getmore’s Tangy grenadine syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "grenadinebottle"
	drink_flags = IS_GLASS | NO_EMPTY_ICON
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/datum/reagent/drink/grenadine = 100)

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "space cola"
	desc = "Cola. In space."
	icon_state = "colabottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/datum/reagent/drink/space_cola = 100)
	shatter_material = MATERIAL_PLASTIC
	shatter = FALSE

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/datum/reagent/drink/spaceup = 100)
	shatter_material = MATERIAL_PLASTIC
	shatter = FALSE

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = list("x"=16, "y"=6)
	drink_flags = NO_EMPTY_ICON
	drop_sound = 'sound/items/drop/shoes.ogg'
	pickup_sound = 'sound/items/pickup/shoes.ogg'
	reagents_to_add = list(/datum/reagent/drink/spacemountainwind = 100)
	shatter_material = MATERIAL_PLASTIC
	shatter = FALSE

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Chip Getmore's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/pwine = 100)

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
	name = "Ultimate Quality beer"
	desc = "Contains only water, malt and hops. Not really as high-quality as the name says, but it’s still popular."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "beer"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/alcohol/ethanol/beer = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Magm-ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/datum/reagent/alcohol/ethanol/ale = 30)

//aurora's drinks

/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen
	name = "Nralakk Touch green chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "chartreusegreenbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/chartreusegreen = 100)

/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow
	name = "Nralakk Touch yellow chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "chartreuseyellowbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/chartreuseyellow = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremewhite
	name = "Xinghua White Mint"
	desc = "Mint-flavoured alcohol, in a bottle."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "whitecremebottle"
	center_of_mass = list("x" = 16,"y" = 5)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/cremewhite = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremeyvette
	name = "Xinghua Delicate Violet"
	desc = "Berry-flavoured alcohol, in a bottle."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "cremedeyvettebottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/cremeyvette = 100)

/obj/item/reagent_containers/food/drinks/bottle/brandy
	name = "Admiral Cindy's brandy"
	desc = "Cheap knock off for Silverport cognac; Getmore’s attempt to ride off the cognac fad of the 2420s."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "brandybottle"
	center_of_mass = list("x" = 15,"y" = 8)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/brandy = 100)

/obj/item/reagent_containers/food/drinks/bottle/guinness
	name = "Guinness"
	desc = "A bottle of good old Guinness."
	icon_state = "guinness_bottle"
	center_of_mass = list("x" = 15,"y" = 4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/guinness = 100)

/obj/item/reagent_containers/food/drinks/bottle/drambuie
	name = "Xinghua Honeyed Satisfaction"
	desc = "A bottle of trendy whiskey with genetically modified barley. The exact genome is a closely-guarded secret, but it tastes sweet and slightly herbal."
	desc_fluff = DRINK_FLUFF_ZENGHU
	icon_state = "drambuie_bottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/drambuie = 100)

/obj/item/reagent_containers/food/drinks/bottle/sbiten
	name = "Getmore’s Traditional Sbiten"
	desc = "A drink that died, then got revived, then died again, and became a fad <i>again</i> now thanks to Getmore having a surplus of honey."
	desc_fluff = DRINK_FLUFF_GETMORE
	icon_state = "sbitenbottle"
	center_of_mass = list("x" = 16,"y" = 7)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/sbiten = 100)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	name = "messa's mead"
	desc = "A bottle of Messa's mead. Bottled somewhere in the icy world of Adhomai."
	icon_state = "messa_mead"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_fluff = "Adhomian beverages are commonly made with fermented grains or vegetables, if alcoholic, or juices mixed with sugar or honey. Victory gin is the most \
	widespread alcoholic drink in Adhomai, the result of the fermentation of honey extracted from Messa's tears, but its production and consumption is slowly declining due to the \
	People's Republic situation in the current conflict. Messa's mead is also another more traditional alternative, made with honey and fermented Earthen-Root juice."
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/messa_mead = 100)

/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Shokyodo Sake"
	desc = "A rice-based alcohol produced and marketed by Nojosuru Foods. While frequently described as rice wine, its production shares more in common with beer."
	desc_fluff = "Brewed in Nojosuru's facilities in Akita Prefecture, Japan, Shokyodo Sake is marketed as a premium good reflecting its lineage from Earth. \
	Despite its high level of quality and pleasing taste, it has never gained much popularity outside of Sol and the Inner Colonies owing to its high cost and Konyang-based \
	competitors."
	icon_state = "sakebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/sake = 100)

/obj/item/reagent_containers/food/drinks/bottle/soju
	name = "Boryeong '45 soju"
	desc = "A rice-based liquor commonly consumed by the non-synthetic residents of Konyang. This particular brand originates from the city of Boreyeong, on Konyang."
	desc_fluff = "While most commonly associated with Konyang, soju can be found throughout the Sol Alliance thanks to the inexpensive cost of producing it and a successful \
	marketing campaign carried out during the robotics boom on Konyang. It is traditionally consumed neat, or without mixing any other liquids into it. The '45 in this brand's \
	name refers to its alcohol by volume content, and not a calendar year."
	icon_state = "sojubottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/soju = 100)

/obj/item/reagent_containers/food/drinks/bottle/makgeolli
	name = "Doctor Kyung's makgeolli"
	desc = "A rice wine imported from Konyang with a very low alcohol content, makegeolli is commonly consumed during social events on Konyang. This bottle has a smiling man \
	wearing a labcoat on its label."
	desc_fluff = "Doctor Gyeong Kyung, PhD., is considered to be one of the Point Verdant Terraneus Institute of AI Research's premiere scholars, and is commonly seen at robotics \
	conferences throughout the Orion Spur. He has also proven to be a fairly successful hobbyist brewer on the side, as seen by this very successful brand. Due to its association \
	with the PVTI, Doctor Kyung's makegeolli is partially funded by Einstein Engines. This has not stopped it from becoming popular even in NanoTrasen-dominated areas, as it \
	really is just that good."
	icon_state = "makgeollibottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/makgeolli = 100)

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
	name = "Xuizi Juice"
	desc = "Blended flower buds from the Xuizi cactus. It smells faintly of vanilla. Bottled by the Arizi Guild for over 200 years."
	icon_state = "xuizibottle"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/datum/reagent/alcohol/butanol/xuizijuice = 30)

/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	name = "Sarezhi Wine"
	desc = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	icon_state = "sarezhibottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/datum/reagent/alcohol/butanol/sarezhiwine = 100)

// Synnono Meme (Bottled) Drinks
//======================================
//

/obj/item/reagent_containers/food/drinks/bottle/boukha
	name = "Boukha Boboksa Classic"
	desc = "A distillation of figs, imported from the Serene Republic of Elyra. Makes an excellent apertif or digestif."
	icon_state = "boukhabottle"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/boukha = 100)

/obj/item/reagent_containers/food/drinks/bottle/whitewine
	name = "Doublebeard Bearded White Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "whitewinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/datum/reagent/alcohol/ethanol/whitewine = 100)
