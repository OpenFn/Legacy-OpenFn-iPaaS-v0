class OdkClient; end;
require 'odk_client/odk_fields_collector'
require 'odk_client/odk_form_parser'

class OdkClient
  def initialize(instance_url, credentials=nil)
    @instance_url = instance_url

    @logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)) 
    @logger.push_tags("OdkClient")

    @client = Curl::Easy.new
    @client.headers["X-OpenRosa-Version"] = "1.0"
    @client.ssl_verify_peer = false
    @client.ssl_verify_host = false

    if credentials
      @client.http_auth_types = :digest
      @client.username = credentials[:username]
      @client.password = credentials[:password]
    end
    
    @error = nil
    @client.on_missing do |resp|
      @error = case resp.response_code
      when 401
        StandardError.new("Access Denied")
      when 404
        StandardError.new("Form can't be found.")
      else
        StandardError.new("Got #{resp.response_code} from server.")
      end
    end

  end

  def get_form(name)
    @form = StringIO.new

    @logger.push_tags("FormID##{name}")
    @client.url = @instance_url + "/formXml?formId=#{name}"
    @logger.info "Fetching form from #{@client.url}"

    @client.on_success do |response|
      @form << response.body 
    end

    @client.perform
    raise @error if @error

    self
  end

  def parse
    fields = OdkClient::OdkFieldsCollector.new

    handler = OdkClient::OdkFormParser.new do |element|
      # Remove the name of the form from the path.
      fields.add element.tap { |e| e[:path].shift }
    end

    Ox.sax_parse(handler, @form, smart: false, convert_special: false)
    fields 
  end
end
