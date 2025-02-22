
--[[██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|                        				 Custom  PZ  Mod  Developer  for  Hire													  |
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|                       	Portfolio:  https://steamcommunity.com/id/glytch3r/myworkshopfiles/							          |
|                       		                                    														 	  |
|                       	Discord:    Glytch3r#1337 / glytch3r															      |
|                       		                                    														 	  |
|                       	Support:    https://ko-fi.com/glytch3r														    	  |
|_______________________________________________________________________________________________________________________________-]]

require "Chat/ISChat"

DeathSwap = DeathSwap or {}


DeathSwap.cmdDesc = [[
Death Swap:
[ Chat Commands ]       [ Description ]
___________________________________________________
/dsHelp              -   Shows Death Swap Commands.
/dsClip              -   Store online players' usernames to Clipboard.
/dsCheck [username]  -   Checks if user is Blacklisted.
/dsAdd [username]    -   Adds username to Blacklist.
/dsDel [username]    -   Removes username from Blacklist.
/ds                  -   Triggers Default Death Swap (sandbox option).
/dsSave              -   Manual Sync (If you edit sandbox option via panel).
___________________________________________________
]]
function DeathSwap.getUserFromQuoted(cmd, prefix)
    return cmd:match('^' .. prefix .. '%s*"(.-)"%s*$')
end

function DeathSwap.getUserFromSingle(cmd, prefix)
    return cmd:match('^' .. prefix .. '%s*(%S+)%s*$')
end

function DeathSwap.getUser(cmd, prefix)
    local user = DeathSwap.getUserFromQuoted(cmd, prefix) or DeathSwap.getUserFromSingle(cmd, prefix)
    return user
end

function DeathSwap.chatCmd(cmd)
    local pl = getPlayer()

    if pl:isAccessLevel('admin') or isAdmin() then

        if cmd:match("^/dsAdd%s+") then
            local user = DeathSwap.getUser(cmd, "/dsAdd")
            if user and user ~= "" then
                DeathSwap.addUserBlacklist(user)
                local str = getText("IGUI_deathswap_add") or "has been added to the blacklist"
                pl:Say(user .. " " .. str)
            else
                local msg = getText("IGUI_deathswap_invalid").." ".."/dsAdd"
                pl:Say(tostring(msg))
            end

        elseif cmd:match("^/dsDel%s+") then
            local user = DeathSwap.getUser(cmd, "/dsDel")
            if user and user ~= "" then
                DeathSwap.delUserBlacklist(user)
                local str = getText("IGUI_deathswap_del") or "has been removed from the blacklist"
                pl:Say(user .. " " .. str)
            else
                local msg = getText("IGUI_deathswap_invalid").." ".."/dsDel"
                pl:Say(tostring(msg))
            end

        elseif cmd:match("^/dsCheck%s+") then
            local user = DeathSwap.getUser(cmd, "/dsCheck")
            if user and user ~= "" then
                local isBlacklisted = DeathSwap.isBlacklisted(user)
                local str1 = getText("IGUI_deathswap_is") or "is blacklisted"
                local str2 = getText("IGUI_deathswap_not") or "is not blacklisted"
                pl:Say(user .. " " .. (isBlacklisted and str1 or str2))
            else
                local msg = getText("IGUI_deathswap_invalid").." ".."/dsCheck"
                pl:Say(tostring(msg))
            end

        elseif cmd:match("^/dsClip%s*$") then
            DeathSwap.dsClip()
        elseif cmd:match("^/dsHelp%s*$") then
            DeathSwap.dsHelp()
        elseif cmd:match("^/dsSave%s*$") then
            DeathSwap.dsSave()
        elseif cmd:match("^/ds%s*$") then
            DeathSwap.doDeathSwap()
        end
    end
end

