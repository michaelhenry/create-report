INSTALL_DIR=/usr/local/bin
SWIFT_BUILD_FLAGS = -c release --disable-sandbox --arch arm64 --arch x86_64
EXECUTABLE_NAME=ghchecks
EXECUTABLE_PATH = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/$(EXECUTABLE_NAME)

.PHONY: build test install uninstall clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

test:
	swift test

install: build
	cp -f $(EXECUTABLE_PATH) $(INSTALL_DIR)

uninstall:
	rm -rf "$(INSTALL_DIR)/$(EXECUTABLE_NAME)"

clean:
	rm -rf .build
