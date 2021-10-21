class Todo < ApplicationRecord
  enum status: {
    new: 0,
    done: 1,
    archived: 2,
  }, _prefix: true
end
