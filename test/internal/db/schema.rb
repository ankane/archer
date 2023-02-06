ActiveRecord::Schema.define do
  create_table :archer_history do |t|
    t.string :user
    t.text :commands
    t.datetime :updated_at
  end
end
