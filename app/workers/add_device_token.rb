class AddDeviceToken
    
  @queue = :add_device_token_queue

  def self.perform(update_token_params, existing_endpoint_arn=nil)
    sns = Aws::SNS::Client.new 

    unless existing_endpoint_arn.nil?
      sns.set_endpoint_attributes(endpoint_arn: existing_endpoint_arn, attributes: { CustomUserData: update_token_params["user_id"].to_s }) 
    else 

    res = sns.create_platform_endpoint(platform_application_arn: update_token_params["arn"], 
                                       token: update_token_params["device_id"],
                                       custom_user_data: update_token_params["user_id"].to_s)
    end

    new_endpoint_arn = existing_endpoint_arn.nil? ? res[:endpoint_arn] : existing_endpoint_arn

    user = User.find(update_token_params["user_id"])

    user.update_attributes(sns_endpoint_arn: new_endpoint_arn)

  end

end
