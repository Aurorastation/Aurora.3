/datum/map_template/ruin/away_site/lar_maria
	name = "Lar Maria"
	id = "lar_maria"
	description = "An orbital greimorian research station."
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("away_site/lar_maria/lar_maria-1.dmm", "away_site/lar_maria/lar_maria-2.dmm")
	spawn_weight = 1
	spawn_cost = 2

/singleton/submap_archetype/lar_maria
	map = "Lar Maria"
	descriptor = "It's an orbital research station."

/obj/effect/overmap/visitable/sector/lar_maria
	name = "Lar Maria"
	desc = "Sensors detect a Zeng-Hu research station with a low energy profile and unknown life signs."
	icon_state = "object"

////////////////////////////Notes and papers
/obj/item/paper/lar_maria/note_1
	name = "paper note"
	info = {"
			<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
			<i>We received the latest batch of test subjects this evening,. Evening? Is it even evening? The schedule out here is so fucked in terms of sleep-cycles I forget to even check what time it is sometimes. I'm pretty sure it's evening anyway. Anyway, point is, we got the greimorians straight from Greima's orbit, and thus far they seem like perfect subjects for our work.</i>
			"}

/obj/item/paper/lar_maria/note_2
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>The Greiomrians have shown fascinating behavior patterns since their arrival. They exhibit an affinity for the crystalized phoron present in their enclosure. Our initial experiments aim to discover why that is so. If Greima still had its phoron atmosphere and its crystals, that would make things much easier. It would seem the Elyrans are the only ones in the galaxy who haven't faced disaster due to this preciarously volatile yet valuable resource. Further observation and controlled studies are required to ascertain the full extent of these interactions.</i>
			"}

/obj/item/paper/lar_maria/note_3
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Specimen B, a larger and more aggressive Greimorian, has proven to be a challenge in containment. It displayed heightened intelligence and an uncanny ability to adapt to its environment. We suspect that it has developed a rudimentary form of problem-solving capability. The specimen's physical characteristics have also undergone significant changes, with its dermal pigmentation shifting to a darker hue. Preliminary data suggests a possible correlation between increased aggression and the shift in pigmentation. Additional precautions are being implemented to ensure the safety of the personnel.</i>
			"}

/obj/item/paper/lar_maria/note_4
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Specimen C has presented an alarming development. It has displayed an ability to emit a highly paralytic toxin from specialized glands located within its limbs. Initial contact with this toxin has resulted in severe muscle spasms and temporary paralysis in the affected subjects. The toxin appears to be a defensive mechanism employed by the Greimorian, possibly to immobilize prey or deter potential threats. The potency of this toxin indicates a significant escalation in the danger posed by these creatures. Additional safety measures and enhanced containment protocols are being implemented.</i>
			"}

/obj/item/paper/lar_maria/note_5
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			This is a reminder to all facility staff, while we may be doing important work for the good of humanity here, you are NOT permitted, as outlined in your contract, to discuss the nature of your work, nor any other related information, with anyone not directly involved with the project without express permission of your facility director. This includes family, friends, local or galactic news outlets and extranet chat forums.
			"}

/obj/item/paper/lar_maria/note_6
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			Specimen D  broke free from its containment chamber, leading to a series of catastrophic events within the station. Its aggression and predatory instincts have reached unparalleled levels. Attempts to subdue the creature were met with violent resistance, resulting in casualties among the research team. No deaths, thankfully. The Greimorian's dermal pigmentation has further deepened, and it appears to be a warrior caste of some sort. Armed security will be present at all times from now on and we're revising our containment protocols.
			"}

/obj/item/paper/lar_maria/note_7
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Can we get some more diversity in test subjects? We could majorly benefit from having some Vaurca, for example. Shame that would be exceptionally difficult to do considering the secrecy of this project.</i>
			"}