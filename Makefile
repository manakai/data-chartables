
PLDIR = bin/
PERL = perl
PERLI = $(PERL) -I$(PLDIR)
TBR2TBL = $(PLDIR)tbr2tbl.pl
TBL2UCM = $(PLDIR)tbl2ucm.pl

SOURCE_DIR = source/
RESULT_DIR = generated/

TBL_jis = $(RESULT_DIR)jisx0208_1978.tbl $(RESULT_DIR)jisx0208_1978_irv.tbl \
  $(RESULT_DIR)jisx0208_1983.tbl $(RESULT_DIR)jisx0208_1983_irv.tbl $(RESULT_DIR)jisx0208_1990.tbl \
  $(RESULT_DIR)jisx0208_1990_open_0201.tbl $(RESULT_DIR)jisx0208_1990_open_ascii.tbl \
  $(RESULT_DIR)jisx0208_1997.tbl $(RESULT_DIR)jisx0208_1997_irv.tbl $(RESULT_DIR)jisx0208_1997_latin.tbl $(RESULT_DIR)jisx0208_1997_yen.tbl \
  $(RESULT_DIR)jisx0212_1990.tbl $(RESULT_DIR)jisx0212_1990_irv.tbl $(RESULT_DIR)jisx0212_0213.tbl \
  $(RESULT_DIR)jisx0212_1990_open_0201.tbl $(RESULT_DIR)jisx0212_1990_open_ascii.tbl \
  $(RESULT_DIR)jisx0212_1990_open_ms.tbl \
  $(RESULT_DIR)jisx0213_2000_1.tbl $(RESULT_DIR)jisx0213_2000_1_esc_24_42.tbl $(RESULT_DIR)jisx0213_2000_2.tbl \
  $(RESULT_DIR)jisx0201_latin.tbl $(RESULT_DIR)jisx0201_katakana.tbl $(RESULT_DIR)ascii_yen.tbl \
  $(RESULT_DIR)jisx0208_to_katakana_hw.tbl
TBL_gb = $(RESULT_DIR)gb2312_1980.tbl $(RESULT_DIR)gb12345_1990.tbl $(RESULT_DIR)iso_ir_165.tbl
TBL_ks = $(RESULT_DIR)ksx1001_1992.tbl
TBL_kps = $(RESULT_DIR)kps9566_1997.tbl
TBL_photograph = $(RESULT_DIR)imode.tbl $(RESULT_DIR)lmode.tbl $(RESULT_DIR)doti.tbl $(RESULT_DIR)jphone.tbl $(RESULT_DIR)iso_ir_169.tbl
TBL_misc = $(RESULT_DIR)iso_ir_231.tbl
TBL_iso8859 = $(RESULT_DIR)isoiec8859_2.tbl $(RESULT_DIR)isoiec8859_3.tbl $(RESULT_DIR)isoiec8859_4.tbl \
  $(RESULT_DIR)isoiec8859_5.tbl $(RESULT_DIR)isoiec8859_6.tbl $(RESULT_DIR)isoiec8859_7.tbl \
  $(RESULT_DIR)isoiec8859_8.tbl $(RESULT_DIR)isoiec8859_8_1999.tbl $(RESULT_DIR)isoiec8859_9.tbl \
  $(RESULT_DIR)isoiec8859_10.tbl #$(RESULT_DIR)isoiec8859_11.tbl \
  $(RESULT_DIR)isoiec8859_13.tbl \
  $(RESULT_DIR)isoiec8859_14.tbl $(RESULT_DIR)isoiec8859_15.tbl $(RESULT_DIR)isoiec8859_16.tbl \
  $(RESULT_DIR)iso_ir_204.tbl $(RESULT_DIR)iso_ir_205.tbl $(RESULT_DIR)iso_ir_206.tbl

all: jis gb ks kps iso8859 photograph misc cp-all web-index

jis:  $(TBL_jis)
jis-tbl:  $(TBL_jis)
gb:  $(TBL_gb)
gb-tbl:  $(TBL_gb)
ks:  $(TBL_ks)
ks-tbl:  $(TBL_ks)
kps:  $(TBL_kps)
kps-tbl:  $(TBL_kps)
iso8859:  $(TBL_iso8859)
iso8859-tbl:  $(TBL_iso8859)
photograph:  $(TBL_photograph)
photograph-tbl:  $(TBL_photograph)
misc:  $(TBL_misc)
misc-tbl:  $(TBL_misc)

$(RESULT_DIR)%.tbl: $(SOURCE_DIR)%.tbr $(TBR2TBL)
	$(PERLI) $(TBR2TBL) $< > $@

$(RESULT_DIR)euc_jp_open_ascii.tbl: $(SOURCE_DIR)euc_jp_open_ascii.tbr $(TBR2TBL) \
  $(RESULT_DIR)jisx0208_1990_open_ascii.tbl \
  $(RESULT_DIR)jisx0212_1990_open_ascii.tbl
	$(PERLI) $(TBR2TBL) $< > $@

$(RESULT_DIR)%.ucm: $(RESULT_DIR)%.tbl $(TBL2UCM)
	$(PERLI) $(TBL2UCM) $< > $@

cp-all:
	cd cp && make all

web-index: generated/web-extra-index.json
generated/web-extra-index.json: bin/web-index.pl source/web-*.txt
	$(PERL) bin/web-index.pl > $@

clean:
	rm -rfv *.BAK .*.BAK *~ .*~

## License: Public Domain.
