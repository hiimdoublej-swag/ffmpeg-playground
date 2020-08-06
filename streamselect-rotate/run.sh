#!/bin/bash
ffmpeg -v info -nostdin \
-i materials/arizona.png \
-i materials/baltimore.png \
-i materials/dodgers.png \
-filter_complex \ "
[1:v][0:v]scale2ref[baltimore][arizona];
[2:v][arizona]scale2ref[dodgers][arizona];

[arizona]loop=loop=-1:size=1:start=0[arizona];
[baltimore]loop=loop=-1:size=1:start=0[baltimore];
[dodgers]loop=loop=-1:size=1:start=0[dodgers];

[arizona][baltimore][dodgers]streamselect=inputs=3:map=0,sendcmd='2.0 streamselect map 1;4.0 streamselect map 2'[rolling];
[rolling]fps=24,trim=duration=6[rolling];

[rolling]loop=loop=-1:size=144:start=0[rolling];
[rolling]trim=duration=30[out]
"  -map "[out]" -y result.mp4
# -i materials/0806_fbg_rkm.mp4 \
# [dodgers][out]streamselect=inputs=2:map=1,sendcmd='2.0 streamselect map 0'[out];
