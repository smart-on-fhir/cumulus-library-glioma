CREATE or replace VIEW glioma__cube_note_sample_casedef AS 
    WITH
    null_replacement AS (
        SELECT
            note_ref,
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
        FROM glioma__sample_casedef
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT note_ref) AS cnt_note_ref,
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
        p.cnt_note_ref AS cnt,
            p."fhir_resource",
            p."note_code",
            p."note_display",
            p."note_system"
    FROM powerset AS p
    WHERE 
        p.cnt_note_ref >= 10
;