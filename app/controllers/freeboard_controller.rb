class FreeboardController < ApplicationController
 
 before_action :authenticate_user!, only: [:upload, :reply_write]
 
    # 게시판 홈
    def freeboards
       @fb_all = Freeboard.all
       
    end
    # 게시판 홈 끝
    
    
    # 글쓰기 페이지
    def upload
        
    end
    # 글쓰기 페이지 끝
    
    
    # 글 작성 처리하는 페이지
    def write
        fb_update = Freeboard.new
        fb_update.fb_user_id =  current_user.id
        fb_update.fb_title = params[:user_title]
        fb_update.fb_content = params[:user_content]
        # fb_update.fb_password = current_user.encrypted_password
        fb_update.save
           
        redirect_to '/freeboard/freeboards'
        
    end
    # 글 작성 처리하는 페이지 끝
    
    # 수정 페이지
    def modify
        
        @id = params[:id]
      
        @one_fb = Freeboard.find(@id)
        
    end
    # 수정 페이지 끝
    
    # 글 수정 처리
    def update
        
        @login_user = User.all
        
        fb_modify = Freeboard.find(params[:id])
        
        
        if current_user.id == fb_modify.fb_user_id #사용자가 같으면 삭제가능
             
            fb_modify.fb_content = params[:md_content]
            fb_modify.fb_title = params[:md_title]
            fb_modify.save
                
            redirect_to '/freeboard/freeboards'
        else
             
            redirect_to :back
        end 
        
    end
    # 글 수정 처리 끝
    
    
    # 삭제 페이지
    def delete
        @id = params[:id]
        
    end
    # 삭제 페이지 끝
    
    
    # 게시글 삭제 액션 페이지
    def delete_action
        
        fb_delete= Freeboard.find(params[:id])
        
        
        if fb_delete.fb_user_id == current_user.id
            
            fb_delete.destroy
                
            redirect_to '/freeboard/freeboards'
             
        else
             
            redirect_to :back
        end
        
    end
    # 게시글 삭제 액션 페이지 끝
    
    # 게시판에 등록한 글 페이지
    def upload_view
     
        @one_fb = Freeboard.find(params[:id])
        @id = params[:id]
        
    end
    # 게시판에 등록한 글 페이지 끝
    
    
    # 게시판 리플 처리 페이지
    def reply_write
        
        fb_reply = Reply.new
        fb_reply.freeboard_id = params[:freeboard_id]
        # fb_reply.rp_name = params[:rp_name]
        fb_reply.user_id=current_user.id
        fb_reply.rp_content = params[:rp_content]
        # fb_reply.rp_hakbun = params[:rp_hakbun]
        fb_reply.save
      
        redirect_to :back
    end
    # 게시판 리플 처리 페이지 끝
    
    # 리플 삭제
    def reply_delete
       
        rp_delete = Reply.find(params[:rp_id])
        

        if rp_delete.user_id == current_user.id
                    # 같은 이름을 가진 사람이 댓글을 삭제할수도 있으므로 학번으로 바꿔야함.
            
            rp_delete.destroy
            redirect_to :back
        else
            
            redirect_to :back
        end
    end
    # 리플 삭제 끝
    
    
    # 리플 수정
    # def reply_modify
    #     #공 지 !
    #     #수정 버튼을 누르면 content 부분에 수정할수 있게 그 부분만 바꿔줘야 하는 코드를 작성해야함!!
        
    #     reply_update = Reply.find(params[:rp_id])
        
        
        
    #     if reply_update.rp_hakbun == current_user.student_number
            
    #         reply_update.rp_content = params[:rp_content]
    #         reply_update.save
    #         redirect_to :back
    #     else
            
    #         redirect_to :back
    #     end
        
    # end
    # 리플 수정 
    
    
    
    # 비 로그인시 경고출력
    def warning
        
    end
    # 비 로그인시 경고출 끝


end