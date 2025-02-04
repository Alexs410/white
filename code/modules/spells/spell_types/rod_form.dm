/obj/effect/proc_holder/spell/targeted/rod_form
	name = "Rod Form"
	desc = "Take on the form of an immovable rod, destroying all in your path. Purchasing this spell multiple times will also increase the rod's damage and travel range."
	clothes_req = TRUE
	human_req = FALSE
	charge_max = 250
	cooldown_min = 100
	range = -1
	school = SCHOOL_TRANSMUTATION
	include_user = TRUE
	invocation = "CLANG!"
	invocation_type = INVOCATION_SHOUT
	action_icon_state = "immrod"

/obj/effect/proc_holder/spell/targeted/rod_form/cast(list/targets,mob/user = usr)
	var/area/A = get_area(user)
	if(istype(A, /area/wizard_station))
		to_chat(user, "<span class='warning'>You know better than to trash Wizard Federation property. Best wait until you leave to use [src].</span>")
		return
	for(var/mob/living/M in targets)
		var/turf/start = get_turf(M)
		var/obj/effect/immovablerod/wizard/W = new(start, get_ranged_target_turf(start, M.dir, (15 + spell_level * 3)))
		W.wizard = M
		W.max_distance += spell_level * 3 //You travel farther when you upgrade the spell
		W.damage_bonus += spell_level * 20 //You do more damage when you upgrade the spell
		W.start_turf = start
		M.forceMove(W)
		M.notransform = TRUE
		M.status_flags |= GODMODE

//Wizard Version of the Immovable Rod

/obj/effect/immovablerod/wizard
	var/max_distance = 13
	var/damage_bonus = 0
	var/turf/start_turf
	notify = FALSE
	dnd_style_level_up = FALSE
	/// The wizard who's piloting our rod.
	var/datum/weakref/our_wizard

/obj/effect/immovablerod/wizard/Move()
	if(get_dist(start_turf, get_turf(src)) >= max_distance)
		stop_travel()
		return
	return ..()

/obj/effect/immovablerod/wizard/Destroy()
	if(wizard)
		wizard.status_flags &= ~GODMODE
		wizard.notransform = FALSE
		wizard.forceMove(get_turf(src))
	return ..()

/obj/effect/immovablerod/wizard/penetrate(mob/living/L)
	if(L.anti_magic_check())
		L.visible_message("<span class='danger'>[capitalize(src.name)] hits [L], but it bounces back, then vanishes!</span>" , "<span class='userdanger'>[capitalize(src.name)] hits you... but it bounces back, then vanishes!</span>" , "<span class='danger'>You hear a weak, sad, CLANG.</span>")
		qdel(src)
		return
	L.visible_message("<span class='danger'>[L] is penetrated by an immovable rod!</span>" , "<span class='userdanger'>The rod penetrates you!</span>" , "<span class='danger'>You hear a CLANG!</span>")
	L.adjustBruteLoss(70 + damage_bonus)



/**
 * Called when the wizard rod reaches it's maximum distance
 * or is otherwise stopped by something.
 * Dumps out the wizard, and deletes.
 */
/obj/effect/immovablerod/wizard/proc/stop_travel()
	eject_wizard()
	qdel(src)

/**
 * Eject our current wizard, removing them from the rod
 * and fixing all of the variables we changed.
 */
/obj/effect/immovablerod/wizard/proc/eject_wizard()
	var/mob/living/wizard = our_wizard?.resolve()
	if(QDELETED(wizard))
		return

	wizard.status_flags &= ~GODMODE
	wizard.notransform = FALSE
	wizard.forceMove(get_turf(src))
	our_wizard = null

/**
 * Set wizard as our_wizard, placing them in the rod
 * and preparing them for travel.
 */
/obj/effect/immovablerod/wizard/proc/set_wizard(mob/living/wizard)
	our_wizard = WEAKREF(wizard)

	wizard.forceMove(src)
	wizard.notransform = TRUE
	wizard.status_flags |= GODMODE
