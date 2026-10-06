return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      picker = "snacks",
      lsp = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>na", "<cmd>Dotnet add package<cr>", desc = "NuGet: Add Package" },
      { "<leader>nr", "<cmd>Dotnet remove package<cr>", desc = "NuGet: Remove Package" },
      { "<leader>no", "<cmd>Dotnet outdated<cr>", desc = "NuGet: Outdated Packages" },
      { "<leader>nR", "<cmd>Dotnet restore<cr>", desc = "NuGet: Restore Packages" },
    },
  },
}
