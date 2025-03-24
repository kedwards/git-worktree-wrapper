package utils

import (
    "os"
    "os/exec"
)

func Git(args ...string) error {
    cmd := exec.Command("git", args...)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    return cmd.Run()
}
