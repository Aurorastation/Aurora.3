//PAPERS
/obj/item/weapon/paper/REDresult
	name = "RED Scan Results"
	icon_state = "pamphlet"

/obj/item/weapon/paper/REDresult/proc/changeinfo(var/mob/T, var/scantype, var/scanduration)
        info = {"\[center\]\[logo\]\[/center\]
\[center\]\[b\]\[i\]Official NanoTrasen science report.\[/b\]\[/i\]\[hr\]
\[small\]RED Scan completed at: \[b\][station_name()]\[/b\], time taken: scanduration ? [scanduration] : Unknown , Type: scantype ? [scantype] : Unknown Completed. Scan results:\[br\]
\[br\]
While preparing a convicted individual, remove their ID and have the terminal scan it.\[br\]
Next, select all applicable charges from the menu available. The computer will calculate the sentence based on the minimum recommended sentence - any variables such as repeat offense will need to be manually accounted for.\[br\]
After all the charges have been applied, the processing officer is invited to add a short description of the incident, any related evidence, and any witness testimonies.\[br\]
Simply press the option "Render Guilty", and the sentence is complete! The convict's records will be automatically updated to reflect their crimes. You should now insert the printed receipt into the cell timer, and begin processing.\[br\]
\[hr\]
Please note: Cell timers will \[b\]NOT\[/b\] function without a valid incident form receipt inserted into them.
\[small\]FOR USE BY SECURITY ONLY\[/small\]\[br\]"}