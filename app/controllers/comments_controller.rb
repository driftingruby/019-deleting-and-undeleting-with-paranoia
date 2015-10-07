class CommentsController < ApplicationController
  before_action :set_comment, only: :show

  # GET /comments/new
  def new
    @user = User.find(params[:user_id])
    @comment = @user.comments.new
  end

  # POST /comments
  # POST /comments.json
  def create
    @user = User.find(params[:user_id])
    @comment = @user.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @user, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @user = User.find(params[:user_id])
    @comment = @user.comments.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @comment.destroy
    elsif params[:type] == 'forever'
      @comment.really_destroy!
    elsif params[:type] == 'undelete'
      @comment.restore
    end

    respond_to do |format|
      format.html { redirect_to @user, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @user = User.find(params[:user_id])
      @comment = @user.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :content)
    end
end
