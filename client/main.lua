local InArmour = false

RegisterNetEvent('ewen:server:SetArmour', function(type)
    InArmour = type
end)

AddEventHandler("gameEventTriggered", function(eventName, eventArguments)
    if InArmour then
        local args = {}
        if eventName == "CEventNetworkEntityDamage" then
            local victimEntity, attackEntity, damage, _, _, fatalBool, weaponUsed, _, _, _, entityType = table.unpack(eventArguments)
            args = { victimEntity, attackEntity, fatalBool == 1, weaponUsed, entityType,
                     math.floor(string.unpack("f", string.pack("i4", damage)))
            }
            if GetEntityType(victimEntity) == 1 then
                if victimEntity == PlayerPedId() then
                    if InArmour then
                        if GetPedArmour(PlayerPedId()) == 0 then
                            TriggerServerEvent('ewen:server:BreakKevlar')
                            SetEntityInvincible(PlayerPedId(), true)
                            DisablePlayerFiring(GetPlayerPed(-1), true)
                            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
                            Citizen.Wait(10000)
                            SetEntityInvincible(PlayerPedId(), false)
                            ResetPedRagdollTimer(PlayerPedId())
                            InArmour = false
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if IsPedWalking(PlayerPedId()) then
            if GetPedArmour(PlayerPedId()) == 0 then
                TriggerServerEvent('ewen:server:getKevlar')
                break
            end
        end
    end
end)