class PagesController < ApplicationController
  def home
  end

  def secure
    unless user_signed_in?
      redirect_to root_path, flash: { error: 'Please sign in first.' }
    end
  end
end
