local configuration = {
    signs                        = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
        follow_files = true
    },
    attach_to_untracked          = true,
    current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil, -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    on_attach                    = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between hunks
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = "Next git hunk" })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true, desc = "Previous git hunk" })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage hunk" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset hunk" })
        map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Stage hunk" })
        map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
            { desc = "Reset hunk" })
        map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame line (full)" })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "Toggle line blame" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this ~" })
        map('n', '<leader>td', gs.toggle_deleted, { desc = "Toggle deleted" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
    end
}

require('gitsigns').setup(configuration)

-- Global keymaps for navigating between changed files
local function get_changed_files()
    local result = vim.fn.systemlist('git diff --name-only HEAD')
    if vim.v.shell_error ~= 0 then
        result = vim.fn.systemlist('git ls-files --modified --others --exclude-standard')
    end
    return result
end

local function navigate_to_file(direction)
    local changed_files = get_changed_files()
    if #changed_files == 0 then
        vim.notify("No changed files", vim.log.levels.INFO)
        return
    end

    local current_file = vim.fn.expand('%:.')
    local current_idx = nil

    for i, file in ipairs(changed_files) do
        if file == current_file then
            current_idx = i
            break
        end
    end

    local next_idx
    if not current_idx then
        next_idx = 1
    else
        if direction == "next" then
            next_idx = (current_idx % #changed_files) + 1
        else
            next_idx = current_idx - 1
            if next_idx < 1 then
                next_idx = #changed_files
            end
        end
    end

    vim.cmd('edit ' .. changed_files[next_idx])
end

vim.keymap.set('n', ']f', function() navigate_to_file("next") end, { desc = "Next changed file" })
vim.keymap.set('n', '[f', function() navigate_to_file("prev") end, { desc = "Previous changed file" })
