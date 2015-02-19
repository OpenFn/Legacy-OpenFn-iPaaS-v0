# Submission
# ==========

# Responsible for handling message/submissions from an integration,
# transforming it, and sending to another integration.

# Steps
# -----
#
# [Receipt](submission/receipt.rb) takes a raw source message and a mapping
# and then creates a new [Record](submission/record.rb)
# 
# [PayloadEncoding](submission/payload_encoding.rb) then encodes the 
# raw source payload, and saves it as `source_payload` on the `Record`
#
# [Translation](submission/translation.rb) takes the `Record` and modifies
# the `source_payload` into a translated result, and saves it on the `Record`.

# Adapters
# --------
#
# A [Mapping](mapping.rb) has the following properties that are used
# to determine which dependecies are needed for the pipeline.
#
# Mappings have a `Source` and `Destination` instance of a
# [ConnectedApp](connected_app.rb) which supplies an integration class.
#

module Submission
end
