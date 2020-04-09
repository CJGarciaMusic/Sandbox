function plugindef()
    finaleplugin.ParameterTypes = [[String]]
    finaleplugin.ParameterDescriptions = [[What are your hopes, dreams, and darkest secrets?]]
    finaleplugin.ParameterInitValues = [[your text here, pls]]
    return "Paramter Test", "Paramter Test", "Testing for Parameters"
end

local my_message = "This is the default message"
local parameters = {...}

if parameters[1] then 
    my_message = parameters[1]
end

finenv.UI():AlertInfo(my_message, nil)