local utils = require("buildtask.utils")
local pluginName = "BuildTask.nvim"
-- python F string like functionality but with javascript syntax
local F = utils.F
-- If notify is availabe then use it
if (require("notify")) then vim.notify = require("notify") end
-- the tasks found in the task.json file
local tasks = nil
local default_shell = "$SHELL"
local default_task_file = "task.json"
local function parseTask()
    local fileName = vim.fn.getcwd() .. "/" .. default_task_file
    local fileContents = utils.read_json_file(fileName)
    -- vim.pretty_print(fileContents)
    if (fileContents == vim.NIL or fileContents == nil) then
        vim.notify("File  '" .. fileName .. "' not found", "error",
                   {title = pluginName, timeout = 2000})
        return 1
    end
    tasks = fileContents["tasks"]
    if (tasks == nil) then
        vim.notify("Tasks not found check task file \n " .. fileName, "error",
                   {title = pluginName, timeout = 2000})
        return 1
    end
    vim.notify("Tasks found successfully in \n" .. fileName, "success",
               {title = pluginName, timeout = 2000})
    return 0
end
local function runDefaultTask(file_name, shell)
    -- if task was nil then run parseTask() once
    local is_error = 0
    local default_task = nil
    if tasks == nil then is_error = parseTask() end
    if is_error == 1 then
        print("Error getting tasks")
        return 1
    end
    -- there is no error now
    -- vim.pretty_print(tasks)
    for idx, task in pairs(tasks) do
        if (task.group.isDefault) then
            vim.pretty_print(task)
            default_task = task
            break
        end
    end
    local command_args = ""
    ---@diagnostic disable-next-line: unused-local
    for idx, args in pairs(default_task["args"]) do
        -- print(idx)
        command_args = command_args .. args .. " "
    end
    local pos = 0
    local target = string.byte(".")
    for i = #file_name, 1, -1 do
        if (file_name:byte(i) == target) then pos = i end
    end
    pos = pos - 1
    -- print("pos: " .. pos)
    local substituted_command = (F(command_args, {
        file = vim.fn.getcwd() .. "/" .. file_name,
        fileDirname = vim.fn.getcwd(),
        fileBasenameNoExtension = string.sub(file_name, 1, pos)
    }))
    -- print(default_task.command .. " " .. substituted_command)
    vim.api.nvim_command('botright split new') -- split a new window
    vim.api.nvim_win_set_height(0, 30) -- set the window height
    -- local win_handle = vim.api.nvim_tabpage_get_win(0) -- get the window handler
    local buf_handle = vim.api.nvim_win_get_buf(0) -- get the buffer handler
    local jobID = vim.api.nvim_call_function("termopen", {shell})
    -- vim.api.nvim_buf_set_name(buf_handle, "Build")
    vim.api.nvim_buf_set_option(buf_handle, 'modifiable', true)
    vim.api.nvim_chan_send(jobID, default_task.command .. " " ..
                               substituted_command .. "\n")
    -- vim.api.nvim_buf_set_lines(buf_handle, 0, 0, true, {"ls"})

end
local function setup(config)
    vim.api.nvim_add_user_command("Hello", utils.hello, {})
    vim.api.nvim_add_user_command("BtBuildDefault", function()
        runDefaultTask(vim.fn.expand('%'), default_shell)
    end, {})

    if (config == nil or config == vim.NIL) then
        print("Using default config")
        return 1
    end
    if (config["default_shell"] ~= nil) then
        default_shell = config["default_shell"]
    end
    if (config["default_task_file"] ~= nil) then
        default_task_file = config["default_task_file"]
    end
    -- vim.api.nvim_add_user_command("Hello", utils.hello, {})
    -- vim.api.nvim_add_user_command("BtBuildDefault", function()
    --     runDefaultTask(vim.fn.expand('%'), default_shell)
    -- end, {})

end
return {setup = setup}
