local config = {
    chestInput = {},
    chestOutput = {},
    fluidInput = {},
    fluidInterface = {},
    chestOutputMode = true
}
local manager = require("manager")
local sides = require("sides")

config.chestInput.checkInterval = 3
--using this program to ctrl molten items
config.moltenCtrl = true
--me interface chest
config.chestInput.chestSourceSide = sides.west
config.chestInput.chestOutputSide = sides.east
--input bus chest
config.chestOutput.chestSourceSide = sides.down
config.chestOutput.chestOutputSide = sides.up
--molten output side
config.chestInput.moltenOutputSide = sides.north
--fluid source side
config.fluidSourceSide = sides.down
config.fluidOutputSide = sides.up
config.tankSourceSide = config.fluidSourceSide
--rs. side
config.redStoneSide = sides.east
--flash side
config.flashSide = sides.north
--transposer
config.chestInput.proxy = manager.proxy("${ci1}")
config.fluidInput[1] = manager.proxy("${fi1}")
config.fluidInput[2] = manager.proxy("${fi2}")
config.fluidInput[3] = manager.proxy("${fi3}")
config.fluidInput[4] = manager.proxy("${fi4}")
--ender chest
config.chestOutput[1] = manager.proxy("${co1}")
config.chestOutput[2] = manager.proxy("${co2}")
config.chestOutput[3] = manager.proxy("${co3}")
config.chestOutput[4] = manager.proxy("${co4}")
config.chestOutput[5] = manager.proxy("${co5}")
config.chestOutput[6] = manager.proxy("${co6}")
config.chestOutput[7] = manager.proxy("${co7}")
config.chestOutput[8] = manager.proxy("${co8}")
config.chestOutput[9] = manager.proxy("${co9}")
config.chestOutput[10] = manager.proxy("${co10}")
config.chestOutput[11] = manager.proxy("${co11}")
config.chestOutput[12] = manager.proxy("${co12}")
config.chestOutput[13] = manager.proxy("${co13}")
config.chestOutput[14] = manager.proxy("${co14}")
config.chestOutput[15] = manager.proxy("${co15}")
config.chestOutput[16] = manager.proxy("${co16}")
--me fluid interfaces
config.fluidInterface[1] = manager.proxy("${fif1}")
config.fluidInterface[2]= manager.proxy("${fif2}")
config.fluidInterface[3] = manager.proxy("${fif3}")
config.fluidInterface[4] = manager.proxy("${fif4}")

return config