
SOURCES_BASH=$(wildcard *.sh bin/*sh src/sh/*sh tests/*.sh research/*.sh)
USER?=$(shell whoami)
HOME?=/home/$(USER)

test:
	@bash tests/harness.sh

lint:
	@shellcheck $(SOURCES_BASH)

fmt:
	@shfmt -w $(SOURCES_BASH)

install:
	@mkdir -p "$(HOME)/.local/bin"
	TARGET="$(HOME)/.local/bin/git-kv"
	if [ -e "$$TARGET" ]; then
		curl -o "$$TARGET" 'https://raw.githubusercontent.com/sebastien/git-kv/master/bin/git-kv'
		chmod +x "$$TARGET"
	fi

install-link:
	@mkdir -p "$(HOME)/.local/bin"
	TARGET="$(HOME)/.local/bin/git-kv"
	if [ -e "$$TARGET" ]; then
		unlink "$$TARGET"
	fi
	ln -sfr bin/git-kv "$$TARGET"

print-%:
	@$(info $*=$($*))

.ONESHELL:
# EOF
