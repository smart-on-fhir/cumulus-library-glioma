create table glioma__cohort_dx_neuro as 
select distinct * from 
 glioma__cohort_study_population_dx , 
glioma__valueset_dx_neuro
WHERE
glioma__cohort_study_population_dx.dx_code = glioma__valueset_dx_neuro.code and 
glioma__cohort_study_population_dx.dx_system = glioma__valueset_dx_neuro.system