# frozen_string_literal: true

class CreateE621Tables < ActiveRecord::Migration[7.1]
  def change
    reversible do |r|
      r.up { execute("CREATE SCHEMA e621") }
      r.down { execute("DROP SCHEMA e621 CASCADE") }
    end

    create_table(:e621_artists, id: :bigint, default: nil, force: :cascade) do |t|
      t.datetime(:created_at, null: false)
      t.bigint(:creator_id, null: false)
      t.string(:group_name)
      t.boolean(:is_active, null: false)
      t.boolean(:is_locked, null: false)
      t.bigint(:linked_user_id)
      t.string(:name, null: false)
      t.text(:other_names, array: true, null: false, default: [])
      t.datetime(:updated_at, null: false)
      t.text(:urls, array: true, null: false, default: [])
    end

    add_index(:e621_artists, :name, unique: true)
    add_index(:e621_artists, :creator_id)

    create_table(:e621_bulk_update_requests, id: :bigint, default: nil, force: :cascade) do |t|
      t.bigint(:approver_id)
      t.datetime(:created_at, null: false)
      t.bigint(:forum_topic_id)
      t.text(:script, null: false)
      t.string(:status, null: false)
      t.string(:title)
      t.datetime(:updated_at, null: false)
      t.bigint(:user_id, null: false)
    end

    add_index(:e621_bulk_update_requests, :user_id)
    add_index(:e621_bulk_update_requests, :status)

    create_table(:e621_pools, id: :bigint, default: nil, force: :cascade) do |t|
      t.string(:category, null: false)
      t.datetime(:created_at, null: false)
      t.bigint(:creator_id, null: false)
      t.text(:description, null: false)
      t.boolean(:is_active, null: false)
      t.string(:name, null: false)
      t.bigint(:post_ids, array: true, null: false, default: [])
      t.datetime(:updated_at)
    end

    add_index(:e621_pools, :creator_id)
    add_index(:e621_pools, :name)

    create_table(:e621_posts, id: :bigint, default: nil, force: :cascade) do |t|
      t.bigint(:approver_id)
      t.bigint(:change_seq, null: false)
      t.integer(:comment_count, null: false)
      t.datetime(:created_at, null: false)
      t.text(:description, null: false)
      t.integer(:down_score, null: false)
      t.float(:duration)
      t.integer(:fav_count, null: false)
      t.string(:file_ext, null: false)
      t.bigint(:file_size, null: false)
      t.integer(:image_height, null: false)
      t.integer(:image_width, null: false)
      t.boolean(:is_deleted, null: false)
      t.boolean(:is_flagged, null: false)
      t.boolean(:is_note_locked, null: false)
      t.boolean(:is_pending, null: false)
      t.boolean(:is_rating_locked, null: false)
      t.boolean(:is_status_locked, null: false)
      t.text(:locked_tags, null: false)
      t.string(:md5)
      t.bigint(:parent_id)
      t.string(:rating, null: false)
      t.integer(:score, null: false)
      t.text(:sources, array: true, null: false, default: [])
      t.text(:tags, array: true, null: false, default: [])
      t.integer(:up_score, null: false)
      t.datetime(:updated_at)
      t.bigint(:uploader_id)
    end

    add_index(:e621_posts, :md5, unique: true, where: "md5 IS NOT NULL")
    add_index(:e621_posts, :uploader_id)
    add_index(:e621_posts, :rating)
    add_index(:e621_posts, :is_deleted)

    create_table(:e621_post_replacements, id: :bigint, default: nil, force: :cascade) do |t|
      t.bigint(:approver_id)
      t.datetime(:created_at, null: false)
      t.bigint(:creator_id, null: false)
      t.string(:file_ext, null: false)
      t.string(:file_name, null: false)
      t.bigint(:file_size, null: false)
      t.integer(:image_height, null: false)
      t.integer(:image_width, null: false)
      t.string(:md5, null: false)
      t.bigint(:post_id, null: false)
      t.text(:reason, null: false)
      t.text(:source)
      t.string(:status, null: false)
      t.datetime(:updated_at, null: false)
    end

    add_index(:e621_post_replacements, :post_id)
    add_index(:e621_post_replacements, :creator_id)
    add_index(:e621_post_replacements, :status)

    create_table(:e621_post_versions, id: :bigint, default: nil, force: :cascade) do |t|
      t.text(:added_locked_tags, array: true, null: false, default: [])
      t.text(:added_tags, array: true, null: false, default: [])
      t.text(:description)
      t.boolean(:description_changed, null: false)
      t.text(:locked_tags)
      t.boolean(:parent_changed, null: false)
      t.bigint(:parent_id)
      t.string(:rating)
      t.boolean(:rating_changed, null: false)
      t.text(:reason)
      t.text(:removed_locked_tags, array: true, null: false, default: [])
      t.text(:removed_tags, array: true, null: false, default: [])
      t.text(:source)
      t.boolean(:source_changed, null: false)
      t.text(:tags)
      t.datetime(:updated_at, null: false)
      t.bigint(:updater_id, null: false)
      t.integer(:version, null: false)
    end

    add_index(:e621_post_versions, :updater_id)
    add_index(:e621_post_versions, :updated_at)

    create_table(:e621_tag_aliases, id: :bigint, default: nil, force: :cascade) do |t|
      t.string(:antecedent_name, null: false)
      t.string(:consequent_name, null: false)
      t.datetime(:created_at)
      t.string(:status, null: false)
    end

    add_index(:e621_tag_aliases, :antecedent_name)
    add_index(:e621_tag_aliases, :consequent_name)
    add_index(:e621_tag_aliases, :status)

    create_table(:e621_tag_implications, id: :bigint, default: nil, force: :cascade) do |t|
      t.string(:antecedent_name, null: false)
      t.string(:consequent_name, null: false)
      t.datetime(:created_at)
      t.string(:status, null: false)
    end

    add_index(:e621_tag_implications, :antecedent_name)
    add_index(:e621_tag_implications, :consequent_name)
    add_index(:e621_tag_implications, :status)

    create_table(:e621_tags, id: :bigint, default: nil, force: :cascade) do |t|
      t.string(:category, null: false)
      t.string(:name, null: false)
      t.integer(:post_count, null: false)
    end

    add_index(:e621_tags, :name, unique: true)
    add_index(:e621_tags, :category)

    create_table(:e621_wiki_pages, id: :bigint, default: nil, force: :cascade) do |t|
      t.text(:body, null: false)
      t.datetime(:created_at, null: false)
      t.bigint(:creator_id)
      t.boolean(:is_locked, null: false)
      t.string(:title, null: false)
      t.datetime(:updated_at)
      t.bigint(:uploader_id)
    end

    add_index(:e621_wiki_pages, :title, unique: true)
    add_index(:e621_wiki_pages, :creator_id)
  end
end
