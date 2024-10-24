RegisterKeyMapping("anchor", "Anchor Boat", "keyboard", "e")
local config = Config
local currentLang = config.defaultLang

RegisterCommand("anchor", function(source)
    local ped = PlayerPedId()
    if IsPedInAnyBoat(ped) then
        local boat = GetVehiclePedIsIn(ped)
        if GetPedInVehicleSeat(boat, -1) == ped then
            if GetEntitySpeed(boat) <= config.speedToDeploy / 3.6 then 
                if IsBoatAnchoredAndFrozen(boat) then
                    SetBoatAnchor(boat, false)
                    SetBoatFrozenWhenAnchored(boat, false)
                    SetForcedBoatLocationWhenAnchored(boat, false)
                    SendNotification(config.Locales[currentLang].raisedText, "ANCHOR_RAISE_SOUND") 
                else
                    if CanAnchorBoatHere(boat) then
                        SetBoatAnchor(boat, true)
                        SetBoatFrozenWhenAnchored(boat, true)
                        SetForcedBoatLocationWhenAnchored(boat, true)
                        SendNotification(config.Locales[currentLang].loweredText, "ANCHOR_DROP_SOUND") 
                    else
                        SendNotification(config.Locales[currentLang].notInWaterText, "ERROR_SOUND") 
                    end
                end
            else
                SendNotification(config.Locales[currentLang].tooFastText, "ERROR_SOUND") 
            end
        end
    end
end, false)

function SendNotification(message, sound)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)

    if sound == "ANCHOR_RAISE_SOUND" then
        PlaySoundFromEntity(-1, "PICK_UP", PlayerPedId(), "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0)
    elseif sound == "ANCHOR_DROP_SOUND" then
        PlaySoundFromEntity(-1, "Dropped", PlayerPedId(), "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 0, 0)
    elseif sound == "ERROR_SOUND" then
        PlaySoundFromEntity(-1, "Pin_Bad", PlayerPedId(), "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", 0, 0)
    end
end

if config.Locales[currentLang].boatAnchoredText then
    CreateThread(function()
        while true do
            Wait(500)
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsEntering(ped)
            if IsBoatAnchoredAndFrozen(veh) then
                SendNotification(config.Locales[currentLang].boatAnchoredText, "ANCHOR_RAISE_SOUND")
            end
        end
    end)
end
