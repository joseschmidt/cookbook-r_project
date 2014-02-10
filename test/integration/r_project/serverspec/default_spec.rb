# coding: utf-8
require 'spec_helper'

describe 'r_project::default' do
  os = backend(Serverspec::Commands::Base).check_os

  context yumrepo('epel') do
    it 'exists' do
      expect(subject).to exist
    end # it

    it 'is enabled' do
      expect(subject).to be_enabled
    end # it
  end if os[:family == 'RedHat']

  describe package('R') do
    case os[:family]
    when 'RedHat'
      if os[:release].to_f < 6.0
        it 'is installed with version 2.15.2-1.el5' do
          expect(subject).to be_installed.with_version('2.15.2-1.el5')
        end # it
      else
        it 'is installed with version 3.0.2-1.el6' do
          expect(subject).to be_installed.with_version('3.0.2-1.el6')
        end # it
      end # if
    else
      it 'is pending' do
        pending('TODO: add spec for other OS families')
      end # it
    end # case
  end # describe

  context command("echo 'library(qcc)' | R --vanilla --quiet") do
    it 'is installed (R qcc library)' do
      expect(subject).to return_exit_status(0)
    end # it
  end # context

end # describe
