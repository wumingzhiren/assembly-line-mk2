local config = require("conf.config")
local cp = require("component")
local item_utils = require("util.item_utils")
local shell = require "shell"
local input = config.chestInput.proxy
local inputSide = config.chestInput.chestSourceSide
local db = cp.database
local args, _ = shell.parse(...)

local function getNilSlot()
    for i = 1, 81 do
        local data = db.get(i)
        if not data then
            return i
        end
    end
end

local _M = {}
function _M.default()
    local dbSlot = getNilSlot()
    if dbSlot then
        local _ = input.store(inputSide, 1, db.address, dbSlot)
        print("done")
    else
        error("no available db slot found")
    end
end

function _M.all()
    --may replace the original data
    local dbSlot = getNilSlot()
    local allStacks = input.getAllStacks(inputSide).getAll()
    for i, v in pairs(allStacks) do
        if v.name == nil then
            print("done")
            return
        end
        input.store(inputSide, i + 1, db.address, dbSlot)
        dbSlot = dbSlot + 1
    end
    print("done")
end

function _M.readAll()
    local msg = "slot:%d --> label:%s --> identity:%s"
    for i = 1, 81 do
        local data = db.get(i )
        if data then
            print(string.format(msg, i , data.label, item_utils.itemIdentity(data)))
        end
    end
end

function _M.clearAll()
    for i = 1, 81 do
        db.clear(i)
    end
    print("done")
end

local functionName;
if type(args) == "table" then
    functionName = args[1] or "default"
end

if _M[functionName] then
    _M[functionName]()
end

return _M