crumb :root do
  link "Home", root_path
end

crumb :sign_in do
  link "ログイン", new_user_session_path
  parent :root
end

crumb :sign_up do
  link "ユーザ登録", new_user_registration_path
  parent :root
end

crumb :user_show do
  link "マイページ", user_path(params[:id])
  parent :root
end

crumb :user_edit do
  link "ユーザ情報の編集", edit_user_registration_path
  parent :user_show
end

crumb :song_search do
  link "検索", search_songs_path(keyword: "")
  parent :root
end

crumb :song_new do
  link "楽曲の登録", new_song_path
  parent :root
end

crumb :song_show do |song|
  if song == nil
    song = Song.find(params[:id])
  end
  link song.title, song_path(song)
  parent :song_search
end

crumb :song_edit do
  link "楽曲の編集", edit_song_path
  parent :song_show
end

crumb :chord_new do
  link "コード譜の作成", new_chord_path
  parent :root
end

crumb :chord_show do
  chord = Chord.find(params[:id])
  link "コード譜", chord_path
  parent :song_show, chord.song
end

crumb :chord_edit do
  link "コード譜の編集", edit_chord_path
  parent :chord_show
end

crumb :message_list do
  link "メッセージ一覧", list_messages_path
  parent :user_show
end

crumb :informations_vision do
  link "ビジョン", informations_vision_path
end

crumb :informations_apply do
  link "Bluegrass上級者の皆様へのお願い", informations_apply_path
  parent :informations_vision
end


# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
