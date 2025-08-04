var/list/powers = typesof(/datum/power/changeling) - /datum/power/changeling	//needed for the badmin verb for now
var/list/datum/power/changeling/powerinstances = list()

/datum/power
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""
	var/isVerb = TRUE	//Is it an active or passive power?
	var/verbpath //Path to a verb that contains the effects.

/datum/power/changeling
	var/allowduringlesserform = FALSE
	/// How many absorbed DNAs we must have before buying this power.
	var/required_dna = 0
	/// Cost for the changeling to evolve this power.
	var/genomecost = 69420

/datum/power/changeling/respec
	name = "Re-adapt"
	desc = "Permits us to re-adapt ourselves to fit a new situation. Requires that we absorb a victim first."
	allowduringlesserform = TRUE
	genomecost = 0
	verbpath = /mob/proc/changeling_try_respec

//DNA absorption

/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to forcibly absorb DNA from another sentient creature. They will perish during the process, but we will be able to mimic their form or re-evolve ourselves. Have caution, this takes some time."
	genomecost = 0
	verbpath = /mob/proc/changeling_absorb_dna

//Transformation

/datum/power/changeling/transform
	name = "Transform"
	desc = "We permanently take on the appearance and voice of one we have absorbed."
	genomecost = 0
	verbpath = /mob/proc/changeling_transform

/datum/power/changeling/lesser_form
	name = "Lesser Form"
	desc = "We debase ourselves and become lesser. We become a weaker, but more mobile form."
	genomecost = 2
	verbpath = /mob/proc/changeling_lesser_form

/datum/power/changeling/mimicvoice
	name = "Mimic Voice"
	desc = "We shape our vocal glands to sound like a desired voice."
	helptext = "Will turn your voice into the name that you enter. We must constantly expend chemicals to maintain our form like this"
	genomecost = 1
	verbpath = /mob/proc/changeling_mimicvoice

/datum/power/changeling/fakedeath
	name = "Regenerative Stasis"
	desc = "We fake our own death, imperceptible to even the best of doctors. We can choose when to re-animate."
	helptext = "Can only be used before death. CAN ONLY BE USED ONCE."
	genomecost = 0
	verbpath = /mob/proc/changeling_fakedeath

/datum/power/changeling/emergency_transform
	name = "Emergency Transform"
	desc = "If circumstances are dire enough, we can detach our head to transform into a lesser form to escape and regenerate later."
	helptext = "Can be used before or after death."
	genomecost = 0
	verbpath = /mob/proc/changeling_emergency_transform

//Hivemind

/datum/power/changeling/hive_upload
	name = "Hive Channel"
	desc = "We can channel a DNA into the airwaves, allowing our fellow changelings to absorb it and transform into it as if they acquired the DNA themselves."
	helptext = "Allows other changelings to absorb the DNA you channel from the airwaves. Will not help them towards their absorb objectives."
	genomecost = 0
	verbpath = /mob/proc/changeling_hiveupload

/datum/power/changeling/hive_download
	name = "Hive Absorb"
	desc = "We can absorb a single DNA from the airwaves, allowing us to use more disguises with help from our fellow changelings."
	helptext = "Allows you to absorb a single DNA and use it. Does not count towards your absorb objective."
	genomecost = 0
	verbpath = /mob/proc/changeling_hivedownload

/datum/power/changeling/hivemind_commune
	name = "Hivemind Commune"
	desc = "We can speak with the members of our Hivemind, without it being apparent to the people in our view."
	genomecost = 0
	verbpath = /mob/proc/changeling_hivemind_commune

/datum/power/changeling/hivemind_eject
	name = "Hivemind Eject"
	desc = "We can eject a pesky hivemind from ourselves, if it complains a lot. This won't free up space, but will prevent them from screaming at us."
	helptext = "Ghosts the chosen hivemind. Use it on salty people spamming you to send them to deadchat."
	genomecost = 0
	verbpath = /mob/proc/changeling_eject_hivemind

/datum/power/changeling/hivemind_morph
	name = "Hivemind Release Morph"
	desc = "We release a hivemind member as a morph. They will be able to crawl inside vents and disguise themselves as objects."
	genomecost = 0
	verbpath = /mob/living/carbon/human/proc/changeling_release_morph

//Stings and sting accessorries
//Rest in pieces, unfat sting. - Geeves

/datum/power/changeling/extract_dna
	name = "Extract DNA Sting"
	desc = "We silently sting a human and copy their DNA, allowing us to mimic their form."
	genomecost = 0
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_extract_dna_sting

/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	genomecost = 2
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_boost_range

/datum/power/changeling/deaf_sting
	name = "Deaf Sting"
	desc = "We sting a human, completely deafening them for a short time."
	genomecost = 1
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_deaf_sting

/datum/power/changeling/blind_sting
	name = "Blind Sting"
	desc = "We sting a human, completely blinding them for a short time."
	genomecost = 1
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_blind_sting

/datum/power/changeling/silence_sting
	name = "Silence Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Does not provide a warning to a victim that they have been stung, until they try to speak and cannot."
	genomecost = 2
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_silence_sting

