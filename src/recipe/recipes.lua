local _M = {}
local R = {}
local ITEM = "item"
local MOLTEN = "molten"
local FLUID = "fluid"

local config = require("conf.config")
local flashTable = require("component").inventory_controller.getAllStacks(config.flashSide).getAll()
local utils = require("util.Utils")

function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

function _M.getRecipes()
    
    local len = #flashTable
    for i = 0,len do
        R[i+1] = {}
        R[i+1].items = {}
        for j = 1,flashTable[i].inputItems.n do
            R[i+1].items[j] = {}
            R[i+1].items[j].label = flashTable[i].inputItems[j][1]
            R[i+1].items[j].amount = flashTable[i].inputItems[j][2]
            R[i+1].items[j].type = ITEM
        end
        
        for j = 1,flashTable[i].inputFluids.n do
            R[i+1].items[flashTable[i].inputItems.n + j] = {}
            R[i+1].items[flashTable[i].inputItems.n + j].label = flashTable[i].inputFluids[j][1]
            R[i+1].items[flashTable[i].inputItems.n + j].amount = flashTable[i].inputFluids[j][2]
            R[i+1].items[flashTable[i].inputItems.n + j].type = FLUID
        end
        
        R[i+1].nickname = flashTable[i].output
        
    end--flash读取结束
    --开始进行流体数据转换
    
    --读取流体及流体容器数据
    local AllFluidNameTable = utils.loadCsvFile("./conf/fluid.csv") 
    local AllFluidContainerNameTable = utils.loadCsvFile("./conf/fluidcontainer.csv") 
    
    --建立流体label和id对应关系
    local label2Fluid = {}
    
    for i = 1,#R do
        for j = 1,#R[i].items do
            if R[i].items[j].type == FLUID and label2Fluid[R[i].items[j].label] == nil then
                label2Fluid[R[i].items[j].label] = {}
                local len2 = #AllFluidNameTable
                for k = 1,len2 do
                    if R[i].items[j].label == AllFluidNameTable[k]["Localized Name"] then
                        label2Fluid[R[i].items[j].label].name = AllFluidNameTable[k].Name
                    end
                end
            end
        end
    end
    --建立流体id和流体容器对应关系
    
    for k,v in pairs(label2Fluid) do
        for k1,v1 in pairs(AllFluidContainerNameTable) do
            if v.name == v1.Fluid and v1["Empty Container Item"] == "IC2:itemCellEmpty" then
               label2Fluid[k].container = string.sub(v1["Filled Container"],3)
               label2Fluid[k].containerItem = v1["Filled Container Item"]
               break
            end
        end
    end
    --建立流体容器和物品对应关系
    for k,v in pairs(label2Fluid) do
        v.type = FLUID
        if string.sub(v.name,0,7) == "molten." then
            v.type = MOLTEN
            local tmp = split(v.container,'@')
            v.itemId = tmp[2]
            if v.containerItem == "gregtech:gt.metaitem.99" then
                v.itemPrefix = "gregtech:gt.metaitem.01"
            elseif v.containerItem == "bartworks:gt.bwMetaGeneratedcellMolten" then
                v.itemPrefix = "bartworks:gt.bwMetaGeneratedingot"
            elseif string.sub(v.containerItem,0,18) == "miscutils:itemCell" then
                v.itemPrefix = "miscutils:itemIngot"..string.sub(v.containerItem,19)
            end
        end
    end
    
    --将R中熔融流体转化为对应物品
    
    for k,v in pairs (R) do
        for k1,v1 in pairs (v.items) do
            if v1.type == FLUID then
                v1[1] = string.gsub(label2Fluid[v1.label].container,'@','.')
                v1.cname = label2Fluid[v1.label].name
                if label2Fluid[v1.label].type == MOLTEN then
                    v1.type = MOLTEN
                    if v1.amount == 36 then
                        v1[1] = label2Fluid[v1.label].itemPrefix..".26"..label2Fluid[v1.label].itemId
                        v1.amount = 2
                        v1.times = 18
                    elseif v1.amount == 72 then
                        v1[1] = label2Fluid[v1.label].itemPrefix..".23"..label2Fluid[v1.label].itemId
                        v1.amount = 1
                        v1.times = 72
                    else
                        if label2Fluid[v1.label].itemPrefix == "gregtech:gt.metaitem.01" then
                            v1[1] = label2Fluid[v1.label].itemPrefix..".11"..label2Fluid[v1.label].itemId
                        else
                            v1[1] = label2Fluid[v1.label].itemPrefix.."."..label2Fluid[v1.label].itemId
                        end
                        v1.amount = v1.amount / 144
                        v1.times = 144
                    end
                end
            end
        end
    end
    
    return R
end

return _M