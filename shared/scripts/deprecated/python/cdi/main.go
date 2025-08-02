package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/urfave/cli/v2"
)

func getSearchDirs(extra []string) []string {
	envVars := []string{"PROJECT_DIR", "WORK_DIR", "ASSET_DIR"}
	var dirs []string

	for _, env := range envVars {
		if dir := os.Getenv(env); dir != "" {
			dirs = append(dirs, dir)
		}
	}
	for _, dir := range extra {
		if _, err := os.Stat(dir); err == nil {
			dirs = append(dirs, dir)
		}
	}
	return dirs
}

func runCommand(name string, args ...string) ([]string, error) {
	out, err := exec.Command(name, args...).Output()
	if err != nil {
		return nil, err
	}
	lines := strings.Split(strings.TrimSpace(string(out)), "\n")
	return lines, nil
}

func findAllDirs(searchDirs []string) []string {
	var dirs []string
	var err error

	if _, err = exec.LookPath("fd"); err == nil {
		for _, dir := range searchDirs {
			if found, e := runCommand("fd", ".", "--type", "d", dir); e == nil {
				dirs = append(dirs, found...)
			}
		}
	}

	if len(dirs) == 0 {
		args := append(searchDirs, "-type", "d")
		if found, e := runCommand("find", args...); e == nil {
			dirs = append(dirs, found...)
		}
	}

	unique := map[string]bool{}
	var result []string
	for _, d := range dirs {
		if d != "" && !unique[d] {
			unique[d] = true
			result = append(result, d)
		}
	}
	return result
}

func fzfSelect(items []string) string {
	cmd := exec.Command("fzf", "--prompt", "Select directory: ", "--height", "40%", "--reverse", "--border")
	in, _ := cmd.StdinPipe()
	go func() {
		defer in.Close()
		for _, item := range items {
			fmt.Fprintln(in, item)
		}
	}()
	out, err := cmd.Output()
	if err != nil {
		return ""
	}
	return strings.TrimSpace(string(out))
}

func changeDirAndShell(dir string) {
	fmt.Println("Changing to:", dir)
	os.Chdir(dir)
	shell := os.Getenv("SHELL")
	if shell == "" {
		shell = "/bin/bash"
	}
	cmd := exec.Command(shell)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}

func main() {
	app := &cli.App{
		Name:  "smartcd",
		Usage: "Fuzzy cd tool with env and fallback search",
		Action: func(c *cli.Context) error {
			args := c.Args().Slice()
			target := ""
			extra := []string{}

			if len(args) > 0 {
				target = args[0]
				extra = args[1:]
			}

			searchDirs := getSearchDirs(extra)

			if target != "" {
				if info, err := os.Stat(target); err == nil && info.IsDir() {
					changeDirAndShell(target)
					return nil
				}
				allDirs := findAllDirs(searchDirs)
				var matches []string
				for _, d := range allDirs {
					if strings.Contains(filepath.Base(d), filepath.Base(target)) {
						matches = append(matches, d)
					}
				}
				if len(matches) == 0 {
					matches = allDirs
				}
				if selected := fzfSelect(matches); selected != "" {
					changeDirAndShell(selected)
				}
			} else {
				allDirs := findAllDirs(searchDirs)
				if selected := fzfSelect(allDirs); selected != "" {
					changeDirAndShell(selected)
				}
			}
			return nil
		},
	}

	if err := app.Run(os.Args); err != nil {
		fmt.Fprintln(os.Stderr, "Error:", err)
	}
}
