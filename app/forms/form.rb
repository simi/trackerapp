class Form
  include ActiveModel::Model
  include ActiveModel::Validations

  private
  def store(attributes)
    attributes.each do |name, value|
      instance_variable_set(:"@#{name}", value) if value.present?
    end
  end

  def persisted?
    false
  end

end
