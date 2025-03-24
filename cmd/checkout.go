package cmd

import (
    "fmt"
    "os/exec"

    "github.com/spf13/cobra"
)

var checkoutCmd = &cobra.Command{
    Use:   "checkout [branch]",
    Short: "Checkout a branch",
    Long:  `Checkout a branch in a bare repository.`,
    Run: func(cmd *cobra.Command, args []string) {
        if len(args) < 1 {
            fmt.Println("You must specify a branch to checkout")
            return
        }
        branch := args[0]
        // Implement the checkout logic here
        exec.Command("git", "checkout", branch).Run()
    },
}

func init() {
    rootCmd.AddCommand(checkoutCmd)
}
