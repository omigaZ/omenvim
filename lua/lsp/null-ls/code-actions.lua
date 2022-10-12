local M = {}

local null_ls_utils = require("lsp.null-ls.utils")

M["go"] = {
    method = require("null-ls").methods.CODE_ACTION,
    filetypes = { "go" },
    generator = {
        fn = function(context)
            return {
                {
                    title = "Import Packages",
                    action = function()
                        local get_pkgs = function()
                            local results = {}
                            local list_pkg = io.popen("gopkgs"):read("*all")
                            for line in list_pkg:gmatch("[^\n\r]+") do
                                table.insert(results, line)
                            end
                            return results
                        end
                        local import_position = -1
                        local pkg_position = -1
                        for index, value in ipairs(context["content"]) do
                            local find = string.find(value, "import")
                            if find then
                                import_position = index
                                break
                            end
                            if pkg_position == -1 then
                                local find_pkg = string.find(value, "package")
                                if find_pkg then
                                    pkg_position = index
                                end
                            end
                        end
                        local postion = import_position
                        local no_import = false
                        if postion == -1 then
                            no_import = true
                            postion = pkg_position
                        end
                        vim.ui.select(get_pkgs(), { prompt = "Import Packages" }, function(choice)
                            if not choice then
                                return
                            end
                            vim.ui.input({ prompt = "Alias PkgName" }, function(input)
                                local newline = nil
                                if input then
                                    newline = "\t" .. input .. "\"" .. choice .. "\""
                                else
                                    newline = "\t" .. "\"" .. choice .. "\""
                                end
                                if not no_import then
                                    vim.api.nvim_buf_set_lines(0, postion, postion, false, { newline })
                                else
                                    vim.api.nvim_buf_set_lines(0, postion, postion, false, { "import(", newline, ")" })
                                end
                                vim.lsp.buf.format({ async = true })
                            end)
                        end)
                    end
                },
                {
                    title = "Vendor",
                    action = function()
                        null_ls_utils.shell_command_toggle_wrapper("go mod vendor")
                    end
                },
                {
                    title = "GenTest",
                    action = function()
                        vim.ui.select(require("lsp.null-ls.utils").get_current_functions(),
                            { prompt = "Select Function To Generate Test" }, function(choice)
                            if not choice then
                                return
                            end
                            local current_file = vim.api.nvim_buf_get_name(0)
                            local list_pkg
                            if choice == "ALL  - for all functions" then
                                list_pkg = io.popen("gotests -all -w " .. current_file):read("*all")
                            else
                                list_pkg = io.popen("gotests -only " .. choice .. " -w " .. current_file):read("*all")
                            end
                            for line in list_pkg:gmatch("[^\n\r]+") do
                                if string.find(line, "No tests generated") then
                                    local go_test_file = string.gsub(current_file, "(%w+).go$", "%1_test.go")
                                    require("utils.notify").notify(line, "warn", "GenTest")
                                elseif string.find(line, "Generated Test") then
                                    local go_test_file = string.gsub(current_file, "(%w+).go$", "%1_test.go")
                                    vim.cmd("vsplit " .. go_test_file)
                                    require("utils.notify").notify(line, "info", "GenTest")
                                else
                                    require("utils.notify").notify(line, "error", "GenTest")
                                end
                            end
                        end)
                    end
                },
            }
        end
    }
}


M["rust"] = {
    method = require("null-ls").methods.CODE_ACTION,
    filetypes = { "rust" },
    generator = {
        fn = function(_)
            return {
                {
                    title = "Cargo Check",
                    action = function()
                        null_ls_utils.shell_command_toggle_wrapper("cargo check")
                    end
                },
                {
                    title = "Cargo Build",
                    action = function()
                        null_ls_utils.shell_command_toggle_wrapper("cargo build")
                    end
                },
                {
                    title = "Cargo Run",
                    action = function()
                        null_ls_utils.shell_command_toggle_wrapper("cargo run")
                    end
                }
            }
        end
    }
}

return M
