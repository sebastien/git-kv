
USER?=$(shell whoami)
HOME?=/home/$(USER)
SOURCES_ALL=$(wildcard Makefile bin/* *.md tests/*.sh)

test:
	@bash tests/harness.sh

aider-update:
	aider $(SOURCES_ALL)
install:
	@mkdir -p "$(HOME)/.local/bin"
	TARGET="$(HOME)/.local/bin/git-kv"
	if [ -e "$$TARGET" ]; then
		curl -o "$$TARGET" 'https://raw.githubusercontent.com/sebastien/git-kv/master/bin/git-kv'
		chmod +x "$$TARGET"
	fi

print-%:
	@$(info $*=$($*))

.ONESHELL:
# EOF
