require "prototypes.unselectable-lamp-panel"

-- Item
local item = table.deepcopy(data.raw["item"]["small-lamp"])
overwriteContent(item, {
	name = "monochrom-display-row",
	order = "z[small-lamp]1",
	place_result = "monochrom-display-row",
	icon = "__integratedCircuitry__/graphics/icons/display-row.png",
	icon_size = 64,
})
data:extend({	item })

-- Recipe & Technology
data:extend({
	{
		type = "recipe",
		name = "monochrom-display-row",
		enabled = false,
		ingredients = {
			{"small-lamp", 5},
			{"steel-plate", 2},
			{"electronic-circuit",5}
		},
		result = "monochrom-display-row"
	}
})
addTechnologyUnlocksRecipe("optics","monochrom-display-row")


-- Monochrom display
REMOVE_KEY = "-remove-"
local entity = table.deepcopy(data.raw["lamp"]["small-lamp"])
overwriteContent(entity, {
	type = "lamp",
	name = "monochrom-display-row",
	icon = "__integratedCircuitry__/graphics/icons/display-row.png",
	icon_size = 64,
	collision_box = REMOVE_KEY,
	selection_box = {{-0.5, -0.5}, {0.5, 4.5}},
	collision_box = {{-0.4,-0.4},{0.4,4.4}},
	collision_mask = {"water-tile", "item-layer", "object-layer"},
	order="a",
	circuit_wire_max_distance = 7,
	energy_source = {
		type = "void",
	},
	picture_off = {
		filename = "__integratedCircuitry__/graphics/entity/monochrom-display-row.png",
		priority = "extra-high",
		width = 32,
		height = 160,
		shift = {0, 2}
	},
	picture_on = {
		filename = "__integratedCircuitry__/graphics/entity/monochrom-display-row.png",
		priority = "extra-high",
		width = 32,
		height = 160,
		shift = {0, 2}
	},
	circuit_connector_sprites = REMOVE_KEY,
	fast_replaceable_group = REMOVE_KEY,
	circuit_wire_connection_point = {
		wire = { red = {0.47, 4.47}, green = {0.47, 4.47} },
		shadow = { red = {0.47, 4.47}, green = {0.47, 4.47} }
	},
	minable = {
		result = item.name,
		mining_time = 0.5
	}
}, REMOVE_KEY)

data:extend({	entity })
