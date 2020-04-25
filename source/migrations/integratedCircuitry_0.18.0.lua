local function check(force, technologyName, recipeName)
	if force.technologies[technologyName].researched then
		force.recipes[recipeName].enabled = true
	end
end

for i, force in pairs(game.forces) do
	force.reset_technologies()
	force.reset_recipes()
	
	-- technology unlocking migration:
	check(force, "circuit-network","compact-combinator")
	check(force, "optics", "lamp-panel")
	check(force, "optics", "status-panel")
end