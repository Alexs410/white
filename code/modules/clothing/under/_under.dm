/obj/item/clothing/under
	name = "under"
	icon = 'icons/obj/clothing/under/default.dmi'
	worn_icon = 'icons/mob/clothing/under/default.dmi'
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	permeability_coefficient = 0.9
	slot_flags = ITEM_SLOT_ICLOTHING
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	equip_sound = 'sound/items/equip/jumpsuit_equip.ogg'
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound =  'sound/items/handling/cloth_pickup.ogg'
	var/fitted = FEMALE_UNIFORM_FULL // For use in alternate clothing styles for women
	var/has_sensor = HAS_SENSORS // For the crew computer
	var/random_sensor = TRUE
	var/sensor_mode = NO_SENSORS
	var/can_adjust = TRUE
	var/adjusted = NORMAL_STYLE
	var/alt_covers_chest = FALSE // for adjusted/rolled-down jumpsuits, FALSE = exposes chest and arms, TRUE = exposes arms only
	var/obj/item/clothing/accessory/attached_accessory
	var/mutable_appearance/accessory_overlay
	var/mutantrace_variation = NO_MUTANTRACE_VARIATION //Are there special sprites for specific situations? Don't use this unless you need to.
	var/freshly_laundered = FALSE

/obj/item/clothing/under/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
		if(HAS_BLOOD_DNA(src))
			. += mutable_appearance('icons/effects/blood.dmi', "uniformblood")
		if(accessory_overlay)
			. += accessory_overlay

/obj/item/clothing/under/attackby(obj/item/I, mob/user, params)
	if((has_sensor == BROKEN_SENSORS) && istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		C.use(1)
		has_sensor = HAS_SENSORS
		to_chat(user,"<span class='notice'>You repair the suit sensors on [src] with [C].</span>")
		return 1
	if(!attach_accessory(I, user))
		return ..()

/obj/item/clothing/under/update_clothes_damaged_state(damaging = TRUE)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_w_uniform()
	if(has_sensor > NO_SENSORS)
		has_sensor = BROKEN_SENSORS

/obj/item/clothing/under/Initialize()
	. = ..()
	if(random_sensor)
		//make the sensor mode favor higher levels, except coords.
		sensor_mode = pick(SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS, SENSOR_COORDS)

/obj/item/clothing/under/emp_act()
	. = ..()
	if(has_sensor > NO_SENSORS)
		sensor_mode = pick(SENSOR_OFF, SENSOR_OFF, SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS)
		if(ismob(loc))
			var/mob/M = loc
			to_chat(M,"<span class='warning'>The sensors on the [src] change rapidly!</span>")

/obj/item/clothing/under/equipped(mob/user, slot)
	..()
	if(adjusted)
		adjusted = NORMAL_STYLE
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST

	if(mutantrace_variation && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(DIGITIGRADE in H.dna.species.species_traits)
			adjusted = DIGITIGRADE_STYLE
		H.update_inv_w_uniform()

	if(slot == ITEM_SLOT_ICLOTHING && freshly_laundered)
		freshly_laundered = FALSE
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "fresh_laundry", /datum/mood_event/fresh_laundry)

	if(attached_accessory && slot != ITEM_SLOT_HANDS && ishuman(user))
		var/mob/living/carbon/human/H = user
		attached_accessory.on_uniform_equip(src, user)
		H.fan_hud_set_fandom()
		if(attached_accessory.above_suit)
			H.update_inv_wear_suit()
	set_sensor_glob()	

/obj/item/clothing/under/dropped(mob/user)
	if(attached_accessory)
		attached_accessory.on_uniform_dropped(src, user)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.fan_hud_set_fandom()
			if(attached_accessory.above_suit)
				H.update_inv_wear_suit()
	set_sensor_glob()	
	..()

/obj/item/clothing/under/proc/attach_accessory(obj/item/I, mob/user, notifyAttach = 1, params)
	. = FALSE
	if(istype(I, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/A = I
		if(attached_accessory)
			if(user)
				to_chat(user, "<span class='warning'><b>[src.name]</b> уже что-то имеет.</span>")
			return
		else

			if(!A.can_attach_accessory(src, user)) //Make sure the suit has a place to put the accessory.
				return
			if(user && !user.temporarilyRemoveItemFromInventory(I))
				return
			if(!A.attach(src, user))
				return

			if(user && notifyAttach)
				to_chat(user, "<span class='notice'>Прикрепляю <b>[I.name]</b> на <b>[src.name]</b>.</span>")

			var/accessory_color = attached_accessory.icon_state
			if(I.mob_overlay_icon)
				accessory_overlay = mutable_appearance(I.mob_overlay_icon, "[accessory_color]")
			else
				accessory_overlay = mutable_appearance('icons/mob/clothing/accessories.dmi', "[accessory_color]")

			var/list/click_params = params2list(params)
			if(click_params && click_params["icon-x"] && click_params["icon-y"])
				var/cx = clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				var/cy = clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
				accessory_overlay.transform = matrix(accessory_overlay.transform).Translate(cx, cy)

			accessory_overlay.alpha = attached_accessory.alpha
			accessory_overlay.color = attached_accessory.color

			if(ishuman(loc))
				var/mob/living/carbon/human/H = loc
				H.update_inv_w_uniform()
				H.update_inv_wear_suit()
				H.fan_hud_set_fandom()

			return TRUE

/obj/item/clothing/under/proc/remove_accessory(mob/user)
	if(!isliving(user))
		return
	if(!can_use(user))
		return

	if(attached_accessory)
		var/obj/item/clothing/accessory/A = attached_accessory
		attached_accessory.detach(src, user)
		if(user.put_in_hands(A))
			to_chat(user, "<span class='notice'>Снимаю <b>[A.name]</b> с <b>[src.name]</b>.</span>")
		else
			to_chat(user, "<span class='notice'>Снимаю <b>[A.name]</b> с <b>[src.name]</b> и она падает на пол.</span>")

		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.update_inv_w_uniform()
			H.update_inv_wear_suit()
			H.fan_hud_set_fandom()


/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(freshly_laundered)
		. += "Выглядит свежим и чистым."
	if(can_adjust)
		if(adjusted == ALT_STYLE)
			. += "Alt-клик на [src.name] чтобы носить нормально."
		else
			. += "Alt-клик on [src.name] чтобы носить как дебил."
	if (has_sensor == BROKEN_SENSORS)
		. += "Похоже, сенсоры на этой штуке повреждены."
	else if(has_sensor > NO_SENSORS)
		switch(sensor_mode)
			if(SENSOR_OFF)
				. += "Сенсоры отключены."
			if(SENSOR_LIVING)
				. += "Сенсоры состояния ЖИВ/МЁРТВ работают."
			if(SENSOR_VITALS)
				. += "Сенсоры жизненных показателей работают."
			if(SENSOR_COORDS)
				. += "Сенсоры жизненных показателей и местоположения работают."
	if(attached_accessory)
		. += "Вау! На этой штуке есть [attached_accessory]."

/obj/item/clothing/under/rank
	dying_key = DYE_REGISTRY_UNDER
