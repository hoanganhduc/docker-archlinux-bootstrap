#URL=http://mirrors.kernel.org/archlinux/iso/latest/
#RELEASE_DATE=$(shell curl -s $(URL)|grep -o "[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}"|head -n1)
RELEASE_DATE=2014.12.01
RELEASE_DATE_URL=2014/12/01
URL=https://archive.archlinux.org/iso/$(RELEASE_DATE)/
INPUT_ARCHIVE=archlinux-bootstrap-$(RELEASE_DATE)-x86_64.tar.gz
OUTPUT_DIR=pkgdir
DOCKER_IMG=hoanganhduc/archlinux:$(RELEASE_DATE)
CURL=curl -\# -O

.PHONY: docker-build publish

all: $(INPUT_ARCHIVE) $(OUTPUT_DIR) docker-build

$(INPUT_ARCHIVE):
	$(CURL) $(URL)$@

$(OUTPUT_DIR):
	mkdir $(OUTPUT_DIR)
	tar xf $(INPUT_ARCHIVE) -C $(OUTPUT_DIR) --strip-components 1
	
	sed -i 's/CheckSpace/#CheckSpace/' $(OUTPUT_DIR)/etc/pacman.conf
	sed -i 's,SigLevel    = Required DatabaseOptional,SigLevel = Never,g' $(OUTPUT_DIR)/etc/pacman.conf
	echo 'Server = https://archive.archlinux.org/repos/$(RELEASE_DATE_URL)/$$repo/os/$$arch' > $(OUTPUT_DIR)/etc/pacman.d/mirrorlist
	echo 'en_US.UTF-8 UTF-8' > $(OUTPUT_DIR)/etc/locale.gen
	echo 'LANG="en_US.UTF-8"' > $(OUTPUT_DIR)/etc/locale.conf
	ln -s /usr/share/zoneinfo/UTC $(OUTPUT_DIR)/etc/localtime
	rm $(OUTPUT_DIR)/README

docker-build:
	docker build --rm=true --force-rm=true -t $(DOCKER_IMG) .

publish:
	docker push $(DOCKER_IMG)

clean:
	rm -rf $(OUTPUT_DIR)
