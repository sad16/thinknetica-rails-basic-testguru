class TestPassagesController < ApplicationController
  before_action :find_test_passage, only: [:show, :update, :result]
  before_action :check_timer, only: [:show, :update]

  def show
  end

  def update
    @test_passage.accept!(params[:answer_ids])

    if @test_passage.current_question?
      render :show
    else
      redirect_to result_test_passage_path(@test_passage)
    end
  end

  def result
    unless @test_passage.completed?
      @test_passage.completed!
      current_user.badges << Badge.assignable(@test_passage)
      TestPassageMailer.result_email(@test_passage).deliver_now
    end
  end

  private

  def find_test_passage
    @test_passage = TestPassage.find(params[:id])
  end

  def check_timer
    redirect_to result_test_passage_path(@test_passage) unless @test_passage.timer_valid?
  end
end
