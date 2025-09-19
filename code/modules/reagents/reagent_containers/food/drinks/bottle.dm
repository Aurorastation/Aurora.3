///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

/obj/item/reagent_containers/food/drinks/bottle
	name = "glass bottle"
	desc = "This blank bottle is unyieldingly anonymous, offering no clues to its contents."
	icon_state = "glassbottle"
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi'
	filling_states = "10;20;30;40;50;60;70;80;90;100"
	amount_per_transfer_from_this = 5//Smaller sip size for more BaRP and less guzzling a litre of vodka before you realise it
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	force = 11
	hitsound = /singleton/sound_category/bottle_hit_intact_sound
	var/smash_duration = 5 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	matter = list(MATERIAL_GLASS = 800)

	var/obj/item/reagent_containers/glass/rag/rag = null
	var/rag_underlay = "rag"
	drink_flags = IS_GLASS

/obj/item/reagent_containers/cup/glass/bottle/small
	name = "small glass bottle"
	desc = "This blank bottle is unyieldingly anonymous, offering no clues to its contents."
	icon_state = "glassbottlesmall"
	volume = 50

/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if(rag)
		rag.forceMove(src.loc)
	rag = null
	return ..()

//when thrown on impact, bottles smash and spill their contents
/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()

	var/mob/M = throwingdatum?.thrower?.resolve()
	if((drink_flags & IS_GLASS) && istype(M) && M.a_intent == I_HURT)
		var/throw_dist = get_dist(get_turf(M), get_turf(src))
		if(throwingdatum.speed >= throw_speed && smash_check(throw_dist)) //not as reliable as smashing directly
			if(reagents)
				hit_atom.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over [hit_atom]!"))
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

/obj/item/reagent_containers/food/drinks/bottle/proc/smash(var/newloc, atom/against = null, var/break_top)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	var/obj/item/broken_bottle/B = new /obj/item/broken_bottle(newloc)
	if(prob(33))
		new/obj/item/material/shard(newloc) // Create a glass shard at the target's location!
	B.icon_state = initial(icon_state)

	var/icon/I = new(src.icon, src.icon_state)
	if(break_top) //if the bottle breaks its top off instead of the bottom
		desc = "A bottle with its neck smashed off."
		I.Blend(B.flipped_broken_outline, ICON_OVERLAY, rand(5), 0)
	else
		I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	if(rag && rag.on_fire && isliving(against))
		rag.forceMove(loc)
		var/mob/living/L = against
		L.IgniteMob()

	playsound(src, /singleton/sound_category/glass_break_sound, 70, 1)
	src.transfer_fingerprints_to(B)

	qdel(src)
	return B

