class InteractionsController < ApplicationController

  def create
    interaction = Interaction.new(create_params)

    check_valid_authorization

    interaction = InteractionActions.new(interaction: interaction).create!

    if interaction.persisted?
       json_response 201,
        success: true,
        message_id: 'record_created',
        message: I18n.t('success.record_created'),
        data: { interaction: interaction }
    else
      unless interaction.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: interaction.errors
      else
        raise CantSaveError
      end

    end

  end

  private

  def create_params
    params.require(:interaction).permit(:user_id, :topic_id, :topic_type, :action, :users_watching)
  end

end
