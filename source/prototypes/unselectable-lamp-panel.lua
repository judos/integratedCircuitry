

-- unselectable lamp-panel
entity = table.deepcopy(data.raw["lamp"]["lamp-panel"])
local REMOVE_KEY = "-remove-"
overwriteContent(entity, {
	name = "display-unselectable-panel",
	icon = "__integratedCircuitry__/graphics/icons/display-unselectable-panel.png",
	icon_size = 32,
	order = "zzzz",
	selection_box = REMOVE_KEY,
	draw_circuit_wires = false,
	flags = {
		"placeable-neutral", 
		"player-creation",
		"not-on-map",
		"not-blueprintable",
		"hide-alt-info",
		"not-deconstructable",
		"not-upgradable"
	},
	picture_off = {
		filename = "__integratedCircuitry__/graphics/empty.png",
		priority = "high",
		width = 1,
		height = 1,
	},

}, REMOVE_KEY)

data:extend({	entity })