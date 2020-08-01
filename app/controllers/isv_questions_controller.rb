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

  def search
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    if params[:query].present?
      query = params[:query]
      render :json => IsvQuestion.where("value LIKE ?", "%#{query}%"), :status => 200
    else
      render :json => [], :status => 200
    end
  end

  def import_csv
    csv_text = File.read('ask_reflect.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      ask_time = DateTime.strptime(row[0], "%m/%d/%Y %H:%M:%S")
      ques = IsvQuestion.new(:ask_time => ask_time,
        :name => row[1],
        :ask_type => row[2],
        :value => row[3],
        :verse => row[4])
      ques.save!
    end
    render :json => csv, :status => 200
  end

end