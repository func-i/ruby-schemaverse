# The current tic in the game should be referenced by: tic = TicSeq.first.last_value
# @see https://schemaverse.com/tutorial/tutorial.php?page=TheTicSequence
class TicSeq < ActiveRecord::Base
  self.table_name = 'tic_seq'
end