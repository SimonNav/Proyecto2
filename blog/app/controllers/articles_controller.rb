class ArticlesController < ApplicationController
  before_action :authenticate_user!  # Requiere autenticación para todas las acciones
  before_action :set_article, only: [:show, :edit, :update, :destroy]  # Configura el artículo en las acciones
  before_action :authorize_user!, only: [:edit, :update, :destroy]  # Asegura que solo el propietario pueda editar o eliminar

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)  # Asocia el artículo al usuario actual
    if @article.save
      redirect_to @article, notice: 'Artículo creado exitosamente.'
    else
      render :new
    end
  end

  def show
  end

  def index
    @articles = Article.all
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Artículo actualizado correctamente.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Artículo eliminado.'
  end

  private

  # Filtra los parámetros permitidos
  def article_params
    params.require(:article).permit(:title, :text)
  end

  # Encuentra el artículo usando el ID
  def set_article
    @article = Article.find(params[:id])
  end

  # Asegura que solo el usuario propietario pueda editar o eliminar el artículo
  def authorize_user!
    redirect_to articles_path, alert: 'No tienes permiso para realizar esta acción.' unless @article.user == current_user
  end
end
