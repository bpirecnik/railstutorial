class BlogsController < ApplicationController
    before_action :find_blog, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
    
    def index
    	@blogs = Blog.all.order("created_at DESC")
    end
    
    def show
    end
    
    def new
    	@blog = current_user.blogs.build
    end
    def create
    	@blog = current_user.blogs.build(blog_params)
    	
    	if @blog.save
    		redirect_to @blog, notice: "New post was created"
    	else
    		render "new"
    	end
    end
    
    def edit
    end
    
    def update
    	if @blog.update(blog_params)
    		redirect_to @blog, notice: "Post was succsessfully"
    	else
    		render "edit"
    	end
    end
    
    
    def destroy
    	@blog.destroy
    	redirect_to root_path
    end
    
    private
    	def blog_params
            params.require(:blog).permit(:image, :title, :body)
    	end
    	
    	def find_blog
    		@blog = Blog.find(params[:id])
    	end
end
