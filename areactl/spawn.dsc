umc-area-spawn:
	type: task
	script:

	- define thiscuboid <server.flag[umc.area.<[name]>.area]>
	- define loc <server.flag[umc.area.<[name]>.spawn.location]>
	- define living <[thiscuboid].entities[villager].count_matches[*].if_null[0]>
	- define max <server.flag[umc.area.<[name]>.spawn.max]>
	- define rsv <server.flag[umc.area.<[name]>.spawn.reserve]>
	- define many <[max].sub_int[<[rsv]>].sub_int[<[living]>]>
	- define entities <server.flag[umc.area.<[name]>.spawn.entities]>
	- define color <server.flag[umc.area.<[name]>.spawn.color]>
	- define prof <server.flag[umc.area.<[name]>.spawn.prof].if_null[NITWIT]>

	- define prof NITWIT

	- if <[many]> <= 0:
		- stop

	- narrate "debug: <[living]> <[max]> <[many]> "

	- choose <[entities]>:

		- default:

			- if  == "#random":
				- define dlist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_color|<[color]>]>
			- else if <[color]> == "#each":
				- define dlist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_color|each]>
			- else:

				- foreach <util.list_numbers_to[<[many]>]>:
					- define dlist <list[dlist].include[<[color]>]>

			- define plist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_prof|each]>

			- foreach <[dlist]> as:m:
				- define p <[plist].get[<[loop_index]>.if_null[NONE]>
				- define vd villager[color=<[m]>;villager_level=2;profession=<[p]>]
#				- narrate <[vd]>
				- spawn <[vd]> <[loc]> persistent


		- case disguise:

			- if <[color]> == "#random":
				- define dlist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_color|random]>
			- else if <[color]> == "#each":
				- define dlist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_color|each]>
			- else:
				- foreach <util.list_numbers_to[<[many]>]>:
					- define dlist <list[dlist].include[<[color]>]>

			- define plist <proc[umc-vm-randomizer].context[<[many]>|<[entities]>_prof|each]>

			- foreach <[dlist]> as:color:
				- define p <[plist].get[<[loop_index]>.if_null[NONE]>
				- define v villager["color=plains;villager_level=2"]
				- spawn <[v]> <[loc]> persistent
				- foreach <[loc].find_entities[villager].within[10]> as:ve:
					- if <[ve].is_disguised.not>:
						- disguise <[ve]> as:<[color]> global

		- case mmobs:

			- define dlist <server.flag[umc.mmob.<[color]>]>
			- define dcount <[dlist].count_matches[*]>

			- if <[many]> > <[dlist].count_matches[*]>:
				- define dlist <list[<[dlist]>].include[<[dlist].random[<[many].sub_int[<[dcount]>]>]>]>

			- define dlist <[dlist].get[<1>].to[<[many]>]>

			- foreach <[dlist]> as:m:
				- mythicspawn <[m]> <[loc]>


	- narrate <[dlist]>

umc-vm-randomizer:
	type: procedure
	definitions: many|type|way
	script:

		- narrate  "-- <[many]> <[type]> <[way]>"

		- choose <[type]>:

			- case villager_color:
				- define dlist <script[umc_config].data_key[villager.color].as_list>
			- case villager_prof:
				- define dlist <script[umc_config].data_key[villager.prof].as_list>
			- case mmobs_color:
				- define dlist <server.flag[umc.mmob.color].as_list>
			- case disguise_color:
				- define dlist <script[umc_config].data_key[disguise.color].as_list>

		- define dcount <[dlist].count_matches[*]>

		- if <[way]> == "#random":
			- if <[many]> <= dcount:
				- define dlist <[dlist].random[<[many]>]>
			- else:
				- define dlist <list[<[dlist].random[<[dcount]>]>].include[<[dlist].random[<[many].sub_int[<[dcount]>]>]>]>

		- if <[way]> == "random":
			- if <[many]> <= dcount:
				- define dlist <[dlist].random[<[many]>]>
			- else:
				- define dlist <list[<[dlist].random[<[dcount]>]>].include[<[dlist].random[<[many].sub_int[<[dcount]>]>]>]>

		- else if <[way]> == "each":

			- if <[many]> >= <[dlist].count_matches[*]>:
				- define dlist <list[<[dlist]>].include[<[dlist].random[<[many].sub_int[<[dcount]>]>]>]>

		- determine <[dlist].get[<1>].to[<[many]>]>
