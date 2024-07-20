*"* use this source file for your ABAP unit test classes

INTERFACE lif_person.
  DATA name TYPE string.
  DATA age  TYPE i.
ENDINTERFACE.


CLASS lcl_person DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_person.

    METHODS constructor IMPORTING VALUE(name) TYPE string
                                  VALUE(age)  TYPE i.
ENDCLASS.


CLASS lcl_person IMPLEMENTATION.
  METHOD constructor.
    lif_person~name = name.
    lif_person~age = age.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_02_internal_table DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS t01_01_new FOR TESTING.
    METHODS t01_02_new FOR TESTING.
    METHODS t01_03_new FOR TESTING.
    METHODS t01_04_new FOR TESTING.
    METHODS t01_05_new FOR TESTING.
    METHODS t01_06_new FOR TESTING.
    METHODS t01_07_new FOR TESTING.
    METHODS t01_08_new FOR TESTING.
    METHODS t01_09_new FOR TESTING.

ENDCLASS.


CLASS lcl_02_internal_table IMPLEMENTATION.
  METHOD t01_01_new.
    FINAL(dref) = NEW i( ).
    cl_aunit_assert=>assert_bound( dref ).
  ENDMETHOD.

  METHOD t01_02_new.
    FINAL(dref) = NEW i( 123 ).
    cl_aunit_assert=>assert_equals( exp = 123
                                    act = dref->* ).
  ENDMETHOD.

  METHOD t01_03_new.
    FINAL(dref) = NEW i( 123 ).
    dref->* = 234.
    cl_aunit_assert=>assert_equals( exp = 234
                                    act = dref->* ).
  ENDMETHOD.

  METHOD t01_04_new.
    FINAL(dref) = NEW i( 123 ).
    FINAL(dref_copy) = dref.
    dref_copy->* = 234.
    cl_aunit_assert=>assert_equals( exp = 234
                                    act = dref->* ).
  ENDMETHOD.

  METHOD t01_05_new.
    TYPES: BEGIN OF t_person,
             name TYPE string,
             age  TYPE i,
           END OF t_person.

    FINAL(person) = NEW t_person( name = 'John Doe'
                                  age  = '30' ).
    cl_aunit_assert=>assert_equals( exp = 'John Doe'
                                    act = person->name ).
    cl_aunit_assert=>assert_equals( exp = 30
                                    act = person->age ).
  ENDMETHOD.

  METHOD t01_06_new.
    TYPES: BEGIN OF t_person,
             name TYPE string,
             age  TYPE i,
           END OF t_person.
    TYPES tt_person TYPE STANDARD TABLE OF t_person WITH EMPTY KEY.

    FINAL(person) = NEW tt_person( ( name = 'John Doe' age = 30 )
                                   ( name = 'McDonald' age = 60 ) ).

    cl_aunit_assert=>assert_equals( exp = 'John Doe'
                                    act = person->*[ 1 ]-name ).
    cl_aunit_assert=>assert_equals( exp = 'McDonald'
                                    act = person->*[ 2 ]-name ).
    cl_aunit_assert=>assert_equals( exp = 30
                                    act = person->*[ 1 ]-age ).
    cl_aunit_assert=>assert_equals( exp = 60
                                    act = person->*[ 2 ]-age ).
  ENDMETHOD.

  METHOD t01_07_new.
    TYPES: BEGIN OF t_person,
             name TYPE string,
             age  TYPE i,
           END OF t_person.
    TYPES tt_person TYPE STANDARD TABLE OF REF TO t_person WITH EMPTY KEY.

    DATA(persons) = VALUE tt_person( ).
    INSERT NEW t_person( name = 'John Doe'
                         age  = 30 ) INTO TABLE persons.
    INSERT NEW t_person( name = 'McDonald'
                         age  = 60 ) INTO TABLE persons.

    cl_aunit_assert=>assert_equals( exp = 'John Doe'
                                    act = persons[ 1 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 'McDonald'
                                    act = persons[ 2 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 30
                                    act = persons[ 1 ]->age ).
    cl_aunit_assert=>assert_equals( exp = 60
                                    act = persons[ 2 ]->age ).
  ENDMETHOD.

  METHOD t01_08_new.
    TYPES tt_person TYPE STANDARD TABLE OF REF TO lif_person WITH EMPTY KEY.

    DATA(persons) = VALUE tt_person( ).
    INSERT NEW lcl_person( name = 'John Doe'
                           age  = 30 ) INTO TABLE persons.
    INSERT NEW lcl_person( name = 'McDonald'
                           age  = 60 ) INTO TABLE persons.

    cl_aunit_assert=>assert_equals( exp = 'John Doe'
                                    act = persons[ 1 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 'McDonald'
                                    act = persons[ 2 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 30
                                    act = persons[ 1 ]->age ).
    cl_aunit_assert=>assert_equals( exp = 60
                                    act = persons[ 2 ]->age ).
  ENDMETHOD.

  METHOD t01_09_new.
    TYPES tt_person TYPE STANDARD TABLE OF REF TO lif_person WITH EMPTY KEY.

    FINAL(persons) = VALUE tt_person( ( NEW lcl_person( name = 'John Doe'
                                                        age  = 30 ) )
                                      ( NEW
                                        lcl_person( name = 'McDonald'
                                                    age  = 60 ) ) ).

    cl_aunit_assert=>assert_equals( exp = 'John Doe'
                                    act = persons[ 1 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 'McDonald'
                                    act = persons[ 2 ]->name ).
    cl_aunit_assert=>assert_equals( exp = 30
                                    act = persons[ 1 ]->age ).
    cl_aunit_assert=>assert_equals( exp = 60
                                    act = persons[ 2 ]->age ).
  ENDMETHOD.
ENDCLASS.


CLASS lcl_02_internal_table_b DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS t01_01_value_base FOR TESTING.
ENDCLASS.


CLASS lcl_02_internal_table_b IMPLEMENTATION.
  METHOD t01_01_value_base.
    TYPES: BEGIN OF person,
             first_name TYPE string,
             last_name  TYPE string,
             age        TYPE i,
           END OF person.

    TYPES: BEGIN OF user,
             username   TYPE string,
             first_name TYPE string,
             last_name  TYPE string,
           END OF user.

    TYPES people TYPE STANDARD TABLE OF person WITH EMPTY KEY.
    TYPES users  TYPE STANDARD TABLE OF user WITH EMPTY KEY.

    FINAL(people) = VALUE people( ( first_name = '' last_name = 'Doe' age = 30 )
                                  ( first_name = 'Martin' last_name = 'Robert' age = 50 ) ).
    FINAL(users) = VALUE users( FOR p IN people
                                ( username   = p-first_name && ` ` &&  p-last_name
                                  first_name = p-first_name
                                  last_name  = p-last_name  ) ).


    cl_aunit_assert=>assert_equals(
        exp = VALUE users( ( username = 'John Doe' first_name = 'John' last_name = 'Doe' )
                           ( username = 'Martin Robert' first_name = 'Martin' last_name = 'Robert' ) )
        act = users ).
  ENDMETHOD.
ENDCLASS.
