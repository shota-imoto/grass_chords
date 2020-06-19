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
    @chordunits = @chord.chordunits
  end

  # GET /chords/new
  def new
    @chord = Chord.new
    @chord.chordunits.build
  end

  # GET /chords/1/edit
  def edit
    @chord = Chord.find(params[:id])
  end

  # POST /chords
  # POST /chords.json
  def create
    @chord = Chord.new(chord_params)
    if @chord.save
      redirect_to @chord, notice: 'コード譜を作成しました' 
    else
      redirect_to @chord
    end

  end

  # PATCH/PUT /chords/1
  # PATCH/PUT /chords/1.json
  def update
    @chord.update(chord_params)
    redirect_to @chord, notice: 'コード譜を編集しました'
  end

  # DELETE /chords/1
  # DELETE /chords/1.json
  def destroy
    @chord.destroy
    redirect_to root_path, notice: 'コード譜を削除しました'

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chord
      @chord = Chord.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chord_params
      params.require(:chord).permit(:song_id, :artist_id, :album_id, :version, chordunits_attributes: [:address, :text, :leftbar, :rightbar, :beat, :id]).merge(user_id: current_user.id)
    end

    def chord_to_num
      absolute_note_array = [
        "G",
        "G#",
        "A",
        "Bb",
        "B",
        "C",
        "C#",
        "D",
        "Eb",
        "E",
        "F",
        "F#",
        "G",
        "A",
        "Bb",
        "B",
        "C",
        "C#",
        "D",
        "Eb",
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
        "1B",
        "2",
        "3b",
        "3",
        "4",
        "4B",
        "5",
        "6b",
        "6",
        "7b",
        "7",
      ]

      symbol_array = ["#","b"]
      no_change_symbol_array = ["m","{","}","@","$","#","'","‘"]
      begin_symbol = ["{","@","$","#","'"]
      
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
        # chord=修飾記号のとき,前の文字が音階記号以外の場合は、無視する         
        elsif symbol_array.include? chord
          if (difference_note_array.include? output_array.last.to_s)            
            output_last = output_array.last
            if chord == "B"
              if output_last != 11
                output_last = output_last + 1
              elsif output_last == 11
                output_last = 0
              end
            elsif chord == "b"
              if output_last != 0
                output_last = output_last - 1
              elsif output_last == 0
                output_last = 11
              end
            end 
            output_array.pop
            output_array << output_last
          end
        elsif no_change_symbol_array.include? chord
            output_array << chord
        elsif (begin_symbol.include? chord)
          output_array << chor
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
