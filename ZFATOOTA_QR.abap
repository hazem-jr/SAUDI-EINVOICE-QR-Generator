FUNCTION ZFATOORA_QR.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IM_SNAME) TYPE  STRING
*"     REFERENCE(IM_TAXNUM) TYPE  STRING
*"     REFERENCE(IM_TIME_STAMP) TYPE  STRING
*"     REFERENCE(IM_TOTAM) TYPE  STRING
*"     REFERENCE(IM_TAXAM) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(EX_QRCODE) TYPE  STRING
*"----------------------------------------------------------------------
TYPES : BEGIN OF ty_tlv ,
          tag    TYPE n LENGTH 2,
          length TYPE n LENGTH 3,
          value  TYPE string,
          hexa_v type xstring ,
        END OF ty_tlv .

TYPES : BEGIN OF ty_tlv_hex ,
          tag    TYPE xstring,
          length TYPE xstring,
          value  TYPE xstring,
        END OF ty_tlv_hex .

DATA :gt_tlv TYPE TABLE OF ty_tlv ,
      gs_tlv type  ty_tlv .

DATA : gt_tlv_hex TYPE TABLE OF ty_tlv_hex,
       gs_tlv_hex TYPE ty_tlv_hex.

data : gv_final_hex type xstring ,
       gv_final     type string .


********************** create TLV******************************
*- seller name
gs_tlv-tag = 1 .
gs_tlv-value = im_sname .
gs_tlv-length = strlen( gs_tlv-value ) .
BREAK xabap3 .

PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .

CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .

APPEND gs_tlv TO gt_tlv .
CLEAR : gs_tlv , gs_tlv_hex .

*-Tax number
gs_tlv-tag = 2 .
gs_tlv-value = im_taxnum .
gs_tlv-length = strlen( gs_tlv-value ) .

PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .

CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .

APPEND gs_tlv TO gt_tlv .
CLEAR : gs_tlv , gs_tlv_hex .

*-date / time
*IF p_invtim > 0 .
*  CONCATENATE im_invdat 'T' into data(lv_date).
*  CONCATENATE _invtim 'Z' into data(lv_time) .
*  CONCATENATE lv_date lv_time INTO DATA(lv_dat_tim) SEPARATED BY '-'.
*ENDIF .

gs_tlv-tag = 3 .
gs_tlv-value = im_time_stamp ."lv_dat_tim .
gs_tlv-length = strlen( gs_tlv-value ) .

PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .

CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .

APPEND gs_tlv TO gt_tlv .
CLEAR : gs_tlv , gs_tlv_hex .


*- total amount
gs_tlv-tag = 4 .
gs_tlv-value =  im_totam .
gs_tlv-length = strlen( gs_tlv-value ) .

PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .

CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .

APPEND gs_tlv TO gt_tlv .
CLEAR : gs_tlv , gs_tlv_hex .

*- tax amount
gs_tlv-tag = 5 .
gs_tlv-value =  im_taxam .
gs_tlv-length = strlen( gs_tlv-value ) .

PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .

CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .

APPEND gs_tlv TO gt_tlv .
CLEAR : gs_tlv , gs_tlv_hex .
break xabap3 .

*- get seial hexa line
loop at gt_tlv into gs_tlv .
   CONCATENATE gv_final_hex gs_tlv-hexa_v into gv_final_hex IN BYTE MODE .
  ENDLOOP .

PERFORM to_base64 USING gv_final_hex CHANGING gv_final .

ex_qrcode = gv_final .

ENDFUNCTION.
