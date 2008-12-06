# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

DataMapper.auto_migrate!

class SpecPopulator
  
  require "dm-sweatshop"
  #NOTE: the randexp library uses a dictionary file (/usr/share/words)
  # to pick random words from there. If there are no words for a 
  # certain word-length, it will fail miserably  
  User.fixture {{
    :login                => (login = /\w{4,10}/.gen),
    :name                 => /\w{2,8} \w{2,8}/.gen,
    :email                => "#{login}@example.com",
    :password             => (password = /\w{6,10}/.gen),
    :password_confirmation => password,
    :role                 => /admin|user/.gen,
    :blog_url             => /http:\/\/\w{4,10}\.(com|org|info)/.gen,
    # :recommendations      => 5.of { Recommendation.gen },
  }}

  #NOTE: recommendations can not be created from the User.fixture call
  # since those would want to pick from users which are not yet generated.
  Recommendation.fixture {{
    :user => User.pick,
    :recommendee => User.pick,
  }}

  def self.generate_users(n)
    n.of { User.gen }
  end

  def self.generate_recommendations(n)
    n.of do
      begin
        Recommendation.gen
      rescue => e
        #NOTE: duplicate keys (same user-recommendee pair)
        # will likely occur. The easiest thing is just to
        # ignore these errors.
        # DataMapper.logger.error(e)
      end
    end    
  end
  
  def self.populate!(options={})
    self.generate_users(options[:users])
    self.generate_recommendations(options[:recommendations])
    #NOTE: since the keys of a hash are unordered, we can not rely
    # on iterating on them since users (in our case) have to be
    # generated before the recommendations
    # options.keys.each do |model|
    #   self.send("generate_#{model.to_s}", options[model])
    # end
  end

end