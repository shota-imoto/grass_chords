class InstrumentsController < ApplicationController
  def new
    @instrument = Instrument.new
  end

  def create
    Instrument.create(instrument_params)
    redirect_to("/")
  end

  private

  def instrument_params
    params.permit(:name, :total_string)
  end

end
