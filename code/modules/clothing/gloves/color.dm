/obj/item/clothing/gloves/color
	dying_key = DYE_REGISTRY_GLOVES

/obj/item/clothing/gloves/color/chief_engineer
	desc = "These gloves provide protection against electric shock. They are so thin you can barely feel them."
	name = "advanced insulated gloves"
	icon_state = "ce_insuls"
	inhand_icon_state = "lgloves"
	siemens_coefficient = 0

/obj/item/clothing/gloves/color/yellow
	desc = "Эти перчатки защитят пользователя от поражения электрическим током. Очень толстые, скорее всего из таких будет невозможно стрелять."
	name = "резиновые перчатки"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE
	custom_price = PAYCHECK_MEDIUM * 10
	custom_premium_price = PAYCHECK_COMMAND * 6
	cut_type = /obj/item/clothing/gloves/cut
	clothing_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/toy/sprayoncan
	name = "распылитель изолирующего спрея"
	desc = "Какая главная проблема встала сегодня перед нашей станцией?"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "sprayoncan"

/obj/item/toy/sprayoncan/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(iscarbon(target) && proximity)
		var/mob/living/carbon/C = target
		var/mob/living/carbon/U = user
		var/success = C.equip_to_slot_if_possible(new /obj/item/clothing/gloves/color/yellow/sprayon, ITEM_SLOT_GLOVES, qdel_on_fail = TRUE, disable_warning = TRUE)
		if(success)
			if(C == user)
				C.visible_message("<span class='notice'>[U] распылил на руки блестящую резину!</span>")
			else
				C.visible_message("<span class='warning'>[U] распылил на руки [C] блестяшую резину!</span>")
		else
			C.visible_message("<span class='warning'>Резина не прилипла к рукам [C]!</span>")

/obj/item/clothing/gloves/color/yellow/sprayon
	desc = "И как ты собираешься их снять, умник?"
	name = "перчатки из изолирующего спрея"
	icon_state = "sprayon"
	inhand_icon_state = "sprayon"
	item_flags = DROPDEL
	permeability_coefficient = 0
	resistance_flags = ACID_PROOF
	var/charges_remaining = 10

/obj/item/clothing/gloves/color/yellow/sprayon/Initialize()
	.=..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)

/obj/item/clothing/gloves/color/yellow/sprayon/equipped(mob/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_LIVING_SHOCK_PREVENTED, .proc/use_charge)
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, .proc/use_charge)

/obj/item/clothing/gloves/color/yellow/sprayon/proc/use_charge()
	SIGNAL_HANDLER

	charges_remaining--
	if(charges_remaining <= 0)
		var/turf/location = get_turf(src)
		location.visible_message("<span class='warning'>[src] crumble[p_s()] away into nothing.</span>") // just like my dreams after working with .dm
		qdel(src)

/obj/item/clothing/gloves/color/fyellow                             //Cheap Chinese Crap
	desc = "Эти перчатки являются дешевыми подделками желанных перчаток - это может плохо кончиться."
	name = "бюджетные резиновые перчатки"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in Initialize()
	permeability_coefficient = 0.05
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/cut

/obj/item/clothing/gloves/color/fyellow/Initialize()
	. = ..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/old
	desc = "Эти перчатки защитят пользователя от поражения электрическим током. Староватые."
	name = "старенькие резиновые перчатки"

/obj/item/clothing/gloves/color/fyellow/old/Initialize()
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/cut
	desc = "These gloves would protect the wearer from electric shock... if the fingers were covered."
	name = "fingerless insulated gloves"
	icon_state = "yellowcut"
	inhand_icon_state = "ygloves"
	transfer_prints = TRUE

/obj/item/clothing/gloves/cut/heirloom
	desc = "The old gloves your great grandfather stole from Engineering, many moons ago. They've seen some tough times recently."

/obj/item/clothing/gloves/color/black
	desc = "Эти перчатки огнеупорные."
	name = "чёрные перчатки"
	icon_state = "black"
	inhand_icon_state = "blackgloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/fingerless

/obj/item/clothing/gloves/color/orange
	name = "оранжевые перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "orange"
	inhand_icon_state = "orangegloves"

/obj/item/clothing/gloves/color/red
	name = "красные перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "red"
	inhand_icon_state = "redgloves"


/obj/item/clothing/gloves/color/red/insulated
	name = "резиновые перчатки"
	desc = "Эти перчатки защитят пользователя от поражения электрическим током."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE

