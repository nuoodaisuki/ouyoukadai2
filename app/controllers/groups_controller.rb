class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    group.owner_id = current_user.id
    if group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    group = Group.find(params[:id])
    if group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def new_group_email
    @group = Group.find(params[:id])
  end

  def send_group_email
    @group = Group.find(params[:id])
    @owner = current_user
    @title = params[:title]
    @content = params[:content]

    # メール送信
    GroupMailer.group_notification(@group, @owner, @title, @content).deliver_now

    # 送信完了画面に遷移
    redirect_to email_sent_group_path(@group, title: @title, content: @content)
  end

  def email_sent
    @group = Group.find(params[:id])
    @title = params[:title]
    @content = params[:content]
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end