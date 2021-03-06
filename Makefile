PROJECT = Libmacgpg
TARGET = Libmacgpg
CONFIG = Release
TEST_TARGET = UnitTest

XCCONFIG = ""
ifeq ("$(CODE_SIGN)","1")
    XCCONFIG=-xcconfig Dependencies/GPGTools_Core/make/code-signing.xcconfig
endif

.PRE :=
ifndef CFG
compile clean:
        $(foreach cfg,$(cfg_list), $(MAKE) CFG=$(cfg) $@;)
.PRE := foo-
endif

include Dependencies/GPGTools_Core/make/default

all: compile

update-core:
	@cd Dependencies/GPGTools_Core; git pull origin master; cd -
update-pinentry:
	@cd Dependencies/pinentry-mac; git pull origin master; cd -
update-me:
	@git pull

update: update-me update-core update-pinentry

test:
	@xcodebuild -project $(PROJECT).xcodeproj -target $(TEST_TARGET) -configuration $(CONFIG) build 

compile:
	@xcodebuild -project $(PROJECT).xcodeproj -target $(TARGET) -configuration $(CONFIG) build $(XCCONFIG)

clean:
	@xcodebuild -project $(PROJECT).xcodeproj -target $(TARGET) -configuration $(CONFIG) clean > /dev/null

pkg-core: compile
	@./Dependencies/GPGTools_Core/scripts/pkg-core.sh