/obj/item/clothing/gloves/color/rainbow
	name = "радужные перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "rainbow"
	inhand_icon_state = "rainbowgloves"

/obj/item/clothing/gloves/color/blue
	name = "синие перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "blue"
	inhand_icon_state = "bluegloves"

/obj/item/clothing/gloves/color/purple
	name = "фиолетовые перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "purple"
	inhand_icon_state = "purplegloves"

/obj/item/clothing/gloves/color/green
	name = "зелёные перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "green"
	inhand_icon_state = "greengloves"

/obj/item/clothing/gloves/color/grey
	name = "серые перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "gray"
	inhand_icon_state = "graygloves"

/obj/item/clothing/gloves/color/light_brown
	name = "светло-коричневые перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "lightbrown"
	inhand_icon_state = "lightbrowngloves"

/obj/item/clothing/gloves/color/brown
	name = "коричневые перчатки"
	desc = "Пара перчаток, они ни в коем случае не выглядят особенными."
	icon_state = "brown"
	inhand_icon_state = "browngloves"

/obj/item/clothing/gloves/color/captain
	desc = "Царственно-синие перчатки с красивой золотой отделкой, алмазным противоударным покрытием и встроенным тепловым барьером. Шикарно."
	name = "капитанские перчатки"
	icon_state = "captain"
	inhand_icon_state = "egloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 70, ACID = 50)

/obj/item/clothing/gloves/color/latex
	name = "латексные перчатки"
	desc = "Дешевые стерильные перчатки из латекса. Передает второстепенные парамедицинские знания пользователю через бюджетные наночипы."
	icon_state = "latex"
	inhand_icon_state = "latex"
	siemens_coefficient = 0.3
	permeability_coefficient = 0.01
	clothing_traits = list(TRAIT_QUICK_CARRY)
	transfer_prints = TRUE
	resistance_flags = NONE

/obj/item/clothing/gloves/color/latex/nitrile
	name = "нитриловые перчатки"
	desc = "Ценные стерильные перчатки толще латекса. Передача интимных знаний парамедиков пользователю через наночипы."
	icon_state = "nitrile"
	inhand_icon_state = "nitrilegloves"
	clothing_traits = list(TRAIT_QUICKER_CARRY, TRAIT_FASTMED)
	transfer_prints = FALSE

/obj/item/clothing/gloves/color/infiltrator
	name = "перчатки лазутчика"
	desc = "Заточенные под столкновения перчатки для переноса людей. Благодаря наночипам передают носителю тактическую информацию о похищениях."
	icon_state = "infiltrator"
	inhand_icon_state = "infiltrator"
	siemens_coefficient = 0
	permeability_coefficient = 0.3
	clothing_traits = list(TRAIT_QUICKER_CARRY)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	transfer_prints = FALSE

/obj/item/clothing/gloves/color/latex/engineering
	name = "перчатки мастера"
	desc = "Переработанные инженерные перчатки, внутри которых задействованы строительные подпрограммамы, позволяющие носящему значительно ускорить строительство."
	icon = 'icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_gauntlets"
	inhand_icon_state = "clockwork_gauntlets"
	siemens_coefficient = 0.8
	permeability_coefficient = 0.3
	clothing_traits = list(TRAIT_QUICK_BUILD)
	custom_materials = list(/datum/material/iron=2000, /datum/material/silver=1500, /datum/material/gold = 1000)

/obj/item/clothing/gloves/color/white
	name = "белые перчатки"
	desc = "Выглядят довольно причудливо."
	icon_state = "white"
	inhand_icon_state = "wgloves"
	custom_price = PAYCHECK_MINIMAL

/obj/effect/spawner/lootdrop/gloves
	name = "случайные перчатки"
	desc = "Эти перчатки должны быть случайного цвета..."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "random_gloves"
	loot = list(
		/obj/item/clothing/gloves/color/orange = 1,
		/obj/item/clothing/gloves/color/red = 1,
		/obj/item/clothing/gloves/color/blue = 1,
		/obj/item/clothing/gloves/color/purple = 1,
		/obj/item/clothing/gloves/color/green = 1,
		/obj/item/clothing/gloves/color/grey = 1,
		/obj/item/clothing/gloves/color/light_brown = 1,
		/obj/item/clothing/gloves/color/brown = 1,
		/obj/item/clothing/gloves/color/white = 1,
		/obj/item/clothing/gloves/color/rainbow = 1)
