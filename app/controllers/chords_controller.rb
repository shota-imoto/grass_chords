class ChordsController < ApplicationController
  before_action :set_chord, only: [:show, :edit, :update, :destroy]

  # GET /chords
  # GET /chords.json
  def index
    @chords = Chord.all.includes(:song, :user).order(id: "DESC").limit(5)
  end

  # GET /chords/1
  # GET /chords/1.json
  def show
    @chord = Chord.find(params[:id])

  end

  # GET /chords/new
  def new
    @chord = Chord.new
  end

  # GET /chords/1/edit
  def edit
  end

  # POST /chords
  # POST /chords.json
  def create
    
    @chord = Chord.new(chord_params)
    chord_to_num
    respond_to do |format|
      if @chord.save
        format.html { redirect_to @chord, notice: 'Chord was successfully created.' }
        format.json { render :show, status: :created, location: @chord }
      else
        format.html { render :new }
        format.json { render json: @chord.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chords/1
  # PATCH/PUT /chords/1.json
  def update
    respond_to do |format|
      if @chord.update(chord_params)
        format.html { redirect_to @chord, notice: 'Chord was successfully updated.' }
        format.json { render :show, status: :ok, location: @chord }
      else
        format.html { render :edit }
        format.json { render json: @chord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chords/1
  # DELETE /chords/1.json
  def destroy
    @chord.destroy
    respond_to do |format|
      format.html { redirect_to chords_url, notice: 'Chord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chord
      @chord = Chord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chord_params
      params.permit(:song_id, :artist_id, :album_id, :text, :version, :key_now_state).merge(user_id: current_user.id)
    end

    def chord_to_num
      absolute_note_array = [
        "G",
        "G#",
        "A",
        "B♭",
        "B",
        "C",
        "C#",
        "D",
        "E♭",
        "E",
        "F",
        "F#",
        "G",
        "A",
        "B♭",
        "B",
        "C",
        "C#",
        "D",
        "E♭",
        "E",
        "F",
        "F#",
      ];
      difference_note_array = [
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
      ]
      relative_note_array = [
        "1",
        "1#",
        "2",
        "3♭",
        "3",
        "4",
        "4#",
        "5",
        "6♭",
        "6",
        "7♭",
        "7",
      ]

      symbol_array = ["#","♭"]
      no_change_symbol_array = ["m","+","*","<",">","w","f","t","/","|"]
      begin_symbol = ["<","w","f","t","|","/"]
      
      chords = @chord.text.split("")
      key_note = params[:key_name].delete("key of ")
      key_note = key_note.delete("m")
      key_index = absolute_note_array.index(key_note)
      output_array = []
      chords.each do |chord|
      binding.pry

        if absolute_note_array.include? chord
          difference_index = absolute_note_array.index(chord)
          difference_index = difference_index - key_index
          
          output_array << difference_index
        # chord=就職記号のとき,前の文字が音階記号以外の場合は、無視する
        elsif (difference_note_array.include? output_array.last.to_s)

          if symbol_array.include? chord            
            output_last = output_array.last
            if chord == "#"
              if output_last != 11
                output_last = output_last + 1
              elsif output_last == 11
                output_last = 0
              end
            elsif chord == "♭"
              
              if output_last != 0
                output_last = output_last - 1
              elsif output_last == 0
                output_last = 11
              end
            end 
            output_array.pop
            output_array << output_last
          elsif no_change_symbol_array.include? chord
            output_array << chord
          end
        elsif (begin_symbol.include? chord)
          output_array << chord
        end
      end
      output_array.each_with_index do |output,i|
        if symbol_array.include? output
        elsif no_change_symbol_array.include? output
        else
          output = output.to_i
          output_array[i] = relative_note_array[output]
        end
      end
      @chord[:text]= output_array.join
    end
end
