class BookController < ApplicationController
    
     before_action :authenticate_user!, only: [:booking, :view_booking]
    
    
    def real_main  # 메인페이지
       
        
    end
    
    
    def main 
        @building=Building.all
        
      
       
      
    end
    
    def detail_info
        #건물별 강의실 정보 출력
        @building=Building.find(params[:id])
        @class_list=Room.where(building_name: @building.name)
        
    end
    
    def view_booking
        #해당 강의실의 예약현황을 보여줌
        @class=Room.find(params[:id])
        @date=params[:show_date]
        
        
        # Room.reservations.where(date: Date.today)
    
        
    end
    
    def booking #신청서 작성
        @class=Room.find(params[:id])
        @date=params[:date]
        
      
          
        @save_result = params[:save_result]
        
        
        #신청양식
    end
    

    
    def booking_process
    
        @date=params[:date].to_time
        @all_reservation=Reservation.where(room_id: params[:id]).where(date: params[:date])
        #@all_reservation=Reservation.where("room_id = ? and date = ?", params[:id], @date)
        # @all_reservation=Reservation.where(room_id: params[:id]).where(date: @date)
        # @all_reservation=Reservation.where(room_id: params[:id]).where(date: @date)
        @start_time=Time.new(@date.year, @date.month, @date.day, params[:start_time].to_time.hour, params[:start_time].to_time.min)
        @finish_time=Time.new(@date.year, @date.month, @date.day, params[:finish_time].to_time.hour, params[:finish_time].to_time.min)
        # 
        # @save_result = true # 초기값 설정을 true 에서 "" 로 바꿔놈.
         
        if (( Time.zone.now<= @start_time.to_s(:db)) and (@start_time.to_s(:db) < @finish_time.to_s(:db))) # true여야함
          if @all_reservation.count==0
             @save_result=true
          
          else
            @all_reservation.each do |r| #부들부들 
              if ((@start_time.between?(r.start_time, r.finish_time)) or 
                  (@finish_time.between?(r.start_time, r.finish_time)) or
                  ((@start_time < r.start_time) and (r.finish_time < @finish_time)))
  
                @save_result = false    #중복일 때 false
                
              else #안겹치면 저장
                
                @save_result = true
              end
            end #all_reservation.each do  
          end #@all_reservation.count==0
         
        else
            @save_result = false
          
        end #Time.zone.now
        
        #걸러줌!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        if @save_result == true
          
            @reservation=Reservation.new #새로운 예약 db를 생성
            @reservation.room_id=params[:id]
            @reservation.user=current_user.id #여기다가는 유저 이름을 저장한다.(나중에 수정할것)
            @reservation.professor=params[:professor]
            @reservation.date=params[:date]
            @reservation.start_time=@start_time
            @reservation.finish_time=@finish_time
            @reservation.purpose=params[:purpose]
            @reservation.save
            
            redirect_to action:"view_booking", id: params[:id], show_date: params[:date]
            
        # elsif @all_reservation.nil?
        #   @reservation=Reservation.new #새로운 예약 db를 생성
        #   @reservation.room_id=params[:id]
        #   @reservation.user=current_user.email #여기다가는 유저 이름을 저장한다.(나중에 수정할것)
        #   @reservation.professor=params[:professor]
        #   @reservation.date=params[:date]
        #   @reservation.start_time=@start_time
        #   @reservation.finish_time=@finish_time
        #   @reservation.purpose=params[:purpose]
        #   @reservation.save
          
        #   redirect_to action:"view_booking", id: params[:id], show_date: params[:date]
          
        else
          redirect_to action:"booking", id: params[:id], show_date: params[:date], save_result: "false1"
        end
        
            
    end
    
    def mypage
      
    end
    
    def delete #예약 지울때
        reservation_del = Reservation.find(params[:id])
        reservation_del.destroy
        
        redirect_to :back
    end
    
    def condition
        
        @class = Reservation.all
        
        if current_user     #로그인이 되어있고
                # redirect_to :back        
            if current_user.email == "admin@ptu.ac.kr" # 관리자라면 입장
            
            else #관리자가 아니면 백
                
            redirect_to action:"real_main", mode: "false"
            end  
            
        elsif current_user.nil?
            redirect_to action:"real_main", mode: "blank"
      
        end
    end    
    
    def test
        @a="ff"
    end
   
    
    
