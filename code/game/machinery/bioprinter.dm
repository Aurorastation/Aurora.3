//These machines are mostly just here for debugging/spawning. Skeletons of the feature to come.

/obj/machinery/bioprinter
	name = "organ bioprinter"
	desc = "It's a machine that grows replacement organs."
	icon = 'icons/obj/surgery.dmi'

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40

	icon_state = "bioprinter"

	var/prints_prosthetics
	var/stored_matter = 200
	var/loaded_dna //Blood sample for DNA hashing.
	var/list/products = list(
		BP_HEART =   list(/obj/item/organ/internal/heart,  50),
		BP_LUNGS =   list(/obj/item/organ/internal/lungs,  40),
		BP_KIDNEYS = list(/obj/item/organ/internal/kidneys,20),
		BP_EYES =    list(/obj/item/organ/internal/eyes,   30),
		BP_LIVER =   list(/obj/item/organ/internal/liver,  50)
		)

/obj/machinery/bioprinter/prosthetics
	name = "prosthetics fabricator"
	desc = "It's a machine that prints prosthetic organs."
	prints_prosthetics = 1

/obj/machinery/bioprinter/attack_hand(mob/user)

	var/choice = input("What would you like to print?") as null|anything in products
	if(!choice)
		return

	if(stored_matter >= products[choice][2])

		stored_matter -= products[choice][2]
		var/new_organ = products[choice][1]
		var/obj/item/organ/O = new new_organ(get_turf(src))

		if(prints_prosthetics)
			O.robotic = 2
		else if(loaded_dna)
			visible_message("<b>[src]</b> injects the stored DNA into the biomass.")
			O.transplant_data = list()
			var/datum/weakref/W = loaded_dna["donor"]
			var/mob/living/carbon/C = W.resolve()
			if (C)
				O.transplant_data["species"] =    C.species.name
				O.transplant_data["blood_type"] = loaded_dna["blood_type"]
				O.transplant_data["blood_DNA"] =  loaded_dna["blood_DNA"]

		visible_message("<b>[src]</b> spits out a new organ.")

	else
		to_chat(user, SPAN_WARNING("There is not enough matter in [src]."))

/obj/machinery/bioprinter/attackby(obj/item/W, mob/user)

	// DNA sample from syringe.
	if(!prints_prosthetics && istype(W,/obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			to_chat(user, SPAN_INFO("You inject the blood sample into the bioprinter."))
		return
	// Meat for biomass.
	var/consumed
	if(!prints_prosthetics && istype(W, /obj/item/reagent_containers/food/snacks/meat))
		stored_matter += 50
		consumed = TRUE
	// Steel for matter.
	if(prints_prosthetics && istype(W, /obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
		var/obj/item/stack/S = W
		stored_matter += S.amount * 10
	if(consumed)
		user.drop_from_inventory(W,src)
		user.visible_message("<b>[src]</b> processes [W].", "<b>[src]</b> processes [W]. Levels of stored [prints_prosthetics ? "biomass" : "matter"] now: [stored_matter]")
		qdel(W)

	return..()
