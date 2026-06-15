# Default variables

GAME_REVISION ?= 0
GAME_LANGUAGE ?= ENGLISH

# Builds the ROM using a modern compiler
MODERN        ?= 0
# Compares the ROM to a checksum of the original - only makes sense using when non-modern
COMPARE       ?= 0

KEEP_TEMPS    ?= 0

ifeq (modern,$(MAKECMDGOALS))
  MODERN := 1
endif
ifeq (compare,$(MAKECMDGOALS))
  COMPARE := 1
endif

# For gbafix
TITLE       := POKEMON EMER
GAME_CODE   := BPEE
MAKER_CODE  := 01

BUILD_DIR := build
BUILD_NAME := emerald

# Revision
ifeq ($(GAME_REVISION),10)
  BUILD_NAME := $(BUILD_NAME)_switch
endif

# Modern GCC
ifeq ($(MODERN),1)
  BUILD_NAME := $(BUILD_NAME)_modern
endif
