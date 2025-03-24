package cmd

import (
    "os"
    "os/exec"
    "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
    Use:   "git-worktree-wrapper",
    Short: "A wrapper for git worktree commands",
    Long:  `A wrapper for git worktree commands to simplify usage in bare repositories.`,
    Run: func(cmd *cobra.Command, args []string) {
        if len(args) > 0 {
            // Forward the command to the native git client
            gitCmd := exec.Command("git", args...)
            gitCmd.Stdout = os.Stdout
            gitCmd.Stderr = os.Stderr
            if err := gitCmd.Run(); err != nil {
                os.Exit(1)
            }
        } else {
            cmd.Help()
        }
    },
}

func Execute() {
    if err := rootCmd.Execute(); err != nil {
        os.Exit(1)
    }
}

func init() {
    cobra.OnInitialize()
}
