class MyEvent < ActiveRecord::Base

 self.primary_key = 'id'

  def read_event()
    self.class.select("READ_EVENT(#{self.id})").all
  end

end