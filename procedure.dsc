umc-time-period:

	# <proc[umc-time-period]>

	type: procedure
	script:

	- if <player.location.world.time.is_more_than_or_equal_to[18000]>:
		- determine "midnight"
	- else if <player.location.world.time.is_more_than_or_equal_to[13000]>:
		- determine "night"
	- else if <player.location.world.time.is_more_than_or_equal_to[8000]>:
		- determine "dusk"
	- else if <player.location.world.time.is_more_than_or_equal_to[3000]>:
		- determine "day"
	- else:
		- determine "dawn"

umc-config:

	# <proc[umc-config].context[<context.args.get[1]>]>

	# use to query data-key from umc-config

	type: procedure
	definitions: command
	script:

	- choose <[command]>:

		- default:
			- determine ""

		- case stats:
			- determine <list[].include[<script[umc_config].data_key[stats]>]>

		- case villager-spawn:
			- determine <util.list_numbers_to[15].alphanumeric>
		- case villager-level:
			- determine <list[#random|#each].include[<list[1|2|3|4|5]>]>
		- case villager-kill:
			- determine <list[3|5|10|20|50]>
		- case param1-villager:
			- determine <list[#random|#each].include[<script[umc_config].data_key[villager.color].as_list.alphabetical>]>
		- case param2-villager:
			- determine <list[#random|#each].include[<script[umc_config].data_key[villager.prof]>]>
		- case param1-disguise:
			- determine <list[#random|#each].include[<script[umc_config].data_key[disguise.color]>]>
		- case param1-mmobs:
			- determine <list[#random|#each].include[<script[umc_config].data_key[mmobs.color]>]>
		- case param2-mmobs:
			- determine <list[#random|#each].include[<script[umc_config].data_key[mmobs.skin]>]>

		- case shop-set:
			- determine <list[buy|sell]>

		- case area-name:
			- determine <server.flag[umc.area].keys.if_null[]>

		- case area-adjustheight:
			- determine <list[max|5|10|20|30|50]>

		- case area-spawn:
			- determine <list[max|material|entities|color|location|calc]>

		- case area-flag:
			- determine <list[price|owner|spawn_max|spawn_material|spawn_entities|active|title|gamemode|task|spawn_reserve]>
		- case area-unflag:
			- determine <list[price|owner|spawn_max|spawn_material|spawn_entities|active|title|gamemode|task|spawn_reserve]>
		- case area-flag-gamemode:
			- determine <list[adventure|survival|creative]>
		- case area-flag-active:
			- determine <list[true|false]>
		- case area-flag-price:
			- determine <list[-1|0|<player.flag[seltool_selection].volume.volume.div_int[100].round_to_precision[2]>]>
		- case area-flag-owner:
			- define l <list[]>
			- foreach <server.players> as:p:
				- define l <[l].include[<[p].name>]>
			- determine <[l]>
		- case area-spawn-reserve:
			- determine <list[0|1|2|3]>
		- case area-spawn-material:
			- determine <list[*_bed|chest|crafting_table|lantern]>
		- case area-flag-spawn-entities:
			- determine <list[villager|disguise|mmobs|monster]>

		- case area-flag-spawn_entities-villager:
			- determine <list[#random|#each].include[<script[umc_config].data_key[villager.color].as_list.alphabetical>]>
		- case area-flag-spawn_entities-disguise:
			- determine <list[#random|#each].include[<script[umc_config].data_key[disguise.color]>]>
		- case area-flag-spawn_entities-mmobs:
			- determine <list[#random|#each].include[<script[umc_config].data_key[mmobs.color]>]>


		- case optool-kill:
			- determine <server.entity_types>
		- case optool-spawner:
			- determine <server.entity_types>