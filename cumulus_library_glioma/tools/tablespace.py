from enum import Enum

# study prefix is the schema "root" or "tablespace" for tables in this study (glioma)
PREFIX = 'glioma'

class Reference(Enum):
    """
    https://docs.smarthealthit.org/cumulus/library/core-study-details.html
    """
    dx = 'condition'
    rx = 'medicationrequest'
    lab = 'observation_lab'
    obs = 'observation'
    proc = 'procedure'
    doc = 'documentreference'
    diag = 'diagnosticreport'
    pat = 'patient'
    enc = 'encounter'

    def aspect(self)-> str:
        return self.name

    def reference(self):
        if Reference.pat.name == self.name:
            return 'subject_ref'
        if Reference.lab.name == self.name:
            return 'observation_ref'
        return f"{self.value}_ref"

    def code(self)-> str:
        if Reference.doc.name == self.name:
            return 'doc_type_code'
        if Reference.lab.name == self.name:
            return 'lab_observation_code'
        return f"{self.name}_code"

    def system(self)-> str:
        if Reference.doc.name == self.name:
            return 'doc_type_system'
        if Reference.lab.name == self.name:
            return 'lab_observation_system'
        return f"{self.name}_system"

#-----------------------------------------------------------------------------
# get Reference Enum
#-----------------------------------------------------------------------------
_REF_KEYS = [str(ref.name) for ref in Reference]
def get_reference(table:str) -> Reference:
    lookup = name_trim(table)
    tokens = set(lookup.split('_'))
    match = tokens.intersection(_REF_KEYS)
    if not match:
        raise ValueError(f"Reference value {match} not found in table {table}")
    if len(match) > 1:
        raise ValueError(f"Reference value {match} multiple match types for table {table}")
    return Reference[match.pop()]

#-----------------------------------------------------------------------------
# naming conventions
#-----------------------------------------------------------------------------
def name_prefix(table: list | str) -> list | str:
    if isinstance(table, list):
        return [f'{PREFIX}__{table}' for table in sorted(set(table))]
    else:
        return f'{PREFIX}__{table}'

def name_suffix(name: str, suffix=None) -> str:
    return f'{name}_{suffix}' if suffix else name

def name_trim(table) -> str:
    simple = table
    for part in ['cohort_', 'cube_', 'valueset_']:
        simple = simple.replace(part, '')
    return simple.replace(name_prefix(''), '')

def name_join(part: str, table: str) -> str:
    return name_prefix('_'.join([part, name_trim(table)]))

def name_sample(table: str, suffix=None) -> str:
    part = name_suffix('sample', suffix)
    return name_join(part, table)

def name_cohort(table: str, suffix=None) -> str:
    part = name_suffix('cohort', suffix)
    return name_join(part, table)

def name_study_population(suffix=None) -> str:
    table = name_suffix('study_population', suffix)
    return name_join('cohort', table)

def name_cube(table: str, suffix: str = None) -> str:
    part = f'cube_{suffix}' if suffix else 'cube'
    return name_join(part, table)

def name_valueset(table: str, suffix=None) -> str:
    part = f'valueset_{suffix}' if suffix else 'valueset'
    return name_join(part, table)

#-----------------------------------------------------------------------------
# Basic SQL to replace with JINJA Templates
#-----------------------------------------------------------------------------
def sql_list(clauses_list) -> str:
    return sql_iter(clauses_list, ',')

def sql_and(clauses_list) -> str:
    return sql_iter(clauses_list, 'and')

def sql_iter(clauses_list, operator=',') -> str:
    if not isinstance(clauses_list, list):
        return sql_iter([clauses_list])
    return f' {operator} \n'.join(sorted(list(set(clauses_list))))

#-----------------------------------------------------------------------------
# CTAS (create table as)
#-----------------------------------------------------------------------------
def ctas(source: str, variable: str, where: list) -> str:
    """
    CTAS(create table as) will create a COHORT table as a subselection of the
    study population cohort table.

    :param source: study population cohort source
    :param variable: variable cohort target to create
    :param where: JOIN study_population cohort to variable cohort
    :return: str SQL for creating the variable cohort table.
    """
    from_list = sql_list([source, name_valueset(variable)])
    cohort_name = name_cohort(variable)
    select = f"select distinct * from \n {from_list}"
    sql = [f'create table {cohort_name} as ',
           select, 'WHERE', sql_and(where)]
    return '\n'.join(sql)

def ctas_as_view(sql:str, table_name:str) -> str:
    """
    :param sql: CTAS (create table as)
    :param table_name: Table name to turn into a view
    :return: sql CVAS (create view as)
    """
    create_table = f'CREATE TABLE {table_name} AS ('
    replace_view = f'CREATE or replace VIEW {table_name} AS '
    return sql.replace(create_table, replace_view).replace(');', ';')
