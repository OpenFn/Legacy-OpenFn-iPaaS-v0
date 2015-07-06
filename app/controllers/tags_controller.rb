class TagsController < ApplicationController

  skip_before_filter :require_login
  #acts_as_taggable
  #acts_as_taggable_on :taggings

  # commented to hide index
  #def index
  #  @tags = Tag.all
  #  render json: @tags
  #end

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
    id = Tag.maximum(:id).next
    tag = Tag.new(:id => id,
                  :name => params[:name],
                  :taggings_count => params[:count])
    tag.save
    tagging = Tagging.new(:tag_id => id,
                          :taggable_id => params[:product_id],
                          :tagger_id => current_user.id)
    tagging.draft_creation
    render json: tagging
  end

  def product_tags_edit
     if !current_user.present?
       render json: {status: "login", redirect_url: "/login"}
       return
     end
    tags = params["_json"]
    taggings = Tagging.where(:taggable_id => params[:product_id])
    taggings.delete_all
    if tags.present?
      tags.each do |tag|
      name = tag["name"]
      id = tag["id"]
      tagging = Tagging.new(:tag_id => tag["id"],
                            :taggable_id => params[:product_id],
                            :tagger_id => current_user.id)
      tagging.draft_creation
      end
    product_tags
    else
      render json: {tags: tags, redirect_url: "/product/#{params[:product_id]}"}
    end
  end

  def tagging_count
    tags = Tagging.where(:tag_id => params[:tag_id])
    render json: tags.count
  end

  def tags_add
    tags = params["_json"]
    product = Product.find(params[:product_id])
    if tags.present?
      tags.each do |tag|
      name = tag["name"]
      #tagging =  Tagging.new(:tag_id => tag["id"],
      #                      :taggable_id => params[:product_id],
      #                      :tagger_id => current_user.id)
      product.tag_list.add(name)
      #tagging.draft_creation
      product.save
      #product.tag_list.draft_creation
      end
    end
    render json: params
  end

  def tags_delete
    tags = params["_json"]
    product = Product.find(params[:product_id])
    if tags.present?
      tags.each do |tag|
      name = tag["name"]
      product.tag_list.remove(name)
      #tagging = Tagging.where(:tag_id => tag["id"], :taggable_id => params[:product_id]).first
      product.save
      end
    end
    render json: params
  end

end
