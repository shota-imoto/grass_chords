class TuningAllsController < ApplicationController
  def new
    # @tuning_all_form = TuningAllForm.new
    @tuning_all = TuningAll.new
    @tuning_all.tunings.build
    # @tuning = Tuning.new
  end

  def create
    # @tuning_all_form = TuningAllForm.new(tuning_all_form_params)
    # @tuning_all_form.save
    # if @tuning_all_form.save
    #   redirect_to  # 成功時
    # else
    #   render 'new' # 失敗
    # end
    @tuning_all = TuningAll.new(tuning_all_params)
    @tuning_all.save
    tuning_params_hash = tuning_params
    tuning_params_array=[]
    @tuning_all.instrument.total_string.times do |i|
      tuning_params_array.push(tuning_params_hash[:tunings_attributes][:"#{i}"])
    end

    #＜編集メモ＞ 一旦、配列化成功 続きはここから

    binding.pry
    tuning_params_array.each do |tuning_params_permitted|
      @tuning = Tuning.new(tuning_params_permitted)
      @tuning[:tuning_all_id]=@tuning_all.id
      @tuning.save!
    end
  end

  private

  def tuning_all_params
    params.permit(:name, :instrument_id).merge(user_id: current_user.id)
  end

  def tuning_params

    params.permit(tunings_attributes:[:string_num, :note_name])
    # .merge(tuning_all_id: @tuning_all.id)
  end

  def tuning_all_form_params 
    params.require(:tuning_all_form_params).permit(:name, tunings_attributes: [:string_num, :note_name])
  end

  def hash_to_array(array)

  end


  
end
