# Devise Trackable Ip

This gem aims to expand on  ip tracking of a user login/failure. It will keep the desired age or amount of attempts along with their outcome result. I originally intended for this to be useful on other models than just User however, some of the logic is married to the form fields at present so may require some tweaking for your application.

To Install, include the gem in your gemfile and run the generator.
```
rails generate devise_trackable_ip:install --model=User

rails db:migrate
```
Add :trackable_ip to your selected model if it wasn't by the above generator.


```
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :trackable_ip
end
```

Alter the retention period or max visit retention limit in an initializer if required.
```
DeviseTrackableIp.configure do |config|
  config.retention_period = 6.months
  config.max_visits_retained_per_user_ip = 1000
end
```

The Record currently retains the following:
```
id: 8,
trackable_id: 441,
trackable_type: "User",
ip_address: "2130706433",
ip_address_type: 2,
visited_at: [[1743714410, 0], [1743714465, 0], [1743714479, 1], [1743714484, 1]]>]
```

the method <Model>.login_history returns the direct array for all ips of user.

```
[
  [Thu, 03 Apr 2025 16:06:50 -0500, "127.0.0.1", 0],
  [Thu, 03 Apr 2025 16:07:45 -0500, "127.0.0.1", 0],
  [Thu, 03 Apr 2025 16:07:59 -0500, "127.0.0.1", 1],
  [Thu, 03 Apr 2025 16:08:04 -0500, "127.0.0.1", 1],
  [Thu, 03 Apr 2025 16:14:57 -0500, "172.16.12.190", 1],
  [Thu, 03 Apr 2025 16:15:11 -0500, "172.16.12.190", 0],
  [Thu, 03 Apr 2025 16:28:20 -0500, "::1", 1],
  [Thu, 03 Apr 2025 16:29:03 -0500, "::1", 1],
  [Thu, 03 Apr 2025 16:29:06 -0500, "::1", 0]
]
```