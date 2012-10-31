module Confetti
  module TemplateHelper
    def generate_and_write (*platforms)
      platforms.each do |config_type|
        class_name = config_type.to_s.split("_").collect do |s|
          s.capitalize
        end.join
        template_class = Confetti::Template.const_get(class_name)

        generate_method = "generate_#{ config_type }".to_sym
        write_method    = "write_#{ config_type }".to_sym

        send :define_method, generate_method do
          template_class.new(self)
        end

        send :define_method, write_method do |*args|
          filepath = args.first

          template = send generate_method

          begin
            output = template.render
            filepath ||= File.join(Dir.pwd, template.output_filename)

            open(filepath, 'w') { |f| f.puts output }
          rescue SystemCallError
            raise IOError, "SystemCallError: unable to write template file"
          end
        end
      end
    end
  end
end
