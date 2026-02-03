CREATE or replace VIEW glioma__cube_patient_study_population_doc AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(doc_status AS varchar),
                'cumulus__none'
            ) AS doc_status,
            coalesce(
                cast(doc_type_code AS varchar),
                'cumulus__none'
            ) AS doc_type_code,
            coalesce(
                cast(doc_type_display AS varchar),
                'cumulus__none'
            ) AS doc_type_display,
            coalesce(
                cast(doc_type_system AS varchar),
                'cumulus__none'
            ) AS doc_type_system,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code
        FROM glioma__cohort_study_population_doc
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "doc_status",
            "doc_type_code",
            "doc_type_display",
            "doc_type_system",
            "enc_class_code",
            concat_ws(
                '-',
                COALESCE("doc_status",''),
                COALESCE("doc_type_code",''),
                COALESCE("doc_type_display",''),
                COALESCE("doc_type_system",''),
                COALESCE("enc_class_code",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "doc_status",
            "doc_type_code",
            "doc_type_display",
            "doc_type_system",
            "enc_class_code"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."doc_status",
            p."doc_type_code",
            p."doc_type_display",
            p."doc_type_system",
            p."enc_class_code"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;