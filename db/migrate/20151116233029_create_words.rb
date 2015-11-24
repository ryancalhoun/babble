class CreateWords < ActiveRecord::Migration
  def up
    create_table :words do |t|
      t.string :value, :null => false
      t.boolean :punct, :default => false, :null => false
      t.boolean :end_of_sentence, :default => false, :null => false

      t.timestamps null: false
    end

    add_column :chains, :word_id, :integer 
    add_column :chains, :prev_word_id, :integer

    Chain.all.each {|chain|
      word = Word.find_or_create_by(:value => chain.word)
      word.update_attributes :punct => chain.is_punct?, :end_of_sentence => chain.is_end?
      word.save!

      chain.update_attributes :word_id => word.id
      if chain.previous
        prev = Word.find_or_create_by(:value => chain.previous)
        prev.save! 
        chain.update_attributes :prev_word_id => prev.id
      end

      chain.save!
    }

    remove_column :chains, :word
    remove_column :chains, :previous
    remove_column :chains, :is_punct
    remove_column :chains, :is_end

  end
  def down
    add_column :chains, :word, :string
    add_column :chains, :previous, :string
    add_column :chains, :is_punct, :boolean, :default => false
    add_column :chains, :is_end, :boolean, :default => false

    Chain.all.each {|chain|
      word = Word.find(chain.word_id)
      chain.update_attributes :word => word.value, :is_punct => word.punct?, :is_end => word.end_of_sentence?
      if chain.prev_word_id
        prev = Word.find(chain.prev_word_id)
        chain.update_attributes :previous => prev.value
      end
      chain.save!
    }

    remove_column :chains, :word_id
    remove_column :chains, :prev_word_id

    drop_table :words
  end
end
