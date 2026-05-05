local data = require("ionic-cmp.data")

local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

local function is_template_file()
  local ft = vim.bo.filetype
  local name = vim.api.nvim_buf_get_name(0)

  return ft == "html" or ft == "angular" or name:match("%.html$")
end

local function get_line_before_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""

  return line:sub(1, col)
end

local function inside_opening_tag()
  local before = get_line_before_cursor()

  local last_lt = before:match("^.*()<")
  local last_gt = before:match("^.*()>")

  return last_lt and (not last_gt or last_lt > last_gt)
end

local function after_tag_start()
  local before = get_line_before_cursor()

  return before:match("<[%w%-]*$")
end

local function inside_ionic_tag()
  local before = get_line_before_cursor()
  local tag = before:match("<(ion%-%w[%w%-]*)[^<>]*$")

  return tag ~= nil
end

local function make_item(item, kind)
  return {
    label = item.label,
    kind = kind,
    detail = item.detail,
    documentation = {
      kind = "markdown",
      value = item.documentation or "",
    },
    insertText = item.insert_text,
    insertTextFormat = 2,
  }
end

function M:get_trigger_characters()
  return { "<", " ", "-", '"' }
end

function M:get_completions(_, callback)
  if not is_template_file() then
    callback({
      is_incomplete_forward = false,
      is_incomplete_backward = false,
      items = {},
    })
    return
  end

  local items = {}

  if after_tag_start() then
    for _, component in ipairs(data.components) do
      table.insert(items, make_item(component, 7))
    end
  elseif inside_opening_tag() and inside_ionic_tag() then
    for _, attribute in ipairs(data.attributes) do
      table.insert(items, make_item(attribute, 10))
    end
  end

  callback({
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
  })
end

return M
