class Work
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String
  property :slug,           String
  property :info,           Text
  property :services,       String
  property :thumb,          String
  property :screenshots,    Text
  property :classification, String

  has n, :images
end
