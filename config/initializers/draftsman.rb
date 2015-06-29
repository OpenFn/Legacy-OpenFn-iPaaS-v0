# Override global `draft` class. For example, perhaps you want your own class at `app/models/draft.rb` that adds
# extra attributes, validations, associations, methods, etc. Be sure that this new model class extends
# `Draftsman::Draft`.
# Draftsman.draft_class_name = 'Draftsman::Draft'

# Serializer for `object`, `object_changes`, and `previous_draft` columns. To use the JSON serializer, change to
# `Draftsman::Serializers::Json`. You could implement your own serializer if you really wanted to. See files in
# `lib/draftsman/serializers`.
#
# Note: this option is not needed if you're using the PostgreSQL JSON data type for the `object`,
# `object_changes`, and `previous_draft` columns.
# Draftsman.serializer = Draftsman::Serializers::Json

# Field which records when a draft was created.
# Draftsman.timestamp_field = :created_at
