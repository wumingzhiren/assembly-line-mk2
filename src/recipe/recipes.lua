local _M = {}
local R = {}
local ITEM = "item"
local MOLTEN = "molten"
local FLUID = "fluid"
local libItem = require("util.libItem")

local config = require("conf.config")
local moltenCtrl = config.moltenCtrl
local flashTable = require("component").inventory_controller.getAllStacks(config.flashSide).getAll()
local utils = require("util.Utils")


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
            R[i+1].items[flashTable[i].inputItems.n + j].cname = libItem.readNbt(flashTable[i])._value["f"..tostring(j-1)]._value.FluidName._value
        end
        
        R[i+1].nickname = flashTable[i].output
        
    end--flash读取结束
    --开始进行流体数据转换
    
    --读取流体及流体容器数据
    local AllFluidContainerNameTable = utils.loadCsvFile("./conf/fluidcontainer.csv")
    
    --建立流体id空表
    local label2Fluid = {}
    
    for i = 1,#R do
        for j = 1,#R[i].items do
            if R[i].items[j].type == FLUID and label2Fluid[R[i].items[j].cname] == nil then
                label2Fluid[R[i].items[j].cname] = {}
            end
        end
    end
    --建立流体id和流体容器对应关系
    
    for k,v in pairs(label2Fluid) do
        for k1,v1 in pairs(AllFluidContainerNameTable) do
            if k == v1.Fluid and v1["Empty Container Item"] == "IC2:itemCellEmpty" then
               v.container = string.sub(v1["Filled Container"],3)
               v.containerItem = v1["Filled Container Item"]
               break
            end
        end
    end
    --建立流体容器和物品对应关系
    for k,v in pairs(label2Fluid) do
        print(k,v.container)
        v.type = FLUID
        local tmp = utils.split(v.container,'@')
        v.itemId = tmp[2]
        if moltenCtrl and string.sub(k,0,7) == "molten." then
            v.type = MOLTEN
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
                v1[1] = label2Fluid[v1.cname].containerItem.."."..label2Fluid[v1.cname].itemId
                if label2Fluid[v1.cname].type == MOLTEN then
                    v1.type = MOLTEN
                    if v1.amount < 144 then
                        v1[1] = label2Fluid[v1.cname].itemPrefix..".26"..label2Fluid[v1.cname].itemId
                        v1.amount = v1.amount / 18
                        v1.times = 18
                    else
                        if label2Fluid[v1.cname].itemPrefix == "gregtech:gt.metaitem.01" then
                            v1[1] = label2Fluid[v1.cname].itemPrefix..".11"..label2Fluid[v1.cname].itemId
                        else
                            v1[1] = label2Fluid[v1.cname].itemPrefix.."."..label2Fluid[v1.cname].itemId
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