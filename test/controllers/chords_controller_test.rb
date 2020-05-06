require 'test_helper'

class ChordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chord = chords(:one)
  end

  test "should get index" do
    get chords_url
    assert_response :success
  end

  test "should get new" do
    get new_chord_url
    assert_response :success
  end

  test "should create chord" do
    assert_difference('Chord.count') do
      post chords_url, params: { chord: { album_id: @chord.album_id, artist_id: @chord.artist_id, song_id: @chord.song_id, text: @chord.text } }
    end

    assert_redirected_to chord_url(Chord.last)
  end

  test "should show chord" do
    get chord_url(@chord)
    assert_response :success
  end

  test "should get edit" do
    get edit_chord_url(@chord)
    assert_response :success
  end

  test "should update chord" do
    patch chord_url(@chord), params: { chord: { album_id: @chord.album_id, artist_id: @chord.artist_id, song_id: @chord.song_id, text: @chord.text } }
    assert_redirected_to chord_url(@chord)
  end

  test "should destroy chord" do
    assert_difference('Chord.count', -1) do
      delete chord_url(@chord)
    end

    assert_redirected_to chords_url
  end
end
