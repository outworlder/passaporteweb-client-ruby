# encoding: utf-8
require 'spec_helper'

describe PassaporteWeb do

  it 'should have a version number' do
    PassaporteWeb::VERSION.should_not be_nil
  end

  describe 'configuration' do
    it 'should be done via block initialization' do
      PassaporteWeb.configure do |c|
        c.url = 'http://some/where'
        c.user_agent = 'My App v1.0'
        c.application_token = 'some-app-token'
        c.application_secret = 'some-app-secret'
        c.user_token = nil
      end
      PassaporteWeb.configuration.url.should == 'http://some/where'
      PassaporteWeb.configuration.user_agent.should == 'My App v1.0'
      PassaporteWeb.configuration.application_token.should == 'some-app-token'
      PassaporteWeb.configuration.application_secret.should == 'some-app-secret'
      PassaporteWeb.configuration.user_token.should be_nil
    end
    it 'should use a singleton object for the configuration values' do
      config1 = PassaporteWeb.configuration
      config2 = PassaporteWeb.configuration
      config1.should === config2
    end
  end

end
