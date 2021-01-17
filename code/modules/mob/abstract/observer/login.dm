/mob/abstract/observer/LateLogin()
	..()
	if (ghostimage)
		ghostimage.icon_state = src.icon_state
	compile_overlays() // works like cut_overlays but it actually works
	updateghostimages()
