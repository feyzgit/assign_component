REPORT  zco_p_pa_duzeltme.

DATA: BEGIN OF gt_report,
        selkz,
        kostl    LIKE csks-kostl,
        setname  LIKE setleaf-setname,
        co_tutar LIKE coss-wog001,
        pa_tutar LIKE ce1tani-vv120,
        fark     LIKE coss-wog001,
END OF gt_report.

PARAMETERS: p_perio TYPE ce1tani-perio.

PERFORM get_data.

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM get_data.

  FIELD-SYMBOLS: <fs> TYPE ANY.
  TYPES: BEGIN OF ty_coss,

         lednr  TYPE coss-lednr,
         objnr  TYPE coss-objnr,
         gjahr  TYPE coss-gjahr,
         wrttp  TYPE coss-wrttp,
         versn  TYPE coss-versn,
         kstar  TYPE coss-kstar,
         hrkft  TYPE coss-hrkft,
         vrgng  TYPE coss-vrgng,
         parob  TYPE coss-parob,
         uspob  TYPE coss-uspob,
         beknz  TYPE coss-beknz,
         twaer  TYPE coss-twaer,
         perbl  TYPE coss-perbl,
         wog001 TYPE coss-wog001,
         wog002 TYPE coss-wog002,
         wog003 TYPE coss-wog003,
         wog004 TYPE coss-wog004,
         wog005 TYPE coss-wog005,
         wog006 TYPE coss-wog006,
         wog007 TYPE coss-wog007,
         wog008 TYPE coss-wog008,
         wog009 TYPE coss-wog009,
         wog010 TYPE coss-wog010,
         wog011 TYPE coss-wog011,
         wog012 TYPE coss-wog012,
         wog013 TYPE coss-wog013,
         wog014 TYPE coss-wog014,
         wog015 TYPE coss-wog015,
         wog016 TYPE coss-wog016,

         END OF ty_coss.

  DATA: lt_coss    TYPE TABLE OF ty_coss,
        ls_coss    TYPE ty_coss,
        lt_ce1tani TYPE TABLE OF ce1tani,
        ls_ce1tani TYPE  ce1tani,
        lt_setleaf TYPE TABLE OF setleaf,
        ls_setleaf TYPE setleaf,
        lr_setname TYPE RANGE OF setleaf-setname,
        ls_setname LIKE LINE OF lr_setname,
        lt_csks    TYPE TABLE OF csks,
        ls_csks    TYPE csks,
        lv_fname   TYPE char50.




  ls_setname-sign   = 'I'.
  ls_setname-option = 'EQ'.
  ls_setname-low    = 'ZPA_VV120'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    = 'ZPA_VV122'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    = 'ZPA_VV170'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    = 'ZPA_VV142'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    = 'ZPA_VV160'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    = 'ZPA_VV161'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    =  'ZPA_VV140'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    =  'ZPA_VV120D'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    =  'ZPA_VV122D'.
  APPEND ls_setname TO lr_setname.
  ls_setname-low    =  'ZPA_VV170D'.
  APPEND ls_setname TO lr_setname.

  SELECT *
    FROM setleaf
    INTO TABLE lt_setleaf
    WHERE setname IN lr_setname.

  IF lt_setleaf[] IS NOT INITIAL.

    SELECT lednr
           objnr
           gjahr
           wrttp
           versn
           kstar
           hrkft
           vrgng
           parob
           uspob
           beknz
           twaer
           perbl
           wog001
           wog002
           wog003
           wog004
           wog005
           wog006
           wog007
           wog008
           wog009
           wog010
           wog011
           wog012
           wog013
           wog014
           wog015
           wog016
      FROM coss
      INTO TABLE lt_coss
      FOR ALL ENTRIES IN lt_setleaf
      WHERE wrttp EQ '04'
        AND gjahr EQ p_perio(4)
        AND kstar EQ lt_setleaf-valfrom(10).

    SELECT lednr
           objnr
           gjahr
           wrttp
           versn
           kstar
           hrkft
           vrgng
           vbund
           pargb
           beknz
           twaer
           perbl
           wog001
           wog002
           wog003
           wog004
           wog005
           wog006
           wog007
           wog008
           wog009
           wog010
           wog011
           wog012
           wog013
           wog014
           wog015
           wog016
      FROM cosp
      INTO TABLE lt_coss
      FOR ALL ENTRIES IN lt_setleaf
      WHERE wrttp EQ '04'
        AND gjahr EQ p_perio(4)
        AND kstar EQ lt_setleaf-valfrom(10).
  ENDIF.

  SELECT paledger
         vrgar
         versi
         perio
         paobjnr
         pasubnr
         belnr
         posnr
         vv120
         vv122
         vv170
         vv142
         vv160
         vv161
         vv140
         vv120d
         vv122d
         vv170d
     FROM ce1tani
    INTO TABLE lt_ce1tani
    WHERE ( kstar EQ 'PADAGITIM'
       OR kstar EQ 'PADAGITIM2')
      AND perio EQ p_perio.

  SELECT kokrs
         kostl
         datbi
         objnr
    FROM csks
    INTO TABLE lt_csks
    FOR ALL ENTRIES IN lt_coss
    WHERE objnr EQ lt_coss-objnr.

  LOOP AT lt_setleaf INTO ls_setleaf.
    gt_report-setname = ls_setleaf-setname.
    LOOP AT lt_coss INTO ls_coss WHERE kstar EQ ls_setleaf-valform(10).
      lv_fname = 'WOG' && p_perio+4.

      ASSIGN COMPONENT lv_fname OF STRUCTURE ls_coss TO <fs>.
      IF <fs> IS ASSIGNED.
        gt_report-co_tutar = <fs>.
      ENDIF.
      READ TABLE lt_csks INTO ls_csks WITH KEY objnr = ls_coss-objnr.
      IF sy-subrc IS INITIAL.
        gt_report-kostl = ls_csks-kostl.
      ENDIF.
      LOOP AT lt_ce1tani INTO ls_ce1tani WHERE kostl EQ ls_csks-kostl.
        lv_fname = ls_setleaf-setname+4.
        ASSIGN COMPONENT lv_fname OF STRUCTURE ls_ce1tani TO <fs>.
        IF <fs> IS ASSIGNED.
          gt_report-pa_tutar = <fs>.
        ENDIF.
      ENDLOOP.

    ENDLOOP.




  ENDLOOP.




ENDFORM.              