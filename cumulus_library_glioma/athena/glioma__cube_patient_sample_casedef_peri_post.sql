CREATE or replace VIEW glioma__cube_patient_sample_casedef_peri_post AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."fhir_resource",
            s."note_code",
            s."note_display",
            s."note_system"
            --noqa: enable=RF03, AL02
        FROM glioma__sample_casedef_peri_post AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
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

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system",
            concat_ws(
                '-',
                COALESCE("fhir_resource",''),
                COALESCE("note_code",''),
                COALESCE("note_display",''),
                COALESCE("note_system",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "fhir_resource",
            "note_code",
            "note_display",
            "note_system"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."fhir_resource",
        p."note_code",
        p."note_display",
        p."note_system"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;