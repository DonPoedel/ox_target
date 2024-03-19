local characterData = nil

AddEventHandler('zeno:server:characterData:load', function(source, character)
    characterData = {
        job = {},
        gang = {},
    }
    characterData.source = source
    characterData.identifier = character.id
    if character.job ~= nil then
        characterData.job.name = character.job.slug
        characterData.job.level = character.job.role.slug
    end
    if character.gang ~= nil then
        characterData.gang.name = character.gang.name
        characterData.gang.level = character.gang.level
    end
end)

AddEventHandler('zeno:client:reiognManager:playerUpdate', function(source, isPlayer, ped, index, state)
    if isPlayer and characterData ~= nil then
        if state.job ~= nil then
            characterData.job.name = state.job.slug
            characterData.job.level = state.job.role.slug
        end
        if state.gang ~= nil then
            characterData.gang.name = state.gang.name
            characterData.gang.level = state.gang.level
        end
    end
end)

AddEventHandler('zeno:server:characterData:unload', function()
    characterData = nil
end)

---@diagnostic disable-next-line: duplicate-set-field
function utils.hascharacterDataGotGroup(filter)
    if characterData == nil then
        return
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