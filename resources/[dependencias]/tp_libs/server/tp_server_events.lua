
--[[ ------------------------------------------------
   Events
]]---------------------------------------------------

RegisterServerEvent('tp_libs:sendNotification')
AddEventHandler('tp_libs:sendNotification', function(tsource, message, type)
    local _source = tonumber(tsource)
    SendNotification(_source, message, type)
end)

RegisterServerEvent("tp_libs:sendToDiscord")
AddEventHandler("tp_libs:sendToDiscord", function(webhook, name, description, color)
    local data = Config.DiscordWebhooking

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = color or 15105570,
                ["author"] = {
                    ["name"] = data.Label,
                    ["icon_url"] = data.ImageUrl,
                },
                ["title"] = name,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = data.Footer .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = data.ImageUrl,

                },
            },

        },
        avatar_url = data.ImageUrl
    }), {
        ['Content-Type'] = 'application/json'
    })
end)


--[[ ------------------------------------------------
   Framework Events
]]---------------------------------------------------

AddEventHandler("vorp:playerJobChange", function(source, job)
    local _source = source
    TriggerClientEvent("tp_libs:getPlayerJob", _source, job)
end)
