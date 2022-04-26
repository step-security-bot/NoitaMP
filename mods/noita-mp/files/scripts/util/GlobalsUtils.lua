-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

-----------------
-- GlobalsUtils:
-----------------
--- class for GlobalsSetValue and GlobalsGetValue
GlobalsUtils = {}

--#region Global public variables

--- key for nuid
GlobalsUtils.nuidKeyFormat = "nuid = %s"
GlobalsUtils.nuidKeySubstring = "nuid = "
GlobalsUtils.nuidValueFormat = "entityId = %s"
GlobalsUtils.nuidValueSubstring = "entityId = "

--#endregion

--#region Access to global private variables

--- Parses key and value string to nuid and entityId.
--- @param xmlKey string GlobalsUtils.nuidKeyFormat = "nuid = %s"
--- @param xmlValue string GlobalsUtils.nuidValueFormat = "entityId = %s"
--- @return number nuid
--- @return number entityId
function GlobalsUtils.parseXmlValueToNuidAndEntityId(xmlKey, xmlValue)
    if type(xmlKey) ~= "string" then
        logger:error("xmlKey(%s) is not type of string!", xmlKey)
    end
    if type(xmlValue) ~= "string" then
        logger:error("xmlKeyValue(%s) is not type of string!", xmlValue)
    end

    local nuid = nil
    local foundNuid = string.find(xmlKey, GlobalsUtils.nuidKeySubstring, 1, true)
    if foundNuid ~= nil then
        nuid = tonumber(string.sub(xmlKey, GlobalsUtils.nuidKeySubstring:len()))
    else
        logger:error("Unable to get nuid number of key string (%s).", xmlKey)
    end

    local entityId = nil
    local foundEntityId = string.find(xmlValue, GlobalsUtils.nuidValueSubstring, 1, true)
    if foundEntityId ~= nil then
        entityId = tonumber(string.sub(xmlValue, GlobalsUtils.nuidValueSubstring:len()))
    else
        logger:error("Unable to get entityId number of value string (%s).", xmlValue)
    end

    return nuid, entityId
end

function GlobalsUtils.setNuid(nuid, entityId, componentIdForOwnerName, componentIdForOwnerGuid, componentIdForNuid)
    GlobalsSetValue(GlobalsUtils.nuidKeyFormat:format(nuid), GlobalsUtils.nuidValueFormat:format(entityId)) -- also change stuff in nuid_update.lua
end

-- function GlobalsUtils.getNuid(entityId)
-- end

--- Builds a key string by nuid and returns nuid and entityId found by the globals.
--- @param nuid number
--- @return number nuid
--- @return number entityId
function GlobalsUtils.getNuidEntityPair(nuid)
    local key = GlobalsUtils.nuidKeyFormat:format(nuid)
    ---@diagnostic disable-next-line: missing-parameter
    local value = GlobalsGetValue(key)
    return GlobalsUtils.parseXmlValueToNuidAndEntityId(key, value)
end

--#endregion

return GlobalsUtils
