declare name        "LiveMixer";
declare description "A stereo channel strip with one master gain and two post-fader sends";
declare version     "0.3";
declare author      "Vincent Rateau, Christopher Arndt";
declare license     "GPLv2";

import("stdfaust.lib");


// Controls
slider = vslider("[3]Volume", 1, 0, 1, 0.01) : si.smooth(0.999);
send_a = vslider("[1]Send A[style:knob]", 0, 0, 1, 0.01) : si.smooth(0.999);
send_b = vslider("[2]Send B[style:knob]", 0, 0, 1, 0.01) : si.smooth(0.999);

// One (mono) mixerstrip
mixerstrip = channel <: _, send;
send = _ <: _ * send_a, _ * send_b;
channel = _ * slider;

// Stereo and routing
router(a1, b1, c1, a2, b2, c2) = a1, a2, b1, b2, c1, c2;
stereostrip = mixerstrip, mixerstrip;

// Process
//process = hgroup("LiveMixer", par(i,1, vgroup("%i", stereostrip : route)));
process = stereostrip : router;
