CREATE or replace VIEW glioma__cube_patient_variable_wide_rx AS 
    WITH
    filtered_table AS (
        SELECT
            s.subject_ref,
            --noqa: disable=RF03, AL02
            s."rx_cancer_directed",
            s."rx_chemo",
            s."rx_chemo_advanced",
            s."rx_chemo_bevacizumab",
            s."rx_chemo_platinum",
            s."rx_chemo_platinum_carboplatin",
            s."rx_chemo_vincristine",
            s."rx_endo_diabetes",
            s."rx_endo_therapy",
            s."rx_mtor_everolimus",
            s."rx_mtor_sirolimus"
            --noqa: enable=RF03, AL02
        FROM glioma__cohort_variable_wide AS s
    ),
    
    null_replacement AS (
        SELECT
            subject_ref,
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
            ) AS rx_chemo_vincristine,
            coalesce(
                cast(rx_endo_diabetes AS varchar),
                'cumulus__none'
            ) AS rx_endo_diabetes,
            coalesce(
                cast(rx_endo_therapy AS varchar),
                'cumulus__none'
            ) AS rx_endo_therapy,
            coalesce(
                cast(rx_mtor_everolimus AS varchar),
                'cumulus__none'
            ) AS rx_mtor_everolimus,
            coalesce(
                cast(rx_mtor_sirolimus AS varchar),
                'cumulus__none'
            ) AS rx_mtor_sirolimus
        FROM filtered_table
    ),

    powerset AS (
        SELECT
            count(DISTINCT subject_ref) AS cnt_subject_ref,
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine",
            "rx_endo_diabetes",
            "rx_endo_therapy",
            "rx_mtor_everolimus",
            "rx_mtor_sirolimus",
            concat_ws(
                '-',
                COALESCE("rx_cancer_directed",''),
                COALESCE("rx_chemo",''),
                COALESCE("rx_chemo_advanced",''),
                COALESCE("rx_chemo_bevacizumab",''),
                COALESCE("rx_chemo_platinum",''),
                COALESCE("rx_chemo_platinum_carboplatin",''),
                COALESCE("rx_chemo_vincristine",''),
                COALESCE("rx_endo_diabetes",''),
                COALESCE("rx_endo_therapy",''),
                COALESCE("rx_mtor_everolimus",''),
                COALESCE("rx_mtor_sirolimus",'')
            ) AS id
        FROM null_replacement
        GROUP BY
            cube(
            "rx_cancer_directed",
            "rx_chemo",
            "rx_chemo_advanced",
            "rx_chemo_bevacizumab",
            "rx_chemo_platinum",
            "rx_chemo_platinum_carboplatin",
            "rx_chemo_vincristine",
            "rx_endo_diabetes",
            "rx_endo_therapy",
            "rx_mtor_everolimus",
            "rx_mtor_sirolimus"
            )
    )

    SELECT
        p.cnt_subject_ref AS cnt,
        p."rx_cancer_directed",
        p."rx_chemo",
        p."rx_chemo_advanced",
        p."rx_chemo_bevacizumab",
        p."rx_chemo_platinum",
        p."rx_chemo_platinum_carboplatin",
        p."rx_chemo_vincristine",
        p."rx_endo_diabetes",
        p."rx_endo_therapy",
        p."rx_mtor_everolimus",
        p."rx_mtor_sirolimus"
    FROM powerset AS p
    WHERE 
        p.cnt_subject_ref >= 10
;