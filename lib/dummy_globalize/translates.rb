class ActiveRecord::Base
  def self.translates(*fields, &block)
    singular_model_name = model_name.singular.to_sym

    table_name = "#{singular_model_name}_translations"
    model_name = self.name

    translation_klass = Class.new(ActiveRecord::Base) do
      self.table_name = table_name

      belongs_to singular_model_name,
        inverse_of: :translations,
        foreign_key: "#{singular_model_name}_id",
        class_name: model_name

      validates :locale, presence: true
      validates singular_model_name, presence: true
    end

    if block
      translation_klass.instance_exec(&block)
    end

    self.const_set("Translation", translation_klass)

    has_many :translations,
      class_name: "#{self.name}::Translation",
      inverse_of: singular_model_name,
      foreign_key: "#{singular_model_name}_id",
      autosave: true,
      dependent: :destroy

    fields.each do |method_name|
      getter_method = method_name
      setter_method = "#{method_name}="

      define_method getter_method do
        fallbacks = if I18n.respond_to?(:fallbacks)
          I18n.fallbacks[I18n.locale]
        else
          [I18n.locale]
        end

        fallbacks.map do |locale|
          translation_for(locale).send(getter_method).presence
        end.compact.first
      end

      define_method setter_method do |value|
        translation_for(I18n.locale).send(setter_method, value)
      end
    end

    scope :with_translations, ->(locale) {
      joins(:translations).where(table_name => { locale: locale })
    }

    define_method :has_translation? do |locale|
      translations.find do |t|
        t.locale.to_s == locale.to_s
      end.present?
    end

    define_method :translation_for do |locale|
      translations.find do |t|
        t.locale.to_s == locale.to_s
      end || translations.build(locale: locale)
    end
  end
end

