

-- Substation for 32x32 power supply inside compact-combinator
local REMOVE = "__REMOVE__"
local entity = table.deepcopy(data.raw["electric-pole"]["small-electric-pole"])
overwriteContent(entity, {
	name = "compact-combinator-substation",
	collision_box = REMOVE,
	selection_box = REMOVE, --{{-0.25, -0.25}, {0.25, 0.25}},
	collision_mask = {},
	order="a",
	track_coverage_during_build_by_moving = false,
	supply_area_distance = 16,
	maximum_wire_distance = 64,
	draw_circuit_wires = false,
	draw_copper_wires = false,
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
	pictures = {
		filename = "__integratedCircuitry__/graphics/empty4x1.png",
		priority = "extra-high",
		width = 1,
		height = 1,
		direction_count = 1,
		shift = {0, 0}
	},
	connection_points = {
		{
			shadow = { red = {0, 0.1}, green = {0.05, 0.15} },
			wire = { red = {0, 0}, green = {0.05, 0.05} }
		}
	},
}, REMOVE)
entity.circuit_connector_sprites = nil
entity.fast_replaceable_group = nil
entity.minable.result = nil
data:extend({	entity })


