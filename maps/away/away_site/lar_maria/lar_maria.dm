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
			<i>We received the latest batch of subjects this evening. Evening? Is it even evening? The schedule out here is so fucked in terms of sleep-cycles I forget to even check what time it is sometimes. I'm pretty sure it's evening anyway. Anyway, point is, we got the greimorians, and thus far they seem like perfect subjects for our work.</i>
			"}

/obj/item/paper/lar_maria/note_2
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>I can't believe it, the type 8 Serum seems to actually have a regenerative effect on the subjects. We actually cut one's arm open during the test and ten minutes later, it had clotted. Fifteen and it was healing, and within two hours it was nothing but a fading scar. This is insanity, and the worst part is, we can't even determine HOW it does it yet. All these samples of the goo and not a damn clue how it works, it's infuriating! I'm going to try some additional tests with this stuff. I've heard it's got all kinds of uses, fuel enhancer, condiment, so on and so forth, even with this minty taste, but we'll see. There's got to be some rhyme or reason to this damned stuff.</i>
			"}

/obj/item/paper/lar_maria/note_3
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>The samples of Type 8 we've got are almost out, but it seems like we're actually onto something major here. We'll need to get more sent over asap. This stuff may well be the key to immortality. We cut off one of the test subject's arms and they just put it back on and it healed in an hour or so to the point it was working fine. It's nothing short of miraculous.</i>
			"}

/obj/item/paper/lar_maria/note_4
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Tedd, don't get into the cells with the Type 8 subjects anymore, something's off about them the last couple days. They haven't been moving right, and they seem distracted nearly constantly, and not in a normal way. They also look like they're turning kinda... green? One of the other guys says it's probably just a virus or something reacting with it, but I don't know, something seems off.</i>
			"}

/obj/item/paper/lar_maria/note_5
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			This is a reminder to all facility staff, while we may be doing important work for the good of humanity here, our methods are not necessarily one hundred percent legal under SCG law, and as such you are NOT permitted, as outlined in your contract, to discuss the nature of your work, nor any other related information, with anyone not directly involved with the project without express permission of your facility director. This includes family, friends, local or galactic news outlets and bluenet chat forums.
			"}

/obj/item/paper/lar_maria/note_6
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			Due to the recent incident in the labs involving Type 8 test subject #12 and #33, all research personnel are to refrain from interacting directly with the research subjects involved in serum type 8 testing without the presence of armed guards and full Biohazard protective measures in place.
			"}

/obj/item/paper/lar_maria/note_7
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>Can we get some more diversity in test subjects? I know we're mostly working off SCG undesirables, but martians and frontier colonists aren't exactly the most varied bunch. We could majorly benefit from having some Skrell test subjects, for example. Oooh, or one of those GAS things Xynergy's got a monopoly on.</i>
			"}

/obj/item/paper/lar_maria/note_8
	name = "paper note"
	info = {"<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></center>
			<i>On a related note, can we get some more female subjects? There's been some discussion about gender related differences in reactions to some of the chemicals we're working on. Testosterone and shit affecting chemical balances or something, I'm not sure, point is, variety.</i>
			"}

/obj/item/paper/lar_maria/note_9
	name = "paper note"
	info = "<i><font color='blue'>can we get some fresh carp sometime? Or freshish? Or frozen? I just really want carp, ok? I'm willing to pay for it if so.</font></i>"
