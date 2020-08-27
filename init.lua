--Modems but Soqet
-- (requires soqet for CC)

-- Common Locations
package.path = package.path..";/apis/?;/apis/?.lua"
if fs.exists(".global-require-path") then
    local h = fs.open(".global-require-path","r")
    local contents = h.readAll()
    package.path = package.path..";"..contents
    h.close()
end
--Load Soqet
local soqet = require("soqet")
--List Opened Channels
--FIXME: when running multiple instances, it doesn't coop
openedChannels = {}
--Peripheral Object
local peripheralObject = {
    --Opening a channel
    ["open"] = function(c)
        --Adds to "Opened" list
        table.insert(openedChannels, c)
        --Actually opens channel
        return soqet.open(c)
    end,
    ["transmit"] = function(c,rc,m,dist,me)
        --Meta stuff
        local me = me or {}
        --Sets reply channel meta
        me["rc"] = rc
        --Sets distance meta
        me["dist"] = dist or 0
        --Actually sends message
        return soqet.send(c, m, me)
    end,
    ["isWireless"] = function()
        --Is it wireless?
        return true, "soqet"
    end,
    ["isOpened"] = function(c)
        --Get opened channel
        for k,v in pairs(openedChannels) do
            --Compare "c" with "v"
            if c == v then
                --Returns true if found
                return true
            end
        end
        --If not, returns false
        return false
    end,
    ["close"] = function(c)
        --Remove from openedChannels
        openedChannels[c] = nil
        --Actually closes channel
        return soqet.close(c)
    end,
    ["isClosed"] = function(c)
        --Opposite of isOpened
        --Checks if channel is closed
        if not peripheralObject.isOpened(c) then
            --Returns true if channel is closed
            return true
        end
        --Returns false if channel is opened
        return false
    end
}
--Opens daemon (event handler)
shell.openTab(fs.combine(fs.getDir(shell.getRunningProgram()), "daemon.lua"))
--Creates copy of peripheral API
local oldperipheral = {}
for k,v in pairs(peripheral) do
    oldperipheral[k] = v
end
--Modifies peripheral.wrap to respond to "soqet"
function _G.peripheral.wrap(p)
    if p == "soqet" then
        return peripheralObject
    else
        return oldperipheral.wrap(p)
    end
end
--Modifies peripheral.find to respond to "soqet"
function _G.peripheral.find(p)
    if p == "soqet" then
        return peripheralObject
    else
        return oldperipheral.find(p)
    end
end

--And thats about it!

