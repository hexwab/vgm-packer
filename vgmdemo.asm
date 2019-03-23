;******************************************************************
; 6502 BBC Micro Compressed VGM (VGC) Music Player
; By Simon Morris
; https://github.com/simondotm/vgm-packer
;******************************************************************


; Allocate vars in ZP
.zp_start
ORG &70
GUARD &8f

;----------------------------------------------------------------------------------------------------------
; Common code headers
;----------------------------------------------------------------------------------------------------------
; Include common code headers here - these can declare ZP vars from the pool using SKIP...

INCLUDE "lib/vgmplayer.h.asm"


.zp_end


\ ******************************************************************
\ *	Utility code - always memory resident
\ ******************************************************************

ORG &1100
GUARD &7c00


;----------------------------


;-------------------------------------------
; main
;-------------------------------------------



.vgm_buffer_start

; reserve space for the vgm decode buffers (8x256 = 2Kb)
ALIGN 256
.vgm_stream_buffers
    skip 256
    skip 256
    skip 256
    skip 256
    skip 256
    skip 256
    skip 256
    skip 256


.vgm_buffer_end
tmp = $80
.start
.main
{   ;lda #16
    ;ldx #0
    ;jsr &fff4
    lda #0 ;$80
    sta $277
    lda #0 ;$c2
    sta $279
    ; initialize the vgm player with a vgc data stream
    jsr irq_init
    lda #hi(vgm_stream_buffers)
    ldx #lo(vgm_data)
    ldy #hi(vgm_data)
    sec
    jsr vgm_init
    ldx #lo(vgm_data2)
    stx vgm_source+0
    ldy #hi(vgm_data2)
    sty vgm_source+1
lda #22:jsr$ffee:lda#130:jsr$ffee
    ; loop & update
    ;lda $240
    ;sta tmp
	sei
	lda #$4e
	sta $fe44
	sta $fe45
	cli
.loop
; set to false to playback at full speed for performance testing
IF TRUE
				; vsync
.vsync1
    ;jsr irq
    ;lda #2
    lda #$40
    bit &FE4D
    beq vsync1
    sta &FE4D
ELSE
    lda #19
    jsr $fff4
ENDIF
IF 0
    dec tmp
    lda tmp
.vsync
    cmp $240
    bne vsync
ENDIF
    ;ldy#4:.loop0 ldx#0:.loop1 nop:nop:dex:bne loop1:dey:bne loop0
    lda #&03:sta&fe21
    sei:jsr vgm_update:cli
    pha:lda #&07:sta&fe21:pla
    beq loop
    cli
    rts
}



INCLUDE "lib/vgmplayer.asm"

; include your tune of choice here, some samples provided....
.vgm_data
;INCBIN "ou-bass.vgc"
INCBIN "ou-intro7.vgc"
.vgm_data2
INCBIN "ou-main7.vgc"
;INCBIN "vgm/ou-bass-quant.vgc"
;INCBIN "testvgm/ym_009.vgc"
;INCBIN "testvgm/song_091.vgc"
;INCBIN "testvgm/axelf.vgc"
;INCBIN "testvgm/bbcapple.vgc"
;INCBIN "testvgm/nd-ui.vgc"
;INCBIN "testvgm/outruneu.vgc"



PRINT ~vgm_data


.end

SAVE "Main", start, end, main

