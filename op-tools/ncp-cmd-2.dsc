umc-npc2-procedure:
	type: procedure
	definitions: cmd|param1
	script:

	- choose <[cmd]>:

		- default:
			- determine ""

		- case anchor:
			- determine <list[cursor|player]>
		- case look:
			- determine <list[cursor|lantern|*_bed|crafting_table]>
		- case text:
			- if <[param1]> == edit || <[param1]> == remove:
				- determine <util.list_numbers_to[<player.selected_npc.flag[text.<[slot]>].count_matches[*]>]>
			- else:
				- determine ""
				
		- case cmd-look:
			- determine <list[set|remove|list]>
		- case cmd-anchor:
			- determine <list[set|remove|list|walk]>
		- case cmd-skin:
			- determine <list[set|remove|list|load]>
		- case cmd-text:
			- determine <list[set|remove|list|reset|edit]>
		- case cmd-flag:
			- determine <list[set|remove|list]>
		- case cmd-task:
			- determine <list[set|remove|list]>

		- case slot:
		
			- choose <[param1]>:
			
				- case flag:
					- determine <script[umc_npc].data_key[flags]>
				- case look:
					- determine <list[bed].include[<script[umc_npc].data_key[anchor].keys>]>
				- default:
					- determine <script[umc_npc].data_key[anchor].keys>

