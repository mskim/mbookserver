# encoding: utf-8
class Admin::MbooksController < ApplicationController
  layout 'admin_layout'
  before_filter :authenticate_admin!

  def index
    @board = "mbook"
    @section = "index"
    
    
    if params[:st] != "all" and params[:st] != "" and params[:st] != nil
      if params[:st] == "1"
        status = "승인대기"
        @menu_on = "mb_req"
      elsif params[:st] == "2"
        status = "삭제대기"
        @menu_on = "mb_del"
      elsif params[:st] == "3"
        status = "대기"
        @menu_on = "mb_all"
      elsif params[:st] == "4"
        status = "승인완료"
        @menu_on = "mb_all"
      else
        @menu_on = "mb_all"
      end
    else
      @menu_on = "mb_all"
    end
    
    @mbooks = Mbook.all

    if params[:cat] != nil and params[:cat] != "" and params[:cat] != "all"
      @mbooks = @mbooks.all(:category_id => params[:cat].to_i)
    end
    
    if params[:sub] != nil and params[:sub] != "" and params[:sub] != "all"
      @mbooks = @mbooks.all(:subcategory1_id => params[:sub].to_i)
    end
    
    if params[:user] != nil and params[:user] != ""
      @mbooks = @mbooks.all(:user_id => params[:user].to_i)
    end
    
    if params[:st] != "all" and params[:st] != "" and params[:st] != nil
      @mbooks = @mbooks.all(:status => status)
    end 
    
    mbooks = @mbooks
    
    @mbooks = @mbooks.search(mbooks, params[:keyword], params[:search], params[:page])
    @total_count = @mbooks.search(mbooks, params[:keyword], params[:search],"").count
    
    @categories = Category.all(:gubun => "template", :order => :priority)
     
    render 'mbook'
  end

  # GET /admin_mbooks/1
  # GET /admin_mbooks/1.xml
  def show
    @mbook = Mbook.get(params[:id])
    
    if @mbook != nil
      @board = "mbook"
      @section = "show"
      
      @menu_on = params[:menu_on]
      
      render 'mbook'  
    else  
      redirect_to '/admin/mbooks'
    end
  end

  # GET /admin_mbooks/new
  # GET /admin_mbooks/new.xml
  def new
    @mbook = Admin::Mbook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mbook }
    end
  end

  # GET /admin_mbooks/1/edit
  def edit
    @mbook = Admin::Mbook.find(params[:id])
  end

  # POST /admin_mbooks
  # POST /admin_mbooks.xml
  def create
    @mbook = Admin::Mbook.new(params[:mbook])

    respond_to do |format|
      if @mbook.save
        flash[:notice] = 'Admin::Mbook was successfully created.'
        format.html { redirect_to(@mbook) }
        format.xml  { render :xml => @mbook, :status => :created, :location => @mbook }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mbook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_mbooks/1
  # PUT /admin_mbooks/1.xml

  def deleteSelection 

    chk_ids = params[:ids]
    chks = chk_ids.split(",")

    chks.each do |chk|
      mbook = Mbook.get(chk.to_i)
      if mbook != nil
          puts_message mbook.zipfile
          if File.exists?(mbook.zipfile)
            FileUtils.rm_rf mbook.zipfile
          end
          
          puts_message mbook.zip_path
          if File.exists?(mbook.zip_path)
            FileUtils.rm_rf mbook.zip_path
          end
          
          puts_message MBOOK_PATH + mbook.id.to_s + ".zip"
          if File.exists?(MBOOK_PATH + mbook.id.to_s + ".zip")
            FileUtils.rm_rf MBOOK_PATH + mbook.id.to_s + ".zip"
          end
          
          mbook_id = mbook.id
          if mbook.destroy 
            puts_message "mBook ("+mbook_id.to_s+") 삭제 성공"
          else
            puts_message "mBook ("+mbook_id.to_s+") 삭제 실패"
          end
      end    
    end

    render :text => "success"
  end

  def change_status
    chk_ids = params[:ids]
    chks = chk_ids.split(",")

    chks.each do |chk|
      mbook = Mbook.get(chk.to_i)
      if mbook != nil
          
          mbook_id = mbook.id
          mbook.status = params[:str_status]
          if mbook.save 
            puts_message "mBook ("+mbook_id.to_s+") 상태변경 성공"
          else
            puts_message "mBook ("+mbook_id.to_s+") 상태변경 실패"
          end
      end    
    end

    render :text => "success"
  end
  
  #1개의 mBook파일에 대한 상태 변경 
  def update_status
    id = params[:id].to_i
    mode = params[:mode]
    
    if Mbook.get(id) != nil
      mbook = Mbook.get(id)
      mbook_id = mbook.id
      mbook.status = params[:str_status]
      if params[:mode] != "승인"
        mbook.cancel_reason = params[:cancel_reason]
      end
      
      if mbook.save 
        puts_message "mBook ("+mbook_id.to_s+") 상태변경 성공"
      else
        puts_message "mBook ("+mbook_id.to_s+") 상태변경 실패"
      end
    else
      redirect_to '/admin/mbooks'
    end

    render :text => "success"
  end
  
end
