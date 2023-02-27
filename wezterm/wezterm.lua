local wezterm = require 'wezterm';

return {
	hyperlink_rules = {
		{
			regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
			format = '$0',
		},
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = '$0',
		},
		{
			regex = [[\b\w+://localhost:\d+/?\S*\b]],
			format = '$0',
		},
	},
	color_scheme = 'tokyonight-storm',
	font = wezterm.font_with_fallback({ 'Inconsolata Arrows', 'Menlo' }),
	font_rules = {
		{
			italic = true,
			font = wezterm.font('Inconsolata Arrows'),
		},
	},
	font_size = 25.0,
	default_cursor_style = "BlinkingBar",
	animation_fps = 1,
	cursor_blink_rate = 500,
	enable_tab_bar = false,
	front_end = "WebGpu",
}
