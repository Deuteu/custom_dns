class CreateDnsRecord < ActiveRecord::Migration[5.1]
  def change
    create_table :dns_records do |t|
      t.string :cloudflare_dns_id
      t.string :cloudflare_dns_type
      t.string :cloudflare_dns_name
      t.string :ping_token, unique: true
    end

    add_index :dns_records, :ping_token
  end
end
