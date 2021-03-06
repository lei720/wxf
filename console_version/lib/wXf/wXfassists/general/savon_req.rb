require 'wXf/wXfui'
require 'wAx/wAxHTTPLibs/savon/lib/savon'
require 'rubygems'






module WXf
module WXfassists
module General
module SavonReq  
       
     attr_accessor :rce
     
     
       #
       # Global Options are created
       #
       def initialize(hash_info={})
             super
             init_opts([
                WXf::WXfmod_Factory::OptString.new('RURL', [true, 'Target address', 'http://www.example.com/test.php']),
                WXf::WXfmod_Factory::OptString.new('PROXYA', [false, 'Proxy IP Address' , '']),
                WXf::WXfmod_Factory::OptString.new('PROXYP', [false, 'Proxy Port Number', '']),
             ])
             
      end
      
      
      #
      # Remote URL option
      #    
      def rurl
        datahash['RURL']
      end

      
     #
     # Proxy port option
     # 
     def proxyp
       datahash['PROXYP']
     end

     
     #
     # Proxy address option
     #
     def proxya
       datahash['PROXYA']
     end
   
   
    #
    # Method which returns true if option isn't either a blank string or n  
    #  
    def exists?(opt)      
        if (opt and opt != '' and not opt == nil)
          return true
        else
          return false
        end
    end
    
    
    #
    # This method can be used to ensure that if only value should 
    # ...is required, only one is entered.
    #
    def eliminator(arg1, arg2)
      if exists?(arg1) and not exists?(arg2)
        return arg1
      elsif exists?(arg2) and not exists?(arg1)
        return arg2
      else
        prnt_err(" Please ensure that both #{arg1} and #{arg2} aren't set")
      end
    end
    
    
    #
    # This method instantiates a client object for the developer to work with.
    # 
    #   
    def simple_savon_client(opts={})
      proxyp = opts['PROXYP']
      proxya = opts['PROXYA']
      rurl = opts['RURL']
      begin
        client = WAx::WAxHTTPLibs::Savon::Client.new("#{rurl}")
        client.request.proxy.port = "#{proxyp}" if proxyp
        client.request.proxy.host = "#{proxya}" if proxya
        return client
      rescue => e
        prnt_err(" SavonReq Error: #{e}")
      end
    end
    
    
    #
    # This makes a request with only a single action
    #
    def single_action_req(opts={})
      rurl = opts['RURL'] || ''
      rparams = opts['RPARAMS'] || {}
      raction = opts['RACTION'] || nil
      proxyp = opts['PROXYP']
      proxya = opts['PROXYA']
      headers = opts['HEADERS'] || {}
      basic_user = opts['USER'] || nil
      basic_pass =  opts['PASS'] || nil
      gzip = opts['GZIP'] || true
        
      begin
        client = WAx::WAxHTTPLibs::Savon::Client.new("#{rurl}")
        
        if exists?(basic_user) and exists?(basic_pass)
            client.request.basic_auth("#{basic_user}", "#{basic_pass}")
        end
           
        if exists?(proxyp) and exists?(proxya)
          client.request.proxy.port = "#{proxyp}"
          client.request.proxy.host = "#{proxya}"
        end
    
        headers.each {|k,v| client.request.headers[k] = v }
   
        if exists?(raction) and exists?(rparams)
          eval("
            client.#{raction} { |soap|             
              soap.body = rparams
            }
          ")
        else
          prnt_err(" You forgot the RACTION or PARAM/VALUE option(s)!")
        end
      rescue => e
        prnt_err(" SavonReq Error: #{e}")
      end
   end
    
end
   
   
     
     
     
     
end end end
