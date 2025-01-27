class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @booknew = Book.new
    @post_comment = PostComment.new
    current_entry = Entry.where(user_id: current_user.id)
    another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      current_entry.each do |current|
        another_entry.each do |another|
          if current.room_id == another.room_id then
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort_by { |book| -book.favorites.where(created_at: from...to).count }
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    user = @book.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def search
    @books = Book.where("tag LIKE ?", "%#{params[:tag]}%")
  end
  

  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :tag)
  end
end
