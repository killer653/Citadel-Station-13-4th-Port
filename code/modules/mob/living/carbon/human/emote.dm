var/fartholdin = 1 //these variables are defined here because I'm a lazy fuck that doesn't want to find a way to circumvent it
var/cansuperfart = 1
var/exception = 1
var/ticker.current_state = 3


/mob/living/carbon/human/emote(act,m_type=1,message = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)


	var/muzzled = is_muzzled()
	//var/m_type = 1

	for (var/obj/item/weapon/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings ANGRILY!"
				m_type = 2

		if ("choke","chokes")
			if (miming)
				message = "<B>[src]</B> clutches \his throat desperately!"
			else
				..(act)

		if ("chuckle","chuckles")
			if(miming)
				message = "<B>[src]</B> appears to chuckle."
			else
				..(act)

		if ("clap","claps")
			if (!src.restrained())
				message = "<B>[src]</B> claps."
				m_type = 2

		if ("collapse","collapses")
			Paralyse(2)
			adjustStaminaLoss(100) // Hampers abuse against simple mobs, but still leaves it a viable option.
			message = "<B>[src]</B> collapses!"
			m_type = 2

		if ("cough","coughs")
			if (miming)
				message = "<B>[src]</B> appears to cough!"
			else
				if (!muzzled)
					message = "<B>[src]</B> coughs!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a strong noise."
					m_type = 2

		if ("cry","crys","cries") //I feel bad if people put s at the end of cry. -Sum99
			if (miming)
				message = "<B>[src]</B> cries."
			else
				if (!muzzled)
					message = "<B>[src]</B> cries."
					m_type = 2
				else
					message = "<B>[src]</B> makes a weak noise. \He frowns."
					m_type = 2

		if ("custom")
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

		if ("dap","daps")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>[src]</B> gives daps to [M]."
				else
					message = "<B>[src]</B> sadly can't find anybody to give daps to, and daps \himself. Shameful."

		if ("eyebrow")
			message = "<B>[src]</B> raises an eyebrow."
			m_type = 1

		if ("flap","flaps")
			if (!src.restrained())
				message = "<B>[src]</B> flaps \his wings."
				m_type = 2

		if ("gasp","gasps")
			if (miming)
				message = "<B>[src]</B> appears to be gasping!"
			else
				..(act)

		if ("giggle","giggles")
			if (miming)
				message = "<B>[src]</B> giggles silently!"
			else
				..(act)

		if ("groan","groans")
			if (miming)
				message = "<B>[src]</B> appears to groan!"
			else
				if (!muzzled)
					message = "<B>[src]</B> groans!"
					m_type = 2
				else
					message = "<B>[src]</B> makes a loud noise."
					m_type = 2

		if ("grumble","grumbles")
			if (!muzzled)
				message = "<B>[src]</B> grumbles!"
			else
				message = "<B>[src]</B> makes a noise."
				m_type = 2

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>[src]</B> shakes hands with [M]."
					else
						message = "<B>[src]</B> holds out \his hand to [M]."

		if ("hug","hugs")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>[src]</B> hugs [M]."
				else
					message = "<B>[src]</B> hugs \himself."

		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='danger'>You cannot send IC messages (muted).</span>"
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				message = "<B>[src]</B> [message]"

		if ("moan","moans")
			if(miming)
				message = "<B>[src]</B> appears to moan!"
			else
				message = "<B>[src]</B> moans!"
				m_type = 2

		if ("mumble","mumbles")
			message = "<B>[src]</B> mumbles!"
			m_type = 2

		if ("pale")
			message = "<B>[src]</B> goes pale for a second."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>[src]</B> raises a hand."
			m_type = 1

		if ("salute","salutes")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>[src]</B> salutes to [param]."
				else
					message = "<B>[src]</b> salutes."
			m_type = 1

		if ("scream","screams")
			if (miming)
				message = "<B>[src]</B> acts out a scream!"
			else
				..(act)

		if ("shiver","shivers")
			message = "<B>[src]</B> shivers."
			m_type = 1

		if ("shrug","shrugs")
			message = "<B>[src]</B> shrugs."
			m_type = 1

		if ("sigh","sighs")
			if(miming)
				message = "<B>[src]</B> sighs."
			else
				..(act)

		if ("signal","signals")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>[src]</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze","sneezes")
			if (miming)
				message = "<B>[src]</B> sneezes."
			else
				..(act)

		if ("sniff","sniffs")
			message = "<B>[src]</B> sniffs."
			m_type = 2

		if ("snore","snores")
			if (miming)
				message = "<B>[src]</B> sleeps soundly."
			else
				..(act)

		if ("whimper","whimpers")
			if (miming)
				message = "<B>[src]</B> appears hurt."
			else
				..(act)

		if ("fart") //time for awful code
			var/obj/item/organ/butt/B = null
			B = locate() in src.internal_organs
			if(!B)
				src << "\red You don't have a butt!"
				return
			if(src.HasDisease(/datum/disease/assinspection))
				src << "<span class='danger'>Your ass hurts too much.</span>"
				return
			for(var/mob/living/M in range(0)) //Bye ghost farts, you will be missed :'(
				if(M != src)
					visible_message("\red <b>[src]</b> farts in <b>[M]</b>'s face!")
				else
					continue
			message = "<B>[src]</B> [pick(
			"rears up and lets loose a fart of tremendous magnitude!",
			"farts!",
			"toots.",
			"harvests methane from uranus at mach 3!",
			"assists global warming!",
			"farts and waves their hand dismissively.",
			"farts and pretends nothing happened.",
			"is a <b>farting</b> motherfucker!",
			"<B><font color='red'>f</font><font color='blue'>a</font><font color='red'>r</font><font color='blue'>t</font><font color='red'>s</font></B>")]"
			playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
			if(prob(12))
				B = locate() in src.internal_organs
				if(B)
					src.internal_organs -= B
					new /obj/item/organ/butt(src.loc)
					new /obj/effect/decal/cleanable/blood(src.loc)
				for(var/mob/living/M in range(0))
					if(M != src)
						visible_message("\red <b>[src]</b>'s ass hits <b>[M]</b> in the face!", "\red Your ass smacks <b>[M]</b> in the face!")
						M.apply_damage(15,"brute","head")
				visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")
		if("superfart") //how to remove ass
			exception = 1
			if (ticker.current_state == 3)//safety1
				if(world.time < fartholdin)//safety2
					src << "Your ass is not ready to blast."
					return
				else
					if(cansuperfart)
						var/obj/item/organ/butt/B = null
						B = locate() in src.internal_organs
						if(!B)
							src << "\red You don't have a butt!"
							return
						else if(B)
							src.internal_organs -= B
						//src.butt = null
						src.nutrition -= 500 //vv THIS CODE IS MELTING MY EYES AND I'M NOT ALLOWED TO FIX IT HELP vv
						playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
						spawn(1)
							playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
							spawn(1)
								playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
								spawn(1)
									playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
									spawn(1)
										playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
										spawn(1)
											playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
											spawn(1)
												playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
												spawn(1)
													playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
													spawn(1)
														playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
														spawn(1)
															playsound(src.loc, 'sound/misc/fart.ogg', 50, 1, 5)
															spawn(5)
																playsound(src.loc, 'sound/misc/fartmassive.ogg', 75, 1, 5)
																new /obj/item/organ/butt(src.loc)
																new /obj/effect/decal/cleanable/blood(src.loc)
																if(src.HasDisease(/datum/disease/assinspection))
																	src << "<span class='danger'>It hurts so much!</span>"
																	apply_damage(50, BRUTE, "chest")
																if(prob(76))
																	for(var/mob/living/M in range(0))
																		if(M != src)
																			visible_message("\red <b>[src]</b>'s ass blasts <b>[M]</b> in the face!", "\red You ass blast <b>[M]</b>!")
																			M.apply_damage(75,"brute","head")
																		else
																			continue
																	visible_message("\red <b>[src]</b> blows their ass off!", "\red Holy shit, your butt flies off in an arc!")
																else if(prob(12))
																	var/startx = 0
																	var/starty = 0
																	var/endy = 0
																	var/endx = 0
																	var/startside = pick(cardinal)

																	switch(startside)
																		if(NORTH)
																			starty = src.loc
																			startx = src.loc
																			endy = 38
																			endx = rand(41, 199)
																		if(EAST)
																			starty = src.loc
																			startx = src.loc
																			endy = rand(38, 187)
																			endx = 41
																		if(SOUTH)
																			starty = src.loc
																			startx = src.loc
																			endy = 187
																			endx = rand(41, 199)
																		else
																			starty = src.loc
																			startx = src.loc
																			endy = rand(38, 187)
																			endx = 199

																	//ASS BLAST USA
																	visible_message("\red <b>[src]</b> blows their ass off with such force, it turns into an immovable ass!", "\red Holy shit, your butt flies off into the galaxy!")
																	usr.gib() //don't superfart without thinking of the consequences kids
																	new /obj/effect/immovablerod/butt(locate(startx, starty, 1), locate(endx, endy, 1))
																	priority_announce("What the fuck was that?!", "Assblast Alert")
																else if(prob(12))
																	visible_message("\red <b>[src]</b> rips their ass apart in a massive explosion!", "\red Holy shit, your butt goes supernova!")
																	explosion(src.loc,0,1,3,flame_range = 3)
																	usr.gib() // see above comment

		if ("yawn","yawns")
			if (!muzzled)
				message = "<B>[src]</B> yawns."
				m_type = 2

		if("wag","wags")
			if(dna && dna.species && (("tail_lizard" in dna.species.mutant_bodyparts) || (dna.features["tail_human"] != "None")))
				message = "<B>[src]</B> wags \his tail."
				startTailWag()
			else
				src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if("stopwag")
			if(dna && dna.species && (("waggingtail_lizard" in dna.species.mutant_bodyparts) || ("waggingtail_human" in dna.species.mutant_bodyparts)))
				message = "<B>[src]</B> stops wagging \his tail."
				endTailWag()
			else
				src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if ("help") //This can stay at the bottom.
			src << "Help for human emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, dance, dap, deathgasp, drool, eyebrow, faint, flap, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, jump, laugh, look-(none)/mob, me, moan, mumble, nod, pale, point-(atom), raise, salute, scream, shake, shiver, shrug, sigh, signal-#1-10, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, stopwag, tremble, twitch, twitch_s, wave, whimper, wink, wag, yawn"

		else
			..(act)

	if(miming)
		m_type = 1



	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			visible_message(message)
		else if (m_type & 2)
			audible_message(message)



//Don't know where else to put this, it's basically an emote
/mob/living/carbon/human/proc/startTailWag()
	if(!dna || !dna.species)
		return
	if("tail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_lizard"
		dna.species.mutant_bodyparts -= "spines"
		dna.species.mutant_bodyparts |= "waggingtail_lizard"
		dna.species.mutant_bodyparts |= "waggingspines"
	if("tail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_human"
		dna.species.mutant_bodyparts |= "waggingtail_human"
	update_body()


/mob/living/carbon/human/proc/endTailWag()
	if(!dna || !dna.species)
		return
	if("waggingtail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_lizard"
		dna.species.mutant_bodyparts -= "waggingspines"
		dna.species.mutant_bodyparts |= "tail_lizard"
		dna.species.mutant_bodyparts |= "spines"
	if("waggingtail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_human"
		dna.species.mutant_bodyparts |= "tail_human"
	update_body()