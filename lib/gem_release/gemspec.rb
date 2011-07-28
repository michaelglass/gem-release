module GemRelease
  class Gemspec < Template
    attr_reader :author, :email, :homepage, :summary, :description, :strategy

    def initialize(options = {})
      super('gemspec', options)

      @author      ||= user_name
      @email       ||= user_email
      @homepage    ||= "http://github.com/#{github_user}/#{name}" || "[your github name]"

      @summary     ||= '[summary]'
      @description ||= '[description]'

      @strategy = options[:strategy]
    end

    def files
      case strategy
      when 'git'
        '`git ls-files app lib`.split("\n")'
      else
        'Dir.glob("{lib/**/*,[A-Z]*}")'
      end
    end

    def exists?
      File.exists?(filename)
    end

    def filename
      "#{name}.gemspec"
    end
  end
end
