package polyden

type Color int

// Colors and color names from https://colorhexa.com/web-safe-colors
const (
	ColorBlack                      Color = ((iota/36)*51)<<16 + (((iota/6)%6)*51)<<8 + (iota%6)*51
	ColorVeryDarkBlue                     // 000033
	ColorLightVeryDarkBlue                // 000066
	ColorDarkBlue                         // 000099
	ColorStrongBlue                       // 0000cc
	ColorBlue                             // 0000ff
	ColorVeryDarkLimeGreen                // 003300
	ColorVeryVeryDarkCyan                 // 003333
	ColorDarkMidnightBlue                 // 003366
	ColorDarkPowderBlue                   // 003399
	ColorLessGreenStrongBlue              // 0033cc
	ColorMostlyPureBlue                   // 0033ff
	ColorPakistanGreen                    // 006600
	ColorVeryDarkCyanLimeGreen            // 006633
	ColorVeryDarkCyan                     // 006666
	ColorLightDarkBlue                    // 006699
	ColorMoreGreenStrongBlue              // 0066cc
	ColorLightMostlyPureBlue              // 0066ff
	ColorDarkLimeGreen                    // 009900
	ColorDarkCyanLimeGreen                // 009933
	ColorLessDarkCyanLimeGreen            // 009966
	ColorDarkCyan                         // 009999
	ColorGreenStrongBlue                  // 0099cc
	ColorLighterMostlyPureBlue            // 0099ff
	ColorStrongLimeGreen                  // 00cc00
	ColorStrongCyanLimeGreen              // 00cc33
	ColorLighterStrongCyanLimeGreen       // 00cc66
	ColorCaribbeanGreen                   // 00cc99
	ColorStrongCyan                       // 00cccc
	ColorMostlyPureCyan                   // 00ccff
	ColorGreen                            // 00ff00
	ColorMostlyPureLimeGreen              // 00ff33
	ColorMostlyPureCyanLimeGreen          // 00ff66
	ColorMorePureCyanLimeGreen            // 00ff99
	ColorMorePureCyan                     // 00ffcc
	ColorCyan                             // 00ffff
	ColorVeryDarkRed                      // 330000
	ColorVeryDarkMagenta                  // 330033
	ColorVeryDarkViolet                   // 330066
	ColorDarkViolet                       // 330099
	ColorRedStrongBlue                    // 3300cc
	ColorMostlyPureBlueRed                // 3300ff

	// TODO: finish colors. https://colorhexa.com/web-safe-colors

	ColorWhite2 = 0xff_ff_ff
	ColorRed2   = 0xff_00_00
	ColorGreen2 = 0x00_ff_00
	ColorBlue2  = 0x00_00_ff

	ColorOrange
)
