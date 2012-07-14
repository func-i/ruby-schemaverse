# @see https://schemaverse.com/tutorial/tutorial.php?page=MyEvents
class MyEvent < ActiveRecord::Base

 self.primary_key = 'id'

  # Read all the event details for an events
  def read_event
    self.class.select("READ_EVENT(#{self.id})").all
  end

end