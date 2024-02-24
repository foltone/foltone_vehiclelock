# foltone_vehiclelock

## Description | FR
Ce script permet de verrouiller et deverrouiller les véhicules, il est possible d'acheter des clés pour les véhicules, de les donner à d'autres joueurs, de les nommer et de les supprimer. Le script est optimisé à 0,00 ms et configurable.

Caractéristiques:
- Verrouiller et deverrouiller les véhicules
- Acheter des clés pour les véhicules
- Donner des clés à d'autres joueurs
- Nommer les clés
- Supprimer les clés
- Optimisé à 0,00 ms
- Configurable
- Menu RageUI

## Description | EN
This script allows you to lock and unlock vehicles, it is possible to buy keys for vehicles, give them to other players, name them and delete them. The script is optimized at 0.00 ms and configurable.

Features:
- Lock and unlock vehicles
- Buy keys for vehicles
- Give keys to other players
- Name the keys
- Delete the keys
- Optimized at 0.00 ms
- Configurable
- RageUI menu

## Vidéo
https://youtu.be/cX1-LzVR0Vc

## Discord
https://discord.gg/X9ReemrhKh

## Requirements
- [es_extended](https://github.com/esx-framework/esx_core/tree/main/%5Bcore%5D/es_extended)
- [oxmysql](https://github.com/overextended/oxmysql)

## Available triggers:
- Verifying if have a key for the vehicle plate
```lua
ESX.TriggerServerCallback('foltone_vehiclelock:hasKey', function(hasKey)
    if hasKey then
        -- Do something
    else
        -- Do something
    end
end, vehiclePlate)
```
- Getting my keys
```lua
ESX.TriggerServerCallback('foltone_vehiclelock:getMyKeys', function(keys)
    -- Do something
end)
```
- Buying a key
```lua
ESX.TriggerServerCallback('foltone_vehiclelock:buyKey', function(bought)
    if bought then
        -- Do something
    else
        -- Do something
    end
end, vehiclePlate)
```
- Giving a key
```lua
TriggerServerEvent('foltone_vehiclelock:handingKey', GetPlayerServerId(player), vehiclePlate)
```
- Naming a key
```lua
TriggerServerEvent('foltone_vehiclelock:renameKey', vehiclePlate, name)
```
- Deleting a key
```lua
TriggerServerEvent('foltone_vehiclelock:removeKey', keyId)
```

## License
Ce projet est sous licence ``CC BY-NC 4.0 DEED`` [LICENSE](https://creativecommons.org/licenses/by-nc/4.0/) pour plus d'informations
- Attribution - Vous devez créditer l'Œuvre, intégrer un lien vers la licence et indiquer si des modifications ont été effectuées à l'Oeuvre. Vous devez indiquer ces informations par tous les moyens raisonnables, sans toutefois suggérer que l'Offrant vous soutient ou soutient la façon dont vous avez utilisé son Oeuvre.
- Pas d’Utilisation Commerciale - Vous n'êtes pas autorisé à faire un usage commercial de cette Oeuvre, tout ou partie du matériel la composant.
- Pas de restrictions complémentaires - Vous n'êtes pas autorisé à appliquer des conditions légales ou des mesures techniques qui restreindraient légalement autrui à utiliser l'Oeuvre dans les conditions décrites par la licence.
