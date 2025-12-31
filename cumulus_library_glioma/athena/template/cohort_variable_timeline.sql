create      table $prefix__cohort_study_variables_timeline as
select      distinct
            wide.*                  ,
            status              	,
            age_at_visit        	,
            gender              	,
            race_display        	,
            ethnicity_display   	,
            enc_period_ordinal  	,
            enc_period_start_day	,
            enc_period_start_week	,
            enc_period_start_month	,
            enc_period_start_year	,
            enc_period_end_day  	,
            enc_class_code      	,
            enc_servicetype_code	,
            enc_servicetype_system	,
            enc_servicetype_display	,
            enc_type_code       	,
            enc_type_system     	,
            enc_type_display
from        $prefix__cohort_study_population        as population
left join   $prefix__cohort_study_variables_wide    as wide
on          population.encounter_ref = wide.encounter_ref
;