class TemplateKind < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name
  validates_lengths_from_database
  has_many :provisioning_templates, :inverse_of => :template_kind
  has_many :os_default_templates
  validates :name, :presence => true, :uniqueness => true
  scoped_search :on => :name

  def self.jar
    @jar ||= { "PXELinux" => N_("PXE Linux Template"),
               "PXEGrub" => N_("PXE Grub Template"),
               "iPXE" => N_("iPXE Template"),
               "provision" => N_("Provision Template"),
               "finish" => N_("Finish Template"),
               "script" => N_("Script Template"),
               "user_data" => N_("User Data Template"),
               "ZTP" => N_("ZTP Template"),
               "POAP" => N_("POAP Template")
             }
  end

  def self.add_to_jar(hash)
    jar.merge!(hash) { |key| raise Foreman::Exception.new(N_("Cannot add template with key %s, it already exists"), key) }
  end

  def to_s
    TemplateKind.jar[name] || name
  end
end
