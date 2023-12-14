# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def action
    params[:action].to_sym
  end
end
