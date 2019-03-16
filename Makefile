vgmdemo.ssd: vgmdemo.asm lib/vgmplayer.asm lib/vgmplayer.h.asm
	beebasm -i vgmdemo.asm -do vgmdemo.ssd -boot Main -v >out.txt
