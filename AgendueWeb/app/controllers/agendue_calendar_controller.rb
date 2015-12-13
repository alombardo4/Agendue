class AgendueCalendarController < ApplicationController

  def show
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @user = User.find_by_id(session[:userid])
    @tasks = Task.all_tasks(@user.id)
    @personal_tasks = PersonalTask.all_personal_tasks(@user.id)
    @all_items = Array.new
    @all_items += @tasks
    @all_items += @personal_tasks
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def show_old
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @user = User.find_by_id(session[:userid])
    @tasks = Task.all_tasks(@user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def ics
    user = User.find_by_id(params[:id])
    puts params[:id]
    puts user.share_calendar
    if user && user.share_calendar
      @stringpath = Task.calendar_random_path(params[:id])
      if @stringpath != params[:hash]
        redirect_to landing_path
      end

      tasks = Task.all_tasks(user.id)
      @calendar = Icalendar::Calendar.new
      for task in tasks
        if task.duedate
          event = Icalendar::Event.new
          event.dtstart = Icalendar::Values::Date.new(task.duedate)
          event.dtstart.ical_params = { "VALUE" => "DATE" }
          event.summary = task.name
          event.description = task.description + "\n" + task_url(task.id)
          if tempuser = User.find_by_id(task.assignedto)
            event.attendee = "mailto:" + tempuser.name
          end
          @calendar.add_event(event)
        end
      end
      personal_tasks = PersonalTask.all_personal_tasks(user.id)
      for task in personal_tasks
        if task.duedate
          event = Icalendar::Event.new
          event.dtstart = Icalendar::Values::Date.new(task.duedate)
          event.dtstart.ical_params = { "VALUE" => "DATE" }
          event.summary = task.title
          event.description = task.description + "\n" + personal_task_url(task.id)
          event.attendee = "mailto:" + user.name
          @calendar.add_event(event)
        end
      end

      @calendar.publish
      headers['Content-Type'] = "text/calendar; charset=UTF-8"  # Google Calendar likes this!
      render :text => @calendar.to_ical
    else
      redirect_to landing_path
    end
  end
end
