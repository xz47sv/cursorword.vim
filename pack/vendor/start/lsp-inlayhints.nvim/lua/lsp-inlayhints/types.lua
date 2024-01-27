---@class lsp_position
---@field public line integer @Line position in a document (zero-based).
-- Character offset on a line in a document (zero-based). The meaning of this
-- offset is determined by the negotiated `PositionEncodingKind`.
--
-- If the character value is greater than the line length it defaults back
-- to the line length.
---@field public character integer

---@class line_hint_map
---@field label string
---@field kind integer
---@field position lsp_position