/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/attacking_item, mob/user)
	if(!rag && istype(attacking_item, /obj/item/reagent_containers/glass/rag))
		insert_rag(attacking_item, user)
		return
	if(rag && attacking_item.isFlameSource())
		rag.attackby(attacking_item, user)
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
		to_chat(user, SPAN_NOTICE("You stuff [R] into [src]."))
		rag = R
		rag.forceMove(src)
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if(!rag)
		return
	user.put_in_hands(rag)
	rag = null
	atom_flags |= (initial(atom_flags) & ATOM_FLAG_OPEN_CONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/proc/delete_rag()
	if(!rag)
		return
	QDEL_NULL(rag)
	atom_flags |= (initial(atom_flags) & ATOM_FLAG_OPEN_CONTAINER)
	update_icon()

/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if(rag)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/update_icon()
	underlays.Cut()
	ClearOverlays()
	if("[icon_state]-[get_filling_state()]" in icon)
		if(reagents?.total_volume)
			var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]-[get_filling_state()]")
			filling.color = reagents.get_color()
			AddOverlays(filling)
	set_light(0)
	if(rag)
		var/underlay_image = image(icon='icons/obj/item/reagent_containers/food/drinks/drink_effects.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		if(rag.on_fire)
			set_light(2, l_color = LIGHT_COLOR_FIRE)
		return
	..()

/obj/item/reagent_containers/food/drinks/bottle/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/blocked = ..()

	if(user.a_intent != I_HURT)
		return
	if(target_mob == user)  //A check so you don't accidentally smash your brains out while trying to get your drink on.
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
		weaken_duration = smash_duration + min(0, force - target_mob.get_blocked_ratio(target_zone, DAMAGE_BRUTE) * 100 + 10)

	var/mob/living/carbon/human/H = target_mob
	if(istype(H) && H.headcheck(target_zone))
		var/obj/item/organ/affecting = H.get_organ(target_zone) //headcheck should ensure that affecting is not null
		user.visible_message(SPAN_DANGER("[user] smashes [src] into [H]'s [affecting.name]!"))
		if(weaken_duration)
			target_mob.apply_effect(min(weaken_duration, 5), WEAKEN, blocked) // Never weaken more than a flash!
	else
		user.visible_message(SPAN_DANGER("\The [user] smashes [src] into [target_mob]!"))

	//The reagents in the bottle splash all over the target_mob, thanks for the idea Nodrak
	if(reagents)
		user.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over [target_mob]!"))
		reagents.splash(target_mob, reagents.total_volume)

	//Finally, smash the bottle. This kills (qdel) the bottle.
	var/obj/item/broken_bottle/B = smash(target_mob.loc, target_mob)
	user.put_in_active_hand(B)

	return blocked

/obj/item/reagent_containers/food/drinks/bottle/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	smash(loc)

/*
 * Proc to make the bottle spill some of its contents out in a froth geyser of varying intensity/height
 * Arguments:
 * * offset_x = pixel offset by x from where the froth animation will start
 * * offset_y = pixel offset by y from where the froth animation will start
 * * intensity = how strong the effect is, both visually and in the amount of reagents lost. comes in three flavours
*/
/obj/item/reagent_containers/food/drinks/bottle/proc/make_froth(offset_x, offset_y, intensity)
	if(!intensity)
		return

	if(!reagents.total_volume)
		return

	var/amount_lost = intensity * 5
	reagents.remove_any(amount_lost)

	visible_message(SPAN_WARNING("Some of [name]'s contents are let loose!"))
	var/intensity_state = null
	switch(intensity)
		if(1)
			intensity_state = "low"
		if(2)
			intensity_state = "medium"
		if(3)
			intensity_state = "high"
	///The froth fountain that we are sticking onto the bottle
	var/mutable_appearance/froth = mutable_appearance('icons/obj/item/reagent_containers/food/drinks/drink_effects.dmi', "froth_bottle_[intensity_state]")
	froth.pixel_x = offset_x
	froth.pixel_y = offset_y
	AddOverlays(froth)
	CUT_OVERLAY_IN(froth, 2 SECONDS)

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/broken_bottle
	name = "broken bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi'
	icon_state = "broken_bottle"
	force = 20
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = TRUE
	edge = FALSE
	hitsound = /singleton/sound_category/bottle_hit_broken
	///The mask image for mimicking a broken-off bottom of the bottle
	var/static/icon/broken_outline = icon('icons/obj/item/reagent_containers/food/drinks/drink_effects.dmi', "broken")
	///The mask image for mimicking a broken-off neck of the bottle
	var/static/icon/flipped_broken_outline = icon('icons/obj/item/reagent_containers/food/drinks/drink_effects.dmi', "broken-flipped")
	w_class = WEIGHT_CLASS_SMALL
	persistency_considered_trash = TRUE

/obj/item/broken_bottle/persistence_apply_content(content, x, y, z)
	src.x = x
	src.y = y
	src.z = z

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
	reagents_to_add = list(/singleton/reagent/alcohol/gin = 100)

/obj/item/reagent_containers/food/drinks/bottle/victorygin
	name = "Victory gin"
	desc = "Pour one out for Al'mari. His gun was on stun, bless his heart."
	icon_state = "victorygin"
	center_of_mass = list("x"=16, "y"=4)
	desc_extended = "Considered the official drink of the People's Republic of Adhomai, Victory Gin was created to celebrate the end of the revolution. It is commonly found in NanoTrasen's \
	facilities, due to a contract that allows the government to supply the corporation, and in the Tajaran communities of Tau Ceti. The destruction of Victory Gin's bottles and reserves \
	was widespread when Republican positions and cities were taken by the opposition as the drink is deemed by many as a symbol of the Hadiist regime."
	reagents_to_add = list(/singleton/reagent/alcohol/victorygin = 100)

/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Mu Cephei Special Reserve Whiskey"
	desc = "An okayish single-malt whiskey. This one is produced mainly in New Valletta on Callisto and is fairly famous among Cythereans, too. It's great to get you \
	in the right mindset for your tenth night out clubbing in a row!"
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "whiskeybottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/whiskey = 100)

/obj/item/reagent_containers/food/drinks/bottle/fireball
	name = "Delta Cephei Cinnamon Fireball"
	desc = "An okayish single-malt whiskey, infused with cinnamon and hot pepper that used to be mainly produced on Mars, but the production line was since moved to Earth for geopolitical reasons. \
	It is sometimes claimed that particularly desperate Eridanian dregs came up with the current recipe for this drink."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "fireballbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/fireball = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Martian 50% Premium Vodka"
	desc = "Only potatoes grown in real imported Martian soil may be used for this premium vodka (imports of Martian soil may have stopped). Made by Silverport, drunk by Zavodskoi."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "vodkabottle"
	center_of_mass = list("x"=17, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/vodka = 100)

/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom
	name = "Inverkeithing Import mushroom vodka"
	desc = "A mushroom-based vodka imported from the breweries of Inverkeithing on Himeo. Drinking too much of this will result in a personal permanent revolution."
	desc_extended = "Vodka made from mushrooms is a local favourite on Himeo, due to the ease with which mushrooms can be grown under the planet's surface. This bottle is \
	from the Schwarzer Drache Breweries Syndicate in Inverkeithing, arguably the most famous brewery on Himeo due to its historical reputation. It is also the most famous brand \
	of mushroom vodka among non-Himeans because of Inverkeithing's developing tourism industry. Drinkers of the world (and beyond), unite!"
	icon_state = "mushroomvodkabottle"
	reagents_to_add = list(/singleton/reagent/alcohol/vodka/mushroom = 100)

/obj/item/reagent_containers/food/drinks/bottle/tequila
	name = "Nathan's Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients! This particular line of tequila has Nathan Trasen's signature on the label and his approval, \
	as can be commonly seen and heard in Getmore's many advertisements for this line. Astute observers may however note the absolute lack of emotion on Trasen's face while reciting his love for Getmore tequila on television."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "tequilabottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/tequila = 100)

/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "bottle of nothing"
	desc = "A bottle filled with nothing."
	icon_state = "bottleofnothing"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/drink/nothing = 100)

/obj/item/reagent_containers/food/drinks/bottle/bitters
	name = "Nojosuru Aromatic Bitters"
	desc = "Only the finest and highest quality herbs find their way into our cocktail bitters, both human <i>and</i> skrellian."
	desc_extended = "This drink is made by Nojosuru Foods, a subsidiary of Zeng-Hu Pharmaceuticals, founded on Earth in 2252. \
						They are known for their surprisingly affordable and incredible quality foods, as well as growing many crops used in pharmaceuticals and luxury items."
	icon_state = "bitters"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/alcohol/bitters = 40)

/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Silverport's Bubbliest champagne"
	desc = "A rather fancy bottle of champagne, fit for collecting and storing in a cellar for decades. This champagne is an absolute mainstay on Venus, used everywhere from appetizers to celebrations to \
	cocktail creation, where it shines the most. If you haven't got a bottle of Silverport's Bubbliest in your fridge, are you <i>really</i> a Cytherean? The advertisements for this line say no!"
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "champagnebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/champagne = 100)
	atom_flags = 0 // starts closed
	///Used for sabrage; increases the chance of success per 1 force of the attacking sharp item
	var/sabrage_success_percentile = 5
	///Whether this bottle was a victim of a successful sabrage attempt
	var/sabraged = FALSE

/obj/item/reagent_containers/food/drinks/bottle/champagne/attack_self(mob/user)
	if(is_open_container())
		return ..()
	balloon_alert(user, "fiddling with cork...")
	if(do_after(user, 1 SECONDS, src))
		if(!is_open_container())
			return open(user, sabrage = FALSE, froth_severity = pick(0, 1))

