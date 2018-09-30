class AdminController < ApplicationController
    layout 'admin'
    before_action -> { authenticate_role!(["admin"]) }
end