*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT carrid connid cityfrom cityto
    INTO TABLE gtd_flights
    FROM spfli
    WHERE carrid IN s_carr.

ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CARRID'.
  gwa_fieldcat-seltext_l = 'Airline Code'.
  gwa_fieldcat-key       = 'X'. "Columna clave
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CONNID'.
  gwa_fieldcat-seltext_l = 'Flight Number'.
  gwa_fieldcat-key       = 'X'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CITYFROM'.
  gwa_fieldcat-seltext_l = 'Departure city'.
  gwa_fieldcat-outputlen = 20.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-fieldname = 'CITYTO'.
  gwa_fieldcat-seltext_l = 'Arrival city'.
  gwa_fieldcat-outputlen = 20.
  APPEND gwa_fieldcat TO gtd_fieldcat.


ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv_list .

  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET       = ' '
*     I_CALLBACK_USER_COMMAND        = ' '
*     I_STRUCTURE_NAME   =
      is_layout          = gwa_layout
      it_fieldcat        = gtd_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
      it_events          = gtd_events
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN          = 0
*     I_SCREEN_START_LINE            = 0
*     I_SCREEN_END_COLUMN            = 0
*     I_SCREEN_END_LINE  = 0
*     IR_SALV_LIST_ADAPTER           =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER        =
*     ES_EXIT_CAUSED_BY_USER         =
    TABLES
      t_outtab           = gtd_flights
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
    WRITE 'Exception error'.
  ENDIF.


ENDFORM.                    " DISPLAY_ALV_LIST

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .

  CLEAR: gwa_layout.
  gwa_layout-zebra = 'X'.

ENDFORM.                    " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  ADD_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM add_events .

  CLEAR: gwa_events.
  gwa_events-name = 'TOP_OF_PAGE'.
  gwa_events-form = 'TOP_OF_PAGE'.
  APPEND gwa_events TO gtd_events.

  CLEAR: gwa_events.
  gwa_events-name = 'PF_STATUS_SET'.
  gwa_events-form = 'PF_STATUS_SET'.
  APPEND gwa_events TO gtd_events.
  
  CLEAR: gwa_events.
  gwa_events-name = 'USER_COMMAND'.
  gwa_events-form = 'USER_COMMAND'.
  APPEND gwa_events TO gtd_events.

ENDFORM.                    " ADD_EVENTS

FORM top_of_page.

  WRITE: / 'Hour:', sy-uzeit ENVIRONMENT TIME FORMAT,
         / 'User:', sy-uname.

ENDFORM.


FORM user_command USING p_ucomm    LIKE sy-ucomm
                        p_selfield TYPE slis_selfield.

  IF p_ucomm EQ '&INF'.
    MESSAGE 'Detalles del vuelo' TYPE'I'.
  ENDIF.

ENDFORM.

FORM pf_status_set USING rt_extab TYPE slis_t_extab.

  SET PF-STATUS 'STATUS_0100'.

ENDFORM.