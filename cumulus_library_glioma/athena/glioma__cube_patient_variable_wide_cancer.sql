CREATE or replace VIEW glioma__cube_patient_variable_wide_cancer AS 
    WITH
    null_replacement AS (
        SELECT
            subject_ref,
            coalesce(
                cast(dx_brain_tumor AS varchar),
                'cumulus__none'
            ) AS dx_brain_tumor,
            coalesce(
                cast(dx_cancer AS varchar),
                'cumulus__none'
            ) AS dx_cancer,
            coalesce(
                cast(rx_cancer_directed AS varchar),
                'cumulus__none'
            ) AS rx_cancer_directed,
            coalesce(
                cast(rx_chemo AS varchar),
                'cumulus__none'
            ) AS rx_chemo,
            coalesce(
                cast(rx_chemo_advanced AS varchar),
                'cumulus__none'
            ) AS rx_chemo_advanced,
            coalesce(
                cast(rx_chemo_bevacizumab AS varchar),
                'cumulus__none'
            ) AS rx_chemo_bevacizumab,
            coalesce(
                cast(rx_chemo_platinum AS varchar),
                'cumulus__none'
            ) AS rx_chemo_platinum,
            coalesce(
                cast(rx_chemo_platinum_carboplatin AS varchar),
                'cumulus__none'
            ) AS rx_chemo_platinum_carboplatin,
            coalesce(
                cast(rx_chemo_vincristine AS varchar),
                'cumulus__none'
            ) AS rx_chemo_vincristine
        FROM glioma__cohort_variable_wide
        
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "dx_brain_tumor",
            "dx_cancer",
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine",
            concat_ws(
                '-',
                COALESCE("dx_brain_tumor",''),
                COALESCE("dx_cancer",''),
                COALESCE("rx_cancer_directed",''),
                COALESCE("rx_chemo",''),
                COALESCE("rx_chemo_advanced",''),
                COALESCE("rx_chemo_bevacizumab",''),
                COALESCE("rx_chemo_platinum",''),
                COALESCE("rx_chemo_platinum_carboplatin",''),
                COALESCE("rx_chemo_vincristine",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "dx_brain_tumor",
            "dx_cancer",
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
            p."dx_brain_tumor",
            p."dx_cancer",
            p."rx_cancer_directed",
            p."rx_chemo",
            p."rx_chemo_advanced",
            p."rx_chemo_bevacizumab",
            p."rx_chemo_platinum",
            p."rx_chemo_platinum_carboplatin",
            p."rx_chemo_vincristine"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;