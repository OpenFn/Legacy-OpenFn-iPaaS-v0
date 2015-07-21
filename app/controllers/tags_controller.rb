class TagsController < ApplicationController

  skip_before_filter :require_login

  def get_all
    @tags = Tag.all
    render json: @tags
  end

  def get_all_json
    @tags = Tag.all
    render json: @tags.to_json
  end

  def product_tags
    tags = []
    taggings = Tagging.live.includes(:draft).where(:taggable_id => params[:product_id])
    taggings.each do |tagging|
      tag_id = tagging.tag_id
      tag = Tag.find(tag_id)
      tags.push(tag)
    end
    render json: {tags: tags, redirect_url: "/product/#{params[:product_id]}"}
  end

  def product_tags_add
    if !current_user.present?
      render json: {status: "login", redirect_url: "/login"}
      return
    end
    @draft = Draftsman::Draft.new
    @draft.item_type = "Tagging"
    @draft.item_id = params[:product_id]
    @draft.event = "create"
    @draft.whodunnit = current_user.id
    @draft.object = params[:tag].to_json
    @draft.save
    redirect_to :back
  end

  def tags_add
    tags = params["_json"]
    product = Product.find(params[:product_id])
    if tags.present?
      tags.each do |tag|
      name = tag["name"]
      @draft = Draftsman::Draft.new
      @draft.item_type = "Tagging"
      @draft.item_id = product.id
      @draft.event = "create"
      @draft.whodunnit = current_user.id
      @draft.object = tag.to_json
      @draft.save
      end
    end
    render json: product
  end

  def tags_delete
    tags = params["_json"]
    product = Product.find(params[:product_id])
    if tags.present?
      tags.each do |tag|
      name = tag["name"]
      @draft = Draftsman::Draft.new
      @draft.item_type = "Tagging"
      @draft.item_id = product.id
      @draft.event = "destroy"
      @draft.whodunnit = current_user.id
      @draft.object = tag.to_json
      @draft.save
      end
    end
    render json: product
  end

  def tag_draft_publish
    draft = Draftsman::Draft.find(params[:id])
    if params[:response]=="publish"
      product = Product.find(draft.item_id)
      tag_name = draft.object["name"]
      if draft.event == "create"
        product.tag_list.add(tag_name)
      elsif draft.event == "destroy"
        product.tag_list.remove(tag_name)
      end
      product.save
    end
    draft.delete
    render json: product
  end


end
