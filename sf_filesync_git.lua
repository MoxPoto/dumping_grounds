-- Syncs the currently open starfall file with filesystem changes
-- sometimes, a bug occurs when you switch to a Generic new tab in the SF editor, not always though

local PRINT_EACH_CHANGE = false

local function debugPrint(msg)
    chat.AddText(Color(0, 0, 0), "[", Color(0, 255, 0), "SF Filesync", Color(0, 0, 0), "]", Color(255, 255, 255), ": ", msg)
end

local wireEditor = SF.Editor.editor 
local lastTime = 0
local lastFile = ""
local PREFIX = "starfall/"

if wireEditor and SF.Editor then 
    lastFile = SF.Editor.getOpenFile()
    lastTime = file.Time(PREFIX .. lastFile, "DATA")

    hook.Add("Think", "sffilesync_watch", function()
        if not file.Exists(PREFIX .. lastFile, "DATA") then return end 
        
        local newTime = file.Time(PREFIX .. lastFile, "DATA")

        if newTime ~= lastTime then 
            if PRINT_EACH_CHANGE then
                debugPrint("Detected new code! Applied changes")
            end

            wireEditor:SetCode(file.Read(PREFIX .. lastFile, "DATA"))
        end

        lastTime = newTime
        lastFile = SF.Editor.getOpenFile()
    end)
end