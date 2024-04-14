local utils = require 'client.utils'

local characterData = nil

RegisterNetEvent('zeno:client:player:load', function(character)
    characterData = {
        job = {},
        gang = {},
    }
    characterData.identifier = character.id
    if character.job ~= nil then
        characterData.job.name = character.job.slug
        characterData.job.level = tonumber(character.job.role.slug)
    end
    if character.gang ~= nil then
        characterData.gang.name = character.gang.name
        characterData.gang.level = tonumber(character.gang.role.slug)
    end
end)

RegisterNetEvent('zeno:client:player:unload', function()
    characterData = nil
end)
AddEventHandler('zeno:client:regionManager:playerUpdate', function(isPlayer, ped, index, state)
    if state ~= nil and isPlayer and characterData ~= nil then
        if state.job ~= nil then
            characterData.job.name = state.job.slug
            characterData.job.level = tonumber(state.job.role.slug)
        end
        if state.gang ~= nil then
            characterData.gang.name = state.gang.name
            characterData.gang.level = tonumber(state.gang.role.slug)
        end
    end
end)


---@diagnostic disable-next-line: duplicate-set-field
function utils.hasPlayerGotGroup(filter)

    if characterData == nil then
        return false
    end

    local _type = type(filter)

    if _type == 'string' then
        local job = characterData.job.name == filter
        local gang = characterData.gang.name == filter
        local identifier = characterData.identifier == filter


        if job or gang or identifier then
            return true
        end
    elseif _type == 'table' then
        local tabletype = table.type(filter)

        if tabletype == 'hash' then
            for name, level in pairs(filter) do
                local job = characterData.job.name == name
                local gang = characterData.gang.name == name
                local identifier = characterData.identifier == name

                if job and level <= characterData.job.level or gang and level <= characterData.gang.level or identifier then
                    return true
                end
            end
        elseif tabletype == 'array' then
            for i = 1, #filter do
                local name = filter[i]
                local job = characterData.job.name == name
                local gang = characterData.gang.name == name
                local identifier = characterData.identifier == name

                if job or gang or identifier then
                    return true
                end
            end
        end
    end
end