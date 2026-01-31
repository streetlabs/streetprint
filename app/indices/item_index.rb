ThinkingSphinx::Index.define :item, :with => :active_record do
  # Fields for full-text searching
  indexes :title
  indexes :full_text
  indexes :notes
  indexes :location
  indexes :city
  indexes :publisher
  indexes :date_details
  indexes :reference_number

  # Join associations for searching
  indexes authors(:name), :as => :author_name
  indexes categories(:name), :as => :category_name

  # Attributes for filtering and sorting
  has :site_id
  has :document_type_id
  has :year
  has :month
  has :day
  has :published
  has :created_at
  has :updated_at

  # Computed date field for sorting by year/month/day
  has "CONCAT(LPAD(IFNULL(year, 0), 4, '0'), LPAD(IFNULL(month, 0), 2, '0'), LPAD(IFNULL(day, 0), 2, '0'))", :as => :date, :type => :integer

  # Multi-value attributes for associations
  has authors(:id), :as => :author_ids
  has categories(:id), :as => :category_ids

  # Set condition to index only valid records
  where "title IS NOT NULL"
end
