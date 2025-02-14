
require "lua_timers"

function DeathSwap.getParticipantsData()
    local olPl = getOnlinePlayers()
    local participants = {}

    for i = 0, olPl:size() - 1 do
        local user = olPl:get(i):getUsername()
        if user and not DeathSwap.isBlacklisted(user) then
            local targ = getPlayerFromUsername(user)
            if targ then
                table.insert(participants, {
                    username = user,
                    x = round(targ:getX()),
                    y = round(targ:getY()),
                    z = targ:getZ()
                })
                if (getCore():getDebug() and isAdmin()) then
                    print(user)
                end
            end
        end
    end

    if #participants < 2 then
        local joke = DeathSwap.getRandJoke(ZombRand(1, 5))
        HaloTextHelper.addTextWithArrow(getPlayer(), joke, false, 255, 0, 0)
        return nil
    end

    return participants
end

function DeathSwap.doShuffle(tab)
    if not tab then return end
    local function hasSameIndices(indices)
        for i, v in ipairs(indices) do
            if i == v then
                return true
            end
        end
        return false
    end

    local n = #tab
    local indices = {}

    for i = 1, n do
        indices[i] = i
    end

    repeat
        for i = n, 2, -1 do
            local j = ZombRand(i) + 1
            indices[i], indices[j] = indices[j], indices[i]
        end
    until not hasSameIndices(indices)

    local shuffledTab = {}
    for i = 1, n do
        shuffledTab[i] = {
            username = tab[i].username,
            x = tab[indices[i]].x,
            y = tab[indices[i]].y,
            z = tab[indices[i]].z
        }
    end

    return shuffledTab
end

function DeathSwap.getTimeStamp()
    local dateTable = os.date("*t")
    local timestamp = string.format("%04d%02d%02d%02d%02d%02d",
        dateTable.year, dateTable.month, dateTable.day,
        dateTable.hour, dateTable.min, dateTable.sec)
    return timestamp
end

function DeathSwap.doDeathSwap()
    local pl = getPlayer()
	if pl:isAccessLevel('admin') then
        local user = pl:getUsername()
        local timestamp = DeathSwap.getTimeStamp() or ""
        local msg  = tostring(user).." Triggered Death Swap " .. tostring(DeathSwap.getTimeStamp())
        ISLogSystem.writeLog(pl, msg)
        ISLogSystem.sendLog(pl, 'DeathSwap', msg)

        DeathSwap.sendDeathSwap()
    end
end

function DeathSwap.sendDeathSwap()
    local participantsData = DeathSwap.getParticipantsData()
    local shuffledData
    if participantsData then
        shuffledData.doShuffle(participantsData)
    end

    if shuffledData then
        local pkt = {}
        for _, p in ipairs(participantsData) do
            table.insert(pkt, {
                username = p.username,
                x = p.x,
                y = p.y,
                z = p.z
            })
        end
    end
    sendClientCommand("DeathSwap", "doDeathSwap", {pkt = pkt})
end
-----------------------            ---------------------------

--client
DeathSwap = DeathSwap or {}
local Commands = {}
Commands.DeathSwap = {}
DeathSwap.data = {}
function DeathSwap.triggerDeathSwap()
    if not DeathSwap.data then return end
    local pl = getPlayer()
    local user = pl:getUsername()
    for _, p in ipairs(DeathSwap.data) do
        if p.username == user then
            pl:setX(p.x)
            pl:setY(p.y)
            pl:setZ(p.z)
            pl:setlX(p.x)
            pl:setlY(p.y)
            pl:setlZ(p.z)
            print("DeathSwap: " .. user .. " teleported to X: " .. p.x .. ", Y: " .. p.y .. ", Z: " .. p.z)
            break
        end
    end
    DeathSwap.data = {}
end

function DeathSwap.doAnnounce(pl)
    pl = pl or getPlayer()
    local intro = getText("IGUI_deathswap_start") or "Death Swap will soon begin in"
    pl:addLineChatElement(intro)

    timer:Simple(2, function()
        local cd = SandboxVars.DeathSwap.Countdown or 10
        timer:Create("DeathSwapCountdown", 1, cd, function()
            local str = timer:RepsLeft("DeathSwapCountdown")
            pl:addLineChatElement(str)

            if str == "1" then
                local user = pl:getUsername()
                DeathSwap.triggerDeathSwap(user)
            end
        end)
    end)
end

Commands.DeathSwap.doDeathSwap = function(args)
    local pl = getPlayer()
    local user = pl:getUsername()

    if args.pkt then
        DeathSwap.data = args.pkt
        DeathSwap.doAnnounce(pl)
    end
end

Events.OnServerCommand.Add(function(module, command, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](args)
    end
end)



-----------------------            ---------------------------




--server
if isClient() then return end

local Commands = {}
Commands.DeathSwap = {}

Commands.DeathSwap.doDeathSwap = function(_, args)
    sendServerCommand("DeathSwap", "doDeathSwap", { pkt = args.pkt })
end


Events.OnClientCommand.Add(function(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args)
    end
end)
