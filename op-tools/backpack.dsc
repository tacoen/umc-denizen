umc-backpack:
    type: item
    display name: <&f>umc-backpack
    material: player_head
    allow in material recipes: true
    mechanisms:
		skull_skin: 938dd9c3-4b55-42d5-b71d-f71975fd18bc|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjMwOGJmNWNjM2U5ZGVjYWYwNzcwYzNmZGFkMWUwNDIxMjFjZjM5Y2MyNTA1YmJiODY2ZTE4YzZkMjNjY2QwYyJ9fX0=
	flags:
        noplace: 0
        uuid: <util.random_uuid>
		umc-backpack:
    recipes:
        1:
            type: shaped
            input:
            - leather|air|air
            - chest|air|air
            - leather|air|air

umc-backpackUI:

    type: inventory

    # Must be a valid inventory type.
    # Valid inventory types: BREWING, CHEST, DISPENSER, ENCHANTING, ENDER_CHEST, HOPPER, WORKBENCH
    # | All inventory scripts MUST have this key!
    inventory: CHEST

    # The title can be anything you wish. Use color tags to make colored titles.
    # Note that titles only work for some inventory types, including CHEST, DISPENSER, FURNACE, ENCHANTING, and HOPPER.
    # | MOST inventory scripts should have this key!
    title: Backpack

    # The size must be a multiple of 9. It is recommended to not go above 54, as it will not show correctly when a player looks into it.
    # | Some inventory scripts should have this key! Most can exclude it if 'slots' is used.
    size: 54

    # Set 'gui' to 'true' to indicate that the inventory is a GUI, meaning it's a set of buttons to be clicked, not a container of items.
    # This will prevent players from taking items out of or putting items into the inventory.
    # | SOME inventory scripts should have this key!
    gui: false

    # You can use definitions to define items to use in the slots. These are not like normal script definitions, and do not need to be in a definition tag.
    # | Some inventory scripts MAY have this key, but it is optional. Most scripts will just specify items directly.
#    definitions:
#        my item: ItemTag
#        other item: ItemTag

    # Procedural items can be used to specify a list of ItemTags for the empty slots to be filled with.
    # Each item in the list represents the next available empty slot.
    # When the inventory has no more empty slots, it will discard any remaining items in the list.
    # A slot is considered empty when it has no value specified in the slots section.
    # If the slot is filled with air, it will no longer count as being empty.
    # | Most inventory scripts should exclude this key, but it may be useful in some cases.

#    procedural items:
#    - define list <list>
#    - foreach <server.online_players>:
#        # Insert some form of complex doesn't-fit-in-just-a-tag logic here
#        - define item <[value].skull_item>
#        - define list:->:<[item]>
#    - determine <[list]>

    # You can specify the items in the slots of the inventory. For empty spaces, simply put an empty "slot" value, like "[]".
    # | Most inventory scripts SHOULD have this key!
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [debug_stick] [command_block] [] [] [] [] [] [] []

umc-backpackhandler:
    type: world
    events:
	
        on player crafts umc-backpack:
        - define umc-backpack <item[umc-backpack]>
        - note <inventory[umc-backpackUI]> as:umc-backpack_<[umc-backpack].flag[uuid]>
        - determine <[umc-backpack]>

        on player right clicks block with:umc-backpack:
            - inventory open d:umc-backpack_<context.item.flag[uuid]>
			- playsound <player.location> sound:BLOCK_ENDER_CHEST_OPEN volume:0.5
			- determine cancelled