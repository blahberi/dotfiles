return {
    'chrisgrieser/nvim-early-retirement',
    config = function()
        require("early-retirement").setup({
            retirementAgeMins = 20, -- Close buffers after 20 minutes of inactivity
            ignoreUnsavedChangesBufs = true, -- Never close buffers with unsaved changes
            minimumBufferNum = 2, -- Keep at least 2 buffers open
            ignoreAltFile = true, -- Don't close alternate file (the # file)
            ignoreVisibleBufs = true, -- Don't close visible buffers
            notificationOnAutoClose = false, -- Set to true if you want notifications
        })
    end
}
