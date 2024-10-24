RegisterKeyMapping("anchor", "Anchor Boat", "keyboard", "e")
local config = Config
local currentLang = config.defaultLang

RegisterCommand("anchor", function(source)
    local ped = PlayerPedId()
    if IsPedInAnyBoat(ped) then
        local boat = GetVehiclePedIsIn(ped)
        if GetPedInVehicleSeat(boat, -1) == ped then
            if GetEntitySpeed(ped) <= config.speedToDeploy / 3.6 then -- KM/H
                if IsBoatAnchoredAndFrozen(boat) then
                    SetBoatAnchor(boat, false)
                    SetBoatFrozenWhenAnchored(boat, false)
                    SetForcedBoatLocationWhenAnchored(boat, false)
                    SendNotification(config.Locales[currentLang].raisedText)
                else
                    if CanAnchorBoatHere(boat) then
                        SetBoatAnchor(boat, true)
                        SetBoatFrozenWhenAnchored(boat, true)
                        SetForcedBoatLocationWhenAnchored(boat, true)
                        SendNotification(config.Locales[currentLang].loweredText)
                    else
                        SendNotification(config.Locales[currentLang].notInWaterText)
                    end
                end
            else
                SendNotification(config.Locales[currentLang].tooFastText)
            end
        end
    end
end, false)

function SendNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

if config.Locales[currentLang].boatAnchoredText then
    CreateThread(function()
        while true do
            Wait(500)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsEntering(ped)
            if IsBoatAnchoredAndFrozen(veh) then
                SendNotification(config.Locales[currentLang].boatAnchoredText)
            end
        end
    end)
end
