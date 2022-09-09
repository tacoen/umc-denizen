umc-location-command:
    type: command
    name: umc-tp
    permission: umc-location.can

    tab completions:
        1: go|back|set|list|del|reset
		2: <server.flag[umc.location].keys.alphabetical.if_null[pin]>
        3: <server.flag[umc.location.<context.args.get[2].if_null[pin]>].keys.alphabetical.if_null[home]>

    script:

	- define slot <context.args.get[2].if_null[pin]>
	- define lname <context.args.get[3].if_null[home]>

    - choose <context.args.first>:

		- case set:
			- if <[lname]> == null:
				- narrate "<red>[!] Missing Location Name"
				- stop

			- flag server umc.location.<[slot]>.<[lname].to_lowercase>:<player.location.simple>
			- narrate "<&d><[lname]> <&7>Saved on <&e><[slot]>"

		- case go:
			- define val <server.flag[umc.location.<[slot]>.<[lname]>].if_null[null]>
			- if <[val]> == null:
				- narrate "<lname> was not in record."
				- stop

			- run umc-tp-task def.dest:<[val]>

		- case del:
			- if <[lname]> == null:
				- narrate "<red>[!] Missing Location Name"
				- stop

			- flag server umc.location.<[slot]>.<[lname].to_lowercase>:!
			- narrate "<[lname]> removed"

		- case reset:
			- if <[slot]> == null:
				- narrate "<red>[!] Missing Slot Name"
				- stop

			- flag server umc.location.<[slot]>:!
			- narrate "<[slot]> removed"

		- case back:
			- if <player.flag[tpback]>==null:
				- narrate "No record."
			- else:
				- narrate "Teleporting Back to <player.flag[tpback]>..."
				- teleport <player> location:<player.flag[tpback]>
				- flag <player> tpback:!
				
		- case reset-all:
			- flag server umc.location:!

		- case list:

			- narrate "umc.location: <[slot]> ----------"

			- foreach <server.flag[umc.location.<[slot]>]> key:key as:val:
				- define d <player.location.distance[<[val]>].round_down_to_precision[2]>
				- if <[d]> > 100:
					- clickable umc-tp-task def.dest:<[val]> for:<player> until:7s save:dest
					- narrate "<[loop_index]>. <underline><&b><element[<[key].to_uppercase>].on_click[<entry[dest].command>]><reset> - <[d]> block away."
				- else:
					- narrate "<[loop_index]>. <[key]> - <[d]> block away."

			- narrate " "

		- default:

			- narrate "umc.location: <[slot]> ----------"

			- foreach <server.flag[umc.location.<[slot]>]> key:key as:val:
				- define d <player.location.distance[<[val]>].round_down_to_precision[2]>
				- if <[d]> > 100:
					- clickable umc-tp-task def.dest:<[val]> for:<player> until:7s save:dest
					- narrate "<[loop_index]>. <underline><&b><element[<[key].to_uppercase>].on_click[<entry[dest].command>]><reset> - <[d]> block away."
				- else:
					- narrate "<[loop_index]>. <[key]> - <[d]> block away."


umc-tp-task:
    type: task
    script:
		- flag <player> tpback:<player.location.simple>
		- wait 1s
		- narrate "Teleporting to <[dest]>..."
		- ~teleport <player> <[dest]>
		- wait 2s
		- narrate "use: <&b>/umc-location back<reset> to return to previous location."
