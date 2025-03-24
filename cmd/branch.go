package cmd

import (
    "fmt"
    "os/exec"

    "github.com/spf13/cobra"
)

var branchCmd = &cobra.Command{
    Use:   "branch [branch]",
    Short: "Manage branches",
    Long:  `Manage branches in a bare repository.`,
    Run: func(cmd *cobra.Command, args []string) {
        if len(args) < 1 {
            fmt.Println("You must specify a branch to manage")
            return
        }
        branch := args[0]
        // Implement the branch logic here
        exec.Command("git", "branch", branch).Run()
    },
}

func init() {
    rootCmd.AddCommand(branchCmd)
}