/obj/item/reagent_containers/food/drinks/bottle/champagne/attackby(obj/item/attacking_item, mob/user)
	. = ..()

	if(is_open_container())
		return ..()

	if(!has_edge(attacking_item))
		return

	if(attacking_item.force < 5)
		balloon_alert(user, "not strong enough!")
		return

	playsound(user, 'sound/weapons/holster/sheathout.ogg', 25, TRUE)
	balloon_alert(user, "preparing to swing...")
	if(!do_after(user, 2 SECONDS, src)) //takes longer because you are supposed to take the foil off the bottle first
		return

	if(is_open_container())
		balloon_alert(user, "already open! you spill some on the floor!")
		if(reagents.total_volume)
			src.reagents.remove_any(reagents.total_volume / 5)
		return

	///The bonus to success chance that the user gets for being a command role
	var/command_bonus = (user.mind?.assigned_role in command_positions) ? 20 : 0

	var/job_bonus = user.mind?.assigned_role == "Bartender" ? 25 : 0

	var/sabrage_chance = (attacking_item.force * sabrage_success_percentile) + command_bonus + job_bonus

	if(prob(sabrage_chance))
		///Severity of the resulting froth to pass to make_froth()
		var/severity_to_pass
		if(sabrage_chance > 100)
			severity_to_pass = 0
		else
			switch(sabrage_chance) //the less likely we were to succeed, the more of the drink will end up wasted in froth
				if(1 to 33)
					severity_to_pass = 3
				if(34 to 66)
					severity_to_pass = 2
				if(67 to 99)
					severity_to_pass = 1
		return open(user, sabrage = TRUE, froth_severity = severity_to_pass)
	else //you dun goofed
		user.visible_message(
			SPAN_DANGER("[user] fumbles the sabrage and cuts [src] in half, spilling it over themselves!"), \
			SPAN_DANGER("You fail your stunt and cut [src] in half, spilling it over you!"), \
			"You hear spilling."
			)
		return smash(src.loc, user, break_top = TRUE)

/obj/item/reagent_containers/food/drinks/bottle/champagne/update_icon()
	. = ..()
	if(is_open_container())
		if(sabraged)
			icon_state = "[initial(icon_state)]_sabrage"
		else
			icon_state = "[initial(icon_state)]_popped"
	else
		icon_state = initial(icon_state)

/obj/item/reagent_containers/food/drinks/bottle/champagne/open(mob/user, var/sabrage, var/froth_severity)
	if(!sabrage)
		user.visible_message(SPAN_DANGER("[user] loosens the cork of [src] causing it to pop out of the bottle with great force."), \
								SPAN_GOOD("You elegantly loosen the cork of [src] causing it to pop out of the bottle with great force."), \
								"You can hear a pop.")
	else
		sabraged = TRUE
		user.visible_message(SPAN_DANGER("[user] cleanly slices off the cork of [src], causing it to fly off the bottle with great force."), \
								SPAN_GOOD("You elegantly slice the cork off of [src], causing it to fly off the bottle with great force."), \
								"You can hear a pop.")
	playsound(src, 'sound/items/champagne_pop.ogg', 70, TRUE)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	make_froth(offset_x = 0, offset_y = sabraged ? 13 : 15, intensity = froth_severity) //the y offset for sabraged is lower because the bottle's lip is smashed
	///Type of cork to fire away
	var/obj/projectile/bullet/cork_to_fire = sabraged ? /obj/projectile/bullet/champagne_cork/sabrage : /obj/projectile/bullet/champagne_cork
	///Our resulting cork projectile
	var/obj/projectile/bullet/champagne_cork/popped_cork = new cork_to_fire(get_turf(src))
	popped_cork.firer =  user
	popped_cork.fire(dir2angle(user.dir) + rand(-30, 30))

/obj/projectile/bullet/champagne_cork
	name = "champagne cork"
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi'
	icon_state = "champagne_cork"
	damage = 5
	embed = FALSE
	sharp = FALSE
	agony = 10 // ow!
	var/drop_type = /obj/item/trash/champagne_cork

/obj/projectile/bullet/champagne_cork/on_hit(atom/target, blocked, def_zone)
	. = ..()
	new drop_type(src.loc) //always use src.loc so that ash doesn't end up inside windows

/obj/item/trash/champagne_cork
	name = "champagne cork"
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi'
	icon_state = "champagne_cork"

/obj/projectile/bullet/champagne_cork/sabrage
	icon_state = "champagne_cork_sabrage"
	drop_type = /obj/item/trash/champagne_cork/sabrage

/obj/item/trash/champagne_cork/sabrage
	icon_state = "champagne_cork_sabrage"

/obj/item/reagent_containers/food/drinks/bottle/fernet
	name = "\improper Mictlan Armago Fernet"
	desc = "An herbal, bitter liqueur, created using a heavily-guarded family recipe from the Armago family that includes a unique medley of herbs, roots, and spices."
	desc_extended = "While the exact ingredients remain confidential, rumors speak of saffron, aged myrrh, and a mysterious herb known only to the elders of the family. Whatever the composition, each bottle \
	is an homage to the multi-generational lineage of the Armago family, with roots back to Chile on Earth. The fernet undergoes a traditional pot-still distillation method, using several goes to evolve the flavor and \
	ensure purity and potency. The liqueur is then aged in charred oak barrels, lending a smoky flavor. Despite its handcrafted nature, it is a ubiquitous spirit on Mictlan, often being consumed as part of an ever-evolving \
	range of cocktails and drinks, to add that touch of spice to a drink."
	icon_state = "fernetbottle"
	reagents_to_add = list(/singleton/reagent/alcohol/fernet = 100)

/obj/item/reagent_containers/food/drinks/bottle/mintsyrup
	name = "Getmore's Bold Peppermint"
	desc = "Minty fresh. Contains dyn (and just a little peppermint)."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "mint_syrup"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/drink/mintsyrup = 100)

/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Cytherea Artiste patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy. It's among some of the most expensive Silverport Quality Brand products, \
	perhaps due to demand rather than the actual cost of production."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "patronbottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/singleton/reagent/alcohol/patron = 100)

/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Undirstader Broeckhouser rum"
	desc = "If Getmore gets any alcohol right, it's certainly rum, according to (most) New Gibsoners (only Ovanstaders were polled)! This is <b>real</b>, <i><b>GENUINE</b></i> Undirstader rum, made using <b>OLD WORLD</b> recipes! The most authentic \
	Undirstader drink in Getmore's wide arsenal! Or so the advertisements say. Undirstader critics often point to this rum as a corporate mockery of their culture, yet it remains the most \
	popular Getmore product in New Gibson's Ovanstads by far, and most people simply know it as a famous Undirstader drink produced by Getmore."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "rumbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/rum = 100)

/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "flask of holy water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = list("x"=17, "y"=10)
	reagents_to_add = list(/singleton/reagent/water/holywater = 100)

/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Xinghua vermouth"
	desc = "Sweet, sweet dryness. Some alcohol critics say that the addition of dyn to the recipe ruins the drink, \
	but the average consumer doesn't really notice the difference, and it's cheaper to manufacture."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "vermouthbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/vermouth = 100)

