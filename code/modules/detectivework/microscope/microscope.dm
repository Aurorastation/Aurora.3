//microscope code itself
/obj/machinery/microscope
	name = "high powered electron microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = 1
	density = 1

	var/obj/item/sample = null
	var/report_num = 0

/obj/machinery/microscope/attackby(obj/item/W as obj, mob/user as mob)

	if(sample)
		to_chat(user, "<span class='warning'>There is already a slide in the microscope.</span>")
		return

	if(istype(W, /obj/item/forensics/slide) || istype(W, /obj/item/sample/print))
		to_chat(user, "<span class='notice'>You insert \the [W] into the microscope.</span>")
		user.unEquip(W)
		W.forceMove(src)
		sample = W
		update_icon()
		return

/obj/machinery/microscope/attack_hand(mob/user)

	if(!sample)
		to_chat(user, "<span class='warning'>The microscope has no sample to examine.</span>")
		return

	to_chat(user, "<span class='notice'>The microscope whirrs as you examine \the [sample].</span>")

	if(!do_after(user, 25) || !sample)
		return

	to_chat(user, "<span class='notice'>Printing findings now...</span>")
	var/obj/item/paper/report = new()
	var/pname
	var/info
	report.stamped = list(/obj/item/stamp)
	report.overlays = list("paper_stamped")
	report_num++

	if(istype(sample, /obj/item/forensics/slide))
		var/obj/item/forensics/slide/slide = sample
		if(slide.has_swab)
			var/obj/item/forensics/swab/swab = slide.has_swab

			pname = "GSR report #[++report_num]: [swab.name]"
			info = "<b>Scanned item:</b><br>[swab.name]<br><br>"

			if(swab.gsr)
				info += "Residue from a [swab.gsr] bullet detected."
			else
				info += "No gunpowder residue found."

		else if(slide.has_sample)
			var/obj/item/sample/fibers/fibers = slide.has_sample
			pname = "Fiber report #[++report_num]: [fibers.name]"
			info = "<b>Scanned item:</b><br>[fibers.name]<br><br>"
			if(fibers.evidence)
				info = "Molecular analysis on provided sample has determined the presence of unique fiber strings.<br><br>"
				for(var/fiber in fibers.evidence)
					info += "<span class='notice'>Most likely match for fibers: [fiber]</span><br><br>"
			else
				info += "No fibers found."
		else
			pname = "Empty slide report #[report_num]"
			info = "Evidence suggests that there's nothing in this slide."
	else if(istype(sample, /obj/item/sample/print))
		pname = "Fingerprint report #[report_num]: [sample.name]"
		info = "<b>Fingerprint analysis report #[report_num]</b>: [sample.name]<br>"
		var/obj/item/sample/print/card = sample
		if(card.evidence && card.evidence.len)
			info += "Surface analysis has determined unique fingerprint strings:<br><br>"
			for(var/prints in card.evidence)
				info += "<span class='notice'>Fingerprint string: </span>"
				if(!is_complete_print(prints))
					info += "INCOMPLETE PRINT"
				else
					info += "[prints]"
				info += "<br>"
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
		to_chat(remover, "<span class='warning'>\The [src] does not have a sample in it.</span>")
		return
	to_chat(remover, "<span class='notice'>You remove \the [sample] from \the [src].</span>")
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
