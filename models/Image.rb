class Image
  include DataMapper::Resource

  property :id,       Serial
  property :src,      String
  property :alt,      String
  property :caption,  String
  property :width,    Integer
  property :height,   Integer
  property :slug,     Integer

  belongs_to :work
end