/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Nixiqi's Happy Accident coffee liqueur"
	desc = "A particularly genius Skrell came up with the recipe by accident in a hydroponics lab by spilling coffee in their herbal concoction, or so the story goes."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "kahluabottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/coffee/kahlua = 100)

/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "Uptown Cytherean goldschlager"
	desc = "Not as sophisticated as Cytherea Artiste, but I guess if you <i>really</i> want to have pure gold in your drink..."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "goldschlagerbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/goldschlager = 100)

/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Cytherea Golden Sweetness cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Savor this, and feel the real high life."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "cognacbottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/cognac = 100)

/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Silverport Quality Brand red wine"
	desc = "Some consider this to be Silversun's main cultural export."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "winebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/wine = 100)

/obj/item/reagent_containers/food/drinks/bottle/rose_wine
	name = "\improper Coral Twilight Rose"
	desc = "A blended fragrant rose wine with a coral hue from the shores of Silversun. High-quality and fruity."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "rosewine"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/rose = 100)

/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "\improper Chip Getmore's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "pwinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/pwine = 100)

/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time. Particularly artistic Cythereans drink this Silverport product to get inspired."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "absinthebottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/singleton/reagent/alcohol/absinthe = 100)

/obj/item/reagent_containers/food/drinks/bottle/limoncello
	name = "Limoncello Mediterraneo"
	desc = "A lemon liquor popular in Italy and in Assunzione."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "limoncello"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/alcohol/limoncello = 100)

/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine melon liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor, made from a Silversun-grown variety of melon. Sweet and light, and surprisingly cheap considering the manufacturer."
	desc_extended = DRINK_FLUFF_SILVERPORT
	icon_state = "melonliqour"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/alcohol/melonliquor = 100)

/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Xuaousha curacao"
	desc = "A fruity, exceptionally azure drink. Thanks to weird Skrellian genetic experiments, oranges used for this are, in fact, really blue."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "curacaobottle"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/alcohol/bluecuracao = 100)

/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Getmore's Tangy grenadine syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "grenadinebottle"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/drink/grenadine = 100)

/obj/item/reagent_containers/food/drinks/bottle/applejack
	name = "\improper Arvani Special Reserve Applejack"
	desc = "Smooth distilled applejack liquor From Biesel. Stronger and more flavorful than traditional hard cider."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "applejackbottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/singleton/reagent/alcohol/applejack = 100)

/obj/item/reagent_containers/food/drinks/bottle/triplesec
	name = "\improper Fleur de Majestueux Triple Sec"
	desc = "A fruity Xanu liqueur made from orange peels. Best mixed as part of cocktails."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "triplesecbottle"
	center_of_mass = list("x"=16, "y"=7)
	reagents_to_add = list(/singleton/reagent/alcohol/triplesec = 100)

// Soda

/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "comet cola"
	desc = "Getmore's most popular line of soda. A generic cola, otherwise."
	icon_state = "colabottle"
	empty_icon_state = "soda_empty"
	center_of_mass = list("x"=16, "y"=6)
	volume = 30
	atom_flags = 0 //starts closed
	reagents_to_add = list(/singleton/reagent/drink/space_cola = 30)

/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Vacuum Fizz"
	desc = "Tastes like a hull breach in your mouth."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "space-up_bottle"
	empty_icon_state = "soda_empty"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/drink/spaceup = 30)

/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Stellar Jolt"
	desc = "For those who have a need for caffeine stronger than would be sensible."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "space_mountain_wind_bottle"
	empty_icon_state = "soda_empty"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/drink/spacemountainwind = 30)

/obj/item/reagent_containers/food/drinks/bottle/hrozamal_soda
	name = "Hro'zamal Soda"
	desc = "A bottle of Hro'zamal Soda. Made with Hro'zamal Ras'Nifs powder and bottled in the People's Republic of Adhomai."
	desc_extended = "Hro'zamal Soda is a soft drink made from the seed's powder of a plant native to Hro'zamal, the sole Hadiist colony. While initially consumed as a herbal tea by the \
	colonists, it was introduced to Adhomai by the Army Expeditionary Force and transformed into a carbonated drink. The beverage is popular with factory workers and university \
	students because of its stimulant effect."
	icon_state = "hrozamal_soda_bottle"
	empty_icon_state = "soda_empty"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/drink/hrozamal_soda = 30)

