class EventCreator
  
  def self.create!(event_record)
    puts "Title: #{event_record["title"].inspect}"
    event = Event.create(form_event_object(event_record))

    if event_record["users#rsvp"]
      rsvps = event_record["users#rsvp"].split(';').map {|i| k = i.split('#'); {user_name: k[0], status: k[1]} }      

      rsvps.each do |entry|      
        user = User.find_by username: entry[:user_name]        
        user_events = user.events
        
        user_events.each do |u_event|
          if same_start_and_end_time?(u_event, event)
            update_event_since_conflicting(u_event, user)
          end

          if conflicting_time?(u_event, event)
            update_event_since_conflicting(u_event, user)
          end
        end

        meeting = Meeting.create(event: event, user: user, rsvp: entry[:status])
      end
    end

  end

  def self.update_event_since_conflicting(event, user)    
    conflicting_meeting = event.meetings.where(user_id: user.id).first
    if conflicting_meeting
      conflicting_meeting.rsvp = "NO" 
      conflicting_meeting.save
    end
  end

  def self.same_start_and_end_time?(first_event, second_event)
    is_same_time?(first_event.start_time, second_event.start_time) && is_same_time?(first_event.end_time, second_event.end_time)
  end

  def self.is_same_time?(first_event_time, second_event_time)
    first_event_time == second_event_time
  end

  def self.conflicting_time?(first_event, second_event)
    is_start_time_conflicting?(first_event, second_event) || is_end_time_conflicting?(first_event, second_event)
  end

  def self.is_start_time_conflicting?(first_event, second_event)
    first_event.start_time < second_event.start_time && first_event.end_time > second_event.start_time
  end

  def self.is_end_time_conflicting?(first_event, second_event)
    first_event.start_time < second_event.end_time && first_event.end_time > second_event.end_time
  end

  def self.form_event_object(event_record)
    {
      title: event_record["title"],
      start_time: event_record["starttime"],
      end_time: event_record["endtime"],
      description: event_record["description"],
      all_day: event_record["allday"]
    }
  end
  
  
end