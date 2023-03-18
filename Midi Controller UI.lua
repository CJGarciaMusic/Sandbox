function plugindef()
    finaleplugin.RequireSelection = true
    finaleplugin.Author = "CJ Garcia, CF Pan"
    finaleplugin.Copyright = "2022 CJ Garcia, CF Pan"
    finaleplugin.Version = "0.1"
    finaleplugin.Date = "January 14, 2022"
    finaleplugin.CategoryTags = "Midi Tool UI"
    return "Midi Tool UI","Midi Tool UI","This is for Midi Tool UI"
end

--Helper function: Make validator "HasNum" so that only new controller Number is inserted into table (to avoid repeating)
--"tablename" and "number" are variables named for parameters ("parameter" is when used to define, and become argument when called)
local function HasNum(tablename, number)
--Next 2 lines mean that for every input variable v, if it is a number that's already in the table then stop
--"k" (key) and "v" (value) are stand-in variable that can be named
--The function is ended by return "true", which makes function stop
    for k, v in pairs(tablename) do
        if tablename[k][1] == number then
            return true
        end
    end
    return false
end

--Helper function: 2/9 if a number we're looking for exists in the table, then it will tell us index (i.e., order) of number in the table
local function NumIndex(tablename,number)
    for k, v in pairs(tablename) do
        if tablename[k][1] == number then
            return k
        end
    end
    return -1 --2/9 since index always start at 1, return of -1 will mean it's not in our table (rather than return "nil")
end

--Make function to address LoadRegion bug below (bug is that it loads the entire measure and NOT the highlighted region only)
local function isInRegion(midiExp)
    if ((midiExp.MeasurePos >= finenv.Region():GetStartMeasurePos()) and (midiExp.MeasurePos <= finenv.Region():GetEndMeasurePos())) then --if variable midiExp is >= start of measure positoin and <= end position, then show
        return true
    end
    return false
end

--2/23 this helper function is to give us all the values associated with a midi CC
local function GetValues(tablename, number)
    local ReturnString = "" --this is to output string
        for k, v in pairs(tablename) do
        if tablename[k][1] == number then
            for i, j in pairs(tablename[k][2]) do --2/23 [2] is going to layer in Example 2 of Feb 16 lesson notes
            ReturnString = ReturnString.. j.. ","
            end
        end
    end
    return ReturnString
end


--Make master (i.e., nested) table for final list of Midi contollers; following are all empty tables
local MidiControllers = {}
--Make table for values
local CatchValues = {}
--Make table for numbers
local CatchNumbs = {}




-- STOCK CODE: For all data to see similar to JW Lua print output, add to string below
local printString = ""

-- for noteentry in eachentrysaved(finenv.Region()) do
--     -- Add data to printString
--     -- Each piece of data should be on a new line with "\n"
--     printString = printString.."\n".."Note at position: "..noteentry.MeasurePos
-- end

local musicRegion = finenv.Region()
local startStaff = musicRegion:GetStartStaff()
local endStaff = musicRegion:GetEndStaff()
local startMeas = musicRegion:GetStartMeasure()
local endMeas = musicRegion:GetEndMeasure()
local startPos = musicRegion:GetStartMeasurePos()
local endPos = musicRegion:GetEndMeasurePos()
if endPos > 1000000 then
    local getTime = finale.FCMeasure()
    getTime:Load(endMeas)
    local newEndPos = getTime:GetTimeSignature()
    local beat = newEndPos:GetBeats()
    local beatDuration = newEndPos:GetBeatDuration()
    endPos = (beat * beatDuration)
end


