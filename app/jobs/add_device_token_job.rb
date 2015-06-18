class AddDeviceTokenJob < ActiveJob::Base

  queue_as :add_device_token

  def perform(update_token_params, existing_endpoint_arn=nil) 
    sns = Aws::SNS::Client.new 

    # If the endpoint is registered before, we know it must exist in AWS
    if !existing_endpoint_arn.nil?
      res = update_endpoint(
        sns,
        existing_endpoint_arn,
        update_token_params[:user_id].to_s
      )
    else
      # If it does not exist in the DB, we first try to create it, if we can't create it, we try to update it
      begin
        res = sns.create_platform_endpoint(
          platform_application_arn: update_token_params[:arn], 
          token: update_token_params[:device_id],
          custom_user_data: update_token_params[:user_id].to_s)
      rescue Aws::SNS::Errors::InvalidParameter
        res = update_endpoint(
          sns,
          existing_endpoint_arn,
          update_token_params[:user_id].to_s
        )
      end
    end

    new_endpoint_arn = existing_endpoint_arn.nil? ? res[:endpoint_arn] : existing_endpoint_arn

    user = User.find(update_token_params[:user_id])
    
    user.update(sns_endpoint_arn: new_endpoint_arn, device_type: update_token_params[:device_type])
  end

  private

  def update_endpoint(sns, arn, user_id)
    sns.set_endpoint_attributes(
      endpoint_arn: arn, 
      attributes: { 
        CustomUserData: user_id
      }
    )
  end

end
