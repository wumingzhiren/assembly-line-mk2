local Main = {}
local event = require("event")
local chestReader = require("chest.reader")
local recipeMatcher = require("recipe.matcher")
local progress = require("recipe.Progress")
local recipes=require("recipe.recipes")
local computer = require("computer")
local config = require("conf.config")
local rsSide = config.redStoneSide
local rs = require("component").redstone
processing = false
allRecipe = nil

function Main.start()
    local interval = config.chestInput.checkInterval or 2
    local timer = event.timer(interval, Main.loop, math.huge)
    allRecipe = recipes.getRecipes()
    print("started!")
    while true do
        local id, _, x, y = event.pullMultiple("interrupted")
        if id == "interrupted" then
            print("interrupted cancel timer")
            event.cancel(timer)
            break
        end
    end
end

function Main.loop()
    if processing or rs.getInput(rsSide) > 0 then
        print("processing item...")
        return
    end
    local hasItem, all = chestReader.hasItem();
    if hasItem then
        local recipe = recipeMatcher.match(allRecipe,all)
        if not recipe then
            --print(computer.uptime() .. "no recipe match")
            return
        end
        local pg = progress:new(recipe)
        processing = true
        pg:start()
        processing = false
        print("processing stop")
    end
end


Main.start()