--Data collection (midiexpressions is a variable name)
local midiexpressions = finale.FCMidiExpressions()
--Call method to load all Midi expressions in the selected region; feed it finenv to do so
midiexpressions:LoadAllForRegion(musicRegion) --*BUG: this actually selects entire measure regardless of highlighted selection
--Make "for loop" to go through all the elements
for midicc in each(midiexpressions) do
    if (isInRegion(midicc)) then --*BUG WORKAROUND: use function isInRegion created above and feed it cc
        --For if/then statement use method IsController to "validate" (i.e., so only controller CC Midi data is shown)
        --[A] Following line means: if the item is a CC (variable name "midicc"), then... (cont'd)
        if midicc:IsController() then

            -- Feeding HasNum data i.e., ControllerNumber; 2/23 next 2 lines means if HasNum is not midi controller already in our table then feed it to table
            if (HasNum(MidiControllers, midicc.ControllerNumber)==false) then
                table.insert( MidiControllers, {midicc.ControllerNumber, {}} ) --2/23 { } are big keys, while "midicc.ControllerNumber" is also a key
            end
        end
    end
end

--2/23 use this loop to populate empty table
for midicc in each(midiexpressions) do
    if (isInRegion(midicc)) then --*BUG WORKAROUND: use function isInRegion created above and feed it cc
        --For if/then statement use method IsController to "validate" (i.e., so only controller CC Midi data is shown)
        --[A] Following line means: if the item is a CC (variable name "midicc"), then... (cont'd)
        if midicc:IsController() then

            -- 2/23 find key number of the midi cc
            -- if (HasNum(MidiControllers, midicc.ControllerNumber)==false) then
            local CCkey = NumIndex(MidiControllers, midicc.ControllerNumber) -- 2/23 output key number of the midi CC
                table.insert( MidiControllers[CCkey][2], midicc.ControllerValue ) --2/23 analagous to Example 2 of Feb 16 lesson notes; "midicc.ControllerValue" 3rd layer getting at values
        end
    end
end


for k, v in pairs (MidiControllers) do --2/9 print string to de-bug code and will remove eventually
printString = printString..v[1].." : "..GetValues(MidiControllers,v[1]).."\n" --2/23 this is designating which big key, and [1] is the first value of that table v
end
-- This creates the Alert Dialog Box which presents whole string in dialog box (instead of print)
-- printString = MidiControllers[1][1]
-- finenv.UI():AlertInfo(printString, "Print Output") -- this prints out all the data being grabbed
--REMEMBER TO LATER ADD IF/THEN STATEMENT TO ALERT WHEN THERE'S NO MIDI DATA




--Building dialog box 2022-12-20
--Stock code to create variable "dialog" and call Class
local dialog = finale.FCCustomLuaWindow()

--Stock code to call Methods for buttons
dialog:CreateCancelButton()

--Stock code to call FC String to change title of dialog box
local dialogString = finale.FCString()
dialogString.LuaString = "Midi Tools"
dialog:SetTitle(dialogString)

--Swticher (aka Tab Group)
--Create variable and call Method under FFCustomLuaWindow Class
local tabGroup = dialog:CreateSwitcher(0,0)
--(1) Tab Page 1 (i.e., tab 0)
dialogString.LuaString = "Add New CC"
tabGroup:AddPage(dialogString)

--(2) Tab Page 2 (i.e., tab 1)
dialogString.LuaString = "Scale"
tabGroup:AddPage(dialogString)
--Create for loop to have dynamic static text; use the big table MidiControllers

local controllersTable = {}
local windowHeight = 25
-- for i = #MidiControllers, 1, -1 do
--     local k = i
--     local v = MidiControllers[i]
-- end
for k, v in pairs(MidiControllers) do
    local staticText = dialog:CreateStatic(0,(25*k))--the () is to avoid Y axis texts overlapping
    dialogString.LuaString = "CC: "..v[1] --"v" is from the For Loop variable v, and 1 means first item in table grouping (each group is CC, start value, end value)
    --Set the above to static text, use below
    staticText:SetText(dialogString)
    --To make sure this static text only appears in Tab Page 2 so call FCCtrlSwitcher Class's Method "AttachControl", which requires feeding in ( ) the control (in this case our static text) comma integer (in this case "1" to attach to Tab Page 2)
    tabGroup:AttachControl(staticText,1)
    --Make 1st editable text; i.e., start value
    local firstValue = dialog:CreateEdit(50,(25*k)) --use Method CreateEdit to have editable text field
    dialogString.LuaString = v[2][1] -- 3/3 [2] pulls out 2nd big key which is a full table and [1] pulls out 1st item only
    firstValue:SetText(dialogString)--this adds the text
    firstValue:SetWidth(40)--this Method sets width of dialog box
    firstValue:SetEnable(false) --3/3 this is to disable ability to edit first value shown in dialog box
    tabGroup:AttachControl(firstValue,1)--this attaches the text only to this page
    --Make 2nd editable text; i.e., end value
    local endValue = dialog:CreateEdit(100,(25*k)) --use Method CreateEdit to have editable text field
    dialogString.LuaString = v[2][#v[2]] -- 3/3 use # to get last value
    endValue:SetText(dialogString)
    endValue:SetWidth(40)--this Method sets width of dialog box
    endValue:SetEnable(false) --3/3 this is to disable ability to edit last value shown in dialog box
    tabGroup:AttachControl(endValue,1)
    --3/3 make check boxes for Scale tab (FCCCustomLuaWindow class already called above)
    local CheckBox = dialog:CreateCheckbox(150,(25*k)) --3/3 this creates the checkbox
    CheckBox:SetCheck(0) --3/3 this calls FCCtrlCheckbox class, and 0 will make checkbox blank
    tabGroup:AttachControl(CheckBox,1) -- 3/3 tab group "1" is the 2nd tab group (start ordering from 0) to attach checkboxes to 2nd
    table.insert(controllersTable, {CheckBox, firstValue, endValue, v[1]})
    windowHeight = windowHeight + (25 * k)
end

local applyScaleButton = dialog:CreateButton(0, windowHeight)
dialogString.LuaString = "Apply Scale"
tabGroup:AttachControl(applyScaleButton, 1)
applyScaleButton:SetText(dialogString)
applyScaleButton:SetWidth(80)
applyScaleButton:SetEnable(false)

local deleteButton = dialog:CreateButton(200, windowHeight)
dialogString.LuaString = "Delete"
tabGroup:AttachControl(deleteButton, 1)
deleteButton:SetText(dialogString)
deleteButton:SetWidth(80)
deleteButton:SetEnable(false)

function DeleteMidiDataInRegion(ccNum)
    for midicc in eachbackwards(midiexpressions) do
        if (isInRegion(midicc)) then
            if midicc:IsController() then
                if (midicc.ControllerNumber == ccNum) then
                    midicc:DeleteData()
                end
            end
        end
    end
end

function CreateNewMidi(ccNum, ccVal, measure, measurePos, staff)
    local newMidi = finale.FCMidiExpression()
    newMidi:SetUseController()
    newMidi:SetControllerNumber(ccNum)
    newMidi:SetControllerValue(ccVal)
    newMidi:SetMeasurePos(measurePos)
    local cell = finale.FCCell(measure, staff)
    newMidi:ConnectCell(cell)
    newMidi:SaveNew()
end

function ApplyScale(ccNum, firstNum, secondNum)
    local duration = musicRegion:CalcDuration()
    local difference = math.abs(firstNum - secondNum)
    local increment = duration / difference

    if (startMeas ~= endMeas) then
        finenv.UI():AlertInfo("Hey, sorry, you can only do single or partial measures at the moment... working on it", "Error :(")
        return
    end
    DeleteMidiDataInRegion(ccNum)
    local anotherString = ""
    for staff = startStaff, endStaff do
        if firstNum > secondNum then
            local counter = 0
            for i = firstNum, secondNum, -1 do
                CreateNewMidi(ccNum, i, startMeas, startPos + (counter * increment), staff)
                anotherString = anotherString.."pos: "..(startPos + (counter*increment)).." value: "..(i)
                counter = counter + 1
            end
        end
        if secondNum > firstNum then
            local counter = 0
            for i = firstNum, secondNum, 1 do
                CreateNewMidi(ccNum, i, startMeas, startPos + (counter * increment), staff)
                anotherString = anotherString.."pos: "..(startPos + (counter*increment)).." value: "..(i)
                counter = counter + 1
            end
        end
    end
end


function GetEnabledValues(actionType)
    for i = #controllersTable, 1, -1 do
        local controller = controllersTable[i]
        local checkbox = controller[1]
        local firstInput  = controller[2]
        local lastInput = controller[3]
        local ccNumber = controller[4]
        if (actionType == "Delete") then
            checkbox:SetEnable(false)
            firstInput:SetEnable(false)
            lastInput:SetEnable(false)
            DeleteMidiDataInRegion(ccNumber)
            table.remove(MidiControllers, i)
            table.remove(controllersTable, i)
            finenv.UI():AlertInfo("The removed data will be reflected here when you open this window again", "Removed CC "..ccNumber)
            break
        end
        if (actionType == "Apply") then
            if checkbox:GetCheck() == 1 then
                local newFirst = finale.FCString()
                newFirst.LuaString = ""
                newFirst.LuaString = firstInput:GetText(newFirst)

                local newLast = finale.FCString()
                newLast.LuaString = ""
                newLast.LuaString = lastInput:GetText(newLast)

                ApplyScale(ccNumber, tonumber(newFirst.LuaString), tonumber(newLast.LuaString))
                checkbox:SetCheck(0)
                firstInput:SetEnable(false)
                lastInput:SetEnable(false)
            end
        end
    end
end

local confirmationDialog = finale.FCCustomLuaWindow()
confirmationDialog:CreateCancelButton()
confirmationDialog:CreateOkButton()

local confirmString = finale.FCString()
confirmString.LuaString = "Delete Confirmation"
confirmationDialog:SetTitle(confirmString)

local confirmationBody = confirmationDialog:CreateStatic(0, 0)
confirmationBody:SetWidth(300)
confirmString.LuaString = "Are you sure you want to delete the selected midi data?"
confirmationBody:SetText(confirmString)

function EnableTextField(ctrl)
    local enableApply = false
    for key, controller in pairs(controllersTable) do
        local checkbox = controller[1]
        local firstInput  = controller[2]
        local lastInput = controller[3]
        if (ctrl:GetControlID() == checkbox:GetControlID()) then
            if (checkbox:GetCheck() == 1) then
                firstInput:SetEnable(true)
                lastInput:SetEnable(true)
            else
                firstInput:SetEnable(false)
                lastInput:SetEnable(false)
            end
        end
        if checkbox:GetCheck() == 1 then
            enableApply = true
        end
    end
    applyScaleButton:SetEnable(enableApply)
    deleteButton:SetEnable(enableApply)
    if (ctrl:GetControlID() == applyScaleButton:GetControlID() and applyScaleButton:GetEnable() == true) then
        GetEnabledValues("Apply")
    end
    if (ctrl:GetControlID() == deleteButton:GetControlID() and deleteButton:GetEnable() == true) then
        if confirmationDialog:ExecuteModal(nil) == 1 then
            GetEnabledValues("Delete")
        end
    end
end

--3/3 we want to condition certain functions to run only when dialog box open (because these functions only pertain to text fields, etc.)
dialog:RegisterHandleCommand(EnableTextField) --3/3 this means if EnableTextField will run only when dialog box is open as determined by method RegisterHandleCommand

--Stock code call Method to render dialog box - 2 lines: "if..." line and "end" (fill in middle)
if dialog:ExecuteModal(nil) == 1 then
    
end










