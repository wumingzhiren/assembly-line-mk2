local _M = {}

function _M.split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end
--用于获取csv表
function _M.loadCsvFile(filePath) 
    -- 读取文件 需要替换为自己的读取接口
    local file,err = io.open(filePath)
    local data = file:read("*a")
    io.close(file)
    -- 按行划分
    local lineStr = split(data, '\n\r')

    --[[
        第一行是字段
    ]]
    local titles = split(lineStr[1], ",")
    local ID = 1
    local arrs = {}
    for i = 2, #lineStr, 1 do
        -- 一行中，每一列的内容
        local content = split(lineStr[i], ",")

        -- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title
        arrs[ID] = {}
        for j = 1, #titles, 1 do
            arrs[ID][titles[j]] = content[j]
        end

        ID = ID + 1
    end

    return arrs
end

return _M