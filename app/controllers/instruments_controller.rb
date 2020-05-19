class InstrumentsController < ApplicationController
  def new
    @instrument = Instrument.new
  end

  def create
    Instrument.create(instrument_params)
    redirect_to("/")
  end

  def search
    params[:keyword].strip!
    keywords = params[:keyword].split(/\s/)
    @instruments = Instrument.all
    keywords.each do |keyword|
      @instruments = @instruments.where("name like ?", "%#{keyword}%")
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def instrument_params
    params.permit(:name, :total_string)
  end

end
