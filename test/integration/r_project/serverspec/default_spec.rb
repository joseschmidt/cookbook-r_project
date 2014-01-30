# coding: utf-8
require 'spec_helper'

describe 'r_project::default' do
  context yumrepo('epel') do
    it 'exists' do
      expect(subject).to exist
    end # it

    it 'is enabled' do
      expect(subject).to be_enabled
    end # it
  end # context

  context package('R') do
    it 'is installed' do
      expect(subject).to be_installed
    end # it
  end # context

  context command("echo 'library(qcc)' | R --vanilla --quiet") do
    it 'is installed (R qcc library)' do
      expect(subject).to return_exit_status(0)
    end # it
  end # context

end # describe
