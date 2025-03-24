package utils

import (
    "testing"
)

func TestGit(t *testing.T) {
    err := Git("--version")
    if err != nil {
        t.Errorf("Git command failed: %v", err)
    }
}
