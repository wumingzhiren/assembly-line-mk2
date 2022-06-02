local _M = {}
local config = require("conf.config")
local ci = config.chestInput
local chestSourceSide = ci.chestSourceSide

function _M.hasItem()
    local stacks = ci.proxy.getAllStacks(chestSourceSide)
    
    local flag = false
    local all = stacks.getAll()
    for k,v in pairs (all) do
        if v then
            flag = true
        end
    end
    
    if not flag then
        return flag, nil
    end
    
    return flag, all
end

return _M