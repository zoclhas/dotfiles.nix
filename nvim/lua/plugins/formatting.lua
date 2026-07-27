return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    local function get_formatter(biome_formats)
      return function()
        local biome_config = vim.fn.findfile("biome.json", ".;") ~= "" or vim.fn.findfile("biome.jsonc", ".;") ~= ""
        if biome_config then
          return biome_formats
        else
          return { "prettier" }
        end
      end
    end

    opts.formatters = opts.formatters or {}
    opts.formatters.prettier_markdown = {
      inherit = false,
      command = "prettier",
      args = { "--prose-wrap", "always", "--print-width", "80", "--stdin-filepath", "$FILENAME" },
      stdin = true,
    }

    opts.formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = get_formatter({ "biome", "biome-organize-imports" }),
      typescript = get_formatter({ "biome", "biome-organize-imports" }),
      javascriptreact = get_formatter({ "biome", "biome-organize-imports" }),
      typescriptreact = get_formatter({ "biome", "biome-organize-imports" }),
      vue = get_formatter({ "biome", "biome-organize-imports" }),
      css = get_formatter({ "biome", "biome-organize-imports" }),
      html = get_formatter({ "biome", "biome-organize-imports" }),
      json = get_formatter({ "biome", "biome-organize-imports" }),
      jsonc = get_formatter({ "biome", "biome-organize-imports" }),
      yaml = get_formatter({ "biome", "biome-organize-imports" }),
      markdown = { "prettier_markdown" },
      graphql = get_formatter({ "biome", "biome-organize-imports" }),
      c = { "clang_format" },
      cpp = { "clang_format" },
      sh = { "shfmt" },
      nix = { "nixfmt" },
    }
  end,
}
