class TuningAllFormsController < ApplicationController
  def new
    @tuning_all_form = TuningAllForm.new
    # @tuning_all = TuningAll.new
    # @tuning_all.tunings.build
  end

  def create
    @tuning_all_form = TuningAllForm.new(tuning_all_form_params)
    @tuning_all_form.save
    # if @tuning_all_form.save
    #   redirect_to  # 成功時
    # else
    #   render 'new' # 失敗
    # end
    # @tuning_all = TuningAll.new(tuning_all_params)
    # @tuning_all.save
  end

  private

  def tuning_all_params
    params.permit(:name, :instrument_id, tunings_attributes:[:string_num, :note_name])
  end

  def tuning_all_form_params 
    params.require(:tuning_all_form_params).permit(:name, tunings_attributes: [:string_num, :note_name])
  end

end
