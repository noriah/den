package util

import (
	"encoding/json"
	"io"
	"net/http"
)

func GetHttpJson(url string, v any) error {
	resp, err := http.Get(url)

	if err != nil {
		return err
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil
	}

	if err := json.Unmarshal(body, v); err != nil {
		return err
	}

	return nil
}
