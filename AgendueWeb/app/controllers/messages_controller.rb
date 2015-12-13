class MessagesController < ApplicationController
  before_filter :authorize
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # POST /messages
  # POST /messages.json
  def create
    if message_params[:content] == nil || message_params[:content] == ''
      redirect_to request.referrer, :flash => {:error => "You must enter a message"}
    else
      @message = Message.new(message_params)
      @message.projectid = session[:lastproj]
      @message.user = session[:userid]
      @message.content = message_params[:content]
      @message.subject = message_params[:subject]
      if @message.save
        send_notifications(@message)
        if request.referrer
          redirect_to request.referrer, notice: "Bulletin posted successfully."
        end
      else
        if request.referrer
          redirect_to request.referrer, :flash => {:error => "You must enter a message"}
        end
      end

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:user, :subject, :content)
    end

    def send_notifications(message)
      user = User.find_by_id(message.user)
      project = Project.find_by_id(message.projectid)
      project.allshares.split(',').each do |userid|
        if userid != user.id
          message = @message.content + " - " + user.firstname + " " + user.lastname
          subject = "A bulletin has been posted to " + project.name
          Notification.send_notifications_to_user(subject, message, project.id, userid)
        end
      end
    end
end
