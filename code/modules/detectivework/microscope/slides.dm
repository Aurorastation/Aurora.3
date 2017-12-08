	name = "microscope slide"
	desc = "A pair of thin glass panes used in the examination of samples beneath a microscope."
	icon_state = "slide"

	if(has_swab || has_sample)
		user << "<span class='warning'>There is already a sample in the slide.</span>"
		return
		has_swab = W
		has_sample = W
	else
		user << "<span class='warning'>You don't think this will fit.</span>"
		return
	user << "<span class='notice'>You insert the sample into the slide.</span>"
	user.unEquip(W)
	W.forceMove(src)
	update_icon()

	if(has_swab || has_sample)
		user << "<span class='notice'>You remove \the sample from \the [src].</span>"
		if(has_swab)
			has_swab.loc = get_turf(src)
			has_swab = null
		if(has_sample)
			has_sample.forceMove(get_turf(src))
			has_sample = null
		update_icon()
		return

	if(!has_swab && !has_sample)
		icon_state = "slide"
	else if(has_swab)
		icon_state = "slideswab"
	else if(has_sample)
		icon_state = "slidefiber"
