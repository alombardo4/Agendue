if @projects.count < 1
    json.shares ""
else
    json.array!(@projects) do |prj|
        workers = Array.new()
        prj.allshares.split(",").each do |shr|
            tempuser = User.find_by_id(shr)
            if tempuser
                workers << tempuser.firstname + " " + tempuser.lastname
            end
        end
        workers.sort! { |a, b| a.downcase <=> b.downcase }
        sharedwith = ""
        workers.each do |worker|
            sharedwith = sharedwith + "," + worker
        end
        json.id prj.id
        json.name prj.name
        json.projectid prj.projectid
        json.users prj.users
        json.shares prj.shares
        json.allshares sharedwith
    end
end