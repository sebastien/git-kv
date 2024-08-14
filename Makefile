
USER?=$(shell whoami)
HOME?=/home/$(USER)

test:
	@bash tests/harness.sh

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
