# Rails plugin initialization.

require 'recaptcha'
require 'net/http'
require 'recaptcha/rails'
require 'redmine'

to_prepare = Proc.new do
  require_dependency 'recaptcha/client_helper'
  require_dependency 'client_helper_patch'
  Recaptcha::ClientHelper.send(:include, ClientHelperPatch) 

  require_dependency 'account_controller'
  require_dependency 'account_controller_patch'
  AccountController.send(:include, AccountControllerPatch) 
  require_dependency 'issues_controller'
  require_dependency 'issues_controller_patch'
  IssuesController.send(:include, IssuesControllerPatch) 
end


if Redmine::VERSION::MAJOR >= 2
  Rails.configuration.to_prepare(&to_prepare)
else
  require 'dispatcher'
  Dispatcher.to_prepare(:redmine_recaptcha, &to_prepare)
end



Redmine::Plugin.register :redmine_recaptcha do
  name 'reCAPTCHA for user self registration'
  author 'Shane StClair'
  description 'Adds a recaptcha to the user self registration screen to combat spam'
  version '0.1.0'
  url 'http://github.com/srstclair/redmine_recaptcha'
  #requires_redmine :version_or_higher => '0.9.0'
  settings :default => {
     'recaptcha_private_key' => '',
     'recaptcha_public_key' => ''
  }, :partial => 'settings/redmine_recaptcha'

end

