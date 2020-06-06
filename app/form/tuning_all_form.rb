class TuningAllForm
  include ActiveModel::Model

  concerning  :TuningAllBuilder do
    def tuning_all
      @tuning_all = TuningAll.new
    end
  end

  concerning :TuningsBuilder do
    def tunings
      @tunings_attributes = Tuning.new
    end

    def tunings_attributes=(attributes)
      @tunings_attributes = Tuning.new(attributes)
    end
  end

  attr_accessor :name

  def save
    return false if invalid?

    tuning_all.assign_attributes(tuning_all_params)
    build_asscociations

    if tuning_all.save
      true
    else
      false
    end
  end

  private

  def tuning_all_params
    {
      name: name
    }
  end

  def build_asscociations
    tuning_all.tunings << tunings
  end
end