//Small bottles
/obj/item/reagent_containers/food/drinks/bottle/small
	name = "small bottle"
	desc = "A small bottle."
	icon_state = "beer"
	volume = 30
	smash_duration = 1
	atom_flags = 0 //starts closed
	rag_underlay = "rag_small"
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "Virklunder beer"
	desc = "Contains only water, malt and hops. Not really as high-quality as the label says, but it's still popular. This particular line of beer is made by Getmore on New Gibson, specifically in the Ovanstad of \
	Virklund in a massive beer brewery complex. It quickly became the most consumed kind of beer across the Republic of Biesel and has since been in stock in practically every bar across the nation."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "beer"

	reagents_to_add = list(/singleton/reagent/alcohol/beer = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/beer/light
	name = "Carp Lite"
	desc = "Brewed with \"Pure Ice Asteroid Spring Water\"."
	icon_state = "litebeer"
	reagents_to_add = list(/singleton/reagent/alcohol/beer/light = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/beer/root
	name = "Two-Time root beer"
	desc = "A popular, old-fashioned brand of root beer, known for its extremely sugary formula. Might make you want a nap afterwards."
	icon_state = "twotime"
	reagents_to_add = list(/singleton/reagent/drink/root_beer = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Burszi-ale"
	desc = "Manufactured in Virklund on New Gibson by Getmore, this is a true Burszian's drink of choice. That is, if you're not an IPC. You wouldn't be able to buy this ale then. Or think of buying it. Or afford it."
	icon_state = "alebottle"
	item_state = "beer"
	reagents_to_add = list(/singleton/reagent/alcohol/ale = 30)

/obj/item/reagent_containers/food/drinks/bottle/small/midynhr_water
	name = "midynhr water"
	desc = "A soft drink made from honey and tree syrup. The label claims it is good as the tap version."
	icon_state = "midynhrwater"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A soft drink based on Yve'kha's honey and tree syrups. The drink has a creamy consistency and is served cold from the tap of traditional soda fountains. Native to \
	Das'nrra, the beverage is now widespread in the Al'mariist territories. Bottled versions exist, but they are considered to be inferior to what is served in bars and restaurants."
	reagents_to_add = list(/singleton/reagent/drink/midynhr_water = 30)

//aurora's drinks

/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen
	name = "Nralakk Touch green chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "chartreusegreenbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/singleton/reagent/alcohol/chartreusegreen = 100)

/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow
	name = "Nralakk Touch yellow chartreuse"
	desc = "A green, strong liqueur with a very strong flavor. The original recipe called for almost a hundred of different herbs, \
			but thanks to Skrellian improvements to the recipe, it now just has five, without losing any nuance."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "chartreuseyellowbottle"
	center_of_mass = list("x" = 15,"y" = 5)
	reagents_to_add = list(/singleton/reagent/alcohol/chartreuseyellow = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremewhite
	name = "Xinghua White Mint"
	desc = "Mint-flavoured alcohol, in a bottle."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "whitecremebottle"
	center_of_mass = list("x" = 16,"y" = 5)
	reagents_to_add = list(/singleton/reagent/alcohol/cremewhite = 100)

/obj/item/reagent_containers/food/drinks/bottle/cremeyvette
	name = "Xinghua Delicate Violet"
	desc = "Berry-flavoured alcohol, in a bottle."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "cremedeyvettebottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/singleton/reagent/alcohol/cremeyvette = 100)

/obj/item/reagent_containers/food/drinks/bottle/brandy
	name = "Admiral Cindy's brandy"
	desc = "Cheap knock off for Cytherean cognac; Getmore's attempt to ride off the cognac fad of the 2420s."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "brandybottle"
	center_of_mass = list("x" = 15,"y" = 8)
	reagents_to_add = list(/singleton/reagent/alcohol/brandy = 100)

/obj/item/reagent_containers/food/drinks/bottle/guinness
	name = "Guinness"
	desc = "A bottle of good old Guinness. Manufactured by Getmore in a District 3 brewery in Mendell City. It is one of Getmore's most basic and least flashy lines of alcohol."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "guinness_bottle"
	center_of_mass = list("x" = 15,"y" = 4)
	reagents_to_add = list(/singleton/reagent/alcohol/guinness = 100)

/obj/item/reagent_containers/food/drinks/bottle/drambuie
	name = "Xinghua Honeyed Satisfaction"
	desc = "A bottle of trendy whiskey with genetically modified barley. The exact genome is a closely-guarded secret, but it tastes sweet and slightly herbal."
	desc_extended = DRINK_FLUFF_ZENGHU
	icon_state = "drambuie_bottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/singleton/reagent/alcohol/drambuie = 100)

/obj/item/reagent_containers/food/drinks/bottle/messa_mead
	name = "messa's mead"
	desc = "A bottle of Messa's mead. Bottled somewhere in the icy world of Adhomai."
	icon_state = "messa_mead"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A fermented alcoholic drink made from earthen-root juice and Messa's tears leaves. It has a relatively low alcohol content and characteristic honey flavor. \
	Messa's Mead is one of the most popular alcoholic drinks on Adhomai; it is consumed both during celebrations and daily meals. Any proper Adhomian bar will have at least a keg or \
	some bottles of the mead."
	reagents_to_add = list(/singleton/reagent/alcohol/messa_mead = 100)

/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Shokyodo Sake"
	desc = "A rice-based alcohol produced and marketed by Nojosuru Foods. While frequently described as rice wine, its production shares more in common with beer."
	desc_extended = "Brewed in Nojosuru's facilities in Akita Prefecture, Japan, Shokyodo Sake is marketed as a premium good reflecting its lineage from Earth. \
	Despite its high level of quality and pleasing taste, it has never gained much popularity outside of Sol and the Inner Colonies owing to its high cost and Konyang-based \
	competitors."
	icon_state = "sakebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/sake = 100)

/obj/item/reagent_containers/food/drinks/bottle/soju
	name = "Boryeong '45 soju"
	desc = "A rice-based liquor commonly consumed by the non-synthetic residents of Konyang. This particular brand originates from the city of Boreyeong, on Konyang."
	desc_extended = "While most commonly associated with Konyang, soju can be found throughout the Sol Alliance thanks to the inexpensive cost of producing it and a successful \
	marketing campaign carried out during the robotics boom on Konyang. It is traditionally consumed neat, or without mixing any other liquids into it. The '45 in this brand's name \
	refers to its alcohol by volume content, and not a calendar year."
	icon_state = "sojubottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/soju = 100)

/obj/item/reagent_containers/food/drinks/bottle/soju/shochu
	name = "Shu-Kouba Shochu"
	desc = "A rice-based liquour produced and marketed by Nojosuru Foods. Similar to Soju, but more commonly drunk on the rocks or with a mixer, lowering its alcohol content."
	desc_extended = "Majority of Shochu is only produced in Japan’s southernmost island of Kyushu, by a union of independent brewers in co-operation with the Nojosuru company. \
	It stands as one of the Sol Alliance's pride and joy, despite being outcompeted by the more easily mass-produced Konyanger Soju."
	icon_state = "shochubottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/soju = 100)

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
	reagents_to_add = list(/singleton/reagent/alcohol/makgeolli = 100)

/obj/item/reagent_containers/food/drinks/bottle/small/khlibnyz
	name = "khlibnyz"
	desc = "A bottle traditionally made khlibnyz. Likely prepared in some Hadiist communal farm."
	icon_state = "khlibnyz"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A fermented beverage produced from Adhomian bread. Herbs, fruits, and tree sap can be added for flavoring. It is considered a non-alcoholic drink by Adhomian standards \
	because of its very low alcohol content. Khlibnyz was mainly consumed by peasants during pre-contact times and is still very popular with the Hadiist rural population. Communal farms \
	will brew their own Khlibnyz and sell it to the government for distribution."
	reagents_to_add = list(/singleton/reagent/alcohol/khlibnyz = 30)

/obj/item/reagent_containers/food/drinks/bottle/shyyrkirrtyr_wine
	name = "shyyr kirr'tyr wine"
	desc = "Tajaran spirit infused with some eel-like Adhomian creature. The animal floating in the liquid appears to be well preserved."
	icon_state = "shyyrkirrtyrwine"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "An alcoholic made by infusing a whole Shyyr Kirr'tyr in Dirt Berries or Earthen-Root spirit. The Water Snake Devil's poison is neutralized by ethanol, making the \
	beverage safe to consume. The wine can be deadly if improperly prepared. The drink is native to the Southeast Harr'masir wetlands, where it is as common as Messa's Mead. Other \
	Tajara consider the wine to be exotic or outright disgusting. The Shyyr Kirr'tyr is usually eaten after the beverage is imbibed."
	reagents_to_add = list(/singleton/reagent/alcohol/shyyrkirrtyr_wine = 100)

/obj/item/reagent_containers/food/drinks/bottle/sugartree_liquor
	name = "sugar tree liquor"
	desc = "Also called nm'shaan liquor in native Siik'maas: a strong Adhomian liquor reserved for special occasions. A label on the bottle recommends diluting it with icy water before drinking."
	icon_state = "sugartreeliquor"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "An alcoholic drink manufactured from the fruit of the Nm'shaan plant. It usually has a high level of alcohol by volume. Nm'shaan liquor was once reserved for the \
	consumption of the nobility; even today it is considered a decadent drink reserved for fancy occasions."
	reagents_to_add = list(/singleton/reagent/alcohol/sugartree_liquor = 100)

/obj/item/reagent_containers/food/drinks/bottle/veterans_choice
	name = "veteran's choice"
	desc = "A home-made bottle of veteran's choice. Shake it carefully before serving."
	icon_state = "veteranschoice"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A cocktail consisting of Messa's Mead and gunpowder. Supposedly originated among the ranks of the Liberation Army as an attempt to spice up the mead, the cocktail \
	became a hit - not because of its taste - with the young Tajara. Drinking the Veteran's Choice is seen as a way to display one's bravado. ALA soldiers are known to consume the cocktail before going into battle believing that it brings luck."
	reagents_to_add = list(/singleton/reagent/alcohol/veterans_choice = 100)

/obj/item/reagent_containers/food/drinks/bottle/treebark_firewater
	name = "tree-bark firewater"
	desc = "A jug full of adhomian moonshine. The bottle states dubiously that it is a handmade recipe."
	icon_state = "treebarkfirewater"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "High-content alcohol distilled from Earthen-Root or Blizzard Ears. Tree bark is commonly added to the drink to give it a distinct flavor. The firewater's origins can \
	be traced back to the pre-contact times where impoverished peasants would make alcohol out of anything they could find. Homebrewing remains a tradition in the New Kingdom's rural \
	parts. These traditional spirits are also manufactured by large breweries and sold to the urban population as handcrafted."
	reagents_to_add = list(/singleton/reagent/alcohol/treebark_firewater = 100)

/obj/item/reagent_containers/food/drinks/bottle/darmadhir_brew
	name = "Darmadhir Brew"
	desc = "A fancy bottle contained sought-after Darmadhir's nm'shaan liquor. It is more of a collection piece than a beverage."
	icon_state = "darmadhirbrew"
	center_of_mass = list("x" = 16,"y" = 5)
	desc_extended = "A famous variation of the Nm'shaan Liquor; it is described as one of Adhomai's finest spirits. It is produced solely by a small family-owned brewery in Miran'mir. Its \
	recipe is a secret passed down through the generations of the Darmadhir household since immemorial times. The only living member of the family, Hazyr Darmadhir, is a 68 years old \
	Tajara. His sole heir and son died in the Second Revolution after being drafted to fight for the royal army. Alcohol collectors stipulate that the brew's price will skyrocket after Hazyr's death."
	reagents_to_add = list(/singleton/reagent/alcohol/sugartree_liquor/darmadhirbrew = 100)

/obj/item/reagent_containers/food/drinks/bottle/pulque
	name = "Don Augusto's pulque"
	desc = "A glass bottle of Mictlanian pulque. The label states that it is still produced by hand."
	desc_extended = "Don Augusto's pulqlueria is a famous saloon in Lago de Abundancia, known for its quality pulque. After Idris invested in the city, the family-owned business became part of the \
	megacorporation. Nowadays, it is bottled and sold all around the galaxy."
	icon_state = "pulquebottle"
	center_of_mass = list("x" = 16, "y" = 5)
	reagents_to_add = list(/singleton/reagent/alcohol/pulque = 100)

/obj/item/reagent_containers/food/drinks/bottle/vintage_wine //can't make it a child of wine, or else reagents double-fill
	name = "Vintage Wine"
	desc = "A fine bottle of high-quality wine, produced in a small batch and aged for decades, if not centuries. It's likely that few bottles like it remain."
	icon_state = "vwinebottle"
	desc_extended = "Small-batch wines produced by local, independent wineries are highly sought-after by those who can afford them. They are considered highly-collectable items \
	due to how relatively few exist compared to more mass-produced wines. The attention to detail can be seen in the bottle, and felt in the taste. While megacorporations and their \
	subsidiaries don't produce bad products, wine afficianados across the spur agree that nothing comes close to these locally-produced treasures. They can easily be worth thousands of credits."
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/vintage = 100)

/obj/item/reagent_containers/food/drinks/bottle/vintage_wine/Initialize()
	. = ..()
	name = pick("Triesto Pre-Dimming Sangiovese", "New Beirut 2340", "Vysokan Artisans Merlot", "Silver Seas Original Merlot", "Domelkos Morozian Treasure", "Belle Cote Serene Moth 2395",
			"Malta Sol Nebbiolo", "Ashkhaimi Gardens Shiraz", "Old Cairo 2375", "Artisan Empire 2354")

/obj/item/reagent_containers/food/drinks/bottle/dominian_wine
	name = "Jadrani Consecrated geneboosted wine"
	desc = "A bottle of artisanally-crafted, highly sought-after Dominian red wine. Sanctified and exported via House Caladius."
	desc_extended = "The Dominian mastery of the genome does not stop with the mere human; flora and fauna, too, can be adjusted to better serve the needs of the Empire and Her chosen people. This \
	wine- the exact fruit juices used are a coveted secret- represents the Goddess in the Aspect of both the Artisan and the Scholar. Each bottle is inspected, tested, and blessed by a Priestess \
	of the Moroz Holy Tribunal, then packaged and sold across the Empire and various- typically wealthy- foreign markets. The first hundred bottles of every season are given to the Goddess, as thanks for Her providence. \
	The next thousand or so are sent directly to the Royal Family, as a favored gift to the royal court and their functionaries."
	icon_state = "sacredwine"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/dominian = 100)

/obj/item/reagent_containers/food/drinks/bottle/algae_wine
	name = "Reacher's Triumph 2423"
	desc = "A bottle of wine, brewed from algae, made in the traditional style of the Imperial Viceroyalty of Sun Reach, a Dominian frontier-world."
	desc_extended = "A swampy, humid planet, Sun Reach does not possess ample amounts of land available for agriculture, least of all for hops or wine grapes. Still, where exists a will exists a way, and the \
	Goddess truly blessed Her faithful with more than enough of both. Produced from certain strains of the omnipresent Reacher algae, with the aid of benefactors in House Caladius, the result is a murky-blue \
	drink that tastes almost, but entirely not like an absinthe. First presented at the first celebration of the Imperial Annexation, it is now mainly consumed on-world, though large sums are purchased by the \
	Imperial Fleet as a 'morale improvement' measure. It plays a key part in the after-action rituals of the Imperial Armsmen, as the drink causes bizarre dreams said to bring one closer to the Goddess."
	icon_state = "algaewinebottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/algae = 100)

/obj/item/reagent_containers/food/drinks/bottle/assunzione_wine
	name = "\improper Assunzioni Sera Stellata di Dalyan wine"
	desc = "A bottle of velvety smooth red wine from the underground vineyards of Dalyan, Assunzione. The standard liturgical wine of choice for upper-echelon priests and clergy of Luceism, although drinking it outside of holy celebrations is hardly sacrilegious."
	desc_extended = "Rather than rely on technology alone, Assunzioni winemakers sought to incorporate millennia-old traditions into making a wine suitable for the clergy. With the blessing of the church, \
	and with aid from Zeng-Hu, artisans crafted a technique of 'soleato', drying grapes under the light of electrically-amplified warding spheres, engineered to produce immense heat. The dried grapes are then \
	pressed, fermented, and aged in Malagan oak barrels for several years. The resulting wine is exceptionally full-bodied and complex, with notes of dried fruit and tobacco. The drying technique has given it the \
	preemptive blessing of the Luceian Church, and as such wines made using this technique, even of other varietals, are certified for usage in religious communions. Wine such as this is exported to other worlds \
	at great cost, rivalling other wines in the Spur in their rarity and prestige."
	icon_state = "assunzionewine"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/assunzione = 100)

