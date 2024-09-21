/datum/proc/get_view_variables_header()
	return "<b>[src]</b>"

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=left'><<</a>
		<a href='?_src_=vars;datumedit=[REF(src)];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;rename=[REF(src)]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=left'><<</a> <a href='?_src_=vars;datumedit=[REF(src)];varnameedit=dir'>[dir2text(dir)]</a> <a href='?_src_=vars;rotatedatum=[REF(src)];rotatedir=right'>>></a>
		<br><a href='?_src_=vars;datumedit=[REF(src)];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=[REF(src)];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=[REF(src)];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;mob_player_panel=[REF(src)]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;give_spell=[REF(src)]'>Give Spell</option>
		<option value='?_src_=vars;give_disease2=[REF(src)]'>Give Disease</option>
		<option value='?_src_=vars;give_disease=[REF(src)]'>Give TG-style Disease</option>
		<option value='?_src_=vars;godmode=[REF(src)]'>Toggle Godmode</option>
		<option value='?_src_=vars;build_mode=[REF(src)]'>Toggle Build Mode</option>

		<option value='?_src_=vars;ninja=[REF(src)]'>Make Space Ninja</option>
		<option value='?_src_=vars;make_skeleton=[REF(src)]'>Make 2spooky</option>

		<option value='?_src_=vars;direct_control=[REF(src)]'>Assume Direct Control</option>
		<option value='?_src_=vars;drop_everything=[REF(src)]'>Drop Everything</option>

		<option value='?_src_=vars;regenerateicons=[REF(src)]'>Regenerate Icons</option>
		<option value='?_src_=vars;addlanguage=[REF(src)]'>Add Language</option>
		<option value='?_src_=vars;remlanguage=[REF(src)]'>Remove Language</option>
		<option value='?_src_=vars;addorgan=[REF(src)]'>Add Organ</option>
		<option value='?_src_=vars;remorgan=[REF(src)]'>Remove Organ</option>

		<option value='?_src_=vars;fix_nano=[REF(src)]'>Fix NanoUI</option>

		<option value='?_src_=vars;addverb=[REF(src)]'>Add Verb</option>
		<option value='?_src_=vars;remverb=[REF(src)]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;gib=[REF(src)]'>Gib</option>
		<option value='?_src_=vars;dust=[REF(src)]'>Turn to dust</option>
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;setspecies=[REF(src)]'>Set Species</option>
		<option value='?_src_=vars;makeai=[REF(src)]'>Make AI</option>
		<option value='?_src_=vars;makerobot=[REF(src)]'>Make cyborg</option>
		<option value='?_src_=vars;makemonkey=[REF(src)]'>Make monkey</option>
		<option value='?_src_=vars;makeslime=[REF(src)]'>Make slime</option>
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;delall=[REF(src)]'>Delete all of type</option>
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}

/turf/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;explode=[REF(src)]'>Trigger explosion</option>
		<option value='?_src_=vars;emp=[REF(src)]'>Trigger EM pulse</option>
		"}
