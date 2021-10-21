class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = find_post(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = find_post(params[:id])
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = find_post(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = find_post(params[:id])
    if post.destroy
      redirect_to posts_url, notice: "Post was successfully destroyed."
    else
      redirect_to post, notice: "Something went wrong"
    end
  end

  private

  def find_post(id)
    Post.find(id)
  end

  def post_params
    params.require(:post).permit(:user_id, :title, :text, :published_at)
  end
end
