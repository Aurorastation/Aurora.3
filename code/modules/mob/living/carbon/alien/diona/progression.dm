/mob/living/carbon/alien/diona/confirm_evolution()

	//Whitelist requirement for evolution experimentally removed
	if(!is_alien_whitelisted(src, "Diona") && config.usealienwhitelist)
		to_chat(src, alert("You are currently not whitelisted to play as a full diona."))
		return null

	var/response = alert(src, "A worker gestalt is a large, slow, and durable humanoid form. You will lose the ability to ventcrawl and devour animals, but you will gain hand-like tendrils and the ability to wear things.You have enough biomass, are you certain you're ready to form a new gestalt?","Confirm Gestalt","Growth!","Patience...")
	if(response != "Growth!") return  //Hit the wrong key...again.

	if(istype(loc,/obj/item/holder/diona))
		var/obj/item/holder/diona/L = loc
		src.forceMove(L.loc)
		qdel(L)

	return "Diona"

/mob/living/carbon/alien/diona/proc/grow()
	set name = "Exponential Growth"
	set desc = "Evolve into your worker gestalt form, if you have enough biomass."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return

	var/limbs_can_grow = round((nutrition / evolve_nutrition) * 6,1)
	if(limbs_can_grow <= 3) //Head, Trunk, Fork
		to_chat(src, "<span class='warning'>You do not have enough biomass to grow yet. Currently you can only grow [limbs_can_grow]/6 limbs. ([nutrition]/[evolve_nutrition] biomass).</span>")
		return

	if(gestalt)
		to_chat(src, "<span class='warning'>You are already part of a collective, if you wish to form your own, you must split off first.</span>")
		return

	if (!istype(loc, /turf))
		to_chat(src, "<span class='warning'>There's not enough space to grow here. Stand on the floor!.</span>")
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	stunned = 10//No more moving or talking for now
	//muted = 10
	playsound(src.loc, 'sound/species/diona/gestalt_grow.ogg', 100, 1)
	src.visible_message("<span class='warning'> [src] begins to shift and quiver.</span>",
	"<span class='warning'> You begin to shift and quiver, feeling your awareness splinter.</span>")
	sleep(52)
	src.visible_message("<span class='warning'> [src] erupts in a shower of shed bark as it splits into a tangle of new dionaea.</span>",
	"<span class='warning'> All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of new dionaea. We have attained a new form.</span>")

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

	//So that the nymph doesn't get basic for free when evolving.
	if (adult.languages)
		adult.languages.Cut()

	for(var/datum/language/L in languages)
		adult.add_language(L.name)

	//If there are any nymphs inside us, then they become equal parts of the gestalt at the same level
	//Although we are still host, these nymphs become neighbors, not contents
	for(var/mob/living/carbon/alien/diona/D in contents)
		D.forceMove(adult)
		D.gestalt = adult
		D.stat = CONSCIOUS

	//Finally we put ourselves into the gestalt, NOT delete ourself
	//Our mind is already in the gestalt, this is really just transferring our empty body
	src.nutrition = 0
	src.forceMove(adult)
	src.stat = CONSCIOUS
	src.gestalt = adult

	//What do you call a person with no arms or no legs?
	var/list/organ_removal_priorities = list("l_arm","r_arm","l_leg","r_leg")
	var/limbs_to_remove = (6 - limbs_can_grow)
	for(var/organ_name in organ_removal_priorities)
		if(limbs_to_remove <= 0)
			break
		var/obj/item/organ/external/O = adult.organs_by_name[organ_name]
		to_chat(src, "<span class='warning'>You didn't have enough biomass to grow your [O.name]!</span>")
		//adult.organs -= O
		O.droplimb(1,DROPLIMB_EDGE)
		qdel(O)
		limbs_to_remove -= 1
	//Matt
