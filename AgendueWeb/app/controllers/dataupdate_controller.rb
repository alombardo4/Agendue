class DataupdateController < ApplicationController
  skip_before_filter :authorize, :admin

    def updateprojectshares
        @newshare = Array.new()
        for project in Project.all
            if project
                oldshares = project.allshares.split(',')
                newshares = ","
                for share in oldshares
                    user = User.find_by_name(share)
                    if user
                        newid = String(User.find_by_name(share).id)
                        newshares = newshares + newid + ','
                    end
                end
                @newshare << newshares
                project.allshares = newshares
                project.save!
            end

        end
    end

    def updatetaskassign
        for task in Task.all
            if task
                oldassign = task.assignedto
                user = User.find_by_name(oldassign)
                if user
                    task.assignedto = user.firstname + " " + user.lastname
                    task.save!
                end
            end
        end
    end

    def updateuserprojectids
        updates = ''
        for user in User.all
            oldprojects = user.projectids.split(',')
            newids = ''
            oldprojects.each do |proj|
                project = Project.find_by_projectid(proj)
                if project
                    newids += String(project.id) +','
                end
            end
            updates += user.projectids + '-->'
            user.projectids = newids
            user.save!
            updates += user.projectids + '\n'
        end
        render :text => updates
    end

    def updatetaskprojectids
        updates = ''
        for task in Task.all
            project = Project.find_by_projectid(task.projectid)
            if project
                updates += String(task.projectid) + '->'
                task.projectid = project.id
                task.save!
                updates += String(task.projectid) + '//////'
            end
        end
        render :text => updates        
    end
end