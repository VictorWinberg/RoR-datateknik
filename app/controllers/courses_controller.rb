class CoursesController < ApplicationController
  include CoursesHelper

  # GET /courses
  # GET /courses.json
  def index
    @courses = parse('D', '16_17', 'sv')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.fetch(:course, {})
    end
end
