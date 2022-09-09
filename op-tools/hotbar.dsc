
hotbar_command:
    type: command
    name: hotbar
    permission: umc.op
    usage: /hotbar [<&lt>cmd<&gt>] (<&lt>name<&gt>)
    tab completions:
        1: set|del|load|reset|yaml-save|yaml-load
		2: <player.flag[hotbar].keys.alphabetical>

    script:

	- define slot <context.args.get[2].if_null[default]>

    - choose <context.args.first>:

		- case "set":
			- flag player hotbar.<[slot]>:<player.inventory.list_contents.sub_lists[9].get[1]>
			- narrate "<&e><[slot]><&7> Saved"

		- case "del":
			- flag player hotbar.<[slot]>:!

		- case "load":
		
			- foreach <player.flag[hotbar.<[slot]>]> as:item:
				- inventory set slot:<[loop_index]> o:<[item]>

		- case "reset-confirm":
			- flag player hotbar:!

		- case "list":
			- narrate <player.flag[hotbar].keys.alphabetical.comma_separated>

		- case yaml-save:
			- yaml create id:umc-hb
			- yaml id:umc-hb load:data/umc/hotbar.yml 		
			- yaml id:umc-hb set hotbar:<player.flag[hotbar]>			
			- yaml id:umc-hb savefile:data/umc/hotbar.yml 
			- narrate "savefile: data/umc/hotbar.yml"

		- case yaml-load:
			- yaml create id:umc-hb
			- yaml id:umc-hb load:data/umc/hotbar.yml
			- define hb <yaml[umc-hb].read[hotbar]>
			- flag player hotbar:<[hb]>
			- narrate "loadfile: data/umc/hotbar.yml"

		- default:
			- narrate "/hotbar -- Keep your hotbar in server. To reset your hotbar use <&d>reset-confirm<&f>"
			
