# $pubnub = Pubnub.new(
#     :publish_key   => 'pub-4a29a03a-6f61-461f-a21b-75c61f73b55f',
#     :subscribe_key => 'sub-2f610f4c-a98d-11e0-a8dc-f9b6701e4370'
# )
# 
# $callback = lambda do |envelope|
#   Message.create(
#       :author => envelope.msg['author'],
#       :message => envelope.msg['message'],
#       :timetoken => envelope.timetoken
#   ) if envelope.msg['author'] && envelope.msg['message']
# end




