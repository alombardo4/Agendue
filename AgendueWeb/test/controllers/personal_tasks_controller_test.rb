require 'test_helper'

class PersonalTasksControllerTest < ActionController::TestCase
  setup do
    @personal_task = personal_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personal_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create personal_task" do
    assert_difference('PersonalTask.count') do
      post :create, personal_task: { complete: @personal_task.complete, description: @personal_task.description, duedate: @personal_task.duedate, title: @personal_task.title, userid: @personal_task.userid }
    end

    assert_redirected_to personal_task_path(assigns(:personal_task))
  end

  test "should show personal_task" do
    get :show, id: @personal_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @personal_task
    assert_response :success
  end

  test "should update personal_task" do
    patch :update, id: @personal_task, personal_task: { complete: @personal_task.complete, description: @personal_task.description, duedate: @personal_task.duedate, title: @personal_task.title, userid: @personal_task.userid }
    assert_redirected_to personal_task_path(assigns(:personal_task))
  end

  test "should destroy personal_task" do
    assert_difference('PersonalTask.count', -1) do
      delete :destroy, id: @personal_task
    end

    assert_redirected_to personal_tasks_path
  end
end