/obj/item/reagent_containers/food/drinks/bottle/kvass
	name = "Neubach Original kvass"
	desc = "A bottle of authentic Fisanduhian kvass, a cereal alcohol."
	desc_extended = "A traditional drink of the Fisanduh region, originating with the colony ships that brought their people to Moroz, large-scale production \
	is now all but a hazy memory, owing to the region's bloodstained history. Today it comes from either a lonely factory in Strelitz's \
	Rest- an initiative, on behalf of His Imperial Majesty, to bring back jobs for the civilian populace- or home brewing on behalf of locals. This particular variety is, in reality, brewed on \
	Xanu Prime as an outreach effort of the government-in-exile."
	icon_state = "kvassbottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/kvass = 100)

/obj/item/reagent_containers/food/drinks/bottle/tarasun
	name = "Frostdancer Distillery tarasun"
	desc = "A bottle of Lyodii tarasun, an alcoholic beverage made from tenelote milk."
	desc_extended = "Tarasun is an incredibly potent alcoholic beverage distilled and fermented from tenelote milk, often enjoyed during tribal festivities among Lyodii. This particular brand is \
	distilled and distributed by the Frostdancer tribe of the Northern Lyod, with assistance by Zavodskoi Interstellar. Commonly distributed among the Lyodic Rifles of the Imperial military."
	icon_state = "tarasunbottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/tarasun = 100)

