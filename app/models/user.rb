require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :trainings, :dependent => :destroy
  has_many :races, :through => :trainings
  belongs_to :municipality
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :birthday_year, :last_login_at, :last_login_ip, :municipality_id, :gender, :admin

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def time(from = 1.week.ago, to = Date.today)
    seconds = 0
    self.trainings.period(from, to).each do |training|
      training.races.each do |race|
        seconds += (race.time.to_i - Race::EPOCH) unless race.time.blank?
      end
    end
    get_time_from_seconds seconds
  end
  
  def to_param
    login
  end
  
  def role_symbols
    symbols = [:member, :guest]
    symbols << :admin if self.admin
    symbols
  end
  
  def events
    races.find(:all, :select => "DISTINCT(event_id)").map { |r| r.event  }
  end
  
  def event_time(event)
    time = 0
    races.find(:all, :conditions => {:event_id => event.id}).each { |race| time += race.time.to_i - Race::EPOCH unless race.time.blank? }
    ((time / 3600.0) * 100).round.to_f / 100
  end
  
  def event_distance(event)
    distance = 0
    races.find(:all, :conditions => {:event_id => event.id}).each { |race| distance += race.distance }
    distance
  end
  
  def hr_max
    210 - (0.65 * (Date.today.year - self.birthday_year))
  end
  
  protected
  
  def get_time_from_seconds(time)
    result = {}
    result['second'] =  time % 60
    time = (time - result['second']) / 60
    result['minute'] =  time % 60
    result['hour'] = (time - result['minute']) / 60
    result.sort # gets them in right order hour, minute, second even day if used
  end
  
  def password_required?
    if (crypted_password.blank? || !password.blank?)
      identity_url.blank? ? true : false
    else
      false
    end
  end
  
end