class AddPunctuationFlags < ActiveRecord::Migration
  def change
    add_column :chains, :is_punct, :boolean, default: false
    add_column :chains, :is_end, :boolean, default: false
  end
end
