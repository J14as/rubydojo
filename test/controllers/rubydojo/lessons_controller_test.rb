require "test_helper"

module Rubydojo
  class LessonsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "should get root (dashboard)" do
      get root_url
      assert_response :success
    end

    test "should get stylesheet" do
      get stylesheet_url
      assert_response :success
      assert_equal "text/css", response.media_type
    end

    test "should get show lesson" do
      get lesson_url(id: "variables")
      assert_response :success
    end

    test "should post run and return stdout and result" do
      post run_lesson_url(id: "variables"), params: { code: "puts 'hello'; 2 + 2" }, as: :json
      assert_response :success
      
      data = JSON.parse(response.body)
      assert_equal "hello\n", data["stdout"]
      assert_equal "4", data["result"]
      assert_nil data["error"]
    end

    test "should post validate and return success when code is valid" do
      valid_code = <<~RUBY
        age = 25
        PLANET = "Earth"
        def greet(name)
          "Hello, \#{name}!"
        end
      RUBY
      post validate_lesson_url(id: "variables"), params: { code: valid_code }, as: :json
      assert_response :success
      
      data = JSON.parse(response.body)
      assert data["success"]
      assert_nil data["error"]
    end

    test "should post validate and return failure when code is invalid" do
      invalid_code = <<~RUBY
        age = 12
      RUBY
      post validate_lesson_url(id: "variables"), params: { code: invalid_code }, as: :json
      assert_response :success
      
      data = JSON.parse(response.body)
      assert_not data["success"]
      assert_not_nil data["error"]
    end
  end
end
