class TagsController < ApplicationController

  def index
    @tags = Tag.all
    render json: @tags
  end

  def product_tags
    tags = []
    taggings = Tagging.where(:taggable_id => params[:product_id])
    taggings.each do |tagging|
      tag_id = tagging.tag_id
      tag = Tag.find(tag_id)
      tags.push(tag)
    end
    #render json: tags
    render json: {tags: tags, redirect_url: "/product/#{params[:product_id]}"}
  end

  def product_tags_add
    tag = Tag.new(:name => params[:name],
                  :taggings_count => params[:count])
    tag.save
    tag_id = Tag.find(:name => params[:name]).id
    #tag_id = tag_record.id
    tagging = Tagging.new(:tag_id => tag_id,
                          :taggable_id => params[:product_id],
                          :tagger_id => current_user.id)
    tagging.save
  end

  def product_tags_delete
    Rails.logger.info {"#{__FILE__}:#{__LINE__} #{params[:product_id]}"}
    #tag = Tag.find(params[:tag_id])
    #tag.delete
    tagging = Tagging.where(:tag_id => params[:tag_id], :taggable_id => params[:product_id]).first
    tagging.delete
    #render json: tag
    product_tags
  end

  def product_tags_edit
    tags = params["_json"]
    Rails.logger.info {"#{__FILE__}:#{__LINE__} .............#{tags}"}
    taggings = Tagging.where(:taggable_id => params[:product_id])
    taggings.delete_all
     tags.each do |tag|
       name = tag["name"]
       id = tag["id"]
       tagging = Tagging.new(:tag_id => tag["id"],
                          :taggable_id => params[:product_id],
                          :tagger_id => current_user.id)
       Rails.logger.info {"#{__FILE__}:#{__LINE__} ------------#{tagging}"}
       tagging.save
     end
     product_tags
    #render json: params
  end

end
