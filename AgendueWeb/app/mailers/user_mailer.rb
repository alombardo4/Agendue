class UserMailer < ActionMailer::Base
  default from: "welcome@agendue.com"

  def template_email(user_id, message, subject)
    @message = message
    @user = User.find_by_id(user_id)
    @subject = subject
    mail(to: @user.name, from: "no-reply@agendue.com", subject: subject)
  end

  def welcome_email(user)
  	@user = user
  	@url = login_path
  	mail(to: @user.name, from: "welcome@agendue.com", subject: 'Welcome to Agendue')
  end

  def new_share_email(share_email_params)
  	@newemail = share_email_params[:newname]
  	@oldemail = share_email_params[:oldname]
    @project = share_email_params[:project]
  	mail(to: @newemail, from: "sharing@agendue.com", subject: 'A Project has been shared with you on Agendue')
  end

  def existing_share_email(share_email_params)
  	@newemail = share_email_params[:newname]
  	@oldemail = share_email_params[:oldname]
    @project = share_email_params[:project]
  	mail(to: @newemail, from: "sharing@agendue.com", subject: 'A Project has been shared with you on Agendue')
  end

  def password_reset(reset_pass_params)
    @email = reset_pass_params[:name]
    @pass = reset_pass_params[:password]
    mail(to: @email, from: "passwordreset@agendue.com", subject: 'Your password for Agendue has been reset')
  end

  def task_assigned_email(task_assigned_params)
    @email = task_assigned_params[:assignee]
    @task = task_assigned_params[:task]
    @project = task_assigned_params[:project]
    mail(to: @email, from: "assigned@agendue.com", subject: 'A Task has been assigned to you on Agendue')
  end

  def completed_task_email(completed_task_params)
    @task = completed_task_params[:task]
    @project = completed_task_params[:project]
    @email = completed_task_params[:email]
    mail(to: @email, from: "completed@agendue.com", subject: 'A Task has been completed on Agendue')
  end

  def send_admin_email(email)
    @stats = email[:stats]
    mail(to: email[:address], from: 'site@agendue.com', subject: 'Here\'s your damned stats.')
  end
end
