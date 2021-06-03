// Version  : 2.0.0
// Author   : Kevin Lindley
// Date     : 2021-04-29
// Filename : CroneEngine_PolySaw.sc

Engine_PolySaw : CroneEngine {
	var pg;
    var amp=1.0;
    var frelease=0.5;
    var pw=0.5;
    var fcutoff=10000;
    var fgain=2;
    var pan = 0;
    var fattackt = 0.01;
    var fdecayt = 0.3;
    var fsustaint = 1.0;
    var fcurve = -4;
    var pecrelease = 0.1;
    var vattackt = 0.01;
    var vsustaint = 1.0;
    var vrelease = 0.1;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		pg = ParGroup.tail(context.xg);
    SynthDef("PolySaw", {
			arg out, freq = 440, amp=amp, fattackt=fattackt, fdecayt=fdecayt, fcurve=fcurve, pecrelease=pecrelease, fsustaint=fsustaint, fcutoff=fcutoff, fgain=fgain, frelease=frelease, pan=pan,vattackt=vattackt, vsustaint=vsustaint, vrelease=vrelease;
			var snd = Saw.ar(freq);
			var env1 = Env.perc(level: amp, releaseTime: pecrelease).kr(2);
			var fenv3=Env.linen(attackTime: vattackt, sustainTime: vsustaint, releaseTime: vrelease, level: amp, curve: -4.0).kr(2);
			var filt = MoogFF.ar(snd*fenv3,fcutoff*env1,fgain);
			var fenv2=Env.linen(attackTime: fattackt, sustainTime: fsustaint, releaseTime: frelease, level: amp, curve: -4.0).kr(2);
			Out.ar(out, Pan2.ar((filt*fenv2), pan));
		}).add;

		this.addCommand("freq", "f", { arg msg;
			var val = msg[1];
      Synth("PolySaw", [\out, context.out_b, \freq,val,\pw,pw,\amp,amp,\fcutoff,fcutoff,\fattackt,fattackt,\pecrelease,pecrelease,\fgain,fgain,\fdecayt,fdecayt,\fcurve,fcurve,\fsustaint,fsustaint,\frelease,frelease,\pan,pan,\vsustaint,vsustaint,\vrelease,vrelease,\vattackt,vattackt], target:pg);
		});

		this.addCommand("amp", "f", { arg msg;
			amp = msg[1];
		});
		
		this.addCommand("fattackt", "f", { arg msg;
			fattackt = msg[1];
		});
		
		this.addCommand("fdecayt", "f", { arg msg;
			fdecayt = msg[1];
		});

		this.addCommand("fsustaint", "f", { arg msg;
			fsustaint = msg[1];
		});


		this.addCommand("frelease", "f", { arg msg;
			frelease = msg[1];
		});
		
		this.addCommand("fcutoff", "f", { arg msg;
			fcutoff = msg[1];
		});
		
		this.addCommand("fgain", "f", { arg msg;
			fgain = msg[1];
		});
		
		this.addCommand("fcurve", "f", { arg msg;
			fcurve = msg[1];
		});
		
				this.addCommand("pecrelease", "f", { arg msg;
			pecrelease = msg[1];
		});


	  this.addCommand("vattackt", "f", { arg msg;
			vattackt = msg[1];
		});
		

		this.addCommand("vsustaint", "f", { arg msg;
			vsustaint = msg[1];
		});


		this.addCommand("vrelease", "f", { arg msg;
			vrelease = msg[1];
		});
		
		
		this.addCommand("pan", "f", { arg msg;
		  postln("pan: " ++ msg[1]);
			pan = msg[1];
		});
	}
}