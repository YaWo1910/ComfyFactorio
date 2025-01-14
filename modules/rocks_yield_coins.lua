local Event = require 'utils.event'

local coin_yield = {
    ['big-rock'] = 3,
    ['huge-rock'] = 6,
    ['big-sand-rock'] = 3
}

local function on_player_mined_entity(event)
    if coin_yield[event.entity.name] then
        event.entity.surface.spill_item_stack(
            event.entity.position,
            { name = 'coin', count = math.random(math.ceil(coin_yield[event.entity.name] * 0.5), math.ceil(coin_yield[event.entity.name] * 2)) },
            true
        )
    end
end

Event.add(defines.events.on_player_mined_entity, on_player_mined_entity)
