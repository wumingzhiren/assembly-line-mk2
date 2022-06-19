local deflate = require "deflate"
local nbt = require "nbt"
local item = {}

function item.readNbt(itemstack)
    if not itemstack.hasTag then
        error("Item has no NBT tag")
    end
    local out = ""
    deflate.gunzip({input = itemstack.tag,output = function(byte)out=out..string.char(byte)end,disable_crc = true})
    local result = nbt.decode(out)
    return result
end


return item