class ChangeColumnTypeForSectionsStartAndEndTime < ActiveRecord::Migration[8.0]
  def change
    change_column :sections, :start_time, 'timestamp without time zone', using: 'CAST(\'2000-01-01 \' || start_time AS timestamp without time zone)'
    change_column :sections, :end_time, 'timestamp without time zone', using: 'CAST(\'2000-01-01 \' || end_time AS timestamp without time zone)'
  end

  def down
    change_column :sections, :start_time, :time
    change_column :sections, :end_time, :time
  end
end
