class NoteVersion < ActiveRecord::Base
  before_validation :initialize_updater
  belongs_to :updater, :class_name => "User"
  scope :for_user, lambda {|user_id| where("updater_id = ?", user_id)}
  attr_accessible :note_id, :x, :y, :width, :height, :body, :updater_id, :updater_ip_addr, :is_active, :post_id, :html_id, :version

  def self.search(params)
    q = where("true")
    params = {} if params.blank?

    if params[:updater_id]
      q = q.where("updater_id = ?", params[:updater_id].to_i)
    end

    if params[:post_id]
      q = q.where("post_id = ?", params[:post_id].to_i)
    end

    if params[:note_id]
      q = q.where("note_id = ?", params[:note_id].to_i)
    end

    q
  end

  def initialize_updater
    self.updater_id = CurrentUser.id
    self.updater_ip_addr = CurrentUser.ip_addr
  end

  def updater_name
    User.id_to_name(updater_id)
  end
end
