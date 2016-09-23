module Slugify

  module ClassMethod
    def find_by_slug(slugged)
      found = []
      self.all.each do |thing|
        if slugged == thing.slug
          found << thing
        end
      end
      found[0]
    end

  end

  module InstanceMethod
    def slug
      if self.respond_to?(:username)
        strip_chars_array = self.username.downcase.scan(/[a-z0-9]+/)
      else
        strip_chars_array = self.name.downcase.scan(/[a-z0-9]+/)
      end
      slug = strip_chars_array.join("-")
    end
  end

end
