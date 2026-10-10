# Simple mob AI

This is an Aurora-native port of Polaris's datum-based mob AI at commit
`6cd19fe0dec6b5f18b6b18c3eb36af7bf3359f25`.

The body (`/mob/living/simple_animal`) still owns physical implementation such
as movement, attacks, faction rules, and mob-specific effects. Its
`/datum/ai_holder` owns decisions: targeting, target memory, stances, pathing,
following, cooperation, fleeing, communication, and disabled-state behavior.
The two communicate through the `AI*` procs in `ai_interfaces.dm`.

## Included systems

- normal and fast subsystem scheduling, sleep/wake, busy, and player-control
  handoff;
- target filtering, preferred targets and taunts, retaliation memory,
  visibility/alpha checks, corpse handling, last-seen pursuit, and blind fire;
- melee, ranged, and special-attack hooks, firing-lane checks, kiting,
  evasiveness, breakthrough, door use, demolition, and A* pathing;
- destinations, guarding/home return, wandering, timed following, ladders,
  faction help calls, and threat sharing;
- health-, matchup-, cloak-, and profile-based fleeing;
- warning/escalation/stand-down speech, contextual speech profiles, idle
  speech and emotes, and heard-speech hooks;
- stun, restraint, closet, buckle, grab, and confusion handling;
- log levels, stance coloring, path overlays, and last-seen overlays;
- passive, hostile, retaliating, event, guard, demolishing, inert, ranged,
  kiting, aggressive, robust, evasive, hit-and-run, humanoid, pirate,
  mercenary, android, hivebot, slime, xenobiology-slime, and xeno profiles.

## Selecting a profile

Every simple animal receives a holder by default:

- ordinary simple animals use `/datum/ai_holder/simple_animal/passive`;
- hostile animals use `/datum/ai_holder/simple_animal/hostile`;
- retaliating animals use `/datum/ai_holder/simple_animal/retaliate`.

Set `ai_holder_type` on a mob subtype to choose a more specialized profile from
`ai_subtypes.dm`. Set it to `null` only when the body must never run autonomous
AI. Override body-side `AI*` procs for physical or mob-specific behavior, and
holder hooks such as `handle_special_tactic()`, `pick_target()`,
`on_engagement()`, and the pre/post attack hooks for decision changes.

Aurora mobs migrated to specialized profiles include bears, pirates,
mercenaries, Republic androids, Icarus drones, hivebots, hunter and bombardier
spiders, and friendly slimes. The xenobiology-slime and xeno profiles are
available through optional interfaces, but are not assigned because Aurora
does not currently have equivalent simple-animal bodies.

## Legacy compatibility

The holder is authoritative while a mob is autonomous. Legacy hostile
`FoundTarget()`, `LostTarget()`, and `AttackingTarget()` implementations remain
body-side event/effect hooks so bespoke mobs keep their unique attacks and
animations. The old hostile decision loop only remains as a fallback for a
mob with no holder. When a client controls a simple mob, AI processing stops
unless the holder explicitly enables `autopilot`.
