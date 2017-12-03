require "libs.prototypes.all"

-- Item
local item = deepcopy(data.raw["item"]["iron-chest"])
overwriteContent(item, {
	name = "compact-io-port",
	subgroup = "circuit-network",
	order = "c[combinators]-e[compact-combinator-port]",
	place_result = "compact-io-port",
	--icon = "__integratedCircuitry__/graphics/icons/lamp-panel.png",
})
data:extend({	item })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "compact-io-port",
		enabled = true,
		ingredients = {
			{"electronic-circuit", 3},
		},
		result = "compact-io-port"
	}
})


-- Entity
local entity = deepcopy(data.raw["container"]["iron-chest"])
overwriteContent(entity, {
	name = "compact-io-port",
	collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	inventory_size = 0,
	picture = {
		filename = "__integratedCircuitry__/graphics/entity/compact-io-port.png",
		priority = "extra-high",
		width = 52,
		height = 40,
		shift = {0, 0}
	},
	circuit_wire_max_distance = 100000,
	circuit_wire_connection_point = {
		shadow = {
			red = {0, 0.5},
			green = {0.05, 0.55},
		},
		wire = {
			red = {0, -0.5},
			green = {0.05, -0.45},
		}
	},
})
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = "compact-io-port"
data:extend({	entity })

addTechnologyUnlocksRecipe("circuit-network","compact-io-port")

