local _M = {}
local item_utils = require("util.item_utils")
local chipDatabase = require("recipe.chipDatabase")

function _M.match(r,sourceItems)
    if sourceItems == nil or not type(sourceItems) == "table" then
        return nil
    end

    local source = {}
    local toIdentity = {}
    for _, v in pairs(sourceItems) do
        local label = v.label
        local name = v.name
        if label then
            local identityLabel = label            
            local identityName = item_utils.itemIdentity(v)
            local identityChip = chipDatabase[identityName]
            local var0 = source[identityLabel]
            if var0 then
                if identityChip then
                    source[identityChip] = var0 + v.size
                    toIdentity[identityChip] = identityName
                else
                    source[identityLabel] = var0 + v.size
                    source[identityName] = var0 + v.size
                    toIdentity[identityLabel] = identityName
                end                   
            else
                if identityChip then
                    source[identityChip] = v.size
                    toIdentity[identityChip] = identityName
                else
                    source[identityLabel] = v.size
                    source[identityName] = v.size
                    toIdentity[identityLabel] = identityName
                end              
            end
        end
    end
    
    for k, v in pairs(r) do
        local flag = true
        for __, item in pairs(v.items) do
            local sourceAmount = 0
            if source[chipDatabase[item.label]] then
                sourceAmount = source[chipDatabase[item.label]]
                item[1] = toIdentity[chipDatabase[item.label]]
            elseif source[item.label] then
                sourceAmount = source[item.label]
                item[1] = toIdentity[item.label]
            elseif source[item[1]] then
                sourceAmount = source[item[1]]
            end
            if item.type ~= "fluid" and (not sourceAmount or item.amount > sourceAmount) then
                flag = false
                break
            end
        end

        if flag then
            print("matched recipe:" .. v.nickname)
            return v
        end
    end
end

return _M