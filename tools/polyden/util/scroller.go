package util

import "strings"

// scroller code. somewhat based on the behavior of zscroll. very simplified.

type ScrollerTextSource interface {
	Text() (string, error)
	BeforeText() (string, error)
	AfterText() (string, error)
	PadText() (string, error)
}

type Scroller interface {
	// Output returns the full display text
	Output() (string, error)
	// Update updates the internal text render state without shifting the scroll
	Update() error
	// Step updates the scroll position if necessary. No effect on short text.
	Step()
}

type scroller struct {
	source       ScrollerTextSource
	textWidth    int
	scrollIndex  int
	mainText     string
	previousText string
}

func NewScroller(source ScrollerTextSource, width int) Scroller {
	return &scroller{
		source:       source,
		textWidth:    width,
		scrollIndex:  0,
		mainText:     "",
		previousText: "",
	}
}

func (s *scroller) Output() (string, error) {
	before, err := s.source.BeforeText()
	if err != nil {
		return "", err
	}

	after, err := s.source.AfterText()
	if err != nil {
		return "", err
	}

	builder := new(strings.Builder)
	builder.WriteString(before)
	builder.WriteString(s.mainText)
	builder.WriteString(after)

	return builder.String(), nil
}

func (s *scroller) Update() error {
	text, err := s.source.Text()
	if err != nil {
		return err
	}

	if !strings.EqualFold(s.previousText, text) {
		s.scrollIndex = 0
		s.previousText = text
	}

	drawText := text

	if len(drawText) > s.textWidth {
		pad, err := s.source.PadText()
		if err != nil {
			return err
		}

		// TODO: better handle pad text length changes
		// TODO: handle fullwidth chars better

		drawText = drawText + pad

		drawLen := len(drawText)
		if s.scrollIndex >= drawLen {
			s.scrollIndex = 0
		}

		startIdx := s.scrollIndex
		endIdx := startIdx + s.textWidth

		if drawLen < endIdx {
			drawText = drawText + text
		}

		drawText = drawText[startIdx:endIdx]
	}

	s.mainText = drawText

	return nil
}

func (s *scroller) Step() {
	if len(s.previousText) > s.textWidth {
		s.scrollIndex += 1
	}
}
