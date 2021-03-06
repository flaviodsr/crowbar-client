#
# Copyright 2015, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "hashie"
require "active_support/number_helper"

module Crowbar
  module Client
    module Command
      #
      # Base that provides methods shared between command implementations
      #
      class Base
        include ActiveSupport::NumberHelper

        attr_accessor :stdin
        attr_accessor :stdout
        attr_accessor :stderr
        attr_accessor :options
        attr_accessor :args

        def initialize(stdin, stdout, stderr, options = {}, args = {})
          self.stdin = stdin
          self.stdout = stdout
          self.stderr = stderr

          self.options = Hashie::Mash.new(
            options
          )

          self.args = Hashie::Mash.new(
            args
          )

          checks
        end

        protected

        def checks
        end

        def say(message)
          stdout.puts message
        end

        def err(message)
          if message.is_a?(RestClient::Response)
            begin
              json = JSON.parse(message.to_s)
              message = json.fetch("error", message)
            rescue JSON::ParserError
              # too bad, this is not what we expected, we'll print the ugly string
              nil
            end
          end
          raise SimpleCatchableError, message
        end
      end
    end
  end
end
