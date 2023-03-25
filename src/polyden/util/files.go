package util

import "os"

// ReadFile calls os.ReadFile and removes any trailing newline.
func ReadFile(filePath string) (data []byte, err error) {
	data, err = os.ReadFile(filePath)
	if err != nil {
		data = nil
		return
	}

	for len(data) != 0 {
		if data[len(data)-1] != '\n' {
			break
		}
		data = data[:len(data)-1]
	}

	return
}
