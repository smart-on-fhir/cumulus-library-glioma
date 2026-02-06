create or replace view glioma__cohort_casedef_tx_response_30_days as
select * from glioma__cohort_casedef_tx_response where response_days_since_tx >= 30



