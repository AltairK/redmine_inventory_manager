class KeysAndModifications < ActiveRecord::Migration[5.1]
    def self.up
      execute <<-SQL
        ALTER TABLE inventory_parts
        ADD CONSTRAINT uk_inventory_part_part_number UNIQUE (part_number);
      SQL

      execute <<-SQL
        ALTER TABLE inventory_categories
        ADD CONSTRAINT uk_inventory_category_name UNIQUE (name);
      SQL
        
      execute <<-SQL
        ALTER TABLE inventory_providors
        ADD CONSTRAINT uk_inventory_providor_identification UNIQUE (identification);
      SQL
          
      add_column :inventory_movements, :user_from_id, :integer
      add_column :inventory_movements, :user_to_id, :integer
      add_column :inventory_movements, :warehouse_to_id, :integer
      add_column :inventory_movements, :warehouse_from_id, :integer
      add_column :inventory_movements, :serial_number, :string
        
      execute <<-SQL
        ALTER TABLE "inventory_movements" ADD
          CONSTRAINT "fk_inventory_movement_warehouse_to" FOREIGN KEY ("warehouse_to_id")
            REFERENCES "inventory_warehouses"("id")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;
      SQL
      
      execute <<-SQL
        ALTER TABLE "inventory_movements" ADD
          CONSTRAINT "fk_inventory_movement_warehouse_from" FOREIGN KEY ("warehouse_from_id")
            REFERENCES "inventory_warehouses"("id")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;
      SQL
      
      execute <<-SQL
        ALTER TABLE "inventory_movements" ADD
          CONSTRAINT "fk_inventory_movement_user" FOREIGN KEY ("user_id")
            REFERENCES "users"("id")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;
      SQL
      
      execute <<-SQL
        ALTER TABLE "inventory_movements" ADD
          CONSTRAINT "fk_inventory_movement_user_from" FOREIGN KEY ("user_from_id")
            REFERENCES "users"("id")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;
      SQL
      
      execute <<-SQL
        ALTER TABLE "inventory_movements" ADD
          CONSTRAINT "fk_inventory_movement_user_to" FOREIGN KEY ("user_to_id")
            REFERENCES "users"("id")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;
      SQL
      
      add_column :inventory_parts, :where, :string
      
    end

    def self.down
      execute "DROP INDEX IF EXISTS \"uk_inventory_part_part_number\""
      execute "DROP INDEX IF EXISTS \"uk_inventory_category_name\""
      execute "DROP INDEX IF EXISTS \"uk_inventory_providor_identification\""

      execute "DROP INDEX IF EXISTS \"fk_inventory_movements_user\""
      execute "DROP INDEX IF EXISTS \"fk_inventory_movements_user_from\""
      execute "DROP INDEX IF EXISTS \"fk_inventory_movements_user_to\""
      execute "DROP INDEX IF EXISTS \"fk_inventory_movement_warehouse_from\""
      execute "DROP INDEX IF EXISTS \"fk_inventory_movement_warehouse_to\""
      
      remove_column :inventory_movements, :user_from_id
      remove_column :inventory_movements, :user_to_id
      remove_column :inventory_movements, :warehouse_to_id
      remove_column :inventory_movements, :warehouse_from_id
      remove_column :inventory_movements, :serial_number
      remove_column :inventory_parts, :where
    end
  end