/obj/item/reagent_containers/food/drinks/bottle/valokki_wine
	name = "Frostdancer Distillery valokki wine"
	desc = "A bottle of wine distilled from the Morozi cloudberry."
	desc_extended = "A smooth, rich wine distilled from the cloudberry fruit found within the taiga bordering the Lyod. \
	This particular brand is distilled and distributed by the Frostdancer tribe of the Northern Lyod, with assistance by Zavodskoi Interstellar."
	icon_state = "valokkiwinebottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/wine/valokki = 100)

/obj/item/reagent_containers/food/drinks/bottle/twentytwoseventyfive
	name = "2275 Classic"
	desc = "A bottle of Xanan mid-range brandy."
	desc_extended = "The Xanan brandy industry boasts a rich history, centered around the unique climatological conditions of Foy-Niljen brandy country. The 2275's main claim to fame is the Stag Hunt cocktail, \
	the most popular cocktail on Xanu Prime and one of the most consumed in the entire Coalition. It is often said that to make a Stag Hunt without 2275 is to visit the Coalition without seeing Xanu Prime."
	icon_state = "2275bottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/twentytwo = 100)

/obj/item/reagent_containers/food/drinks/bottle/saintjacques
	name = "Saint-Jacques Black Label"
	desc = "An expensive bottle of Saint-Jacques Black Label, a Xanan luxury cognac."
	desc_extended = "The Xanan brandy industry boasts a rich history, centered around the unique climatological conditions of Foy-Niljen brandy country. None hold a candle to the sheer quality- or sheer price- of \
	the highly esteemed Saint-Jacques Black Label, a limited-quantity cognac with a price point somewhere around a small hovercar on a middlingly populated world. Some say it can only be distilled on the yearly anniversary of the formation \
	of the Frontier Alliance; others that each bottle is personally inspected by a panel of Xanan artisans."
	icon_state = "stjacquesbottle"
	center_of_mass = list("x"=16, "y"=5)
	reagents_to_add = list(/singleton/reagent/alcohol/saintjacques = 100)

/obj/item/reagent_containers/food/drinks/bottle/bestblend
	name = "Mahendru's Best Blend"
	desc = "A jar of sugarcane juice. Apple flavored!"
	desc_extended = "Popular in Xanan circles, sugarcane juice competes with tea for the refreshment of choice at summertime gatherings and in the Republic's fridges. Some consider it more 'posh' and 'artisanal', which Mahendru's Best Blend \
	encourages with a glass 'mason jar' design and a lid of authentic Xanan cork."
	icon_state = "sugarcanejuice"
	volume = 45
	reagents_to_add = list(/singleton/reagent/drink/sugarcane = 45)

