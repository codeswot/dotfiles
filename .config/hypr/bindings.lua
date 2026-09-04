-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.
--
-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- ============================================================================
-- macOS Style Keybindings Configuration (SUPER = Command ⌘)
-- ============================================================================

-- Helper: inject synthetic key chord with down/up timer for reliability
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

-- Helper: detect if active window is a terminal (matches Omarchy's terminal tag)
local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

-- Helper: route shortcuts between GUI apps and terminals.
-- In terminals, dangerous chords (like Ctrl+C, Ctrl+Z, Ctrl+S) are prevented or
-- routed to safe terminal equivalents to protect shell state.
local function mac_shortcut(default_mods, default_key, terminal_mods, terminal_key)
  return function()
    if active_window_is_terminal() then
      if terminal_mods and terminal_key then
        send_shortcut_once(terminal_mods, terminal_key)()
      end
    else
      send_shortcut_once(default_mods, default_key)()
    end
  end
end

-- Helper: macOS Cmd+Backspace deletes from cursor to start of line
local function mac_delete_to_start()
  return function()
    if active_window_is_terminal() then
      send_shortcut_once("CTRL", "U")()
    else
      hl.dispatch(hl.dsp.send_key_state({ mods = "SHIFT", key = "Home", state = "down" }))
      hl.timer(function()
        hl.dispatch(hl.dsp.send_key_state({ mods = "SHIFT", key = "Home", state = "up" }))
        hl.timer(function()
          hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "BackSpace", state = "down" }))
          hl.timer(function()
            hl.dispatch(hl.dsp.send_key_state({ mods = "", key = "BackSpace", state = "up" }))
          end, { timeout = 25, type = "oneshot" })
        end, { timeout = 25, type = "oneshot" })
      end, { timeout = 25, type = "oneshot" })
    end
  end
end

-- ============================================================================
-- 1. Unbind Conflicting Omarchy Defaults
-- ============================================================================

-- SUPER+S was: Toggle scratchpad
hl.unbind("SUPER + S")

-- SUPER+F was: Full screen
hl.unbind("SUPER + F")

-- SUPER+CTRL+F was: Tiled full screen
hl.unbind("SUPER + CTRL + F")

-- SUPER+T was: Toggle window floating/tiling
hl.unbind("SUPER + T")

-- SUPER+W was: Close window
hl.unbind("SUPER + W")

-- SUPER+L was: Toggle workspace layout
hl.unbind("SUPER + L")

-- SUPER+P was: Pseudo window
hl.unbind("SUPER + P")

-- SUPER+O was: Pop window out (float & pin)
hl.unbind("SUPER + O")

-- SUPER+K was: Keybindings
hl.unbind("SUPER + K")

-- SUPER+G was: Toggle window grouping
hl.unbind("SUPER + G")

-- SUPER+BACKSPACE was: Toggle window transparency
hl.unbind("SUPER + BACKSPACE")

-- SUPER+code:20 (Minus) and SUPER+code:21 (Equal) were: Expand/Shrink window left
hl.unbind("SUPER + code:20")
hl.unbind("SUPER + code:21")

-- SUPER+code:19 (0) was: Switch to workspace 10
hl.unbind("SUPER + code:19")

-- SUPER+SLASH was: Monitor scaling up
hl.unbind("SUPER + SLASH")

-- SUPER+TAB and SUPER+SHIFT+TAB were: Next/Previous workspace
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")

-- SUPER+SHIFT+S was: Google Maps webapp
hl.unbind("SUPER + SHIFT + S")

-- Arrow key conflicts in tiling.lua (default window focus)
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")

-- Shift + Arrow key conflicts in tiling.lua (default window swap)
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")

-- Grouped window focus conflicts in tiling.lua
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")

-- ============================================================================
-- 2. Relocated Omarchy Features (Preserving Functionality)
-- ============================================================================

-- Scratchpad toggle relocated to SUPER+GRAVE and SUPER+ALT+S
o.bind("SUPER + grave", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))

