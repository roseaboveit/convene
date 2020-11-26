# {Furniture} placed in a {Room} allows it to be used
class FurniturePlacement < ApplicationRecord
  belongs_to :room
  belongs_to :furniture

  # TODO: Ordering of records is likely handled by a well-maintained gem already
  # The order in which {Furniture} is rendered in a Room. Lower is higher.
  attribute :slot, :integer
  validates :slot, presence: true, uniqueness: { scope: :room_id }
end
