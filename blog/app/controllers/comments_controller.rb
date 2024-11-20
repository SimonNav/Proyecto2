class CommentsController < ApplicationController
  before_action :authenticate_user!  # Asegura que el usuario esté autenticado
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user!, only: [:destroy]  # Verifica permisos para borrar comentarios

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user  # Asocia el comentario con el usuario actual

    if @comment.save
      redirect_to article_path(@article), notice: 'Comentario creado exitosamente.'
    else
      redirect_to article_path(@article), alert: 'Error al crear el comentario.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to article_path(@comment.article), notice: 'Comentario eliminado.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    # Permitir que eliminen comentarios el autor del comentario o el creador del artículo
    unless @comment.user == current_user || @comment.article.user == current_user
      redirect_to article_path(@comment.article), alert: 'No tienes permiso para eliminar este comentario.'
    end
  end
end