-- Fullscreen relocated to macOS standard: Cmd+Ctrl+F (SUPER+CTRL+F)
o.bind("SUPER + CTRL + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Floating window toggle relocated to SUPER+ALT+T
o.bind("SUPER + ALT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- Workspace layout toggle relocated to SUPER+ALT+L
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Pseudo window relocated to SUPER+ALT+P
o.bind("SUPER + ALT + P", "Pseudo window", hl.dsp.window.pseudo())

-- Pop window out relocated to SUPER+ALT+O
o.bind("SUPER + ALT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")

-- Keybindings menu relocated to SUPER+SHIFT+K
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")

-- Window grouping toggle relocated to SUPER+ALT+G
o.bind("SUPER + ALT + G", "Toggle window grouping", hl.dsp.group.toggle())

-- Window transparency toggle relocated to SUPER+ALT+BACKSPACE
o.bind("SUPER + ALT + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")

-- Workspace 10 relocated to SUPER+ALT+0
o.bind("SUPER + ALT + code:19", "Switch to workspace 10", hl.dsp.focus({ workspace = "10" }))

-- Directional window focus relocated to SUPER+CTRL+Arrows
o.bind("SUPER + CTRL + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + CTRL + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + CTRL + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + CTRL + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))

-- Directional window swap relocated to SUPER+CTRL+SHIFT+Arrows
o.bind("SUPER + CTRL + SHIFT + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + CTRL + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + CTRL + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + CTRL + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

-- ============================================================================
-- 3. macOS App & Window Control (Cmd = SUPER)
-- ============================================================================

-- Cmd+Q: Quit application / close window
o.bind("SUPER + Q", "Quit application", hl.dsp.window.close())

-- Cmd+W: Close tab in tabbed apps; Cmd+Shift+W closes window
o.bind("SUPER + W", "Close tab", mac_shortcut("CTRL", "W", "CTRL + SHIFT", "W"))
o.bind("SUPER + SHIFT + W", "Close window", hl.dsp.window.close())

-- Cmd+T: New tab; Cmd+Shift+T: Reopen closed tab
o.bind("SUPER + T", "New tab", mac_shortcut("CTRL", "T", "CTRL + SHIFT", "T"))
o.bind("SUPER + SHIFT + T", "Reopen closed tab", mac_shortcut("CTRL + SHIFT", "T"))

-- Cmd+N: New window; Cmd+Shift+N: New incognito/private window
o.bind("SUPER + N", "New window", mac_shortcut("CTRL", "N", "CTRL + SHIFT", "N"))
o.bind("SUPER + SHIFT + N", "New private window", mac_shortcut("CTRL + SHIFT", "N"))

-- Cmd+Tab / Cmd+Shift+Tab: App / window switcher (cycles windows)
o.bind("SUPER + TAB", "Focus next window", hl.dsp.window.cycle_next())
o.bind("SUPER + SHIFT + TAB", "Focus previous window", hl.dsp.window.cycle_next({ next = false }))

-- ============================================================================
-- 4. macOS Web & Content Navigation (Cmd = SUPER)
-- ============================================================================

-- Cmd+R: Reload; Cmd+Shift+R: Hard reload
o.bind("SUPER + R", "Reload", mac_shortcut("CTRL", "R"))
o.bind("SUPER + SHIFT + R", "Hard reload", mac_shortcut("CTRL + SHIFT", "R"))

-- Cmd+L: Focus address / location bar (in terminal, clears screen)
o.bind("SUPER + L", "Focus location bar", mac_shortcut("CTRL", "L", "CTRL", "L"))

-- Cmd+K: Command palette / search in browser/apps; clear screen in terminal
o.bind("SUPER + K", "Command palette / Search", mac_shortcut("CTRL", "K", "CTRL", "L"))

-- Cmd+[ and Cmd+]: History Back / Forward (browser & Finder)
o.bind("SUPER + bracketleft", "Back in history", mac_shortcut("ALT", "Left"))
o.bind("SUPER + bracketright", "Forward in history", mac_shortcut("ALT", "Right"))

-- Cmd+D: Bookmark page
o.bind("SUPER + D", "Bookmark page", mac_shortcut("CTRL", "D"))

-- ============================================================================
-- 5. macOS Editing & Clipboard (Cmd = SUPER)
-- ============================================================================

-- Cmd+A: Select all (in terminal, uses select_all)
o.bind("SUPER + A", "Select all", mac_shortcut("CTRL", "A", "CTRL + SHIFT", "A"))

-- Cmd+Z: Undo; Cmd+Shift+Z / Cmd+Y: Redo
o.bind("SUPER + Z", "Undo", mac_shortcut("CTRL", "Z"))
o.bind("SUPER + SHIFT + Z", "Redo", mac_shortcut("CTRL + SHIFT", "Z"))
o.bind("SUPER + Y", "Redo", mac_shortcut("CTRL", "Y"))

-- Cmd+S: Save
o.bind("SUPER + S", "Save", mac_shortcut("CTRL", "S"))

-- Cmd+F: Find; Cmd+G: Find next; Cmd+Shift+G: Find previous
o.bind("SUPER + F", "Find", mac_shortcut("CTRL", "F"))
o.bind("SUPER + G", "Find next", mac_shortcut("CTRL", "G"))
o.bind("SUPER + SHIFT + G", "Find previous", mac_shortcut("CTRL + SHIFT", "G"))

-- Cmd+P: Print / Quick open
o.bind("SUPER + P", "Print", mac_shortcut("CTRL", "P"))

-- Cmd+O: Open file
o.bind("SUPER + O", "Open file", mac_shortcut("CTRL", "O"))

-- Text formatting: Cmd+B (bold), Cmd+I (italic), Cmd+U (underline), Cmd+/ (comment)
o.bind("SUPER + B", "Bold", mac_shortcut("CTRL", "B"))
o.bind("SUPER + I", "Italic", mac_shortcut("CTRL", "I"))
o.bind("SUPER + U", "Underline", mac_shortcut("CTRL", "U"))
o.bind("SUPER + slash", "Toggle comment", mac_shortcut("CTRL", "slash"))

-- ============================================================================
-- 6. macOS Zoom Controls (Cmd = SUPER)
-- ============================================================================

-- Cmd+= / Cmd++: Zoom in
o.bind("SUPER + EQUAL", "Zoom in", mac_shortcut("CTRL", "equal"))
o.bind("SUPER + PLUS", "Zoom in", mac_shortcut("CTRL", "equal"))

-- Cmd+-: Zoom out
o.bind("SUPER + MINUS", "Zoom out", mac_shortcut("CTRL", "minus"))

-- Cmd+0: Reset zoom
o.bind("SUPER + 0", "Reset zoom", mac_shortcut("CTRL", "0"))

-- ============================================================================
-- 7. macOS Cursor, Text Navigation & Editing (Cmd = SUPER, Option = ALT)
-- ============================================================================

-- Cmd+Left / Cmd+Right: Start / End of line (Home / End)
o.bind("SUPER + LEFT", "Line start (Home)", hl.dsp.send_shortcut({ mods = "", key = "Home" }), { repeating = true })
o.bind("SUPER + RIGHT", "Line end (End)", hl.dsp.send_shortcut({ mods = "", key = "End" }), { repeating = true })

-- Cmd+Up / Cmd+Down: Top / Bottom of document (Ctrl+Home / Ctrl+End)
o.bind("SUPER + UP", "Document top", hl.dsp.send_shortcut({ mods = "CTRL", key = "Home" }), { repeating = true })
o.bind("SUPER + DOWN", "Document bottom", hl.dsp.send_shortcut({ mods = "CTRL", key = "End" }), { repeating = true })

-- Cmd+Shift+Left / Cmd+Shift+Right: Select to start / end of line (Shift+Home / Shift+End)
o.bind("SUPER + SHIFT + LEFT", "Select to line start", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Home" }), { repeating = true })
o.bind("SUPER + SHIFT + RIGHT", "Select to line end", hl.dsp.send_shortcut({ mods = "SHIFT", key = "End" }), { repeating = true })

-- Cmd+Shift+Up / Cmd+Shift+Down: Select to top / bottom of document (Ctrl+Shift+Home / Ctrl+Shift+End)
o.bind("SUPER + SHIFT + UP", "Select to document top", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Home" }), { repeating = true })
o.bind("SUPER + SHIFT + DOWN", "Select to document bottom", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "End" }), { repeating = true })

-- Option+Left / Option+Right: Word left / Word right (Ctrl+Left / Ctrl+Right)
o.bind("ALT + LEFT", "Word left", hl.dsp.send_shortcut({ mods = "CTRL", key = "Left" }), { repeating = true })
o.bind("ALT + RIGHT", "Word right", hl.dsp.send_shortcut({ mods = "CTRL", key = "Right" }), { repeating = true })

-- Option+Up / Option+Down: Paragraph up / Paragraph down (Ctrl+Up / Ctrl+Down)
o.bind("ALT + UP", "Paragraph up", hl.dsp.send_shortcut({ mods = "CTRL", key = "Up" }), { repeating = true })
o.bind("ALT + DOWN", "Paragraph down", hl.dsp.send_shortcut({ mods = "CTRL", key = "Down" }), { repeating = true })

-- Option+Shift+Left / Option+Shift+Right: Select word left / Select word right
o.bind("ALT + SHIFT + LEFT", "Select word left", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Left" }), { repeating = true })
o.bind("ALT + SHIFT + RIGHT", "Select word right", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Right" }), { repeating = true })

-- Option+Shift+Up / Option+Shift+Down: Select paragraph up / Select paragraph down
o.bind("ALT + SHIFT + UP", "Select paragraph up", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Up" }), { repeating = true })
o.bind("ALT + SHIFT + DOWN", "Select paragraph down", hl.dsp.send_shortcut({ mods = "CTRL SHIFT", key = "Down" }), { repeating = true })

-- Cmd+Backspace: Delete to start of line (Ctrl+U in terminal)
o.bind("SUPER + BackSpace", "Delete to line start", mac_delete_to_start())

-- Option+Backspace (Alt+Backspace): Delete previous word
o.bind("ALT + BackSpace", "Delete previous word", mac_shortcut("CTRL", "BackSpace", "CTRL", "W"))

-- Option+Delete (Alt+Delete): Delete word forward
o.bind("ALT + Delete", "Delete word forward", hl.dsp.send_shortcut({ mods = "CTRL", key = "Delete" }), { repeating = true })

-- ============================================================================
-- 8. macOS Screenshot Shortcut (Cmd = SUPER)
-- ============================================================================

-- Cmd+Shift+S: Capture screenshot
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
