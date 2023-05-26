local vehs = {
    {
        level = 0,
        label = "Tier 1 (~b~lvl~s~0)",
        vehs = {
            {maker = "Honda", price = 50000, label = "Accord 86", model = "accord86"},
            {maker = "BMW", price = 65000,label = "e46",model = "bmwe"},
            {maker = "Lexus", price = 70000,label = "RC350 Rocket Bunny",model = "RC350"},
            {maker = "Chevrolet", price = 49500,label = "1970 Chevelle SS",model = "chevelle1970"},
            {maker = "Zirconium", price = 49500,label = "Stratum",model = "stratum"},
            {maker = "Toyota", price = 75000,label = "1985 Toyota Sprinter Trueno GT Apex",model = "AE86"},
        }
    },
    {
        level = 10,
        label = "Tier 2 (~b~lvl~s~10)",
        vehs = {
            {maker = "Honda", price = 85000, label = "2015 Civic Type R",model = "FK2"},
            {maker = "Honda", price = 85000, label = "Civic EK9 Rocket Bunny",model = "civicek9rb"},
            {maker = "BMW", price = 90000,label = "1992 M3 E36 Pandem Rocket Bunny",model = "e36prb"},
            {maker = "Mazda", price = 75000,label = "rx7 Fc3s",model = "fc3s"},
            {maker = "Nissan", price = 75000,label = "180sx",model = "180sx"}, -- icon
            {maker = "Maibatsu", price = 88000,label = "Penumbra",model = "penumbra"}, -- icon
            {maker = "Karin", price = 88000,label = "Sultan",model = "sultan"}, -- icon
            {maker = "Toyota", price = 95000,label = "Chaser JZX100",model = "jzx100"}, -- icon
            {maker = "Nissan", price = 95000,label = "1989-1992 Silvia S13",model = "nis13"}, -- icon
        }
    },
    {
        level = 20,
        label = "Tier 3 (~b~lvl~s~20)",
        vehs = {
            {maker = "Mazda", price = 115000, label = "rx7",model = "FD"}, -- icon
            {maker = "Nissan", price = 120000,label = "s15 Rocket Bunny",model = "s15rb"},
            {maker = "Nissan", price = 140000,label = "350z Rocket Bunny Kit Stanced",model = "350zrb"},
            {maker = "Subaru", price = 190000,label = "BRZ Rocket Bunny",model = "brz"},
            {maker = "Subaru", price = 120000,label = "Impreza WRX STI 2004",model = "subwrx"},
            {maker = "Nissan", price = 150000,label = "1994 240SX SE Fastback",model = "240sx"}, -- icon
            {maker = "Toyota", price = 190000,label = "GT86",model = "toy86"}, -- icon
        }
    },
    {
        level = 30,
        label = "Tier 4 (~b~lvl~s~30)",
        vehs = {
            {maker = "Nissan", price = 250000,label = "GTR35",model = "gtr"},
            {maker = "Nissan", price = 350000,label = "Skyline GT-R34 (BNR34) 2002",model = "skyline"},
            {maker = "Mitsubishi", price = 230000,label = "Lancer Evo VI",model = "cp9a"},
            {maker = "Ford", price = 450000,label = "2015 Mustang GT",model = "MGT"},
            
        }
    },
    {
        level = 40,
        label = "Tier 5 (~b~lvl~s~40)",
        vehs = {
            {maker = "Honda", price = 750000,label = "1992 NSX-R Rocket Bunny",model = "nsxtypr"},
            {maker = "Acura", price = 550000,label = "NSX LB",model = "filthynsx"},
            {maker = "Lamborghini", price = 1200000,label = "Gallardo Superleggera LB ",model = "gallardosuperlb"},
            {maker = "Lamborghini", price = 1400000,label = "2014 Huracan LB",model = "lbsihu"},
            {maker = "Toyota", price = 950000,label = "Supra mk4",model = "a80"},
        }
    },
}

local backToLobby = false
local open = false
local selectedSub = {}
local previewVeh = {
    entity = 0,
    model = ""
}
local previewCoords = vector4(-44.621406555176, -1096.7896728516, 26.422359466553, 118.64887237549)
local vehShopCoords = vector3(-43.162559509277, -1100.0212402344, 26.422359466553)
local camPos = vector3(-45.922637939453, -1102.5314941406, 27.422361373901)
local main = RageUI.CreateMenu("DriftV", "~b~Drift vehicles shop")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift vehicles shop")
local sell =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift vehicles shop")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    DeleteEntity(previewVeh.entity)
    cam.render("SHOP", false, false, 0)
    cam.delete("SHOP")

    if backToLobby then
        EnableLobby()
    end
end
sub.Closed = function()
    DeleteEntity(previewVeh.entity)
end 
sell.Closed = function()
    DeleteEntity(previewVeh.entity)
end 

main.WidthOffset = 100.0
sub.WidthOffset = 100.0
sell.WidthOffset = 100.0

