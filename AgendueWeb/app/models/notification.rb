class Notification < ActiveRecord::Base

  def self.send_notifications_to_user(subject, message, project_id, user_id)
    user = User.find_by_id(user_id)
    if user && !User.is_project_muted(user_id, project_id)
      #send device notifications
      if user.deviceids
        for device in user.deviceids.split(",")
          realDevice = Device.find_by_id(device)

          notif = Notification.new
          notif.message = message
          notif.subject = subject
          notif.device_token = realDevice.token
          notif.notification_os = realDevice.os
          notif.user_id = user_id
          notif.project_id = project_id
          notif.save

          Notification.send_device_notification(notif.notification_os, notif.device_token, notif.message)


          # :message, :device_token, :notification_os, :project_id, :user_id
        end
      end

      #send email notifications
      if !user.noemail
        notif = Notification.new
        notif.message = message
        notif.subject = subject
        notif.device_token = nil
        notif.notification_os = "email"
        notif.user_id = user_id
        notif.project_id = project_id
        notif.save
        Notification.send_email(notif.user_id, notif.message, notif.subject)
      end
    end
  end

  def self.send_device_notification(device_os, device_token, message)
    if device_os == "ios"
      Notification.send_ios(device_token, message)
    elsif device_os == "android"
      Notification.send_android(device_token, message)
    end
  end

  def self.send_ios(deviceToken, message)
    Thread.new do
      puts "Sending iOS"
      APNS.host = 'gateway.push.apple.com'

      APNS.pem = '' #path to pem file
      APNS.port = 2195
      APNS.send_notification(deviceToken, message )
      ActiveRecord::Base.connection.close

    end
  end

  def self.send_android(deviceToken, message)
    Thread.new do
      gcm = GCM.new("")
      registration_id = Array.new()
      registration_id << deviceToken
      options = {
        'data' => {
          'message' => message
        }
      }
      response = gcm.send_notification(registration_id, options)
      Rails.logger.info response
      ActiveRecord::Base.connection.close
    end
  end

  def self.send_email(user_id, message, subject)
    Thread.new do
      UserMailer.template_email(user_id, message, subject).deliver
      ActiveRecord::Base.connection.close
    end
  end

end
