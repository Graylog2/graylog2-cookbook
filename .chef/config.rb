local_mode true
cookbook_path [ File.expand_path('..', __FILE__) ]
knife[:secret_file] = 'encrypted_data_bag_secret_key'
