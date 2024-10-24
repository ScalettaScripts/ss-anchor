RegisterKeyMapping("anchor", "Anchor Boat", "keyboard", "e")
local config = Config

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
                    SendNotification(config.raisedText)
                else
                    if CanAnchorBoatHere(boat) then
                        SetBoatAnchor(boat, true)
                        SetBoatFrozenWhenAnchored(boat, true)
                        SetForcedBoatLocationWhenAnchored(boat, true)
                        SendNotification(config.loweredText)
                    else
                        SendNotification(config.notInWaterText)
                    end
                end
            else
                SendNotification(config.tooFastText)
            end
        end
    end
end, false)

function SendNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

if config.boatAnchoredText then
    CreateThread(function()
        while true do
            Wait(500)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsEntering(ped)
            if IsBoatAnchoredAndFrozen(veh) then
                SendNotification(config.boatAnchoredText)
            end
        end
    end)
end
