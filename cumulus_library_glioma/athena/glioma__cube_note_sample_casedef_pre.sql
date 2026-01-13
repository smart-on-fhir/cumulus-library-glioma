CREATE or replace VIEW glioma__cube_note_sample_casedef_pre AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            s.note_ref,
            e.class_display,
            --noqa: disable=RF03, AL02
            s."fhir_resource",
            s."note_code",
            s."note_display",
            s."note_system"
            --noqa: enable=RF03, AL02
        FROM glioma__sample_casedef_pre AS s
        INNER JOIN core__encounter AS e
            ON s.encounter_ref = e.encounter_ref
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
            note_ref,
            coalesce(
                cast(class_display AS varchar), 
                'cumulus__none'
            ) AS class_display,
            coalesce(
                cast(fhir_resource AS varchar),
                'cumulus__none'
            ) AS fhir_resource,
            coalesce(
                cast(note_code AS varchar),
                'cumulus__none'
            ) AS note_code,
            coalesce(
                cast(note_display AS varchar),
                'cumulus__none'
            ) AS note_display,
            coalesce(
                cast(note_system AS varchar),
                'cumulus__none'
            ) AS note_system
        FROM filtered_table
    ),
    secondary_powerset AS (
        SELECT
            count(DISTINCT note_ref) AS cnt_note_ref,
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system",
            class_display
            ,
            concat_ws(
                '-',
                COALESCE("fhir_resource",''),
                COALESCE("note_code",''),
                COALESCE("note_display",''),
                COALESCE("note_system",''),
                COALESCE(class_display,'')
                
            ) AS id
        FROM null_replacement
        WHERE note_ref IS NOT NULL
        GROUP BY
            cube(
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system",
            class_display
            
            )
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system",
            class_display
            ,
            concat_ws(
                '-',
                COALESCE("fhir_resource",''),
                COALESCE("note_code",''),
                COALESCE("note_display",''),
                COALESCE("note_system",''),
                COALESCE(class_display,'')
                
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system",
            class_display
            
            )
    )

    SELECT
        s.cnt_note_ref AS cnt,
        p."fhir_resource",
        p."note_code",
        p."note_display",
        p."note_system",
        p.class_display
    FROM powerset AS p
    JOIN secondary_powerset AS s on s.id = p.id
    WHERE 
        p.cnt_subject_ref >= 10
        AND s.cnt_note_ref >= 10
;