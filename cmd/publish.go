package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"path"

	"github.com/spf13/cobra"

	"github.com/kubesphere/ksbuilder/pkg/extension"
)

type publishOptions struct {
}

func defaultPublishOptions() *publishOptions {
	return &publishOptions{}
}

func publishExtensionCmd() *cobra.Command {
	o := defaultPublishOptions()

	cmd := &cobra.Command{
		Use:          "publish",
		Short:        "Publish an extension into the market",
		SilenceUsage: true,
		Args:         cobra.ExactArgs(1),
		RunE:         o.publish,
	}

	return cmd
}

func (o *publishOptions) publish(cmd *cobra.Command, args []string) error {
	pwd, _ := os.Getwd()
	p := path.Join(pwd, args[0])
	fmt.Printf("publish extension %s\n", args[0])

	ext, err := extension.Load(p)
	if err != nil {
		return err
	}

	dir, err := os.MkdirTemp("", "publish")
	if err != nil {
		return err
	}
	filePath := path.Join(dir, "extension.yaml")
	err = os.WriteFile(filePath, ext.ToKubernetesResources(), 0644)
	if err != nil {
		return err
	}

	command := exec.Command("kubectl", "apply", "-f", filePath)
	out, err := command.CombinedOutput()
	if err != nil {
		return err
	}

	fmt.Printf(string(out))

	return nil
}
