class VotesController < ApplicationController

  def list
    drop = Drop.find(params[:drop_id])
    votes = Vote.where(drop: drop)
    
    authorize drop, :list_votes?

    json_response 200,
      success: true,
      message: I18n.t('success.ok'),
      message_id: 'ok',
      data: ActiveModel::ArraySerializer.new(
        votes,
        each_serializer: VoteSerializer,
        root: "votes"
      )

  end

  def create
    drop = Drop.find(params[:drop_id])

    authorize drop, :create_vote?

    vote = DropActions.new(
      drop: drop,
      param: { vote: vote_params[:vote] },
      user: current_user
    ).vote!

    if vote.persisted?
      json_response 201,
        success: true,
        message_id: 'record_created',
        message: I18n.t('success.record_created'),
        data: {
          vote: vote
        }
    else
      unless vote.errors.empty?
        json_response 400,
          success: false,
          message_id: 'validation_error',
          message: I18n.t('error.validation_error'),
          errors: vote.errors
      else
        raise CantSaveError
      end
    end
  end

  def destroy
    vote = Vote.find(params[:vote_id])

    authorize vote

    vote.destroy!

    json_response 204,
      sucess: false,
      message_id: 'record_destroyed',
      message: I18n.t('success.record_destroyed'),
      data: { vote: vote } 
  end


  private

  def vote_params
    params.require(:vote).permit(:vote)
  end

end
