*&---------------------------------------------------------------------*
*& Include ZROUTINES01
*&---------------------------------------------------------------------*
*TYPES : BEGIN OF ty_tlv ,
*          tag    TYPE n LENGTH 2,
*          length TYPE n LENGTH 3,
*          value  TYPE string,
*          hexa_v type xstring ,
*        END OF ty_tlv .
*
*TYPES : BEGIN OF ty_tlv_hex ,
*          tag    TYPE xstring,
*          length TYPE xstring,
*          value  TYPE xstring,
*        END OF ty_tlv_hex .
*
*DATA :gt_tlv TYPE TABLE OF ty_tlv ,
*      gs_tlv type  ty_tlv .
*
*DATA : gt_tlv_hex TYPE TABLE OF ty_tlv_hex,
*       gs_tlv_hex TYPE ty_tlv_hex.
*
*data : gv_final_hex type xstring ,
*       gv_final     type string .
*
********************** create TLV******************************
**- seller name
*gs_tlv-tag = 1 .
*gs_tlv-value = im_sname .
*gs_tlv-length = strlen( gs_tlv-value ) .
*BREAK xabap3 .
*
*PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
*PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
*PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .
*
*CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .
*
*APPEND gs_tlv TO gt_tlv .
*CLEAR : gs_tlv , gs_tlv_hex .
*
**-Tax number
*gs_tlv-tag = 2 .
*gs_tlv-value = im_taxnum .
*gs_tlv-length = strlen( gs_tlv-value ) .
*
*PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
*PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
*PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .
*
*CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .
*
*APPEND gs_tlv TO gt_tlv .
*CLEAR : gs_tlv , gs_tlv_hex .
*
**-date / time
**IF p_invtim > 0 .
**  CONCATENATE im_invdat 'T' into data(lv_date).
**  CONCATENATE _invtim 'Z' into data(lv_time) .
**  CONCATENATE lv_date lv_time INTO DATA(lv_dat_tim) SEPARATED BY '-'.
**ENDIF .
*
*gs_tlv-tag = 3 .
*gs_tlv-value = im_time_stamp ."lv_dat_tim .
*gs_tlv-length = strlen( gs_tlv-value ) .
*
*PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
*PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
*PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .
*
*CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .
*
*APPEND gs_tlv TO gt_tlv .
*CLEAR : gs_tlv , gs_tlv_hex .
*
*
**- total amount
*gs_tlv-tag = 4 .
*gs_tlv-value =  im_totam .
*gs_tlv-length = strlen( gs_tlv-value ) .
*
*PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
*PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
*PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .
*
*CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .
*
*APPEND gs_tlv TO gt_tlv .
*CLEAR : gs_tlv , gs_tlv_hex .
*
**- tax amount
*gs_tlv-tag = 5 .
*gs_tlv-value =  im_taxam .
*gs_tlv-length = strlen( gs_tlv-value ) .
*
*PERFORM dec_to_hexa USING gs_tlv-tag CHANGING gs_tlv_hex-tag .
*PERFORM dec_to_hexa USING gs_tlv-length CHANGING gs_tlv_hex-length .
*PERFORM string_to_hexa USING gs_tlv-value CHANGING gs_tlv_hex-value .
*
*CONCATENATE gs_tlv_hex-tag gs_tlv_hex-length gs_tlv_hex-value into gs_tlv-hexa_v in BYTE MODE .
*
*APPEND gs_tlv TO gt_tlv .
*CLEAR : gs_tlv , gs_tlv_hex .
*break xabap3 .
*
**- get seial hexa line
*loop at gt_tlv into gs_tlv .
*   CONCATENATE gv_final_hex gs_tlv-hexa_v into gv_final_hex IN BYTE MODE .
*  ENDLOOP .
*
*PERFORM to_base64 USING gv_final_hex CHANGING gv_final .

*&convert decimal to hexa
form dec_to_hexa using p_dec type n
                 CHANGING p_xstr type xstring .

  CALL METHOD cl_trex_utility=>conv_dec_to_hex
    EXPORTING
      dec    = p_dec
    receiving
      hex    = p_xstr .

ENDFORM .
*& convert string to hexa
FORM string_to_hexa USING p_str TYPE string
                  CHANGING p_xstr TYPE xstring .

  DATA mimetype(50) VALUE  'text/plain; charset=utf-8'.

  CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
    EXPORTING
      text     = p_str
      mimetype = mimetype
*     ENCODING =
    IMPORTING
      buffer   = p_xstr
    EXCEPTIONS
      failed   = 1
      OTHERS   = 2.

*cl_abap_conv_out_ce=>create( encoding = 'UTF-8' )->convert(
*  EXPORTING data = v1
*  IMPORTING buffer = v2 ).
ENDFORM .
*& convert to base64
FORM to_base64 USING p_xstr TYPE xstring
               CHANGING p_base64 TYPE string  .

  CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
    EXPORTING
      input  = p_xstr
    IMPORTING
      output = p_base64.

ENDFORM .
