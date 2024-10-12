package test

import (
	"bytes"
	"fmt"
	"os/exec"
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

func TestSmoke(t *testing.T) {
	// website::tag::1:: Configure the tag to use on the Docker image.
	tag := "docker-smoke"
	VERSION, err := exec.Command("../support/VERSION.sh").Output()
	if err == nil {
	}
	buildOptions := &docker.BuildOptions{
		Tags: []string{tag},
		OtherOptions: []string{
			"--pull",
			"--no-cache",
			"-f",
			"../Dockerfile",
		},
		BuildArgs: []string{fmt.Sprintf("VERSION=%s", bytes.TrimRight(VERSION, "\n"))},
	}

	// website::tag::2:: Build the Docker image.
	docker.Build(t, "../", buildOptions)

	// website::tag::3:: Run the Docker image.
	opts := &docker.RunOptions{Command: []string{"-V"}}
	output := docker.Run(t, tag, opts)
	assert.Contains(t, output, "mdbook")
}
