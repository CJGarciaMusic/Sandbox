function plugindef()
    finaleplugin.RequireSelection = false
    finaleplugin.Author = "CJ Garcia"
    finaleplugin.Copyright = "© 2020 CJ Garcia Music"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "6/15/2020"
    finaleplugin.CategoryTags = "Note"
    return "Lua Repository", "Lua Repository", "A list of all current public Lua scripts."
end

local tmp_dir = "/tmp/"

if os.execute("cd "..tmp_dir.."lua_test.html") == true then
    os.execute("cd "..tmp_dir.."lua_test && curl https://github.com/Nick-Mazuk/jw-lua-scripts --output lua_list.html")
else
    os.execute("cd "..tmp_dir.." && curl https://github.com/Nick-Mazuk/jw-lua-scripts --output lua_list.html")
end

function titlecase(str)
    local buf = {}
    local in_word = false
    for i = 1, #str do
        local c = string.sub(str, i, i)
        if in_word then
            table.insert(buf, string.lower(c))
            if (string.find(c, '%s')) or (string.find(c, '%.')) then
                in_word = false
            end
        else
            table.insert(buf, string.upper(c))
            if (string.find(c, '%('))  then
                in_word = false
            else
                in_word = true
            end
        end
    end
    return table.concat(buf)
end

local current_scripts = {}
local download_links = {}
local current_file = tmp_dir.."/lua_list.html"

for line in io.lines (current_file) do
    if string.find(line, "title=\".*%.lua\"") and (string.find(line, ".lua\" id=\""))then
        local first_index = string.find(line, "title=\".*%.lua\"")
        local last_index = string.find(line, ".lua\" id=\"")
        local file_name = (string.sub(line, first_index + 7, last_index - 1))
        local display_name = titlecase(string.gsub(file_name, "_", " "))
        local download_link = "https://github.com/Nick-Mazuk/jw-lua-scripts/blob/master/"..file_name..".lua"
        table.insert(current_scripts, display_name)
        table.insert(download_links, download_link)
    end
end 

local str = finale.FCString()
 
str.LuaString = "Download Lua Script"
local dialog = finale.FCCustomWindow()
dialog:SetTitle(str)

local script_list = dialog:CreateListBox(0, 0)
script_list:SetWidth(244)


for key, value in pairs(current_scripts) do
    str.LuaString = value
    script_list:AddString(str)
end

dialog:CreateOkButton()
dialog:CreateCancelButton()
 
if dialog:ExecuteModal(nil) == 1 then
    local link_index = script_list:GetSelectedItem() + 1
    os.execute("open "..download_links[link_index])
end