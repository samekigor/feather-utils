package config

import (
	"fmt"
	"log"

	"github.com/spf13/viper"
)

type EnvVarsDetails struct {
	Prefix string
}

type ConfigFileDetails struct {
	ConfigFilePath string
}

var envVarsDetails = EnvVarsDetails{
	Prefix: "FEATHER",
}

func GetEnv(envVar string) (envVal string) {
	viper.SetEnvPrefix(envVarsDetails.Prefix)
	viper.AutomaticEnv()
	envVal = viper.GetString(envVar)
	if envVal == "" {
		log.Fatalf("Env variable={%s} not found", envVar)
	}
	return envVal
}

func (c *ConfigFileDetails) LoadConfigFile() {
	viper.SetConfigFile(c.ConfigFilePath)
	err := viper.ReadInConfig()
	if err != nil {
		panic(fmt.Sprintf("Failed to read config file: %v", err))
	}
}

func (c *ConfigFileDetails) GetValueFromConfig(yamlKey string) string {
	err := viper.ReadInConfig()
	if err != nil {
		panic(fmt.Sprintf("Failed to read config file: %v", err))
	}

	logsPath := viper.GetString(yamlKey)
	if logsPath == "" {
		panic(fmt.Sprintf("Key={%s} not found", yamlKey))
	}

	return logsPath
}
