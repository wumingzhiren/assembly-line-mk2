local _M = {}
local cp = require("component")
local item_utils = require("util.item_utils")
local db = cp.database
local dbCache = {}

function _M.proxy(address)
    return cp.proxy(address)
end

function _M.getFluidDatabase()
    return db
end

function _M.getFluidIndexByRecipeFluidy(recipeFluid)
    local cache = dbCache[recipeFluid[1]]
    if cache then
        return cache
    end

    for i = 1, 81 do
        local data = db.get(i)
        if data and item_utils.itemIdentity(data) == recipeFluid[1] then
            dbCache[recipeFluid[1]] = i
            return i
        elseif data and data.fluid_name == recipeFluid.cname then
            dbCache[recipeFluid[1]] = i
            return i
        elseif data and item_utils.itemIdentity(data) == recipeFluid.containerItem then
            dbCache[recipeFluid[1]] = i
            return i
        end
    end
end

return _M