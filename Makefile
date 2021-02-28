NAME = LiveMixer
DSP = $(NAME).dsp

LIB_EXT = .so
ifeq ($(WINDOWS),true)
LIB_EXT = .dll
endif

LV2_BUNDLE = $(NAME).lv2
LADSPA_LIB = $(NAME)$(LIB_EXT)

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib
LADSPA_DIR ?= $(LIBDIR)/ladspa
ifneq ($(MACOS_OR_WINDOWS),true)
LV2_DIR ?= $(LIBDIR)/lv2
VST_DIR ?= $(LIBDIR)/vst
endif
ifeq ($(MACOS),true)
LV2_DIR ?= /Library/Audio/Plug-Ins/LV2
VST_DIR ?= /Library/Audio/Plug-Ins/VST
endif
ifeq ($(WINDOWS),true)
LV2_DIR ?= $(COMMONPROGRAMFILES)/LV2
VST_DIR ?= $(COMMONPROGRAMFILES)/VST2
endif

USER_LADSPA_DIR ?= $(HOME)/.ladspa
ifneq ($(MACOS_OR_WINDOWS),true)
USER_LV2_DIR ?= $(HOME)/.lv2
USER_VST_DIR ?= $(HOME)/.vst
endif
ifeq ($(MACOS),true)
USER_LV2_DIR ?= $(HOME)/Library/Audio/Plug-Ins/LV2
USER_VST_DIR ?= $(HOME)/Library/Audio/Plug-Ins/VST
endif
ifeq ($(WINDOWS),true)
USER_LV2_DIR ?= $(APPDATA)/LV2
USER_VST_DIR ?= $(APPDATA)/VST
endif


all: lv2 ladspa

lv2: $(LV2_BUNDLE)

ladspa: $(LADSPA_LIB)

$(LV2_BUNDLE): $(DSP)
	faust2lv2 $<

$(LADSPA_LIB): $(DSP)
	faust2ladspa $<

install-user: lv2
	mkdir -p -m755 $(USER_LV2_DIR)/$(NAME).lv2 && \
	  install -m755 $(NAME).lv2/*$(LIB_EXT) $(USER_LV2_DIR)/$(NAME).lv2 && \
	  install -m644 $(NAME).lv2/*.ttl $(USER_LV2_DIR)/$(NAME).lv2

clean:
	-rm -rf $(LV2_BUNDLE) $(LADSPA_LIB)

.PHONY: all clean
