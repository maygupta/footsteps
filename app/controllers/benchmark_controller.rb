class BenchmarkController < ApplicationController
  def index
    @data = {}
    users = User.all
    users.each do |u1|
      @data[u1.name] = {}
      users.each do |u2|
        @data[u1.name][u2.name] = u1.compare(u2)[:total_score]
      end
    end
  end
end
