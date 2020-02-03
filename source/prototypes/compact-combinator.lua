require "libs.prototypes.all"

-- Item
local item = deepcopy(data.raw["item"]["iron-chest"])
overwriteContent(item, {
	name = "compact-combinator",
	subgroup = "circuit-network",
	order = "c[combinators]-e[compact-combinator]",
	place_result = "compact-combinator",
	icon = "__integratedCircuitry__/graphics/icons/compact-combinator.png",
})
data:extend({	item })

-- Recipe
data:extend({
	{
		type = "recipe",
		name = "compact-combinator",
		enabled = true,
		ingredients = {
			{"steel-plate", 5},
			{"advanced-circuit", 5}
		},
		result = "compact-combinator"
	}
})


-- Entity
local entity = deepcopy(data.raw["container"]["iron-chest"])
overwriteContent(entity, {
	name = "compact-combinator",
	collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	inventory_size = 0,
	picture = {
		filename = "__integratedCircuitry__/graphics/entity/compact-combinator.png",
		priority = "extra-high",
		width = 120,
		height = 120,
		shift = util.by_pixel(0, -0.5),
--		hr_version = {
--			filename = "__base__/graphics/entity/iron-chest/hr-iron-chest.png",
--			priority = "extra-high",
--			width = 66,
--			height = 76,
--			shift = util.by_pixel(-0.5, -0.5),
--			scale = 0.5
--		}
	}
})
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = "compact-combinator"
data:extend({	entity })


-- Port
local entity = deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(entity, {
	name = "compact-combinator-io",
	collision_box = {{-0.25, -0.25}, {0.25, 0.25}},
  selection_box = {{-0.25, -0.25}, {0.25, 0.25}},
	order="a",
	track_coverage_during_build_by_moving = false,
	supply_area_distance = 0,
	flags = {"hidden", "placeable-neutral", "placeable-off-grid", "not-on-map"},
	connection_points = {
		{
			shadow = {
				red = {0, 0.1},
				green = {0.05, 0.15},
			},
			wire = {
				red = {0, 0},
				green = {0.05, 0.05},
			}
		}
	},
	pictures = {
		filename = "__integratedCircuitry__/graphics/empty4x1.png",
		priority = "extra-high",
		width = 1,
		height = 1,
		direction_count = 1,
		shift = {0, 0}
	},
})
	
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = nil
data:extend({	entity })


addTechnologyUnlocksRecipe("circuit-network","compact-combinator")

