require "libs.prototypes.all"

-- Item
local item = table.deepcopy(data.raw["item"]["iron-chest"])
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
local entity = table.deepcopy(data.raw["container"]["iron-chest"])
overwriteContent(entity, {
	name = "compact-combinator",
	collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
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

-- Technology
addTechnologyUnlocksRecipe("circuit-network","compact-combinator")



-- Port outside (no graphics)
local entity = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(entity, {
	name = "compact-combinator-io",
	collision_box = {{-0.20, -0.20}, {0.20, 0.20}},
  selection_box = {{-0.25, -0.25}, {0.25, 0.25}},
	order="a",
	track_coverage_during_build_by_moving = false,
	supply_area_distance = 0,
	flags = {
		"placeable-player",
		"placeable-enemy",
		"player-creation",
		"placeable-off-grid",
		"not-on-map"
	},
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
entity.minable.result = "compact-combinator-io"
data:extend({	entity })

-- Item for Port outside (copying for blueprint)
local item = table.deepcopy(data.raw["item"]["iron-chest"])
overwriteContent(item, {
	name = "compact-combinator-io",
	subgroup = "circuit-network",
	order = "c[combinators]-e[compact-combinator]",
	place_result = "compact-combinator-io",
	icon = "__integratedCircuitry__/graphics/icons/compact-combinator.png",
})
data:extend({	item })




-- Port inside
local entity = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(entity, {
	name = "compact-combinator-port",
	collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	order="a",
	track_coverage_during_build_by_moving = false,
	supply_area_distance = 0,
	flags = {
		"placeable-player",
		"placeable-enemy",
		"player-creation",
		--"placeable-off-grid",
		--"not-on-map"
	},
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
		filename = "__integratedCircuitry__/graphics/entity/compact-combinator-port.png",
		priority = "extra-high",
		width = 52,
		height = 40,
		direction_count = 1,
		shift = {0, 0}
	},
})
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = nil
data:extend({	entity })

-- Item for Port inside (copying for blueprint)
local item = table.deepcopy(data.raw["item"]["iron-chest"])
overwriteContent(item, {
	name = "compact-combinator-port",
	subgroup = "circuit-network",
	order = "c[combinators]-e[compact-combinator]",
	place_result = "compact-combinator-port",
	icon = "__integratedCircuitry__/graphics/icons/compact-combinator.png",
})
data:extend({	item })




-- Big pole for connecting cables outside with inside
local removeKey = "__REMOVE__"
local entity = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(entity, {
	name = "compact-combinator-connection",
	collision_box = removeKey, -- {{0, 0}, {0, 0}},
  selection_box = removeKey, --{{-0.25, -0.25}, {0.25, 0.25}},
	order="a",
	track_coverage_during_build_by_moving = false,
	supply_area_distance = 0,
	maximum_wire_distance = 64,
	flags = {
		"placeable-player",
		"placeable-enemy",
		"player-creation",
		"placeable-off-grid",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable",
		"hidden",
		"not-rotatable"
	},
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
}, removeKey)
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = nil
data:extend({	entity })