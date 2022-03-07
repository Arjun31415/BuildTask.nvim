local function hello() print("Testing31415") end
local open = io.open
function split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end
local function read_file(path)
    local file = open(path, "rb")
    if not file then return nil end
    local contents = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return contents
end
local function read_json_file(path)
    local json_string = read_file(path)
    -- print(json_string)
    local json_content = vim.fn.json_decode(json_string)
    return json_content
end

-- print( interp("${name} is ${value}", {name = "foo", value = "bar"}) )
function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end
return {
    hello = hello,
    read_json_file = read_json_file,
    read_file = read_file,
    F = interp,
    split = split
}
