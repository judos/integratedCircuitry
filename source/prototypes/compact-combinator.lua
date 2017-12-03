require "libs.prototypes.all"
require "prototypes.compact-combinator-io"

-- Item
local item = deepcopy(data.raw["item"]["iron-chest"])
overwriteContent(item, {
	name = "compact-combinator",
	subgroup = "circuit-network",
	order = "c[combinators]-e[compact-combinator]",
	place_result = "compact-combinator",
	--icon = "__integratedCircuitry__/graphics/icons/lamp-panel.png",
})
data:extend({	item })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "compact-combinator",
		enabled = true,
		ingredients = {
			{"steel-plate", 1},
		},
		result = "compact-combinator"
	}
})


-- Entity
local entity = deepcopy(data.raw["container"]["iron-chest"])
overwriteContent(entity, {
	name = "compact-combinator",
	collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
  selection_box = {{-0.5, -0.2}, {0.5, 0.2}},
	inventory_size = 1,
})
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = "compact-combinator"
data:extend({	entity })

local entity = deepcopy(data.raw["container"]["iron-chest"])
overwriteContent(entity, {
	name = "compact-combinator-io",
	collision_box = {{-0.25, -0.15}, {0.25, 0.15}},
  selection_box = {{-0.25, -0.15}, {0.25, 0.15}},
	inventory_size = 0,
	circuit_wire_max_distance = 100000,
	order="a",
	flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
	circuit_wire_connection_point = {
		shadow = {
			red = {0, 0.1},
			green = {0.05, 0.15},
		},
		wire = {
			red = {0, 0},
			green = {0.05, 0.05},
		}
	},
})
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.picture.width = 1
entity.picture.height= 1
entity.minable.result = "compact-combinator"
data:extend({	entity })


addTechnologyUnlocksRecipe("circuit-network","compact-combinator")