end
                
        
        # if (Time.zone.now<= Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min) and (@start_time < @finish_time)) 
            
        #     if (@all_reservation.where('start_time AND finish_time BETWEEN ? AND ?', Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min), Time.new(@date.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)) or @all_reservation.where('start_time BETWEEN ? AND ?', Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min), Time.new(@date.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)) or @all_reservation.where('finish_time BETWEEN ? AND ?', Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min), Time.new(@date.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)))
        #         redirect_to '/'
                
                
            # if (r.start_time..r.finish_time).include?(@reservation.start_time) or (r.start_time..r.finish_time).include?(@reservation.finish_time)
            # if @all_reservation.where('start_time AND finish_time BETWEEN ? AND ?', Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min), Time.new(@date.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)) or @all_reservation.where('start_time BETWEEN ? AND ?', @reservation.start_time, @reservation.finish_time) or @all_reservation.where('finish_time BETWEEN ? AND ?', @reservation.start_time, @reservation.finish_time).sds
            
                    # or (r.start_time..r.finish_time).between?(@reservation.start_time..@reservation.finish_time)
                #if (Time.new(@start_time.hour, @start_time.min)).overlaps?(Time.new(r.start_time.hour, r.start_time.min)..Time(r.finish_time.hour, r.finish_time.min)) or (@reservation.finish_time.to_time).overlaps?(r.start_time.to_time..r.finish_time.to_time) 
                #if (r.start_time..r.finish_time).overlaps?(@reservation.start_time..@reservation.finish_time)   #시간이 중복되면?
                #     #if((@reservation.start_time..@reservation.finish_time).cover?(r.start_time) or (@reservation.start_time..@reservation.finish_time).cover?(r.finish_time)
#             else 
                
#                 @reservation=Reservation.new #새로운 예약 db를 생성
#                 @reservation.room_id=params[:id]
#                 @reservation.user=current_user.email #여기다가는 유저 이름을 저장한다.(나중에 수정할것)
#                 @reservation.professor=params[:professor]
#                 @reservation.date=params[:date]
#                 @reservation.start_time=Time.new(@date.year, @date.month, @date.day, @start_time.hour, @start_time.min)
#                 @reservation.finish_time=Time.new(@date.year, @date.month, @date.day, @finish_time.hour, @finish_time.min)
#                 @reservation.purpose=params[:purpose]
#                 @reservation.save
                
#                 redirect_to action:"view_booking", id: params[:id], show_date: params[:date]
                
#             end
#         else
#             redirect_to '/message/main'
#         end    
        
#     end
# end
    #if (r.start_time..r.finish_time).include?(@reservation.start_time) or (r.start_time..r.finish_time).include?(@reservation.finish_time)
                    #if (r.start_time..r.finish_time).overlaps?(@reservation.start_time..@reservation.finish_time).sds #만약 시간이 겹치면
                    
    #if (r.start_time, r.finish_time).include?(@start_time) or (r.start_time, r.finish_time).include?(@finis_time)
                    #if (@start_time.between?(r.start_time, r.finish_time)@finish_time.between?(r.start_time, r.finish_time))
                    # if (@reservation.where((:start_time === r.start_time..r.finish_time) || (:finish_time === r.start_time..r.finish_time)))
                        # @reservation.save
                        # redirect_to :back
                        
                          # @range=r.start_time..r.finish_time
                
                # if (@range.overlaps?(@start_time..@finish_time)or 
                #     @range.include?(@start_time) or 
                #     @range.include?(@finish_time))
                    
                    
                    # @reservation=Reservation.new #새로운 예약 db를 생성
                    # @reservation.room_id=params[:id]
                    # @reservation.user=current_user.email #여기다가는 유저 이름을 저장한다.(나중에 수정할것)
                    # @reservation.professor=params[:professor]
                    # @reservation.date=params[:date]
                    # @reservation.start_time=@start_time
                    # @reservation.finish_time=@finish_time
                    # @reservation.purpose=params[:purpose]
                    # @reservation.save
                    
                    # redirect_to action:"view_booking", id: params[:id], show_date: params[:date]