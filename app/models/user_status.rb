class UserStatus < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :status

  scope :more_recent_than, lambda {|old_id| { :conditions => ["id > ?", old_id],
  						                                      :order => "created_at DESC" }}
  						                                    
  scope :user_history, lambda { |user_id| { :conditions => {:user_id => user_id},
                                                  :order => "created_at desc",
                                                  :include => :user }}

  def has_delete_rights?(user)
    user.admin? || self.user_id == user.id
  end

  def self.history
    limit = Setting.plugin_redmine_user_status['user_status_limit'].to_i
    @statuses = self.all  :order => "created_at desc", 
                          :include => :user, 
                          :limit => (limit || 100)
  end
  
  def to_s
    self.status
  end
  
end


