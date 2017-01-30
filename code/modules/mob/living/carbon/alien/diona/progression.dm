/mob/living/carbon/alien/diona/confirm_evolution()

	//Whitelist requirement for evolution experimentally removed
	/*
	if(!is_alien_whitelisted(src, "Diona") && config.usealienwhitelist)
		src << alert("You are currently not whitelisted to play as a full diona.")
		return null
	*/

	var/response = alert(src, "A worker gestalt is a large, slow, and durable humanoid form. You will lose the ability to ventcrawl and devour animals, but you will gain hand-like tendrils and the ability to wear things.You have enough biomass, are you certain you're ready to form a new gestalt?","Confirm Gestalt","Growth!","Patience...")
	if(response != "Growth!") return  //Hit the wrong key...again.

	if(istype(loc,/obj/item/weapon/holder/diona))
		var/obj/item/weapon/holder/diona/L = loc
		src.loc = L.loc
		qdel(L)

	return "Diona"

/mob/living/carbon/alien/diona/proc/grow()
	set name = "Exponential Growth"
	set desc = "Evolve into your worker gestalt form, if you have enough biomass."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return



	if(nutrition < evolve_nutrition)
		src << "\red You do not have enough biomass to grow yet. Currently [nutrition]/[evolve_nutrition]."
		return

	if(gestalt)
		src << "\red You are already part of a collective, if you wish to form your own, you must split off first"
		return

	if (!istype(loc, /turf))
		src << "\red There's not enough space to grow here. Stand on the floor!."
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	stunned = 10//No more moving or talking for now
	//muted = 10
	playsound(src.loc, 'sound/species/diona/gestalt_grow.ogg', 100, 1)
	src.visible_message("\red [src] begins to shift and quiver.",
	"\red You begin to shift and quiver, feeling your awareness splinter. ")
	sleep(52)
	src.visible_message("\red [src] erupts in a shower of shed bark as it splits into a tangle of half a dozen new dionaea.",
	"\red All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of half a dozen new dionaea. We have attained our gestalt form.")

	var/mob/living/carbon/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)
	show_evolution_blurb()

	if(mind)
		mind.original = src//This tracks which nymph 'is' the gestalt
		mind.transfer_to(adult)
	else
		adult.key = src.key

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)

	for(var/datum/language/L in languages)
		adult.add_language(L.name)

	//If there are any nymphs inside us, then they become equal parts of the gestalt at the same level
	//Although we are still host, these nymphs become neighbors, not contents
	for(var/mob/living/carbon/alien/diona/D in contents)
		D.forceMove(adult)
		D.loc = adult
		D.gestalt = adult
		D.stat = CONSCIOUS

	//Finally we put ourselves into the gestalt, NOT delete ourself
	//Our mind is already in the gestalt, this is really just transferring our empty body
	src.nutrition = 0
	src.forceMove(adult)
	src.loc = adult
	src.stat = CONSCIOUS
	src.gestalt = adult