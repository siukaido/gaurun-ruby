# Gaurun

## .push

[POST /push](https://github.com/mercari/gaurun/blob/master/SPEC.md#post-push)

```ruby
client = Gaurun::Client.new
notification = Gaurun::Notification.new(message: 'this is test message')

notification.ios.token = ['device_token1', 'device_token2']
notification.ios.badge = 10
notification.ios.extend = { hoge: 'piyo' }

notification.android.token = ['registration_id1', 'registration_id2']
notification.android.extend = { foo: 'bar' }

res = client.push(notification)

p res.body
```

## .parallel_push

``` ruby
client = Gaurun::Client.new
notifications = 10.times.map do
  notification = Gaurun::Notification.new(message: 'hoge')
  ...
  notification
end

res = client.parallel_push(notifications)

p res.map(&:body)

```

## .stat_go

[GET /stat/go](https://github.com/mercari/gaurun/blob/master/SPEC.md#get-statgo)

```ruby
client = Gaurun::Client.new
res = client.stat_go

p res.body
```

## .stat_app

[GET /stat/app](https://github.com/mercari/gaurun/blob/master/SPEC.md#get-statapp)

```ruby
client = Gaurun::Client.new
res = client.stat_app

p res.body
```

## .config_pushers

[PUT /config/pushers](https://github.com/mercari/gaurun/blob/master/SPEC.md#put-configpushers)

``` ruby
client = Gaurun::Client.new
res = client.config_pushers(24)

p res.body
```
