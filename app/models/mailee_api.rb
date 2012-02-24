class MaileeAPI

  def initialize params
    #TODO fazer um sistema de envs
    @url = "https://api.mailee.me/api/v2"
    # @url = "http://localhost:3000/api/v2"
    @api_key = params[:api_key]

    # @method = params[:method] || 'get'
    @resource = params[:resource] || 'contacts'
    @action = params[:aktion] || 'index'
    if @resource == 'root'
      @resource = @action
      @action = nil
    end
    @id = params[:id]
    @params = params[:params] || {}

    puts @params.inspect
  end

  def valid_url?
    true #TODO
  end

  ACTION_METHOD_MAPPING = {
    create: :post,
    update: :put,
    test: :put,
    ready: :put,
    destroy: :delete
  }

  def method
    ACTION_METHOD_MAPPING[@action.to_sym] || :get rescue :get
  end

  def resource_path
    case @action
    when "test", "ready", "accesses", "unsubscribes", "list_subscribe", "list_unsubscribe", "html"
      "/#{@resource}/#{@id}/#{@action}"
    when "show", "update"
      "/#{@resource}/#{@id}"
    when "new"
      "/#{@resource}/new"
    else
      "/#{@resource}"
    end
  end

  def url
    @url+resource_path+"?api_key="+@api_key
  end

  ##
  # Removes empty strings for posting and putting.
  ##

  def params
    # Normal cases
    # raise @params.values.inspect
    # return @params.values.length.inspect
    if %w{ready accesses list_subscribe list_unsubscribe}.include?(@action)
      @params
    elsif @params.values.first.is_a? Hash
      {@params.keys.first => @params.values.first.select{|k,v| v.present? }}
    elsif @params.values.first.is_a? Array
      {@params.keys.first => @params.values.first.select(&:present?)} rescue {}
    end
  # rescue => e
  #   {}
  end

  def curl_method
    method != :get ? %(-X #{method.upcase} ) : nil
  end

  def curl_params
    params ? %(-d "#{params.to_param}" ) : nil
  end

  def curl_string
    %(curl #{curl_method}#{curl_params}#{url})
  end

  def retrieve
    # return {foo: "bar"}.to_json
    # return url
    # ret = "yay"
    ret = RestClient.send(method, url, params)
    # raise ret.inspect
    ret = ret.present? ? ret : "OK"
    result = "#{curl_string}\n#{ret}"
    # raise result.inspect
    CGI::escapeHTML( result )
  end

end