
#define A_BIG_NUMBER			9999999
#define STATE_COUNT_NORMAL		4
#define STATE_COUNT_DIAGONAL	7


/mob/verb/ChooseDMI(dmi as file)
	var/dmifile = file(dmi)
	if(isfile(dmifile) && (copytext("[dmifile]",-4) == ".dmi"))
		SliceNDice(dmifile)
	else
		world << "\red Bad DMI file '[dmifile]'"


/proc/SliceNDice(dmifile as file)
	var/icon/sourceIcon = icon(dmifile)
	var/list/states = sourceIcon.IconStates()
	world << "<B>[dmifile] - states: [states.len]</B>"

	switch(states.len)
		if(0 to (STATE_COUNT_NORMAL - 1))
			var/cont = alert(usr, "Too few states: [states.len],  expected [STATE_COUNT_NORMAL] (Non-Diagonal) or [STATE_COUNT_DIAGONAL] (Diagonal), Continue?", "Unexpected Amount of States", "Yes", "No")
			if(cont == "No")
				return
		if(STATE_COUNT_NORMAL)
			world << "4 States, running in Non-Diagonal mode"
		if(STATE_COUNT_DIAGONAL)
			world << "5 States, running in Diagonal mode"
		if((STATE_COUNT_DIAGONAL + 1) to A_BIG_NUMBER)
			var/cont = alert(usr, "Too many states: [states.len],  expected [STATE_COUNT_NORMAL] (Non-Diagonal) or [STATE_COUNT_DIAGONAL] (Diagonal), Continue?", "Unexpected Amount of States", "Yes", "No")
			if(cont == "No")
				return


	var/icon/outputIcon = new /icon()

	var/filename = "[copytext("[dmifile]", 1, -4)]-smooth.dmi"
	fdel(filename) //force refresh

	for(var/state in states)
		var/statename = lowertext(state)
		outputIcon = icon(filename) //open the icon again each iteration, to work around byond memory limits

		switch(statename)
			if("i")
				var/icon/i = icon(sourceIcon, state)

				var/icon/corner1i = icon(i)
				corner1i.DrawBox(null, 1, 1, 32, 24)
				corner1i.DrawBox(null, 17, 1, 32, 32)
				outputIcon.Insert(corner1i, "1-i")

				var/icon/corner2i = icon(i)
				corner2i.DrawBox(null, 1, 1, 16, 32)
				corner2i.DrawBox(null, 17, 1, 32, 24)
				outputIcon.Insert(corner2i, "2-i")

				var/icon/corner3i = icon(i)
				corner3i.DrawBox(null, 1, 32, 16, 25)
				corner3i.DrawBox(null, 17, 32, 32, 1)
				outputIcon.Insert(corner3i, "3-i")

				var/icon/corner4i = icon(i)
				corner4i.DrawBox(null, 1, 1, 16, 32)
				corner4i.DrawBox(null, 17, 32, 32, 25)
				outputIcon.Insert(corner4i, "4-i")

			if("ns")
				var/icon/ns = icon(sourceIcon, state)

				//Vertical
				var/icon/line1n = icon(ns)
				line1n.DrawBox(null, 1, 1, 32, 24)
				line1n.DrawBox(null, 17, 1, 32, 32)
				outputIcon.Insert(line1n, "1-n")

				var/icon/line2n = icon(ns)
				line2n.DrawBox(null, 1, 1, 16, 32)
				line2n.DrawBox(null, 17, 1, 32, 24)
				outputIcon.Insert(line2n, "2-n")

				var/icon/line3s = icon(ns)
				line3s.DrawBox(null, 1, 32, 16, 25)
				line3s.DrawBox(null, 17, 32, 32, 1)
				outputIcon.Insert(line3s, "3-s")

				var/icon/line4s = icon(ns)
				line4s.DrawBox(null, 1, 1, 16, 32)
				line4s.DrawBox(null, 17, 32, 32, 25)
				outputIcon.Insert(line4s, "4-s")

			if("we")
				var/icon/we = icon(sourceIcon, state)

				//Horizontal
				var/icon/line1w = icon(we)
				line1w.DrawBox(null, 1, 1, 32, 24)
				line1w.DrawBox(null, 17, 1, 32, 32)
				outputIcon.Insert(line1w, "1-w")

				var/icon/line2e = icon(we)
				line2e.DrawBox(null, 1, 1, 16, 32)
				line2e.DrawBox(null, 17, 1, 32, 24)
				outputIcon.Insert(line2e, "2-e")

				var/icon/line3w = icon(we)
				line3w.DrawBox(null, 1, 32, 16, 25)
				line3w.DrawBox(null, 17, 32, 32, 1)
				outputIcon.Insert(line3w, "3-w")

				var/icon/line4e = icon(we)
				line4e.DrawBox(null, 1, 1, 16, 32)
				line4e.DrawBox(null, 17, 32, 32, 25)
				outputIcon.Insert(line4e, "4-e")

			if("nwse")
				var/icon/nwse = icon(sourceIcon, state)

				var/icon/corner1nw = icon(nwse)
				corner1nw.DrawBox(null, 1, 1, 32, 24)
				corner1nw.DrawBox(null, 17, 1, 32, 32)
				outputIcon.Insert(corner1nw, "1-nw")

				var/icon/corner2ne = icon(nwse)
				corner2ne.DrawBox(null, 1, 1, 16, 32)
				corner2ne.DrawBox(null, 17, 1, 32, 24)
				outputIcon.Insert(corner2ne, "2-ne")

				var/icon/corner3sw = icon(nwse)
				corner3sw.DrawBox(null, 1, 32, 16, 25)
				corner3sw.DrawBox(null, 17, 32, 32, 1)
				outputIcon.Insert(corner3sw, "3-sw")

				var/icon/corner4se = icon(nwse)
				corner4se.DrawBox(null, 1, 1, 16, 32)
				corner4se.DrawBox(null, 17, 32, 32, 25)
				outputIcon.Insert(corner4se, "4-se")

			if("f")
				var/icon/f = icon(sourceIcon, state)

				var/icon/corner1f = icon(f)
				corner1f.DrawBox(null, 1, 1, 32, 24)
				corner1f.DrawBox(null, 17, 1, 32, 32)
				outputIcon.Insert(corner1f, "1-f")

				var/icon/corner2f = icon(f)
				corner2f.DrawBox(null, 1, 1, 16, 32)
				corner2f.DrawBox(null, 17, 1, 32, 24)
				outputIcon.Insert(corner2f, "2-f")

				var/icon/corner3f = icon(f)
				corner3f.DrawBox(null, 1, 32, 16, 25)
				corner3f.DrawBox(null, 17, 32, 32, 1)
				outputIcon.Insert(corner3f, "3-f")

				var/icon/corner4f = icon(f)
				corner4f.DrawBox(null, 1, 1, 16, 32)
				corner4f.DrawBox(null, 17, 32, 32, 25)
				outputIcon.Insert(corner4f, "4-f")

			if("diag")
				var/icon/diag = icon(sourceIcon, state)

				var/icon/diagse = icon(diag) //No work
				outputIcon.Insert(diagse, "d-se")

				var/icon/diagsw = icon(diag)
				diagsw.Turn(90)
				outputIcon.Insert(diagsw, "d-sw")

				var/icon/diagne = icon(diag)
				diagne.Turn(-90)
				outputIcon.Insert(diagne, "d-ne")

				var/icon/diagnw = icon(diag)
				diagnw.Turn(180)
				outputIcon.Insert(diagnw, "d-nw")

			if("diag_corner_a")
				var/icon/diag_corner_a = icon(sourceIcon, state)

				var/icon/diagse0 = icon(diag_corner_a) //No work
				outputIcon.Insert(diagse0, "d-se-0")

				var/icon/diagsw0 = icon(diag_corner_a)
				diagsw0.Turn(90)
				outputIcon.Insert(diagsw0, "d-sw-0")

				var/icon/diagne0 = icon(diag_corner_a)
				diagne0.Turn(-90)
				outputIcon.Insert(diagne0, "d-ne-0")

				var/icon/diagnw0 = icon(diag_corner_a)
				diagnw0.Turn(180)
				outputIcon.Insert(diagnw0, "d-nw-0")

			if("diag_corner_b")
				var/icon/diag_corner_b = icon(sourceIcon, state)

				var/icon/diagse1 = icon(diag_corner_b) //No work
				outputIcon.Insert(diagse1, "d-se-0")

				var/icon/diagsw1 = icon(diag_corner_b)
				diagsw1.Turn(90)
				outputIcon.Insert(diagsw1, "d-sw-0")

				var/icon/diagne1 = icon(diag_corner_b)
				diagne1.Turn(-90)
				outputIcon.Insert(diagne1, "d-ne-0")

				var/icon/diagnw1 = icon(diag_corner_b)
				diagnw1.Turn(180)
				outputIcon.Insert(diagnw1, "d-nw-0")



		fcopy(outputIcon, filename)	//Update output icon each iteration
	world << "Finished [filename]!"
