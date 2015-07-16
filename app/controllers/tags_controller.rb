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
    id = Tag.maximum(:id).next

    tag = Tag.new(:id => id,
                  :name => params[:name],
                  :taggings_count => params[:count])
    tag.save
    product = Product.find(params[:product_id])
    product.tag_list.add(params[:name])
    product.save
    create_admin_taggings
    render json: product
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
    draft = Draftsman::Draft.find(params[:draft_id])
    if params[:selection] == "publish"
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
    render json: 0
  end


  private

  def create_admin_taggings
    tagging = Tagging.order("created_at").last
    tagging_instance = Tagging.find(tagging.id).to_json
    drafts = Draftsman::Draft.all
    if drafts.present?
      draft_id = Draftsman::Draft.maximum(:id).next
    else
      draft_id = 1
    end
    created_time = Time.now
    draft = Draftsman::Draft.new(:id => draft_id,
                                 :item_type => "Tagging",
                                 :item_id => tagging.id,
                                 :event => "create",
                                 :whodunnit => current_user.id,
                                 :created_at => created_time,
                                 :updated_at => created_time,
                                 :object => tagging_instance)
    draft.save
    tagging.update(:draft_id => draft_id, :published_at => Time.now)
  end

  def delete_admin_taggings(tag_name,product_id)
    tag_id = Tag.find_by_name(tag_name).id
    tagging = Tagging.where(:tag_id => tag_id, :taggable_id => product_id).first
    tagging_instance = Tagging.find(tagging.id).to_json
    drafts = Draftsman::Draft.all
    if drafts.present?
      draft_id = Draftsman::Draft.maximum(:id).next
    else
      draft_id = 1
    end
    created_time = Time.now
    draft = Draftsman::Draft.new(:id => draft_id,
                                 :item_type => "Tagging",
                                 :item_id => tagging.id,
                                 :event => "destroy",
                                 :whodunnit => current_user.id,
                                 :created_at => created_time,
                                 :updated_at => created_time,
                                 :object => tagging_instance)
    draft.save
    tagging.update(:draft_id => draft_id, :trashed_at => Time.now)
  end

end
