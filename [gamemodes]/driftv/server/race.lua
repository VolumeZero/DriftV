local race_saison = Config.raceSeaon
local races = {}

function SubmitRaceScore(source, race, points, vehicle, time)
    if races[race] == nil then
        races[race] = {}
        races[race].scores = {}
    end

    if #races[race].scores == 0 then
        table.insert(races[race].scores, {name = GetPlayerName(source), points = points, veh = vehicle, time = time})
    else    
        local added = false
        local foundIndex = false
        local personalIndex = nil
        local infoToSendIfNewScore = {
            name = nil,
            points = nil,
            oldPoints = nil,
            place = nil,
            race = nil,
            vehicle = nil,
            time = nil
        }

        for k,v in pairs(races[race].scores) do
            if v.points < points then
                added = true
                table.insert(races[race].scores, k, {name = GetPlayerName(source), points = points, veh = vehicle, time = time})
                infoToSendIfNewScore = {
                    name = v.name,
                    points = points,
                    oldPoints = v.points,
                    place = k,
                    race = race,
                    vehicle = vehicle,
                    time = time
                }
                break
            end
        end
        if not added then
            table.insert(races[race].scores, {name = GetPlayerName(source), points = points, veh = vehicle, time = time})
        end

        local cachedNames = {}
        for k,v in pairs(races[race].scores) do
            if cachedNames[v.name] == nil then
                cachedNames[v.name] = v.points
            else
                table.remove(races[race].scores, k)
            end
        end

        --print(cachedNames[GetPlayerName(source)], infoToSendIfNewScore.points)
        if added and cachedNames[GetPlayerName(source)] <= infoToSendIfNewScore.points then
            SendDriftAttackScore(source, infoToSendIfNewScore.name, infoToSendIfNewScore.points, infoToSendIfNewScore.oldPoints, infoToSendIfNewScore.place, infoToSendIfNewScore.race, infoToSendIfNewScore.vehicle)
            TriggerClientEvent('chat:addMessage', -1, {
                color = {252, 186, 3},
                multiline = true,
                args = {"Drift Trials:", "~b~"..GetPlayerName(source).."~s~ just took ~r~POSITION~s~: #"..infoToSendIfNewScore.place.."~s~ on ~g~".. race .."~s~! Score: ~r~" ..infoToSendIfNewScore.points.."~s~ points!"}
            })
            
        end



        for k,v in pairs(races[race].scores) do
            if k > 20 then
                table.remove(races[race].scores, k)
            end
        end
    end
    

    TriggerClientEvent("drift:RefreshRacesScores", -1, races)
    local db = rockdb:new()
    db:SaveTable("races_"..race_saison, races)
    debugPrint("Race saved")
end

Citizen.CreateThread(function()
    local db = rockdb:new()

    races = db:GetTable("races_"..race_saison)
    if races == nil then
        print("Created races data from scratch")
        races = {}
    end

    TriggerClientEvent("drift:RefreshRacesScores", -1, races)
end)


RegisterSecuredNetEvent(Events.raceEnd, function(race, points, vehicle, time)
    SubmitRaceScore(source, race, points, vehicle, time)
end)

RegisterSecuredNetEvent(Events.raceData, function()
    TriggerClientEvent("drift:RefreshRacesScores", source, races)
end)