umc-npc2:
    type: command
    name: umc-npc
    permission: umc.op
    usage: /umc-npc2 cmd slot param
    tab completions:
		1: anchor|skin|look|text|flag|task|info
		2: <proc[umc-npc2-procedure].context[cmd-<context.args.get[1]>]>
		3: <proc[umc-npc2-procedure].context[slot|<context.args.get[1]>]>
		4: <proc[umc-npc2-procedure].context[<context.args.get[1]>|<context.args.get[2]>]>


	script:

	- define cmd <context.args.get[2].if_null[list]>
	- define slot <context.args.get[3].if_null[null]>
	- define param1 <context.args.get[4].if_null[null]>
	- define param2 <context.args.get[5].if_null[null]>

    - if <player.selected_npc||null> == null:
        - narrate "<&c>Please select an NPC before this command!"
        - stop

	- narrate format:umc "For NPC: <player.selected_npc> <player.selected_npc.name>"

	- choose <context.args.first>:

		- case info:
			- run locally infoinfo
			
		- case task:

			- choose <[cmd]>:

				- case set:
					- define val <context.raw_args.after[<[slot]>].trim>
					- flag <player.selected_npc> task.<[slot]>:<[val]>
				- case remove:
					- flag <player.selected_npc> task.<[slot]>:!
				- default:
					- narrate format:umc "task"
					- foreach <npc.flag[task]> key:k as:v:
						- narrate "<[k]>: <[v]>"

		- case flag:

			- choose <[cmd]>:

				- case set:
					- define val <context.raw_args.after[<[slot]>].trim>
					- flag <player.selected_npc> flag.<[slot]>:<[val]>
				- case remove:
					- flag <player.selected_npc> flag.<[slot]>:!
				- default:
					- narrate format:umc "flags"
					- foreach <player.selected_npc.flag[flag]> key:k as:v:
						- narrate "<[k]>: <[v]>"
					- foreach <npc.flag[flag]> key:k as:v:
						- narrate "<[k]>: <[v]>"

		- case text:

			- if <[cmd]> == edit || <[cmd]> == remove:
				- define n <context.args.get[4].if_null[-1]>
				- define entry <context.raw_args.after[<[n]>].trim>
			- else:
				- define n -1
				- define entry <context.raw_args.after[<[slot]>].trim>

			- choose "<[cmd]>:

				- default:
					- narrate  format:umc "<[slot]>:"
					- foreach <player.selected_npc.flag[text.<[slot]>]> as:text:
						- narrate "<[loop_index]> : <[text]>"

				- case reset:
					- flag <player.selected_npc> text.<[slot]>:!
					- narrate  format:umc " <[slot]>: Cleared"

				- case set:
					- flag <player.selected_npc> text.<[slot]>:->:<[entry]>
					- narrate  format:umc "<[slot]>: <player.selected_npc.flag[text.<[slot]>].length>"

				- case edit:
					- flag <player.selected_npc> greet:<player.selected_npc.flag[text.<[slot]>].set_single[<[entry]>].at[<[n]>]>
					- narrate format:umc "<[slot]>: <player.selected_npc.flag[text.<[slot]>].length>"

				- case remove:
					- define removed <player.selected_npc.flag[text.<[slot]>].exclude[<player.selected_npc.flag[text.<[slot]>].get[<n]>]>
					- flag <player.selected_npc> greet:<[removed]>
					- narrate format:umc "<[slot]>: <player.selected_npc.flag[text.<[slot]>].length>"

		- case look:

			- if <[param1]> == cursor || <[param1]> == null:
				- define mat <player.cursor_on.material.name>
				- narrate format:umc "Look for: <[mat]> <[slot]>"
			- else:
				- define mat <[param1]>
				- narrate format:umc "Look for: <[mat]> <[slot]>"

			- choose <[cmd]>:

				- case set:
					- flag <player.selected_npc> lookfor.<[slot]>:<[mat]>
				- case remove:
					- flag <player.selected_npc> lookfor.<[slot]>:!
					- narrate format:umc "<[slot]> removed."
				- default:
					- foreach <player.selected_npc.flag[lookfor]> key:key as:val:
						- narrate "<[loop_index]> <[key]>:<[val]>"

		- case skin:

			- choose <[cmd]>:
				- case set:
					- flag server umc.skins.<player.selected_npc.name>:<player.selected_npc.skin_blob>;<player.selected_npc.name>
					- narrate format:umc "<player.selected_npc.name> Skin saved."
				- case load:
					- run locally load_skin def.name:<player.selected_npc.name>
				- case remove:
					- flag server umc.skins.<player.selected_npc.name>:!
					- narrate format:umc "<player.selected_npc.name> Skin removed."
				- default:
					- foreach <server.flag[umc.skins]> key:key as:val:
						 - if <[key]> == <player.selected_npc.name>:
							- narrate "<&7><[loop_index]> <&f><&l><[key]><&r>"
						 - else:
							- narrate "<&7><[loop_index]> <&f><[key]>"
		- case anchor:

			- if <[param1]> == cursor:
				- define loc <player.cursor_on.simple>
			- else:
				- define loc <player.location.simple>

			- choose <[cmd]>:

				- case set:
					- anchor add id:<[slot]> <[loc]>
					- showfake glass location:<player.selected_npc.anchor[<[slot]>]> duration:5s

				- case remove:
					- anchor remove id:<[slot]>

				- case walk:
					#- teleport <npc> <npc.location>
					- wait 1s
					- define wloc <player.selected_npc.anchor[<[slot]>]>
					- ~walk <npc> location:<[wloc]> speed:0.9 auto_range
					- wait 1s
					- define d  <npc.location.distance[<[wloc]>].round_down_to_precision[2]>
					- narrate "me: <npc.location.simple>"
					- narrate "go: <[wloc]>"
					- narrate format:ntk "<[d]> block is it?"

				- default:

					- narrate "Spawn: <player.selected_npc.spawn_location>"
					- foreach <player.selected_npc.list_anchors> as:nloc:
						- define d  <player.selected_npc.location.distance[<npc.anchor[<[nloc]>]>].round_down_to_precision[2]>
						- narrate "<[loop_index]> - <[nloc]> : <[d]> blocks from NPC"
						- showfake glass location:<player.selected_npc.anchor[<[nloc]>]> duration:5s

		- default:
			- narrate format:umc "umc-npc"

	load_skin:

		- if !<server.has_flag[umc.skins.<[name]>]>:
			- narrate format:umc-err "No skin found <[name]>."
			- stop
		- adjust <player.selected_npc> skin_blob:<server.flag[umc.skins.<[name]>]>
		- narrate format:umc "<[name]> Skin loaded!"
        - playsound <player.location> sound:BLOCK_AMETHYST_CLUSTER_PLACE pitch:0.3 volume:1

	infoinfo:
		- narrate "use_new_finder <npc.use_new_finder>" targets:<server.online_players> per_player
		- narrate "speed <npc.speed>" targets:<server.online_players> per_player
		- narrate "range <npc.range>" targets:<server.online_players> per_player
		- narrate "distance_margin <npc.distance_margin>" targets:<server.online_players> per_player
		- narrate "path_distance_margin <npc.path_distance_margin>" targets:<server.online_players> per_player
		- narrate "lookclose <npc.lookclose>" targets:<server.online_players> per_player
	