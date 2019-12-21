class GroupsController < ApplicationController

   skip_before_filter :require_login

  def image_groups
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []
    
    if params[:group_id].present?
       group = Group.find(params[:group_id])
       ret_sections = []
       group.sections.order(created_at: :desc).each do |section|
         print section.id
         if section.darshan.count > 0
           ret_sections.push(section)
         end
       end
       print ret_sections
       ret = {:group => group, :sections => ret_sections}
    else
      Group.all.each do |group|
         group.sections.order(created_at: :desc).each do |section|
           if section.darshan.count > 0
             ret.push(group)
             break
           end
         end
       end
    end

    render :json => ret, :status => 200
  end

  def audio_groups
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []
    if params[:group_id].present?
       group = Group.find(params[:group_id])
       ret_sections = []
       group.sections.each do |section|
         if section.media.where(:category => 'lecture').count > 0
           ret_sections.push(section)
         end
       end
       ret = {:group => group, :sections => ret_sections}
    else
      Group.all.each do |group|
        group.sections.each do |section|
          if section.media.where(:category => 'lecture').count > 0
            ret.push(group)
            break
          end
        end
       end
    end

    render :json => ret, :status => 200
  end

  def video_groups
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []

    if params[:group_id].present?
       group = Group.find(params[:group_id])
       ret_sections = []
       group.sections.each do |section|
         if section.media.where(:category => 'video').count > 0
           ret_sections.push(section)
         end
       end
       ret = {:group => group, :sections => ret_sections}
    else
      Group.all.each do |group|
         group.sections.each do |section|
           if section.media.where(:category => 'video').count > 0
             ret.push(group)
             break
           end
         end
       end
    end

    render :json => ret, :status => 200
  end

  def kirtan_groups
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

    ret = []

    if params[:group_id].present?
       group = Group.find(params[:group_id])
       ret_sections = []
       group.sections.each do |section|
         if section.media.where(:category => 'kirtan').count > 0
           ret_sections.push(section)
         end
       end
       ret = {:group => group, :sections => ret_sections}
    else
      Group.all.each do |group|
         group.sections.each do |section|
           if section.media.where(:category => 'kirtan').count > 0
             ret.push(group)
             break
           end
         end
       end
    end

    render :json => ret, :status => 200
  end


  def index
    groups = Group.all
    render :json => groups, :status => 200
  end

  def show
    group = Group.find(params[:id])
    render :json => {:group => group, :sections => group.sections}, :status => 200
  end

end
