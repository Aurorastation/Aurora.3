/atom/vv_get_header()
	. = ..()
	. += {"
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/vv_get_header()
	. = ..()
	. += {"
		<br><font size='1'>
		<br><a href='?_src_=vars;datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("mob_player_panel", "Show player panel")
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION("give_spell", "Give Spell")
	VV_DROPDOWN_OPTION("godmode", "Toggle Godmode")

	VV_DROPDOWN_OPTION("make_skeleton", "Make 2spooky")

	VV_DROPDOWN_OPTION("direct_control", "Assume Direct Control")
	VV_DROPDOWN_OPTION("drop_everything", "Drop Everything")

	VV_DROPDOWN_OPTION("regenerateicons", "Regenerate Icons")
	VV_DROPDOWN_OPTION("addlanguage", "Add Language")
	VV_DROPDOWN_OPTION("remlanguage", "Remove Language")
	VV_DROPDOWN_OPTION("addorgan", "Add Organ")
	VV_DROPDOWN_OPTION("remorgan", "Remove Organ")

	VV_DROPDOWN_OPTION("addverb", "Add Verb")
	VV_DROPDOWN_OPTION("remverb", "Remove Verb")
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION("gib", "Gib")
	VV_DROPDOWN_OPTION("dust", "Turn to dust")
	VV_DROPDOWN_OPTION("explode", "Trigger explosion")
	VV_DROPDOWN_OPTION("emp", "Trigger EM pulse")

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("setspecies", "Set Species")
	VV_DROPDOWN_OPTION("makeai", "Make AI")
	VV_DROPDOWN_OPTION("makerobot", "Make cyborg")
	VV_DROPDOWN_OPTION("makemonkey", "Make monkey")
	VV_DROPDOWN_OPTION("makeslime", "Make slime")

/obj/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("delall", "Delete all of type")
	VV_DROPDOWN_OPTION("explode", "Trigger explosion")
	VV_DROPDOWN_OPTION("emp", "Trigger EM pulse")

/turf/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("explode", "Trigger explosion")
	VV_DROPDOWN_OPTION("emp", "Trigger EM pulse")
