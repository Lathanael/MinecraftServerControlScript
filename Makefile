MINECRAFT_USER := minecraft
MINECRAFT_HOME := /home/$(MINECRAFT_USER)
MINECRAFT_SERVER := /etc/init.d/minecraft_server
BASH_COMPLETION := /etc/bash_completion.d/mscs_completion
DISTRO=$(shell ./DistroFinder)

.PHONY: install clean

install: $(DISTRO) $(MINECRAFT_HOME) $(MINECRAFT_SERVER) $(BASH_COMPLETION)

clean: $(DISTRO)
	if [ "$DISTRO" -eq "arch" ]; then \
		update-rc.d -f minecraft_server remove; \
	else \
		; \
	fi
	rm -f $(MINECRAFT_SERVER) $(BASH_COMPLETION)

$(DISTRO):
	DISTRO=$(shell ./DistroMatcher)

$(MINECRAFT_HOME):
	adduser --disabled-password --gecos ",,," --quiet $(MINECRAFT_USER)

$(MINECRAFT_SERVER): minecraft_server
	install -m 0755 minecraft_server $(MINECRAFT_SERVER)
	if [ "$DISTRO" -eq "arch" ]; then \
		; \
	else \
		update-rc.d minecraft_server defaults; \
	fi

$(BASH_COMPLETION): mscs_completion
	install -m 0644 mscs_completion $(BASH_COMPLETION)

