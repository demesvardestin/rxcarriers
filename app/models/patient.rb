class Patient < ActiveRecord::Base
    
    belongs_to :patable, :polymorphic => true
    
end
