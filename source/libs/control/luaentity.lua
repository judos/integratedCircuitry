
-- Try to remove entity and give items back to player
-- player is optional, if not given (e.g. placed by robots) 
--   spill items on floor and mark for removal
function removeEntity(entity, player)
	if player then
			player.mine_entity(entity)
	else
		local pos = entity.position
		local force = entity.force
		local surface = entity.surface
		local items = minedItemsFromEntity(entity)
		entity.destroy()
		for _,stack in pairs(items) do
			surface.spill_item_stack(pos, stack, true, force, false)
		end
		--for _, stack in pairs(itemStacks) do
		--	stack.order_deconstruction(force)
		--end
	end
end


function minedItemsFromEntity(entity)
	local products = entity.prototype.mineable_properties.products
	local items = {}
	if products then
		for _,t in pairs(products) do
			if t.type == "item" then
				if t.probability == nil or math.random()<=t.probability then
					table.insert(items, {name=t.name, count=t.amount})
				end
			end
		end
	end
	return items
end