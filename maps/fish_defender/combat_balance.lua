local Event = require 'utils.event'
local gain_multiplier = 4

local balance_functions = {
    ['land-mine'] = function (force_name)
        if not storage.combat_balance[force_name].land_mine then
            storage.combat_balance[force_name].land_mine = -0.5
        end
        game.forces[force_name].set_ammo_damage_modifier('landmine', storage.combat_balance[force_name].land_mine)
    end,
    ['stronger-explosives'] = function (force_name)
        if not storage.combat_balance[force_name].land_mine then
            storage.combat_balance[force_name].land_mine = -0.5
        end
        storage.combat_balance[force_name].land_mine = storage.combat_balance[force_name].land_mine + 0.05
        game.forces[force_name].set_ammo_damage_modifier('landmine', storage.combat_balance[force_name].land_mine)
    end
}

local function combat_balance(event)
    local research_name = event.research.name
    local force_name = event.research.force.name
    local key
    for b = 1, string.len(research_name), 1 do
        key = string.sub(research_name, 0, b)
        if balance_functions[key] then
            if not storage.combat_balance[force_name] then
                storage.combat_balance[force_name] = {}
            end
            balance_functions[key](force_name)
            return
        end
    end
end

local function on_research_finished(event)
    local research = event.research
    local force_name = research.force.name

    if not storage.shotgun_shell_damage_modifier_old[force_name] then
        storage.shotgun_shell_damage_modifier_old[force_name] = game.forces[force_name].get_ammo_damage_modifier('shotgun-shell') - 0.1
    end

    if string.sub(research.name, 0, 26) == 'physical-projectile-damage' then
        local current_damage = game.forces[force_name].get_ammo_damage_modifier('shotgun-shell')
        local vanilla_gain = current_damage - storage.shotgun_shell_damage_modifier_old[force_name]
        local additional_gain = vanilla_gain * (gain_multiplier - 1)
        game.forces[force_name].set_ammo_damage_modifier('shotgun-shell', current_damage + additional_gain)
    end

    storage.shotgun_shell_damage_modifier_old[force_name] = game.forces[force_name].get_ammo_damage_modifier('shotgun-shell')

    combat_balance(event)
end

local function on_init()
    game.forces.player.set_ammo_damage_modifier('shotgun-shell', 1)
    storage.shotgun_shell_damage_modifier_old = {}
    storage.combat_balance = {}
end

Event.on_init(on_init)
Event.add(defines.events.on_research_finished, on_research_finished)
