vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.confirm = true
vim.o.number = true
vim.o.showmode = false
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.keymap.set("n", "<leader>mc", function()
	local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "gradlew runClient && exit"'
	os.execute(cmd)
end, { desc = "Run [M]inecraft [C]lient" })
vim.keymap.set("n", "<leader>md", function()
	local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "gradlew runData && exit"'
	os.execute(cmd)
end, { desc = "Run [M]inecraft [D]atagen" })
vim.keymap.set("n", "<leader>gb", function()
	local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "gradlew build && exit"'

	os.execute(cmd)
end, { desc = "[G]radle [B]uild" })
vim.keymap.set("n", "<leader>gr", function()
	local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "gradlew --refresh-dependencies && exit"'

	os.execute(cmd)
end, { desc = "[G]radle [R]efresh" })

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.java",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local filepath = vim.fn.expand("%:p")
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		if #lines > 1 or (#lines == 1 and lines[1] ~= "") then
			return
		end

		-- Parse filename parts
		local base_filename = vim.fn.expand("%:t") -- "MyClass.class.java"
		local parts = {}
		for part in string.gmatch(base_filename, "([^.]+)") do
			table.insert(parts, part)
		end

		if #parts ~= 3 or parts[3] ~= "java" then
			return
		end

		local name = parts[1]
		local kind = parts[2]

		-- PACKAGE DETECTION
		local cwd = vim.fn.getcwd()
		local relpath = filepath:sub(#cwd + 2) -- relative to CWD, skip leading slash or backslash
		relpath = relpath:gsub("[/\\]+", "/") -- normalize to forward slashes

		local src_root = "src/main/java"
		local package = ""

		local src_index = relpath:find(src_root, 1, true)
		if src_index then
			local package_path = relpath:sub(src_index + #src_root + 1)
			package_path = package_path:gsub("^[/\\]+", ""):gsub("/", "."):gsub("\\", ".")
			local last_dot = package_path:find("%.[^%.]+$") -- remove filename
			if last_dot then
				package_path = package_path:sub(1, last_dot - 1)
			end
			if #package_path > 0 then
				package = "package " .. package_path:gsub("." .. name .. "." .. kind, "") .. ";"
			end
		end

		-- HEADER
		local header = {}
		if #package > 0 then
			table.insert(header, package)
			table.insert(header, "")
		end

		-- BODY
		local body = {}

		if kind == "class" then
			body = {
				"public class " .. name .. " {",
				"",
				"	public " .. name .. "() {",
				"",
				"	}",
				"}",
			}
		elseif kind == "interface" then
			body = {
				"public interface " .. name .. " {",
				"    ",
				"}",
			}
		elseif kind == "enum" then
			body = {
				"public enum " .. name .. " {",
				"    VALUE1, VALUE2;",
				"    ",
				"}",
			}
		elseif kind == "record" then
			body = {
				"public record " .. name .. "(/* fields */) {",
				"    ",
				"}",
			}
		elseif kind == "abstract" then
			body = {
				"public abstract class " .. name .. " {",
				"    ",
				"}",
			}
		else
			print("Unknown kind: " .. kind)
			return
		end

		local final = vim.list_extend(header, body)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, final)
		vim.cmd("normal! G")
		-- ✅ AUTO-RENAME FILE AFTER TEMPLATE INSERTION
		local old_name = vim.fn.expand("%:t") -- "MyThing.class.java"
		local base_name = name .. "." .. kind .. ".java" -- same as above
		local new_name = name .. ".java" -- "MyThing.java"

		if old_name == base_name then
			local dir = vim.fn.expand("%:h") -- folder path
			local old_path = dir .. "/" .. old_name
			local new_path = dir .. "/" .. new_name

			local ok, err = os.rename(old_path, new_path)
			if ok then
				vim.api.nvim_buf_set_name(0, new_path)
			else
				print("Failed to rename file: " .. tostring(err))
			end
		end
	end,
})
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "Show [C]ode [A]ctions" })

local projectfile = vim.fn.getcwd() .. "/project.godot"
if vim.fn.filereadable(projectfile) == 1 then
	vim.fn.serverstart("127.0.0.1:6004")
end
local rustproject = vim.fn.getcwd() .. "/Cargo.toml"
if vim.fn.filereadable(rustproject) == 1 then
	vim.keymap.set("n", "<leader>rr", function()
		local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "cargo run && exit"'
		os.execute(cmd)
	end, { desc = "[R]ust [R]un" })
	vim.keymap.set("n", "<leader>rb", function()
		local cmd = 'wt -p "Developer Command Prompt for VS 2022" -d . cmd /k "cargo build --release && exit"'
		os.execute(cmd)
	end, { desc = "[R]ust [B]uild" })
end
