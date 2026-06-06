module Rubydojo
  class DashboardController < ApplicationController
    def index
      @lessons = Rubydojo::Lesson.all
      @completed_lessons = session[:completed_lessons] || []
      @progress_percent = if @lessons.any?
        ((@completed_lessons.size.to_f / @lessons.size) * 100).round
      else
        0
      end
    end
  end
end
