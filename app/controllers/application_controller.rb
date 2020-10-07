class ApplicationController < ActionController::Base
    def test
        render plain: 'Testing this'
    end
end
