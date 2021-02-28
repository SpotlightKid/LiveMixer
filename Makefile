DSP = LiveMixer.dsp

all: lv2

lv2: $(DSP)
	faust2lv2 $<

ladspa: $(DSP)
	faust2ladspa $<

.PHONY: all
