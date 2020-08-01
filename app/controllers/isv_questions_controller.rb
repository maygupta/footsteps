require 'csv'


class IsvQuestionsController < ApplicationController
  skip_before_filter :require_login

  def index
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    render :json => IsvQuestion.all, :status => 200
  end

  def import_csv
    csv_text = File.read('ask_reflect.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      print row
    end
  end

end