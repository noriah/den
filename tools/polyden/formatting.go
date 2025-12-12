package polyden

import "fmt"

// Foreground Color
// https://github.com/polybar/polybar/wiki/Formatting#font-t
func FgColor(color Color, text string) string {
	return fmt.Sprintf("%%{F#%x}%s%%{F-}", color, text)
}

// Background Color
// https://github.com/polybar/polybar/wiki/Formatting#background-color-b
func BgColor(color Color, text string) string {
	return fmt.Sprintf("%%{B#%x}%s%%{B-}", color, text)
}

// Reverse back/foreground colors
// https://github.com/polybar/polybar/wiki/Formatting#reverse-back-foreground-colors-r
func Reverse(text string) string {
	return fmt.Sprintf("%%{R}%s", text)
}

// Underline
// https://github.com/polybar/polybar/wiki/Formatting#underline-color-u
func Underline(text string) string {
	return fmt.Sprintf("%%{u-}%s%%{-u}", text)
}

// Underline with color
// https://github.com/polybar/polybar/wiki/Formatting#underline-color-u
func UnderlineColor(color Color, text string) string {
	return fmt.Sprintf("%%{u#%x}%s%%{-u}", color, text)
}

// Overline
// https://github.com/polybar/polybar/wiki/Formatting#overline-color-o
func Overline(text string) string {
	return fmt.Sprintf("%%{o-}%s%%{-o}", text)
}

// Overline with color
// https://github.com/polybar/polybar/wiki/Formatting#overline-color-o
func OverlineColor(color Color, text string) string {
	return fmt.Sprintf("%%{o#%x}%s%%{-o}", color, text)
}

// Font
// https://github.com/polybar/polybar/wiki/Formatting#font-t
func Font(font int, text string) string {
	return fmt.Sprintf("%%{T%d}%s%%{T-}", font, text)
}

// Offset by pixels
// https://github.com/polybar/polybar/wiki/Formatting#offset-o
func OffsetPixel(offset int, text string) string {
	return fmt.Sprintf("%%{O%d}%s%%{O-}", offset, text)
}

// Offset by points
// https://github.com/polybar/polybar/wiki/Formatting#offset-o
func OffsetPoint(offset int, text string) string {
	return fmt.Sprintf("%%{O%dpt}%s%%{O-}", offset, text)
}

// Action command
// https://github.com/polybar/polybar/wiki/Formatting#offset-o
func Action(btn int, cmd string, text string) string {
	return fmt.Sprintf("%%{A%d:%s:}%s%%{A}", btn, cmd, text)
}
