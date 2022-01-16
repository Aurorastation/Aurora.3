//microscope code itself
/obj/machinery/microscope
	name = "high powered electron microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	desc_info = "Use a microscope slide or a fingerprint card on this machine to insert it.\
	\nAlt click to remove any object within it."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = 1
	density = 1

	var/obj/item/sample = null
	var/report_fiber_num = 0
	var/report_print_num = 0
	var/report_gsr_num = 0

/obj/machinery/microscope/attackby(obj/item/W as obj, mob/user as mob)

	if(sample)
		to_chat(user, SPAN_WARNING("There is already a slide in the microscope."))
		return

	if(istype(W, /obj/item/forensics/slide) || istype(W, /obj/item/sample/print))
		to_chat(user, SPAN_NOTICE("You insert \the [W] into the microscope."))
		user.unEquip(W)
		W.forceMove(src)
		sample = W
		update_icon()
		return

/obj/machinery/microscope/attack_hand(mob/user)

	if(!sample)
		to_chat(user, SPAN_WARNING("The microscope has no sample to examine."))
		return

	to_chat(user, SPAN_NOTICE("The microscope whirrs as you examine \the [sample]."))

	if(!do_after(user, 25) || !sample)
		return

	to_chat(user, SPAN_NOTICE("Printing findings now..."))
	var/obj/item/paper/report = new()
	var/pname
	var/info
	report.stamped = list(/obj/item/stamp)
	report.overlays = list("paper_stamped")

	if(istype(sample, /obj/item/forensics/slide))
		var/obj/item/forensics/slide/slide = sample
		if(slide.has_swab)
			var/obj/item/forensics/swab/swab = slide.has_swab
			report_gsr_num++
			pname = "GSR report #[report_gsr_num]"
			info = "<b><font size=\"4\">GSR anaylsis report #[report_gsr_num]</font></b><HR>"
			if(length(swab.gsr))
				info += "Residue analysis of the [swab.name] has determined the presence of the following residues.<ul>"
				for(var/gsr in swab.gsr)
					info += "<li>Residue from a [gsr] bullet detected.</li>"
				info += "</ul>"
			else
				info += "No gunpowder residue found."

		else if(slide.has_sample)
			var/obj/item/sample/fibers/fibers = slide.has_sample
			report_fiber_num++
			pname = "Fiber report #[report_fiber_num]"
			if(fibers.evidence)
				info = "<b><font size=\"4\">Fiber anaylsis report #[report_fiber_num]</font></b><HR>"
				info += "<b>Source locations:</b> "
				info += "[english_list(fibers.source, "no sources were found", ", ", ", ", "")].<br><br>"
				info += "Molecular analysis on [fibers.name] has determined the presence of unique fiber strings.<ul>"
				for(var/fiber in fibers.evidence)
					info += "<li><b>Most likely match for fibers:</b> [fiber]</li>"
				info += "</ul>"
			else
				info += "No fibers found."
		else
			pname = "Empty slide report #[report_fiber_num]"
			info = "Evidence suggests that there's nothing in this slide."
	else if(istype(sample, /obj/item/sample/print))
		report_print_num++
		pname = "Fingerprint report #[report_print_num]"
		var/obj/item/sample/print/card = sample
		info = "<b><font size=\"4\">Fingerprint analysis report #[report_print_num]</font></b><HR>"
		info += "<b>Source locations:</b> "
		info += "[english_list(card.source, "no sources were found", ", ", ", ", "")].<br><br>"
		if(card.evidence && card.evidence.len)
			info += "Surface analysis has determined unique fingerprint strings:<ul>"
			for(var/prints in card.evidence)
				info += "<li><b>Fingerprint string: </b>"
				if(!is_complete_print(prints))
					info += "INCOMPLETE PRINT"
				else
					info += "[prints]"
				info += "</li>"
			info += "</ul>"
		else
			info += "No information available."

	report.set_content_unsafe(pname, info)

	if(report)
		report.update_icon()
		if(report.info)
			to_chat(user, report.info)
	print(report)

/obj/machinery/microscope/proc/remove_sample(var/mob/living/remover)
	if(!istype(remover) || remover.incapacitated() || !Adjacent(remover))
		return
	if(!sample)
		to_chat(remover, SPAN_WARNING("\The [src] does not have a sample in it."))
		return
	to_chat(remover, SPAN_NOTICE("You remove \the [sample] from \the [src]."))
	sample.forceMove(get_turf(src))
	remover.put_in_hands(sample)
	sample = null
	update_icon()

/obj/machinery/microscope/AltClick()
	remove_sample(usr)

/obj/machinery/microscope/MouseDrop(var/atom/other)
	if(usr == other)
		remove_sample(usr)
	else
		return ..()

/obj/machinery/microscope/update_icon()
	icon_state = "microscope"
	if(sample)
		icon_state += "slide"
