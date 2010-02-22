require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :trainings, :dependent => :destroy
  has_many :races, :through => :trainings
  has_many :comments
  
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

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :birthday_year, :last_login_at, :last_login_ip



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
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

  def total_distance(from = 1.week.ago, to = Date.today)
    distances = []
    self.trainings.period(from, to).each do |training|
      training.races.each { |race| distances << race.distance }
    end
    eval distances.join('+')
  end
  
  def total_time(from = 1.week.ago, to = Date.today)
    times = []
    self.trainings.period(from, to).each do |training|
      training.races.each do |race|
        unless race.time.blank?
          times << {:hours => race.time.strftime("%H").to_i,
                    :minutes => race.time.strftime("%M").to_i,
                    :seconds => race.time.strftime("%S").to_i}
        end
      end
    end
    hours = times.map { |time| time[:hours] }
    minutes = times.map { |time| time[:minutes] }
    seconds = times.map { |time| time[:seconds] }
    seconds = eval seconds.join('+') 
    seconds += get_seconds_from_hours_and_minutes(hours, minutes)
    get_time_from_seconds seconds
  end
  
  def admin?
    self.admin
  end
  
  protected
  
  def get_seconds_from_hours_and_minutes(hours, minutes)
    seconds = (3600 * (eval hours.join('+')))
    seconds += (60 * (eval minutes.join('+')))
  end
  
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