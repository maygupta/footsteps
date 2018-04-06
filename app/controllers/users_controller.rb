class UsersController < ApplicationController
  def new
    @user = User.new 
  end

  def index
    @total_rounds = 0
    @total_reading_hours = 0
    @total_hearing_hours = 0
    @total_service_hours = 0
    @total_sadhna_cards = 0

    @current_month_rounds = 0
    @current_month_reading_hours = 0
    @current_month_hearing_hours = 0
    @current_month_service_hours = 0
    @current_month_sadhna_cards = 0

    @month_name = Date.today.strftime("%B")
    @month = Date.today.strftime("%m")
    @year =  Date.today.strftime("%Y")

    sadhna_cards = current_user.sadhna_cards
    current_month_sadhna_cards = current_user.sadhna_cards.where('extract(year from date) = ? AND extract(month  from date) = ? 
      ', @year, @month)

    sadhna_cards.each do |sc|
      @total_rounds += sc.japa_rounds
      @total_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @total_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @total_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @total_service_hours = (@total_service_hours/60).to_s + "h " +  (@total_service_hours % 60).to_s + "m"
    @total_reading_hours = (@total_reading_hours/60).to_s + "h " +  (@total_reading_hours % 60).to_s + "m"
    @total_hearing_hours = (@total_hearing_hours/60).to_s + "h " +  (@total_hearing_hours % 60).to_s + "m"
    @total_sadhna_cards = sadhna_cards.count

    current_month_sadhna_cards.each do |sc|
      @current_month_rounds += sc.japa_rounds
      @current_month_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @current_month_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @current_month_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @current_month_service_hours = (@current_month_service_hours/60).to_s + "h " +  (@current_month_service_hours % 60).to_s + "m"
    @current_month_reading_hours = (@current_month_reading_hours/60).to_s + "h " +  (@current_month_reading_hours % 60).to_s + "m"
    @current_month_hearing_hours = (@current_month_hearing_hours/60).to_s + "h " +  (@current_month_hearing_hours % 60).to_s + "m"
    @current_month_sadhna_cards = current_month_sadhna_cards.count
  end

  def badges
    cards = current_user.sadhna_cards
    @unlocked_badges = []
    @locked_badges = []

    all_badges = [
      ["Chanted 1000 total Japa Rounds", cards.sum(:japa_rounds) > 1000],
      ["Read more than 1000 hours", cards.pluck(:reading).sum(&:to_i) > 60000],
      ["Heard more than 1000 hours", cards.pluck(:hearing).sum(&:to_i) > 60000],
      ["Served more than 1000 hours", cards.pluck(:service).sum(&:to_i)> 60000],
      ["Chanted more than 16 rounds in one day", cards.where("japa_rounds > 16").count > 0],
      ["Served more than 2 hours in one day", cards.where("CAST(service AS INT) > ?", 120).count > 0],
      ["Read more than 2 hours in one day", cards.where("CAST(reading AS INT) > ?", 120).count > 0],
      ["Heard more than 2 hours in one day", cards.where("CAST(hearing AS INT) > ?", 120).count > 0],
      ["Recited 100 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)> 100],
      ["Recited 1000 verses of Bhagavad Gita", cards.pluck(:verses).sum(&:to_i)> 500]
    ]

    complex_badges = [
      ["Chanted x rounds every day in a week"], 
      ["Chanted x rounds every day in a month"],
      ["Chanted x rounds every day in a year"], 
      ["Read atleast 30mins every day in a week"], 
      ["Read atleast 30mins every day in a month"],
      ["Read atleast 30mins every day in a year"]
    ]

    all_badges.each do |badge|
      if badge[1] == true
        @unlocked_badges.push(badge)
      else
        @locked_badges.push(badge)
      end
    end

  end

  def show
    @user = User.find(params[:id])

    @total_rounds = 0
    @total_reading_hours = 0
    @total_hearing_hours = 0
    @total_service_hours = 0
    @total_sadhna_cards = 0

    @current_month_rounds = 0
    @current_month_reading_hours = 0
    @current_month_hearing_hours = 0
    @current_month_service_hours = 0
    @current_month_sadhna_cards = 0

    @month_name = Date.today.strftime("%B")
    @month = Date.today.strftime("%m")
    @year =  Date.today.strftime("%Y")

    sadhna_cards = @user.sadhna_cards
    current_month_sadhna_cards = @user.sadhna_cards.where('extract(year from date) = ? AND extract(month  from date) = ? 
      ', @year, @month)

    sadhna_cards.each do |sc|
      @total_rounds += sc.japa_rounds
      @total_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @total_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @total_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @total_service_hours = (@total_service_hours/60).to_s + "h " +  (@total_service_hours % 60).to_s + "m"
    @total_reading_hours = (@total_reading_hours/60).to_s + "h " +  (@total_reading_hours % 60).to_s + "m"
    @total_hearing_hours = (@total_hearing_hours/60).to_s + "h " +  (@total_hearing_hours % 60).to_s + "m"
    @total_sadhna_cards = sadhna_cards.count

    current_month_sadhna_cards.each do |sc|
      @current_month_rounds += sc.japa_rounds
      @current_month_service_hours +=  if sc.service.present? then sc.service.to_i else 0 end
      @current_month_hearing_hours += if sc.hearing.present? then sc.hearing.to_i else 0 end
      @current_month_reading_hours += if sc.reading.present? then sc.reading.to_i else 0 end
    end
    @current_month_service_hours = (@current_month_service_hours/60).to_s + "h " +  (@current_month_service_hours % 60).to_s + "m"
    @current_month_reading_hours = (@current_month_reading_hours/60).to_s + "h " +  (@current_month_reading_hours % 60).to_s + "m"
    @current_month_hearing_hours = (@current_month_hearing_hours/60).to_s + "h " +  (@current_month_hearing_hours % 60).to_s + "m"
    @current_month_sadhna_cards = current_month_sadhna_cards.count
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
    render "new"
  end

end