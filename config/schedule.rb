# 出力先logの指定
set :output, 'log.rb'
# 実行環境の指定
set :environment, :developmentå

every :minute do
  rake "twitter_data:output"
end
