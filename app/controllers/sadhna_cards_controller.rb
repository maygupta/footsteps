class SadhnaCardsController < ApplicationController

  def new
    @sadhna_card = SadhnaCard.new
    @custom_method = "post"
    @custom_path = "/sadhna_cards"
  end  

  def index
    if params[:month].present? and params[:year].present?
      @month = params[:month]
      @year = params[:year]
    else
      @month = Date.today.strftime("%m")
      @year =  Date.today.strftime("%Y")
    end

    @sadhna_cards = SadhnaCard.where('extract(year  from date) = ? AND extract(month  from date) = ? 
      ', @year, @month).order(date: :desc)

    @months = [["01", "Jan"], ["02", "Feb"], ["03", "March"], ["04", "April"], 
    ["05", "May"], ["06", "June"], ["07", "July"], ["08", "August"], ["09", "Sept"], 
    ["10", "Oct"], ["11", "Nov"], ["12", "Dec"]]
    @years = []
    count = 0
    start = 1989
    while count < 50
      count += 1
      @years.push(start + count)
    end

  end

  def create
    print sadhna_card_params
    @sadhna_card = SadhnaCard.new(sadhna_card_params)
 
    if @sadhna_card.save
      render :json => {id: @sadhna_card.id}, :status => :ok
    else
      render 'new'
    end
  end

  def show
    @sadhna_card = SadhnaCard.find(params[:id])
  end

  def edit

    @sadhna_card = SadhnaCard.find(params[:id])
    print @sadhna_card.wakeup.to_time
  end

  def update
    @sadhna_card = SadhnaCard.find(params[:id])
   
    if @sadhna_card.update(sadhna_card_update_params)
      render :json => {id: @sadhna_card.id}, :status => :ok
    else
      render 'edit'
    end
  end

  private

  def sadhna_card_update_params
    { 
      :date => params[:date],
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing], 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service], 
      :chad => params[:chad], 
      :reading => params[:reading]
    }
  end

  def sadhna_card_params
    { 
      :date => params[:date],
      :japa_rounds => params[:japa_rounds], 
      :hearing => params[:hearing], 
      :wakeup => params[:wake_up],
      :rest_time => params[:slept_at],
      :service => params[:service], 
      :chad => params[:chad], 
      :reading => params[:reading]
    }
  end
end
