CLASS zcl_comment2code_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aia_action .
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    "DATA facade_on_ai_sdk TYPE REF TO lif_aia_facade_on_ai_sdk.
ENDCLASS.



CLASS zcl_comment2code_demo IMPLEMENTATION.

  METHOD constructor.

    "facade_on_ai_sdk = lcl_facade_on_ai_sdk=>create(  ).

  ENDMETHOD.


  METHOD if_aia_action~run.
    TRY.
        DATA(trigger_object) = CAST if_adt_context_src_based_obj( context->get_focused_resource(  ) ).

        "get selected comment
        DATA(position) = trigger_object->get_position(  ).
        IF position->is_cursor(  ).

          DATA(selected_lines) = trigger_object->get_selected_lines( ).

          DATA(user_prompt) = selected_lines[ 1 ].
        ELSE.
          user_prompt = trigger_object->get_exact_selection(  ).
        ENDIF.
      CATCH cx_adt_context_dynamic cx_adt_context_unauthorized.
        RETURN.
    ENDTRY.

    "DATA(result_from_ai) = facade_on_ai_sdk->ask_ai( user_prompt ).
    DATA(source_change_result) = cl_aia_result_factory=>create_source_change_result( ).
    IF trigger_object->get_object_info(  )-object_type-objtype_tr = 'DDLS'.
      source_change_result->add_code_insertion_delta( content = |{ cl_abap_char_utilities=>cr_lf }{ '*delta text added from IDE Action' }| cursor_position = position->get_end_position( ) ).
    ELSE.
      source_change_result->add_code_insertion_delta( content = |{ cl_abap_char_utilities=>newline }{ '*delta text added from IDE Action' }| cursor_position = position->get_end_position( ) ).
    ENDIF.
    result = source_change_result.

  ENDMETHOD.

ENDCLASS.
