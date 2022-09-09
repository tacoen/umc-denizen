umcshop_buy_item:
    type: item
    debug: false
    material: player_head
    display name: <&f>You Buy
    mechanisms:
        skull_skin: f1870f42-720c-421f-9be7-bda6b45f22f8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjg4ZWI1ZjUyOGNlYzU4MzgwMzc1N2JhMjAyYzE1MzYyZjg0YTNmNmZiZTg3MTJlOGFiMjU2ZjI1ZTUyNDUifX19

umcshop_sell_item:
    type: item
    debug: false
    material: player_head
    display name: <&f>You Sell
    mechanisms:
        skull_skin: 4f1c57c7-7e77-4937-ad52-7a9d97714655|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTc0ZTY1ZTJmMTYyNWIwYjIxMDJkNmJmM2RmODI2NGFjNDNkOWQ2Nzk0MzdhM2E0MmUyNjJkMjRjNGZjIn19fQ==


umcshop_exit_item:
    type: item
    debug: false
    material: player_head
    display name: <&f>Exit
    mechanisms:
        skull_skin: b6314fd8-206e-4bb7-8ab7-696b38674de8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTc1ZmViNzYxZTJmMjI5NDViZDJjMmRmNmMyNTFjNTM2Yjc5MjJmYmJhYTQ4MjgwOWRiNDliZDQ3N2Y2ZTEifX19

umc-shop-gui:

    type: inventory
    inventory: CHEST
    size: 54
    gui: true

umc-shop-opentask:
    type: task
    debug: false
    definitions: shop|page
	script:

	- yaml id:umc-shop load:data/umc/shop.yml

	- define inv <inventory[umc-shop-gui]>
	- define page <[page].if_null[buy]>
	- define items <yaml[umc-shop].read[<[shop]>.<[page]>.items]>
	
	- define baseprice <yaml[umc-shop].read[<[shop]>.<[page]>.price].if_null[5]>
	- flag player shop_page:<[page]>
	- flag player shop_id:<[shop]>

	- define si <list[]>
	- define n 0
	- foreach <[items]> as:item:
		- define dn <[item].split[|]>
		- define in <item[<[dn].get[1]>]>
		- define cost <[dn].get[2].if_null[<[baseprice]>]>
		- flag <[in]> cost:<[cost]>
		- definemap mechs:
			lore: "Price <&e><&l><[cost]><&r>"
		- define si <[si].include[<[in].with_map[<[mechs]>]>]>

	- adjust <[inv]> "title:<yaml[umc-shop].read[<[shop]>.title].if_null[Shop]> - <[page].to_titlecase> (Money: <player.money>)"
	- adjust <[inv]> contents:<[si]>

    - inventory set d:<[inv]> o:umcshop_buy_item slot:46
    - inventory set d:<[inv]> o:umcshop_sell_item slot:47
    - inventory set d:<[inv]> o:umcshop_exit_item slot:54

	- inventory open d:<[inv]>

umc-shop-event:
    type: world
    debug: false
    events:

        on player clicks umcshop_sell_item in umc-shop-gui:
		- run umc-shop-opentask def.shop:<player.flag[shop_id]> def.page:sell
		- determine cancelled

        on player clicks umcshop_buy_item in umc-shop-gui:
		- run umc-shop-opentask def.shop:<player.flag[shop_id]> def.page:buy
		- determine cancelled

        on player clicks umcshop_exit_item in umc-shop-gui:
		- inventory close
		- flag player shop_page:!
		- flag player shop_id:!
		- determine cancelled

		on player right clicks in umc-shop-gui:
		- determine cancelled
		
		on player drags in umc-shop-gui:
		- determine cancelled
	
#       on player clicks item in umc-shop-gui:


		on player left clicks in umc-shop-gui:
		- narrate <context.click>
		- narrate <context.slot_type>
		- narrate <context.raw_slot>

		- if <context.raw_slot> > 45
			- determine cancelled

		- if <context.slot_type> == QUICKBAR:
			- determine cancelled
			
		- if <context.item> == <item[air]>:
			- determine cancelled

		- define cost <context.item.flag[cost]>

		- if <[cost]> != null:

			- narrate "<player.flag[shop_page]> <context.slots>"
			
			- choose <player.flag[shop_page]>:

				- case buy:

					- if <player.money.is_more_than_or_equal_to[<[cost]>]>:
						- definemap mechs:
							lore: <list[]>
						- give player <context.item.with_map[<[mechs]>]>
						- money take quantity:<[cost]>
					- else:
						- inventory close
						- actionbar "Not enough Money"
						- narrate format:umc-err "Not enough Money"
						- flag player shop_page:!
						- flag player shop_id:!
						- determine cancelled

				- case sell:

					- narrate <context.item.display_name>
					- definemap mechs:
						lore: <list[]>
					- define item <context.item.with_map[<[mechs]>]>
					- flag <[item]> cost:!

					- if <player.inventory.list_contents.contains_all[<[item]>]>:
						- take player <[item]> quantity:1
						- money give quantity:<[cost]>

					- else:
						- narrate "What?"
		- else:
			- determine cancelled
