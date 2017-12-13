#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Tests for `textnets` package."""

import os
from glob import glob
import pytest

from click.testing import CliRunner

from textnets import textnets, TextCorpus, Textnets
from textnets import cli


@pytest.fixture
def response():
    """Sample pytest fixture.

    See more at: http://doc.pytest.org/en/latest/fixture.html
    """
    # import requests
    # return requests.get('https://github.com/audreyr/cookiecutter-pypackage')


def test_content(response):
    """Sample pytest test function with the pytest fixture as an argument."""
    # from bs4 import BeautifulSoup
    # assert 'GitHub' in BeautifulSoup(response.content).title.string


def test_command_line_interface():
    """Test the CLI."""
    runner = CliRunner()
    result = runner.invoke(cli.main)
    assert result.exit_code == 0
    assert 'textnets.cli.main' in result.output
    help_result = runner.invoke(cli.main, ['--help'])
    assert help_result.exit_code == 0
    assert '--help  Show this message and exit.' in help_result.output

def test_sotu():

    corpus_files = glob(
            os.path.expanduser('~/nltk_data/corpora/state_union/*.txt'))[:5]

    c = TextCorpus(corpus_files)
    assert isinstance(c, TextCorpus)
    assert c._df.shape[0] == len(corpus_files)
    assert c._df.shape[1] == 3
    noun_phrases = c.noun_phrases()

    tn = Textnets(noun_phrases)
    g_groups = tn.graph(node_type='groups')
    g_words = tn.graph(node_type='words')
