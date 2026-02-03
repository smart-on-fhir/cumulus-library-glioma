create table glioma__cohort_rx_chemo as 
select distinct * from 
 glioma__cohort_study_population_rx , 
glioma__valueset_rx_chemo
WHERE
glioma__cohort_study_population_rx.rx_code = glioma__valueset_rx_chemo.code and 
glioma__cohort_study_population_rx.rx_system = glioma__valueset_rx_chemo.system