/obj/item/reagent_containers/food/drinks/bottle/feni
	name = "Morale Supplement VII Feni, Standard, Type I"
	desc = "A bottle of Gadpathurian liquor, issued and manufactured by the United Planetary Defense Council. By nature, this is probably surplus."
	desc_extended = "The product of several decades of research by a half-dozen different cadres, Morale Supplement VII- Feni, Standard- was adopted by decree of the United Planetary Defense Councils Board of Quartermasters for use in purposes \
	relating to celebration, morale improvement, or deployment extension. All non-medical personnel are entitled to one twenty-unit serving of the drink, often regarded as 'Supplement Seven', per celebratory period. It remains an obscure drink \
	outside Gadpathur, not by virtue of its rarity- several thousand bottles are sold off as surplus to fund the UPDCG every year- but by being an extremely acquired taste."
	icon_state = "fenibottle"
	reagents_to_add = list(/singleton/reagent/alcohol/feni = 100)

/obj/item/reagent_containers/food/drinks/bottle/hooch
	name = "hooch bottle"
	desc = "A bottle of rotgut. Its owner has applied some street wisdom to cleverly disguise it as a brown paper bag."
	desc_extended = DRINK_FLUFF_GETMORE
	icon_state = "hoochbottle"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/alcohol/hooch = 100)


/obj/item/reagent_containers/food/drinks/bottle/ogogoro
	name = "ogogoro jar"
	desc = "A traditional Eridani palm wine drink, stored in a mason jar."
	desc_extended = "Ogogoro is a traditional West African drink which the colonists of Eridani originally took with them. The nature of it as a high-alcohol moonshine, however, meant that it would eventually be sidelined by the suits of Eridani as \
	a vestige of the poor man's culture. As such, whilst it remains extremely common amongst dregs, a suit drinking ogogoro would often be looked down upon by their peers. It remains popular in opaque flasks, however. Appropriately, this jar was not brewed \
	on Eridani itself, but instead by the dreg diaspora found in Burzsia."
	icon_state = "ogogoro"
	empty_icon_state = "ogogoro_empty"
	reagents_to_add = list(/singleton/reagent/alcohol/ogogoro = 100)

/obj/item/reagent_containers/food/drinks/bottle/small/burukutu
	name = "burukutu bottle"
	desc = "A traditional Eridani millet beer, distributed by Idris."
	desc_extended = "Burukutu is a millet beer common throughout West Africa and colonies with West African influence. As such, it can be found commonly on the colony of Eridani. This bottle in particular is a Silverport product, extremely popular \
	with the suits of the Eridani federation. In spite of their preference for stronger drinks, dregs can often be found with burukutu 'retrieved' from the aboveground cities of Eridani I. According to the label on the back, this was bottled in Tokura, \
	Eridani I."
	icon_state = "burukutu"
	reagents_to_add = list(/singleton/reagent/alcohol/burukutu = 30)

// Butanol-based alcoholic drinks
//=====================================
//These are mainly for unathi, and have very little (but still some) effect on other species

/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice
	name = "Xuizi Juice"
	desc = "Blended flower buds from the Xuizi cactus. It smells faintly of vanilla. Bottled by the Arizi Guild for over 200 years."
	icon_state = "xuizibottle"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/alcohol/butanol/xuizijuice = 30)

/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine
	name = "Sarezhi Wine"
	desc = "A premium Moghean wine made from Sareszhi berries. Bottled by the Arizi Guild for over 200 years."
	icon_state = "sarezhibottle"
	center_of_mass = list("x" = 16,"y" = 6)
	reagents_to_add = list(/singleton/reagent/alcohol/butanol/sarezhiwine = 100)

// Synnono Meme (Bottled) Drinks
//======================================
//

/obj/item/reagent_containers/food/drinks/bottle/boukha
	name = "Boukha Boboksa Classic"
	desc = "A distillation of figs, imported from the Serene Republic of Elyra. Makes an excellent apertif or digestif."
	icon_state = "boukhabottle"
	center_of_mass = list("x"=16, "y"=6)
	reagents_to_add = list(/singleton/reagent/alcohol/boukha = 100)

/obj/item/reagent_containers/food/drinks/bottle/whitewine
	name = "Pineneedle Brand white wine"
	desc = "A mediocre quality white wine, intended more for making spritzers than for drinking by itself. Produced on Visegrad by Idris."
	icon_state = "whitewinebottle"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/alcohol/whitewine = 100)

/obj/item/reagent_containers/food/drinks/bottle/small/skrellbeerdyn
	name = "Qel'Zvol Hospitality's Prestige beer"
	desc = "This beer is made from fermented dyn leaves and mixed with various spices to give it a palatable flavour."
	desc_extended = "Due to Skrell biology alcohol has a more noticeable effect compared to humans, resulting in alcoholic drinks in the Federation being very light. As a result, breweries in the Federation focus more on flavour profiles than being strong, and mixed drinks that combine flavours or textures are extremely popular."
	icon_state = "skrellbeerdyn"
	amount_per_transfer_from_this = 2
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/singleton/reagent/alcohol/small/skrellbeerdyn = 30)

/obj/item/reagent_containers/food/drinks/bottle/skrellwineylpha
	name = "Federation's Finest ylpha wine"
	desc = "A popular type of Skrell wine made from fermented ylpha berries. It's quite sweet and is usually consumed along with more savoury foods, or it can be served iced as an after-dinner digestif."
	desc_extended = "Due to Skrell biology alcohol has a more noticeable effect compared to humans, resulting in alcoholic drinks in the Federation being very light. As a result, breweries in the Federation focus more on flavour profiles than being strong, and mixed drinks that combine flavours or textures are extremely popular."
	icon_state = "skrellwineylpha"
	center_of_mass = list("x"=16, "y"=8)

	reagents_to_add = list(/singleton/reagent/alcohol/bottle/skrellwineylpha = 100)

/obj/item/reagent_containers/food/drinks/bottle/nemiik
	name = "vrozka farms ne'miik"
	desc = "A bottle of Ne'miik under the label 'Vrozka Farms' from Caprice. It has labels in Basic boasting 'rich in minerals!' and warning that 'consumption by Humans or Tajara may cause negative effects', whatever that means."
	icon_state = "vrozka_nemiik"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/milk/nemiik = 80)
	empty_icon_state = "vrozka_empty"

// Vaurca alcoholic drinks
//=====================================

/obj/item/reagent_containers/food/drinks/bottle/skyemok
	name = "bottle of Skye'mok"
	desc = "Traditional Sedantian drink. Looks like it's inside a pulsating stomach."
	desc_extended = "A traditional Sedantian brew crafted from a special fungus fed to V'krexi, this unique beverage ferments in the swollen stomachs of these creatures. It is served traditionally on the head of the V'krexi it was prepared in."
	icon_state = "skyemok"
	empty_icon_state = "skyemok_empty"
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/drink/toothpaste/skyemok= 80)