Events.OnGameStart.Add(function()
    LuaEventManager.AddEvent("OnChatCmd")
    table.insert(ISChat.allChatStreams, {name = "deathswap", command = "/ds ", tabID = 1})
    local hook = ISChat.logChatCommand

    function ISChat:logChatCommand(command)
        if command and command ~= "" then
            if luautils.stringStarts(command, "/ds") then
                triggerEvent("OnChatCmd", command)
            end
        elseif originalLogChatCommand then
            hook(self, command)
        end
    end

    Events.OnChatCmd.Add(DeathSwap.chatCmd)
end)


function DeathSwap.dsHelp()
    print(DeathSwap.cmdDesc)
    getPlayer():setHaloNote(tostring(DeathSwap.cmdDesc),150,150,250,2500)
end



function DeathSwap.dsClip()
    local res = ""
    local olPl = getOnlinePlayers()
    for i=0, olPl:size()-1 do
        local user = olPl:get(i):getUsername()
        res = res..';'..tostring(user)
    end
    Clipboard.setClipboard(res)
    local str = getText("IGUI_deathswap_clip") or "Usernames saved to clipboard",
    getPlayer():setHaloNote(tostring(str).."\n"..tostring(res),150,250,150,900)
end


function DeathSwap.dsSave()
    local opt1 = SandboxVars.DeathSwap.Blacklist
    DeathSwap.saveBlacklist(tostring(opt1))

    local opt2 = SandboxVars.DeathSwap.playSfx
    DeathSwap.saveBlacklist(tostring(opt2))

    local opt3 = SandboxVars.DeathSwap.Countdown
    DeathSwap.saveBlacklist(tostring(opt3))
    local str = getText("IGUI_deathswap_save") or "Death Swap Blacklist Updated!"
    getPlayer():setHaloNote(tostring(str), 150,250,150,900)

end



--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]


--[[
    local helpStr = "Death Swap [ Chat Commands ]\n\n"..
    "/dsHelp\nShows Death Swap Commands\n\n"..
    "/dsClip\nStore online players username to Clipboard\n\n"..
    "/dsCheck [username]\nChecks if user is Blacklisted\n\n\n"..
    "/dsAdd [username]\nAdds username to Blacklist\n\n"..
    "/dsDel [username]\nRemove username from Blacklist\n\n\n"..
    "/ds\nTrigger Default Death Swap (sandbox option)\n\n"..

    getPlayer():setHaloNote(tostring(helpStr),150,250,150,900) ]]



--[[
function DeathSwap.chatCmd(cmd)
    local pl = getPlayer()

    if pl:isAccessLevel('admin') or isAdmin() then

        if cmd:match("^/dsAdd%s+") then
            local user = cmd:match("^/dsAdd%s+(%S+)")
            if user then
                DeathSwap.addUserBlacklist(user)
                local str = getText("IGUI_deathswap_add") or "has been added to the blacklist"
                pl:Say(tostring(user) .. " "..tostring(str))
            end

        elseif cmd:match("^/dsDel%s+") then
            local user = cmd:match("^/dsDel%s+(%S+)")
            if user then
                DeathSwap.delUserBlacklist(user)
                local str = getText("IGUI_deathswap_del") or "has been removed from the blacklist"
                pl:Say(tostring(user) .. " "..tostring(str))
            end

        elseif cmd:match("^/dsCheck%s+") then
            local user = cmd:match("^/dsCheck%s+(%S+)")
            if user then
                local isBlacklisted = DeathSwap.isBlacklisted(user)
                local str1 = getText("IGUI_deathswap_is") or "is blacklisted"
                local str2 = getText("IGUI_deathswap_not") or "is not blacklisted"
                pl:Say(tostring(user) .." ".. (isBlacklisted and tostring(str1) or tostring(str2)))
            end

        elseif cmd:match("^/dsClip%s*$") then
            DeathSwap.dsClip()
        elseif cmd:match("^/dsHelp%s*$") then
            DeathSwap.dsHelp()
        elseif cmd:match("^/dsSave%s*$") then
            DeathSwap.dsSave()
        elseif cmd:match("^/ds%s*$") then
            DeathSwap.doDeathSwap()
        end
    end
end
 ]]