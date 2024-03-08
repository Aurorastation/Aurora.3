/obj/machinery/antibody_extractor
	name = "antibody extractor"
	desc = "A machine made to extract antibodies. There's a holographic info-label on it..."
	desc_extended = "This machine is made to extract antibodies from a subject. It will only work with the <b>unmutated, original</b> version of the virus. \
					<span class='danger'>This machine will immediately notify the entire facility if used without authorization.</span>"
	icon = 'icons/obj/raccoon_city/extractor.dmi'
	icon_state = "extractor"
	var/mob/living/carbon/human/intended_target
	var/mob/living/carbon/human/current_target