function OpenVehShopMenu(GoBackToLobby)
    if open then
        open = false
        RageUI.Visible(main, false)
    else

        if GoBackToLobby ~= nil and GoBackToLobby == true then
            backToLobby = true
        else
            backToLobby = false
        end

        open = true
        RageUI.Visible(main, true)
        cam.create("SHOP")
        cam.setPos("SHOP", camPos)
        cam.setFov("SHOP", 40.0)
        cam.lookAtCoords("SHOP", previewCoords.xyz)
        cam.setActive("SHOP", true)
        cam.render("SHOP", true, false, 0)

         Citizen.CreateThread(function()
            while open do
                DisableControlAction(0,14,true)
                DisableControlAction(0,15,true)
                DisableControlAction(0,16,true)
                DisableControlAction(0,17,true)
                DisableControlAction(0,20,true)
                DisableControlAction(0,24,true)
                DisableControlAction(0,80,true)
                DisableControlAction(0,140,true)
                RageUI.IsVisible(main, function()
		            RageUI.Button("Money: ~g~$"..GroupDigits(tostring(p:GetMoney())) .. "", nil, {}, true, {});
                    RageUI.Button("Level: (~b~"..p:getLevel().. "~s~)", nil, {}, true, {});
                    RageUI.Button("Sell", nil, {RightLabel = ">"}, true, {}, sell);
                    for k,v in pairs(vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, p:getLevel() >= v.level, {
                            onSelected = function()
                                selectedSub = k
                            end,
                        }, sub);
                    end
                end)

                RageUI.IsVisible(sub, function()
                    RageUI.Button("Money: ~g~$"..GroupDigits(tostring(p:GetMoney())) .. "", nil, {}, true, {});
                    for k,v in pairs(vehs[selectedSub].vehs) do
                        RageUI.Button(v.maker.." "..v.label, nil, {RightLabel = "~g~"..GroupDigits(v.price).."~s~$"}, true, {
                            onSelected = function()
                                if v.price <= p:GetMoney() then
                                    open = false
                                    RageUI.CloseAll()
                                    RageUI.Visible(main, false)
                                    DeleteEntity(previewVeh.entity)
                                    cam.render("SHOP", false, false, 0)
                                    cam.delete("SHOP")
                                    TriggerServerEvent(Events.buyVeh, v.price, v.maker.." "..v.label, v.model)
                                    ShowHelpNotification("Your new vehicle has been added to your garage! To take it out, use F1 -> My vehicles !", true)

                                    if backToLobby then
                                        EnableLobby()
                                    end
                                else
                                    ShowNotification("Not enough money")
                                end
                            end,
                            onActive = function()
                                if previewVeh.model ~= v.model then
                                    DeleteEntity(previewVeh.entity)

                                    local veh = entity:CreateVehicleLocal(v.model, previewCoords.xyz, previewCoords.w)
                                    SetVehicleOnGroundProperly(veh:getEntityId())
                                    FreezeEntityPosition(veh:getEntityId(), true)
                                    SetVehicleDirtLevel(veh:getEntityId(), 0.0)
                                    previewVeh.entity = veh:getEntityId()
                                    previewVeh.model = v.model
                                end
                            end
                        }, sub);
                    end
                end)

                RageUI.IsVisible(sell, function()
                    for k,v in pairs(p:GetCars()) do
                        RageUI.Button(v.label, "Sell Selected Vehicle!", {RightLabel = "~g~"..(v.price).."~s~$"}, true, {
                            onSelected = function()
                                open = false
                                RageUI.CloseAll()
                                RageUI.Visible(main, false)
                                DeleteEntity(previewVeh.entity)
                                cam.render("SHOP", false, false, 0)
                                cam.delete("SHOP")
                                TriggerServerEvent(Events.sellVeh, v.price, v.label, v.model)
                                ShowHelpNotification("Your vehicle has been sold!", true)
                                if backToLobby then
                                    EnableLobby()
                                end
                            end,
                            onActive = function()
                                local pVeh = p:GetCars()
                                for k,v in pairs(pVeh) do
                                    if previewVeh.model ~= v.model then
                                        DeleteEntity(previewVeh.entity)
                                        local veh = entity:CreateVehicleLocal(v.model, previewCoords.xyz, previewCoords.w)
                                        SetVehProps(veh:getEntityId(), v.props)
                                        SetVehicleOnGroundProperly(veh:getEntityId())
                                        FreezeEntityPosition(veh:getEntityId(), true)
                                        SetVehicleDirtLevel(veh:getEntityId(), 0.0)
                                        previewVeh.entity = veh:getEntityId()
                                    end
                                end
                            end
                        }, sell);
                    end
                end)

                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone("veh_shop", vehShopCoords, "Press ~INPUT_CONTEXT~ to open vehicle shop", function() OpenVehShopMenu() end, true, 36, 1.0, {133, 255, 92}, 170)
    AddBlip(vehShopCoords, 326, 2, 0.85, 17, "Drift vehicle shop")
end)

