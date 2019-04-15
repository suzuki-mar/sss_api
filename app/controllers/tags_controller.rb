class TagsController < ApiControllerBase
  before_action :set_tag, only: [:show, :update, :destroy]

  protected
  # 親クラスで必要となるメソッド
  def target_model_name
    'Tag'
  end

  public
  def index
    @tags = Tag.all

    render json: @tags
  end

end
