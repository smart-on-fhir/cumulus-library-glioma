import pathlib
from unittest import mock

import pytest
import sqlglot

import cumulus_library
from cumulus_library_glioma.nlp_result_to_highlights import (
    builder_glioma_highlights as builder_module,
)

@pytest.fixture()
def builder():
    return builder_module.GliomaHighlightsBuilder()

@pytest.fixture()
def database():
    return mock.Mock(name="database")


@pytest.fixture()
def source_tables():
    return [
        "glioma__nlp_gpt4o",
        "glioma__nlp_gpt5",
        "glioma__nlp_gpt_oss_120b",
        "glioma__nlp_llama4_scout",
        "glioma__nlp_claude_sonnet45",
    ]


def test_is_table_valid_delegates_to_sql_utils(database, builder):
    # Mock the is_field_present function to always return True
    with mock.patch.object(
        builder_module.sql_utils, "is_field_present", return_value=True
    ) as mock_is_field_present:
        result = builder._is_table_valid(database, "glioma__nlp_gpt5")

    assert result 
    mock_is_field_present.assert_called_once_with(
        database=database,
        source_table="glioma__nlp_gpt5",
        source_col="result",
        expected={},
)


def test_get_valid_tables_no_available_tables(database, builder, source_tables):
    def is_table_valid(*_):
        return False

    with mock.patch.object(
        builder, "_is_table_valid", side_effect=is_table_valid
    ) as mock_is_table_valid:
        valid_tables = builder._get_valid_glioma_nlp_tables(database)

    assert valid_tables == set()
    assert [call.args for call in mock_is_table_valid.call_args_list] == [
        (database, table_name) for table_name in source_tables
    ]


def test_get_valid_tables_available_but_not_in_source(database, builder, source_tables):
    # Available table(s) that do not overlap with the source list
    available_tables = set("some_other_table")

    def is_table_valid(_, table_name):
        return table_name in available_tables

    with mock.patch.object(
        builder, "_is_table_valid", side_effect=is_table_valid
    ) as mock_is_table_valid:
        valid_tables = builder._get_valid_glioma_nlp_tables(database)

    # No intersection with source_tables -> empty result
    assert valid_tables == set()
    assert [call.args for call in mock_is_table_valid.call_args_list] == [
        (database, table_name) for table_name in source_tables
    ]


def test_get_valid_tables_filters_to_available_sources(database, builder, source_tables):
    # Available table(s) that do overlap with the source list
    available_tables = set([
        source_tables[0],
        source_tables[2],
        source_tables[4]
    ])

    def is_table_valid(_, table_name):
        return table_name in available_tables

    with mock.patch.object(
        builder, "_is_table_valid", side_effect=is_table_valid
    ) as mock_is_table_valid:
        valid_tables = builder._get_valid_glioma_nlp_tables(database)

    assert valid_tables == available_tables
    # Check that we checked for all source_tables
    assert [call.args for call in mock_is_table_valid.call_args_list] == [
        (database, table_name) for table_name in source_tables
    ]

def test_prepare_queries_appends_template_from_valid_tables(database, builder):
    # Build a bogus config with our mock database
    config = cumulus_library.StudyConfig(
        db=database,
        schema="placeholder_schema",
    )
    valid_tables = {"glioma__nlp_gpt5"}
    rendered_query = "select * from glioma__nlp_gpt5"
    
    # Mock methods downstream of prepare_queries before calling it
    with mock.patch.object(
        builder,
        "_get_valid_glioma_nlp_tables",
        return_value=valid_tables,
    ) as mock_get_valid_glioma_nlp_tables, mock.patch.object(
        builder_module.cumulus_library,
        "get_template",
        return_value=rendered_query,
    ) as mock_get_template:
        builder.prepare_queries(config=config)

    # Confirm that we called _get_valid_glioma_nlp_tables with the correct database
    mock_get_valid_glioma_nlp_tables.assert_called_once_with(config.db)
    
    # Confirm that we called get_template with the correct parameters
    expected_template_dir = pathlib.Path(builder_module.__file__).parent
    mock_get_template.assert_called_once_with(
        "glioma__highlights",
        expected_template_dir,
        table_names=valid_tables,
    )
    # Finally, confirm that the queries associated with the builder are as expected
    assert builder.queries == [rendered_query]

def test_prepare_queries_appended_sql_is_valid(database, builder):
    # Build a bogus config with our mock database
    config = cumulus_library.StudyConfig(
        db=database,
        schema="placeholder_schema",
    )
    valid_tables = {"glioma__nlp_gpt5"}
    
    # Mock methods downstream of prepare_queries before calling it
    with mock.patch.object(
        builder,
        "_get_valid_glioma_nlp_tables",
        return_value=valid_tables,
    ):
        builder.prepare_queries(config=config)

    # Use sqlglot parsing to confirm that the generated queries are syntactically valid and create
    # at least one table
    for query in builder.queries:  
        table = str(sqlglot.parse_one(query).find(sqlglot.exp.Table))
        assert table is not None
