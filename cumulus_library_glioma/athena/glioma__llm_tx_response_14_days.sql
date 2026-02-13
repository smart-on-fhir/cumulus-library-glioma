create or replace view glioma__llm_tx_response_14_days as
select * from glioma__llm_tx_response where response_days_since_tx >= 14
;