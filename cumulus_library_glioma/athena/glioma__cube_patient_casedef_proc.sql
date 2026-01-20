CREATE or replace VIEW glioma__cube_patient_casedef_proc AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(enc_class_code AS varchar),
                'cumulus__none'
            ) AS enc_class_code,
            coalesce(
                cast(proc_code AS varchar),
                'cumulus__none'
            ) AS proc_code,
            coalesce(
                cast(proc_display AS varchar),
                'cumulus__none'
            ) AS proc_display,
            coalesce(
                cast(proc_status AS varchar),
                'cumulus__none'
            ) AS proc_status,
            coalesce(
                cast(proc_system AS varchar),
                'cumulus__none'
            ) AS proc_system
        FROM glioma__cohort_casedef_proc
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "enc_class_code",
            "proc_code",
            "proc_display",
            "proc_status",
            "proc_system",
            concat_ws(
                '-',
                COALESCE("enc_class_code",''),
                COALESCE("proc_code",''),
                COALESCE("proc_display",''),
                COALESCE("proc_status",''),
                COALESCE("proc_system",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "enc_class_code",
            "proc_code",
            "proc_display",
            "proc_status",
            "proc_system"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."enc_class_code",
            p."proc_code",
            p."proc_display",
            p."proc_status",
            p."proc_system"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;