
RM=rm -rf
CP=cp
CPR=cp -r
MKDIR=mkdir -p

# Go should not be required to run functional tests
GOOS ?= $(shell command -v go >/dev/null && go env GOOS)
GOARCH ?= $(shell command -v go >/dev/null && go env GOARCH)

GO_MAJOR_VERSION = $(shell command -v go >/dev/null && go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f1)
GO_MINOR_VERSION = $(shell command -v go >/dev/null && go version | cut -c 14- | cut -d' ' -f1 | cut -d'.' -f2)

BUILD_GOVERSION="$(shell command -v go >/dev/null && go version | cut -d " " -f3 | sed -E 's/[go]+//g')"

#Current versioning information from env
BUILD_VERSION?="$(shell git describe --tags)"
BUILD_CODENAME="alphaga"
BUILD_TIMESTAMP=$(shell date +%F"_"%T)
BUILD_TAG?="$(shell git rev-parse HEAD)"
DEFAULT_CONFIGDIR?=/etc/crowdsec
DEFAULT_DATADIR?=/var/lib/crowdsec/data