/datum/power/changeling/transformation_sting
	name = "Transformation Sting"
	desc = "We silently sting a dead human, injecting a retrovirus that forces them to transform into another."
	helptext = "Does not provide a warning to others. The victim will transform much like a changeling would."
	genomecost = 3
	verbpath = /mob/proc/changeling_transformation_sting

/datum/power/changeling/paralysis_sting
	name = "Paralysis Sting"
	desc = "We sting a human, paralyzing them for a short time."
	genomecost = 6
	verbpath = /mob/proc/changeling_paralysis_sting

/datum/power/changeling/hallucinate_sting
	name = "Hallucination Sting"
	desc = "We evolve the ability to sting a target with a powerful hallucinogenic chemical."
	helptext = "The target does not notice they have been stung. The effect occurs after five to fifteen seconds."
	genomecost = 3
	verbpath = /mob/proc/changeling_hallucinate_sting

/datum/power/changeling/death_sting
	name = "Death Sting"
	desc = "We sting a human, transferring five units of cyanide. Their death is likely, unless immediate intervention occurs."
	genomecost = 8
	verbpath = /mob/proc/changeling_death_sting

//Chems and stuff

/datum/power/changeling/adrenaline_sacs
	name = "Adrenaline Sacs"
	desc = "We evolve additional ways of producing stimulants throughout our body."
	helptext = "Gives us the ability to instantly shrug off stuns, as well as producing some painkiller and stimulants."
	genomecost = 1
	verbpath = /mob/proc/changeling_unstun

/datum/power/changeling/ChemicalSynth
	name = "UPGRADE: Rapid Chemical-Synthesis"
	desc = "We evolve new pathways for producing our necessary chemicals, permitting us to naturally create them faster."
	helptext = "More than doubles the rate at which we naturally recharge chemicals."
	genomecost = 4
	isVerb = FALSE
	verbpath = /mob/proc/changeling_fastchemical

/datum/power/changeling/engorged_glands
	name = "UPGRADE: Engorged Chemical Glands"
	desc = "Our chemical glands swell, permitting us to store more chemicals inside of them."
	helptext = "Allows us to store an extra fifty units of chemicals."
	genomecost = 4
	isVerb = FALSE
	verbpath = /mob/proc/changeling_engorgedglands

/datum/power/changeling/nobreathing
	name = "UPGRADE: No Breathing"
	desc = "We no longer have need to breathe, although we go through the motions to fool observers."
	helptext = "Harmful gas can still irritate your eyes and this doesn't mean you can survive in space without a suit. Lung damage can still hurt somewhat."
	genomecost = 2
	isVerb = FALSE
	verbpath = /mob/proc/changeling_nobreathing

/datum/power/changeling/space_adaption
	name = "UPGRADE: Space Adaption"
	desc = "Our body chemistry changes to become resistant to the effects of low pressure, and we no longer have the need to breathe."
	genomecost = 5
	isVerb = FALSE
	verbpath = /mob/proc/changeling_spaceadaption

/datum/power/changeling/rapid_regeneration
	name = "Rapid Regeneration"
	desc = "We evolve the ability to rapidly regenerate, negating the need for stasis."
	helptext = "Heals a moderate amount of damage every tick."
	genomecost = 7
	verbpath = /mob/proc/changeling_rapidregen

//misc

/datum/power/changeling/digital_camouflage
	name = "Digital Camouflage"
	desc = "We evolve the ability to distort our form and proportions, defeating common algorithms used to detect lifeforms on cameras."
	helptext = "An artificial intelligence will not be able to track our movements while we do this. However, anyone looking at us will find us.. uncanny. We must constantly expend chemicals to maintain our form like this."
	genomecost = 1
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_digitalcamo

//weapon and armor like powers

/datum/power/changeling/armblades
	name = "Mutate Armblades"
	desc = "Permits us to reshape our arms into a deadly blade."
	genomecost = 3
	verbpath = /mob/proc/armblades

/datum/power/changeling/shield
	name = "Mutate Shield"
	desc = "Permits us to bloat our hands into a robust shield."
	genomecost = 3
	verbpath = /mob/proc/changeling_shield

/datum/power/changeling/armor
	name = "Integrated Armor"
	desc = "We evolve our skin to harden in response to trauma."
	helptext = "Gives us innate armor, slightly worse than heavy armor."
	genomecost = 1
	isVerb = FALSE
	verbpath = /mob/proc/changeling_armor

/datum/power/changeling/resonant_shriek
	name = "Resonant Shriek"
	desc = "Our lungs and vocal chords evolve, allowing us to briefly emit a noise that deafens and confuses the weak-minded."
	helptext = "Lights are blown, organics are disoriented, and synthetics act as if they were flashed."
	genomecost = 3
	isVerb = TRUE
	verbpath = /mob/proc/resonant_shriek

/datum/power/changeling/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal chords to release a high-frequency sound that overloads synthetics and nearby electronics."
	helptext = "Creates a moderate sized EMP."
	genomecost = 3
	isVerb = TRUE
	verbpath = /mob/proc/dissonant_shriek

