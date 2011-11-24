require 'i18n'
require 'active_support/core_ext/string'
require 'active_support/core_ext/object'
require 'billing/version'
require 'billing/cost'
require 'billing/helpers'
require 'billing/tab'
require 'billing/errors'
require 'billing/extensions'

module Billing
  mattr_accessor :calculators
  self.calculators = []
end
