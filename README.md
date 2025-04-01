rails generate devise_trackable_ip:install --model=User

rails db:migrate

Add :trackable_ip to your User model:


  > class User < ApplicationRecord<br>
  > devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :trackable_ip<br>
  > end

Alter the retention period in an initializer if required.
DeviseTrackableIp.configure do |config|
config.retention_period = 1.month
end