/datum/power/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Creates heat receptors in our eyes and dramatically increases light sensing ability."
	helptext = "Grants us thermal vision that can be toggled on or off. This decreases our resistance to flashing."
	genomecost = 2
	isVerb = TRUE
	verbpath = /mob/proc/changeling_thermals

/datum/power/changeling/electric_lockpick
	name = "Electric Lockpick"
	desc = "We discreetly evolve a finger to be able to send a small electric charge.  \
	We can open most electrical locks, but it will be obvious when we do so."
	helptext = "Use the ability, then touch something that utilizes an electrical locking system, to open it.  Each use costs 10 chemicals."
	genomecost = 1
	verbpath = /mob/proc/changeling_electric_lockpick

/datum/power/changeling/horror_form
	name = "Horror Form"
	desc = "We tear apart our human disguise, revealing our true and ultimate form."
	helptext = "We will assume our ultimate form. This is irreversible. While we are in this state, we are extremely powerful."
	genomecost = 10
	required_dna = 3
	verbpath = /mob/proc/horror_form

// Modularchangling, totally stolen from the new player panel.  YAYY
//I'm too afraid to touch this, you win this time, oldcode - Geeves
// After an HTML course, I finally conquered this. Convert into TGUI eventually. - Geeves
/datum/changeling/proc/EvolutionMenu()//The new one
	set category = "Changeling"
	set desc = "Buy new abilities.."

	var/datum/changeling/changeling = usr.mind.antag_datums[MODE_CHANGELING]
	if(!usr || !usr.mind || !changeling)
		return
	src = changeling

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	var/dat = "<html><head><title>Changeling Evolution Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch() {


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != "") {
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == "") {
						return;
					} else {
						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try {
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0) {
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 ) {
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,power,ownsthis){
					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";
					body += "</td><td align='center'>";
					body += "<font color='#79d39e' size='2'>"+desc+"</font><br>";

					if(helptext) {
						body += "<font color='#f14c46' size='2'>"+helptext+"</font><br>";
					}

					if(!ownsthis) {
						body += "<a href='byond://?src=[REF(src)];P="+power+"'>Evolve</a>";
					}

					body += "</td><td align='center'>";
					body += "</td></tr></table>";
					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item") == 0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++) {
							if(locked_tabs\[j\]==id) {
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;

						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1") {
						link.setAttribute("name","2");
					} else {
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++) {
						if(locked_tabs\[j\] == id) {
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
				}

				function attempt(ab) {
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++) {
						if(locked_tabs\[j\] == id) {
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Changeling Evolution Menu</b></font><br>
					Hover over a power to see more information<br>
					Current evolution points left to evolve with: [geneticpoints]<br>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/datum/power/changeling/P in powerinstances)
		var/ownsthis = 0

		if(P in purchasedpowers)
			ownsthis = 1


		var/color = "#2b2b2b"
		if(i%2 == 0)
			color = "#363636"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<font color='#505dcf' id='link[i]' onmouseover='expand("item[i]","[html_encode(P.name)]","[html_encode(P.desc)]","[html_encode(P.helptext)]","[P]",[ownsthis])'><span id='search[i]'><b>Evolve [P] - Cost: [ownsthis ? "Purchased" : P.genomecost]</b></span></font>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	var/datum/browser/power_win = new(usr, "powers", "Changeling Powers", 900, 480)
	power_win.set_content(dat)
	power_win.open()


/datum/changeling/Topic(href, href_list)
	..()
	if(!ismob(usr))
		return

	if(href_list["P"])
		var/datum/mind/M = usr.mind
		if(!istype(M))
			return
		purchasePower(M, href_list["P"])
		call(/datum/changeling/proc/EvolutionMenu)()



/datum/changeling/proc/purchasePower(var/datum/mind/M, var/power_name, var/remake_verbs = 1)
	var/datum/changeling/changeling = M.antag_datums[MODE_CHANGELING]
	if(!M || !changeling)
		return

	var/datum/power/changeling/power = power_name

	for (var/datum/power/changeling/P in powerinstances)
		if(P.name == power_name)
			power = P
			break

	if(power == null)
		to_chat(M.current, SPAN_WARNING("This is awkward. Changeling power purchase failed, please report this bug to a coder!"))
		return

	if(power in purchasedpowers)
		to_chat(M.current, SPAN_WARNING("We have already evolved this ability!"))
		return

	if(geneticpoints < power.genomecost)
		to_chat(M.current, SPAN_WARNING("We lack the genome to evolve this. Re-evolve yourself to reset your genome points."))
		return

	if(length(absorbed_dna) < power.required_dna)
		to_chat(M.current, SPAN_WARNING("Our DNA structure is not complex enough to evolve this. We need at least [(power.required_dna - length(absorbed_dna))] more assimilated DNA structures to buy it."))
		return

	geneticpoints -= power.genomecost

	purchasedpowers += power

	if(!power.isVerb && power.verbpath)
		call(M.current, power.verbpath)()
	else if(remake_verbs)
		M.current.make_changeling()
