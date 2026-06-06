module Rubydojo
  class LessonsController < ApplicationController
    before_action :find_lesson, only: [:show, :run, :validate]

    def show
      @completed_lessons = session[:completed_lessons] || []
      @is_completed = @completed_lessons.include?(@lesson.id.to_s)
    end

    def run
      code = params[:code].to_s
      eval_result = evaluate_ruby(code)
      
      render json: {
        stdout: eval_result[:stdout],
        result: eval_result[:result],
        error: eval_result[:error]
      }
    end

    def validate
      code = params[:code].to_s
      validation_code = @lesson.validation_code
      
      eval_result = evaluate_ruby(code, validation_code)
      
      if eval_result[:error].nil?
        # Mark lesson as completed
        session[:completed_lessons] ||= []
        unless session[:completed_lessons].include?(@lesson.id.to_s)
          session[:completed_lessons] << @lesson.id.to_s
        end
        
        render json: {
          success: true,
          stdout: eval_result[:stdout],
          result: eval_result[:result]
        }
      else
        render json: {
          success: false,
          error: eval_result[:error],
          stdout: eval_result[:stdout]
        }
      end
    end

    private

    def find_lesson
      @lesson = Rubydojo::Lesson.find(params[:id])
      unless @lesson
        redirect_to root_path, alert: "Lesson not found."
      end
    end

    def evaluate_ruby(user_code, validation_code = nil)
      require "stringio"

      stdout_io = StringIO.new
      original_stdout = $stdout
      $stdout = stdout_io

      error = nil
      result = nil

      # Create an isolated sandbox class and instance to prevent global namespace/constant pollution
      sandbox_class = Class.new
      sandbox_class.class_eval do
        def get_binding
          binding
        end
      end
      sandbox_instance = sandbox_class.new
      eval_binding = sandbox_instance.get_binding

      begin
        # Evaluate user code
        result = eval(user_code, eval_binding, "(user_code)", 1)

        # Evaluate validation code if provided
        if validation_code.present?
          eval(validation_code, eval_binding, "(validation_code)", 1)
        end
      rescue Exception => e
        error = e.message
      ensure
        # Restore stdout
        $stdout = original_stdout
      end

      {
        stdout: stdout_io.string,
        result: result.inspect,
        error: error
      }
    end
  end
end
